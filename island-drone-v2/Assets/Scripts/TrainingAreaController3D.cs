using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using NaughtyAttributes;
using UnityEngine;
using Random = UnityEngine.Random;

public class TrainingAreaController3D : MonoBehaviour
{
    [Header("Collectible Parameters")]

    [Tooltip("The material when the voxel can be collected")]
    public Material undetectedMaterial;

    [Tooltip("The material when the voxel is not collectable")]
    public Material detectedCollectibleMaterial;
    public List<VoxelController> collectiblesList { get; private set; }
    public string collectibleTag = "collectible";

    // training elements tracks child: N_elements, List_Elements
    public Dictionary<Transform, (int numToCollect, List<VoxelController> collectibles)> trainingElements;

    public float maxSpawnHeight = 5f;
    public event Action ScansCompleteEvent;
    private bool m_OptScansComplete; // flag

    public float FieldRadius = 10;
    private float m_RadiusSqr;

    
    // Start is called before the first frame update
    public void Initialize()
    {
        // initialize empty variables
        trainingElements = new Dictionary<Transform, (int numToCollect, List<VoxelController> collectibles)>();
        
        // initialize variables
        FindAllElements(transform);

        // initalize collectibles
        foreach (var kvp in trainingElements.ToArray())
        {
            foreach (var collectible in kvp.Value.collectibles)
            {
                if (collectible.gameObject.activeInHierarchy) collectible.Initialize();
            }
        }
        
        // Debug.Log("found n Collectibles on the TrainingArea you gave me: " + collectiblesList.Count);
        // Debug.Log("found n Children on the TrainingArea you gave me: " + children.Count);
    }
    
    public void Reset()
    {
        print("found n Children on the TrainingArea you gave me: " + trainingElements.Count);
        
        // dicts are immutable on the forach loop so ToArray is the work-around to edit the original dict.
        foreach (var kvp in trainingElements.ToArray())
        {
            // reset each voxels state (material and collider)
            foreach (var collectible in kvp.Value.collectibles)
            {
                if (collectible != null && collectible.gameObject.activeInHierarchy) collectible.Reset();
            }
            // reset the objects position to a random location
            MoveToSafeRandomPosition(kvp.Key);
            // reset the counter of objects that can be detected
            trainingElements[kvp.Key] = (kvp.Value.collectibles.Count, kvp.Value.collectibles);

            // print("current childs name: " + kvp.Key.name);
            // print("found n Collectibles in the current Child: " + kvp.Value.collectibles.Count);
        }
    }

    public bool EverythingHasBeenCollected
    {
        get
        {
            var scannedObjects = 0;
            foreach (var kvp in trainingElements)
            {
                if (IsFullyScanned(kvp))
                {
                    scannedObjects++;
                }
                else
                {
                    // optimization: if one is found that has not been fully scanned, do not keep searching 
                    return false;
                }
            }
            // obvious note: if the number of scanned objects is the same as
            // the number of objects to scan, all items have been scanned 
            return scannedObjects == trainingElements.Count;
        }
    }

    private bool IsFullyScanned(KeyValuePair<Transform, (int numToCollect, List<VoxelController> collectibles)> kvp)
    {
        // print("num to be collected: " + kvp.Value.numToCollect);
        return kvp.Value.numToCollect == 0;
    }
    private void FindCollectibles(Transform parent)
    {
        // TODO change this so it doesnt use the global variable
        // foreach child in parent, exit1: exit when no more children in element
        // Debug.Log("found n children:" + parent.childCount);
        for (int i = 0; i < parent.childCount; i++)
        {
            Transform child = parent.GetChild(i);
            // Debug.Log("childs name: " + child.name);
            if (child.gameObject.activeInHierarchy && child.CompareTag(collectibleTag))
            {
                VoxelController current_child = child.GetComponent<VoxelController>();
                // once flower found, add the flowers list and add the collider attached to the hash map
                if (current_child != null)
                {
                    current_child.undetectedMaterial = undetectedMaterial;
                    current_child.detectedCollectibleMaterial = detectedCollectibleMaterial;

                    collectiblesList.Add(current_child);
                    current_child.Collected += ReduceNumCollected;
                }
            }
            else
            {
                // no flowers found, continue checking looking for flowers
                // until you find a flower or you run out of children (main loop)
                FindCollectibles(child);
            }
        }
    }
    
    public void FindAllElements(Transform parent)
    {
        int count = parent.childCount;
        for (int i = 0; i < count; i++)
        {
            var child = parent.GetChild(i);
            if (child.gameObject.activeInHierarchy)
            {
                collectiblesList = new List<VoxelController>();
                FindCollectibles(child);
                List<VoxelController> elements = collectiblesList; 
                trainingElements.Add(child, (elements.Count, elements));                
            }
        }
    }
    // void SpawnTarget(Transform prefab, Vector3 pos)
    // {
    //     m_Target = Instantiate(prefab, pos, Quaternion.identity, transform.parent);
    // }
    public void MoveToSafeRandomPosition(Transform trans, bool isDrone=false)
    {
        bool safePositionFound = false;
        int attemptsRemaining = 100;
        Vector3 potentialPosition = Vector3.zero;
        Quaternion potentialRotation = new Quaternion();

        // loop until safe position
        while (!safePositionFound && attemptsRemaining > 0)
        {
            // print("looking for a safe position....");
            // make drone spawn higher to bike
            var multiplier = isDrone ? 1.2f : 0.8f;
            float height = Random.Range(0, maxSpawnHeight * multiplier);
            float radius = Random.Range(2f, 10f);
            Quaternion direction = Quaternion.Euler(
                0, Random.Range(-180f, 180f), 0f);
            potentialPosition = transform.position
                                + Vector3.up * height + direction * Vector3.forward * radius;
            // deactivated pitch
            float pitch = 0; // UnityEngine.Random.Range(-60f, 60f);
            float yaw = Random.Range(-180f, 180f);
            potentialRotation = Quaternion.Euler(pitch, yaw, 0f);

            // get a list of all colliders colliding with agent in potentialPosition
            Collider[] colliders = Physics.OverlapSphere(potentialPosition, 1f);
            // safe position if no colliders found
            safePositionFound = colliders.Length == 0;
            attemptsRemaining--;
        }

        Debug.Assert(safePositionFound, "Could not found a safe position");

        // set position, rotation
        trans.position = potentialPosition;
        trans.rotation = potentialRotation;
    }

    public void ReduceNumCollected(object sender, CollectedEventArgs e)
    {
        trainingElements[e.grandparent] = (trainingElements[e.grandparent].numToCollect - 1,
            trainingElements[e.grandparent].collectibles);
    }
    private void OnApplicationQuit()
    {
        foreach (var kvp in trainingElements.ToArray())
        {
            foreach (var collectible in kvp.Value.collectibles)
            {
                collectible.Collected -= ReduceNumCollected;;
            }
        }
    }
}
