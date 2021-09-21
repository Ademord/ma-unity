using System.Collections;
using System.Collections.Generic;
using System.Linq;
using UnityEngine;

namespace Ademord
{
    public class TrainingAreaController2D : MonoBehaviour
    {
        public List<VoxelController> collectiblesList { get; private set; }
        public string collectibleTag = "collectible";
        private Vector3 elementSpawnPosition = new Vector3(0f, 1.1f, 0f);

        // training elements tracks child: N_elements, List_Elements
        public Dictionary<Transform, (int numToCollect, List<VoxelController> collectibles)> trainingElements;
        
        // Start is called before the first frame update
        private void Awake()
        {
            // initialize empty variables
            trainingElements = new Dictionary<Transform, (int numToCollect, List<VoxelController> collectibles)>();
            // initialize variables
            FindAllElements(transform);

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
                    if (collectible.gameObject.activeInHierarchy) collectible.Reset();
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
                var result = true;
                foreach (var kvp in trainingElements)
                {
                    print("num to be collected: " + kvp.Value.numToCollect); 
                    if (kvp.Value.numToCollect > 516)
                    {
                        result = false;
                        break;
                    }
                }

                return result;
            }
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
                if (child.CompareTag(collectibleTag))
                {
                    VoxelController current_child = child.GetComponent<VoxelController>();
                    // once flower found, add the flowers list and add the collider attached to the hash map
                    if (current_child != null)
                    {
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
                collectiblesList = new List<VoxelController>();
                FindCollectibles(child);
                List<VoxelController> elements = collectiblesList; 
                trainingElements.Add(child, (elements.Count, elements));
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
                // print("looking for a safe position....");
                float height = 1.3f; // UnityEngine.Random.Range(1f, 8f);
                float radius = Random.Range(2f, 10f);
                Quaternion direction = Quaternion.Euler(
                    0, Random.Range(-180f, 180f), 0f);
                potentialPosition = transform.localPosition
                                    + Vector3.up * height + direction * Vector3.forward * radius;
                // float pitch = UnityEngine.Random.Range(-60f, 60f);
                float pitch = 0;
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

        public void ReduceNumCollected(object sender, VoxelCollectedEventArgs e)
        {
            trainingElements[e.grandparent] = (trainingElements[e.grandparent].numToCollect - 1,
                trainingElements[e.grandparent].collectibles);
        }
    }

}