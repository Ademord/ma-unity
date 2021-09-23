using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace Ademord
{
    public class VoxelController : MonoBehaviour
    {
        public Material undetectedMaterial { private get;  set; }
        public Material detectedCollectibleMaterial { private get;  set; }
        protected Transform m_Collider;
        
        private MeshRenderer _voxelMeshRenderer;
        public event EventHandler<VoxelCollectedEventArgs> Collected;

        [SerializeField] private bool rotate = false;
        
        int rotationsPerMinute = 10;

        void Update()
        {
            if (rotate)
            {
                var angle = 6 * rotationsPerMinute * Time.deltaTime;
                transform.Rotate(0, angle, 0);
            }
        }

        // [Tooltip("The collider of the current voxel")]
        // public Transform collider;
        public bool CanBeCollected { get { return _voxelMeshRenderer.sharedMaterial == undetectedMaterial; } }

        public void Initialize()
        {
            _voxelMeshRenderer = transform.GetComponent<MeshRenderer>();
            // collider = transform.GetComponent<Collider>();
            m_Collider = transform.Find("collider");

            if (_voxelMeshRenderer == null)
            {
                print("ERROR: _voxelMeshRenderer was NOT FOUND");
            }
            if (m_Collider == null)
            {
                print("ERROR: collider in voxel was NOT FOUND");

            }
        }
        
        public void Reset()
        {
            _voxelMeshRenderer.material = undetectedMaterial;
            m_Collider.gameObject.SetActive(true);
            // var collider = transform.Find("collider");
        }
        
        public bool Collect()
        {
            if (CanBeCollected)
            {
                // print("tryiong to collect a collectable voxel");
                
                // change material
                _voxelMeshRenderer.material = detectedCollectibleMaterial;
                
                // disable collider
                m_Collider.gameObject.SetActive(false);
              
                // notify of collection to TrainingArea
                VoxelCollectedEventArgs args = new VoxelCollectedEventArgs();
                args.grandparent = transform.parent.parent;
                OnCollection(args);

                return true;
            }
            return false;
        }
        
        protected virtual void OnCollection(VoxelCollectedEventArgs e)
        {
            EventHandler<VoxelCollectedEventArgs> handler = Collected;
            if (handler != null)
            {
                handler(this, e);
            }
        }
        bool m_Started;

        // draw sphere gizmo
        // void Start()
        // {
        //     //Use this to ensure that the Gizmos are being drawn when in Play Mode.
        //     m_Started = true;
        // }
        // //Draw the Box Overlap as a gizmo to show where it currently is testing. Click the Gizmos button to see this
        // void OnDrawGizmos()
        // {
        //     Gizmos.color = Color.red;
        //     //Check that it is being run in Play Mode, so it doesn't try to draw this in Editor mode
        //     if (m_Started)
        //         //Draw a cube where the OverlapBox is (positioned where your GameObject is as well as a size)
        //         Gizmos.DrawWireSphere(transform.position, 4f);
        // }
    }

    public class VoxelCollectedEventArgs : EventArgs
    {
        // used to notify of collection
        public Transform grandparent { get; set; }
        public Collider CollisionCollider { get; set; }

    }
    // public class GoalPassedEventArgs : EventArgs
    // {
    //     // used to notify of collection
    //     public Transform grandparent { get; set; }
    //     public Collider CollisionCollider { get; set; }
    // } 
}