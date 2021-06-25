using System;
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
    public event EventHandler<CollectedEventArgs> Collected;
    public bool CanBeCollected { get { return _voxelMeshRenderer.sharedMaterial == undetectedMaterial; } }

    private void Awake()
    {
        _voxelMeshRenderer = transform.GetComponent<MeshRenderer>();
    }
    
    public void Reset()
    {
        _voxelMeshRenderer.material = undetectedMaterial;
        var collider = transform.Find("collider");
        if (collider != null)
        {
            collider.gameObject.SetActive(true);
        }
        else
        {
            print("ERROR: collider in voxel was NOT FOUND");
        }
    }
    
    public bool Collect()
    {
        if (CanBeCollected)
        {
            // change material
            _voxelMeshRenderer.material = detectedCollectibleMaterial;
            
            // disable collider
            var collider = transform.Find("collider");
            if (collider != null)
            {
                collider.gameObject.SetActive(false);
            }
            else
            {
                print("ERROR: collider in voxel was NOT FOUND");
            }
            // notify of collection to TrainingArea
            CollectedEventArgs args = new CollectedEventArgs();
            args.grandparent = transform.parent.parent;
            OnCollection(args);

            return true;
        }
        return false;
    }
    
    protected virtual void OnCollection(CollectedEventArgs e)
    {
        EventHandler<CollectedEventArgs> handler = Collected;
        if (handler != null)
        {
            handler(this, e);
        }
    }
    

}

public class CollectedEventArgs : EventArgs
{
    public Transform grandparent { get; set; }
}
