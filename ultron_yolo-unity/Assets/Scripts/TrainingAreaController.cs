using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TrainingAreaController : MonoBehaviour
{
    public List<VoxelController> collectiblesList { get; private set; }
    public string collectibleTag = "collectible";

    private Vector3 elementSpawnPosition = new Vector3(0f, 1.5f, 0f);
    public List<Transform> children { get; private set; }
    private void Awake()
    {
        // initialize empty variables
        collectiblesList = new List<VoxelController>();
        children = new List<Transform>();
        // initialize variables
        FindCollectibles(transform);
        FindEveryChild(transform);
        
        Debug.Log("found n Collectibles on the TrainingArea you gave me: " + collectiblesList.Count);
        Debug.Log("found n Children on the TrainingArea you gave me: " + children.Count);
    }

    public void Reset()
    {
        // reset all collectibles materials
        foreach (var collectible in collectiblesList)
        {
            collectible.Reset();
        }
        // reset all children positions
        foreach (var element in children)
        {
            // Reset target position (5 meters away from the agent in a random direction)
            Vector3 targetPosition = elementSpawnPosition + Quaternion.Euler(Vector3.up * Random.Range(0f, 360f)) * Vector3.forward * 5f;
            element.transform.localPosition = targetPosition;
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
}
