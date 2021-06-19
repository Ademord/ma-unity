using System.Collections;
using System.Collections.Generic;
using System.Runtime.CompilerServices;
using UnityEngine;

public class PlantController
{
    public List<TorusSegmentController> torusSegments { get; private set; }

    public PlantController(Transform m_Target)
    {
        torusSegments = new List<TorusSegmentController>();
        FindChildTorusSegements(m_Target);
        // Debug.Log("found n torusSegments on the transform you gave me: " + torusSegments.Count);
    }

    public void ResetCollectibles()
    {
        // reset all colliders and colors
        foreach (TorusSegmentController torusSegment in torusSegments)
        {
            torusSegment.Reset();
        }
    }

    private void FindChildTorusSegements(Transform parent)
    {
        // foreach child in parent, exit1: exit when no more children in element
        // Debug.Log("found n children:" + parent.childCount);
        for (int i = 0; i < parent.childCount; i++)
        {
            Transform child = parent.GetChild(i);
            // Debug.Log("childs name: " + child.name);
            if (child.CompareTag("torus_segment"))
            {
                TorusSegmentController torusSegment = child.GetComponent<TorusSegmentController>();
                // once flower found, add the flowers list and add the collider attached to the hash map
                if (torusSegment != null)
                {
                    torusSegments.Add(torusSegment);
                }
            }
            else
            {
                // no flowers found, continue checking looking for flowers
                // until you find a flower or you run out of children (main loop)
                FindChildTorusSegements(child);
            }

        }
    }
}