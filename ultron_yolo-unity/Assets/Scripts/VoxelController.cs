using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class VoxelController : MonoBehaviour
{
    [Tooltip("The material when the voxel can be collected")]
    public Material undetectedCollectibleMaterial;

    [Tooltip("The material when the voxel is not collectable")]
    public Material detectedCollectibleMaterial;

    private Material voxelMaterial;

    public bool CanBeCollected { get { return voxelMaterial == undetectedCollectibleMaterial; } }

    public bool Collect()
    {
        if (CanBeCollected)
        {
            voxelMaterial = detectedCollectibleMaterial;
            return true;
        }
        return false;
    }
    
    public void Reset()
    {
        voxelMaterial = undetectedCollectibleMaterial;
    }

    private void Awake()
    {
        MeshRenderer meshRenderer = GetComponent<MeshRenderer>();
        voxelMaterial = meshRenderer.material;
        Reset();
    }
}
