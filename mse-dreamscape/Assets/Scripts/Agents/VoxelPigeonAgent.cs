using System.Collections;
using System.Collections.Generic;
using MBaske.Sensors.Grid;
using Unity.MLAgents.Sensors;
using UnityEngine;

namespace Ademord
{
    public class VoxelPigeonAgent : PigeonAgentTrain
    {
        [Header("Voxel Agent Parameters")]
        [SerializeField] protected bool m_TrainVoxelCollection = true;
        [SerializeField]
        [Tooltip("Reference to sensor component for retrieving detected goal gameobjects that can be disabled (scanned).")]
        protected GridSensorComponent3D m_SensorComponent_Scanner;
        [SerializeField]
        [Tooltip("Accuracy of the scanner.")]
        protected float m_ScanAccuracy = 80;        
        [SerializeField]
        [Tooltip("Delay between scans.")]
        protected float m_ResetVFXWaitPeriod = 2f;
        
        protected static string m_TargetTag = "collectible"; // same for all.
        protected float m_ShotTime;
        protected int m_VoxelsScanned;
        protected int totalVoxelsScanned;
        protected int totalObjectsScanned;
        
        
        public override void Initialize()
        {
            base.Initialize();

            m_World.OnObjectFullyScannedEventHandler += ObjectFullyScannedEvent;
        }
        
        public override void OnEpisodeBegin()
        {
            base.OnEpisodeBegin();

            ResetAgent();
        }
   
        public override void CollectObservations(VectorSensor sensor)
        {
            base.CollectObservations(sensor);
            
            m_VoxelsScanned = UseScanner(m_Body.WorldForward);
            totalVoxelsScanned += m_VoxelsScanned;
            if (m_EnableVFX && CanResetScannerRotation()) m_VFXController.ResetVFX();
        }
        
        public override void PostAction()
        {
            base.PostAction();
            m_VoxelsScanned = 0;
        }
        protected virtual void ObjectFullyScannedEvent(object sender, VoxelCollectedEventArgs e)
        {
            totalObjectsScanned++;
        }
        private int UseScanner(Vector3 fwd)
        {
            int voxelCount = 0;
            foreach (var target in m_SensorComponent_Scanner.GetDetectedGameObjects(m_TargetTag))
            {
                VoxelController myVoxel = target.transform.parent.GetComponent<VoxelController>();
                if (myVoxel)
                {
                    var myDetectableGameObject = target.transform.GetComponent<VoxelDetectableGameObject>();

                    // dotProduct requirement: ONLY SCAN TARGETS IN FRONT
                    var dotProductToTarget = Vector3.Dot(fwd, myVoxel.transform.forward);

                    // if facing targets and chance to collect is successful
                    if (myDetectableGameObject.IsInSight(Layer.ObstacleMask + Layer.ObjectMask) > 0 && Random.Range(0, 101) <= m_ScanAccuracy)
                    {
                        if (myVoxel.Collect())
                        {
                            // notify of collection / scan
                            OnVoxelScanned(target);
                            m_ShotTime = Time.time;
                            voxelCount++;
                        }
                        else
                        {
                            // this shouldnt happen during normal runtime
                            // print("could not collect voxel" + target.transform.name);
                        }
                    }
                }
            }

            return voxelCount;
        }
        
        public void OnVoxelScanned(GameObject target)
        {
            if (m_EnableVFX) m_VFXController.RotateVFXToTarget(target);
            m_VoxelsScanned++;
        }

        // after having scanned AND a period of time has passed since last scan, reset rotation == not scanning anymore
        // it needs the bool scanned otherwise it will always reset the position since time will always be higher
        protected bool CanResetScannerRotation()
        {
            return (Time.time - m_ShotTime >= m_ResetVFXWaitPeriod);
        } 

        public void ResetAgent(bool fullReset = false)
        {
            totalObjectsScanned = 0;
            m_VoxelsScanned = 0;
        }
    }
}
