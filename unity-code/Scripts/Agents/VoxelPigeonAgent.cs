using System.Collections;
using System.Collections.Generic;
using System.Linq;
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
        private ScanEpisodeData scanEpisodeData;
        
        public override void Initialize()
        {
            base.Initialize();
            
            scanEpisodeData = new ScanEpisodeData();
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

        protected virtual void ObjectFullyScannedEvent(object sender, GoalObjectScannedEventArgs e)
        {
            totalObjectsScanned++;
            // print("e.deltaTime: " + e.deltaTime + "} " + totalObjectsScanned);
            // print("e.deltaTime/e.collectionMeters: " + e.deltaTime/e.collectionMeters + "} " + totalObjectsScanned);

            m_TBStats.Add(m_BehaviorName + "/OFSE: Time To Object {" + totalObjectsScanned + "}", e.deltaTime);
            m_TBStats.Add(m_BehaviorName + "/OFSE: sec/m To Object {" + totalObjectsScanned + "}",
                e.deltaTime / e.collectionMeters);

            scanEpisodeData.appendEventData(e);

            if (totalObjectsScanned > 1)
            {
                float totalCollectionTime = scanEpisodeData.collectionDeltaTimes.Sum();
                float totalMeters = scanEpisodeData.collectionMetersToObject.Sum();

                // print("e.deltaTime: {" + totalCollectionTime + "} (Total)" + totalObjectsScanned);
                // print("e.deltaTime/e.collectionMeters: {" + totalCollectionTime/totalMeters + "} (Total)" + totalObjectsScanned);

                m_TBStats.Add(m_BehaviorName + "/OFSE: Time To Object {" + totalObjectsScanned + "} (Total)",
                    totalCollectionTime);
                m_TBStats.Add(m_BehaviorName + "/OFSE: sec/m To Object {" + totalObjectsScanned + "} (Total)",
                    totalCollectionTime / totalMeters);
            }
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
                    if (myDetectableGameObject.IsInSight(Layer.ObstacleMask + Layer.ObjectMask) > 0 &&
                        Random.Range(0, 101) <= m_ScanAccuracy)
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
            // print("Voxels scanned so far: " + m_VoxelsScanned);
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
            scanEpisodeData.clearEventData();
        }

        private record ScanEpisodeData
        {
            public List<float> collectionDeltaTimes = new List<float>();
            public List<float> collectionMetersToObject = new List<float>();
            
            public void appendEventData(GoalObjectScannedEventArgs e)
            {
                collectionDeltaTimes.Add(e.deltaTime);
                collectionMetersToObject.Add(e.collectionMeters);
            }

            public void clearEventData()
            {
                collectionDeltaTimes.Clear();
                collectionMetersToObject.Clear();
            }
        }
    }
}
