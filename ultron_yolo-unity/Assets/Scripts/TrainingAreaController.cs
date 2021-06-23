using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TrainingAreaController : MonoBehaviour
{
    public List<VoxelController> collectiblesList { get; private set; }
    public string collectibleTag = "collectible";
    private Vector3 elementSpawnPosition = new Vector3(0f, 1.1f, 0f);
    public List<Transform> children { get; private set; }
    // Start is called before the first frame update
    private void Awake()
    {
        // initialize empty variables
        collectiblesList = new List<VoxelController>();
        children = new List<Transform>();
        // initialize variables
        FindCollectibles(transform);
        FindEveryChild(transform);
        
        // Debug.Log("found n Collectibles on the TrainingArea you gave me: " + collectiblesList.Count);
        // Debug.Log("found n Children on the TrainingArea you gave me: " + children.Count);
    }

    public void Reset()
    {
        // reset all collectibles materials, only if the parent was active in hierarchy
        foreach (var collectible in collectiblesList)
        {
            if (collectible.gameObject.activeInHierarchy) collectible.Reset();
        }
        // reset all children positions
        foreach (var element in children)
        {
            // Reset target position (5 meters away from the agent in a random direction)
            // Vector3 targetPosition = elementSpawnPosition + Quaternion.Euler(Vector3.up * Random.Range(0f, 360f)) * Vector3.forward * Random.Range(2f, 10f);
            // element.transform.localPosition = targetPosition;
            MoveToSafeRandomPosition(element);
        }
    }
    private void FindCollectibles(Transform parent)
    {
        // foreach child in parent, exit1: exit when no more children in element
        // Debug.Log("found n children:" + parent.childCount);
        for (int i = 0; i < parent.childCount; i++)
        {
            Transform child = parent.GetChild(i);
            // Debug.Log("childs name: " + child.name);
            if (child.CompareTag(collectibleTag))
            {
                VoxelController current_child = child.GetComponent<VoxelController>();
                // once flower found, add the flowers list and add the collider attached to the hash map
                if (current_child != null)
                {
                    collectiblesList.Add(current_child);
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
    public void FindEveryChild(Transform parent)
    {
        int count = parent.childCount;
        for (int i = 0; i < count; i++)
        {   
            children.Add(parent.GetChild(i));
        }
    }
    // void SpawnTarget(Transform prefab, Vector3 pos)
    // {
    //     m_Target = Instantiate(prefab, pos, Quaternion.identity, transform.parent);
    // }
    private void MoveToSafeRandomPosition(Transform trans)
    {
        bool safePositionFound = false;
        int attemptsRemaining = 100;
        Vector3 potentialPosition = Vector3.zero;
        Quaternion potentialRotation = new Quaternion();

        // loop until safe position
        while (!safePositionFound && attemptsRemaining > 0)
        {
            float height = 1f; // UnityEngine.Random.Range(1f, 8f);
            float radius = Random.Range(2f, 7f);
            Quaternion direction = Quaternion.Euler(
                0, Random.Range(-180f, 180f), 0f);
            potentialPosition = transform.localPosition
                                + Vector3.up * height + direction * Vector3.forward * radius;
            // float pitch = UnityEngine.Random.Range(-60f, 60f);
            float pitch = 0;
            float yaw = Random.Range(-180f, 180f);
            potentialRotation = Quaternion.Euler(pitch, yaw, 0f);

            // get a list of all colliders colliding with agent in potentialPosition
            Collider[] colliders = Physics.OverlapSphere(potentialPosition, 0.1f);
            // safe position if no colliders found
            safePositionFound = colliders.Length == 0;
        }

        Debug.Assert(safePositionFound, "Could not found a safe position");

        // set position, rotation
        trans.position = potentialPosition;
        trans.rotation = potentialRotation;
    }
}
