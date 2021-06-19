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
        var ray = new Ray(this.transform.position, this.transform.forward);
        RaycastHit hit;
        if (Physics.Raycast(ray, out hit, 100)){
            lastHit = hit.transform.gameObject;
            // is this correct? will this be a single Box from the voxels?
            // lastHit.SetActive(false);
            // could i also change the color maybe? to some gray-ish so it looks "disabled"? 
            // lastHit.material = disabledMaterial;
            collision = hit.point;
            MeshRenderer meshRenderer = lastHit.GetComponent<MeshRenderer>();
            meshRenderer.material = disabledMaterial;
        }
    }

    private void OnDrawGizmos()
    {
        Update();
        Gizmos.color = Color.red;
        Gizmos.DrawWireSphere(collision, 0.2f);
    }
}
