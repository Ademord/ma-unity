using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace Ademord.Drone
{
    public class ScannerController : MonoBehaviour
    {
        private Quaternion m_StartRotation;

        public void Awake()
        {
            m_StartRotation = transform.localRotation;
        }

        public void Reset()
        {
            transform.localRotation = m_StartRotation;
        }
        public void Scan(IScannerOwner owner, Transform target)
        {
            // lerp to look at target
            VoxelController myVoxel = target.parent.transform.GetComponent<VoxelController>();
            
            // if (myVoxel != null && myVoxel.Collect())
            if (myVoxel != null)
            {
                if (myVoxel.Collect())
                {
                    // print("collected a voxel!");
                    transform.LookAt(target);

                    // notify Agent of scan
                    owner.OnVoxelScanned();
                }
                else
                {
                    print("could not collect voxel" +  target.transform.name);
                }
            }
            else
            {
                print("conecast could not detect a voxel in detected collider named: " + target.transform.name);
            }
        }
        
        // print("resetting rotation");
        // // reset orientation back to original
        // m_ScannerComponent.Reset();
    }
}