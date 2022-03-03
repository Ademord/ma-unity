using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class VoxelScannerRaycast : MonoBehaviour
{
    // Start is called before the first frame update
    private GameObject lastHit;

    public LayerMask layer;
    public Material disabledMaterial;
    private Vector3 collision = Vector3.zero;
    
    // Update is called once per frame
    void Update()
    {
        var ray = new Ray(transform.position, transform.forward);
        RaycastHit hit;
        if (Physics.Raycast(ray, out hit, 5))
        {
            lastHit = hit.transform.gameObject;

            if (lastHit.CompareTag("collectible"))
            {
                // draw collision
                collision = hit.point;
                
                // give reward if not given before AND dot product < .6
                MeshRenderer meshRenderer = lastHit.GetComponent<MeshRenderer>();
                if (meshRenderer.material != disabledMaterial && Vector3.Dot(lastHit.transform.forward, transform.forward) < -0.6f)
                {
                    print("giving reward here");
                    meshRenderer.material = disabledMaterial;
                }
                else
                {
                    print("NOT giving reward here");
                }
            }
        }
    }

    private void OnDrawGizmos()
    {
        Update();
        // Gizmos.color = Color.red;
        // Gizmos.DrawWireSphere(collision, 0.2f);
    }
}
