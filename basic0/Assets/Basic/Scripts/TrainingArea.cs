using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TrainingArea : MonoBehaviour
{
    public const float AreaDiameter = 20f;

    // private Dictionary<Collider, Flower> nectarFlowerDictionary;
    private List<GameObject> flowerPlants;
    public List<Flower> flowers { get; private set; }

    /// <summary>
    /// Reset flowers and plants
    /// </summary>
    public void ResetFlowers()
    {
        // rotate around y, some x, z
        foreach (GameObject flowerPlant in flowerPlants)
        {
            float xRotation = UnityEngine.Random.Range(-5f, 5f); // between -5, +5 degrees 
            float yRotation = UnityEngine.Random.Range(-180f, 180f);
            float zRotation = UnityEngine.Random.Range(-5f, 5f);
            flowerPlant.transform.localRotation = Quaternion.Euler(xRotation, yRotation, zRotation);
            flowerPlant.transform.localPosition = new Vector3(Random.Range(-7f, 8f), 0 , Random.Range(7f, -8f));
        }
        
        // reset all flower colliders and colors
        foreach (Flower flower in flowers)
        {
            flower.ResetFlower();
        }
    }
    
    /// <summary>
    /// Gets the Flower that a nectar collider belong
    /// </summary>
    /// <param name="collider">nectar collider</param>
    /// <returns>The matching flower</returns>
    // public Flower GetFlowerFromNectar(Collider collider)
    // {
    //     return nectarFlowerDictionary[collider];
    // }

    /// <summary>
    /// Called when area wake up
    /// </summary>
    public void Awake()
    {
        flowerPlants = new List<GameObject>();
        // nectarFlowerDictionary = new Dictionary<Collider, Flower>();
        flowers = new List<Flower>();
        FindChildFlowers(transform);
        Debug.Log("found plants: " + flowerPlants.Count);
        Debug.Log("found flowers: " + flowers.Count);
    }

    // called when the game starts
    private void Start()
    {
        // find all flowers that are children of GameObject
    }

    /// <summary>
    /// find all parents
    /// </summary>
    /// <param name="parent">parents of the children to check</param>
    private void FindChildFlowers(Transform parent)
    {
        // Debug.Log("found n children:" + parent.childCount);
        // foreach child in parent, exit1: exit when no more children in element
        for (int i = 0; i < parent.childCount; i++)
        {
            Transform child = parent.GetChild(i);
            if (child.CompareTag("flower_plant"))
            {
                // Found a flower plant, add it to the plants list
                flowerPlants.Add(child.gameObject);
                // look for flowers in this plant and add them eventually
                FindChildFlowers(child);
            }
            else
            {
                // not a plant, look for a flower eventually! 
                Flower flower = child.GetComponent<Flower>();
                // once flower found, add the flowers list and add the collider attached to the hash map
                if (flower != null)
                {
                    flowers.Add(flower);
                    // nectarFlowerDictionary.Add(flower.nectarCollider, flower);
                    // exit2: done, no need to check further children
                }
                else
                {
                    // no flowers found, continue checking looking for flowers
                    // until you find a flower or you run out of children (main loop)
                    FindChildFlowers(child);
                }
            }
        }
        
    }
}
