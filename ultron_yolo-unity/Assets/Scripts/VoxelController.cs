using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class VoxelController : MonoBehaviour
{
    [Tooltip("The material when the voxel can be collected")]
    public Material undetectedMaterial;

    [Tooltip("The material when the voxel is not collectable")]
    public Material detectedCollectibleMaterial;

    private MeshRenderer _voxelMeshRenderer;

    public bool CanBeCollected { get { return _voxelMeshRenderer.sharedMaterial == undetectedMaterial; } }

    private void Awake()
    {
        _voxelMeshRenderer = transform.GetComponent<MeshRenderer>();
    }
    
    public void Reset()
    {
        _voxelMeshRenderer.material = undetectedMaterial;
    }
    
    public bool Collect()
    {
        if (CanBeCollected)
        {
            _voxelMeshRenderer.material = detectedCollectibleMaterial;
            return true;
        }
        return false;
    }
    
 


}
