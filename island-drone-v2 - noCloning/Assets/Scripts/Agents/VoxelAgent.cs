using System.Collections;
using System.Collections.Generic;
using System.Linq;
using MBaske.Sensors.Grid;
using Unity.MLAgents.Sensors;
using UnityEngine;

namespace Ademord
{
    public class VoxelAgent : DroneAgent
    {
        [SerializeField]
        [Tooltip("Forward axis angle below which agent is rewarded for following opponent.")]
        protected float m_TargetFollowAngle = 30;
        
        [SerializeField]
        [Tooltip("Distance below which agent is rewarded for following goals.")]
        [Range(5f, 50f)]
        protected float m_TargetFollowDistance = 10f;
        
        protected float m_TargetFollowDistanceSqr;
        [SerializeField]
        [Tooltip("Ship-to-ship forward axis angle below which target is locked and auto-fire triggered.")]
        protected float m_TargetScanAngle = 10;
        [SerializeField]
        [Tooltip("Ship-to-ship distance below which target is locked and auto-fire triggered.")]
        protected float m_TargetScanDistance = 20;
        protected float m_TargetScanDistanceSqr;
        [SerializeField]
        [Tooltip("Delay between auto-fire shots.")]
        protected float m_ScanReloadTime = 0.2f;       
        [SerializeField]
        [Tooltip("Delay between auto-fire shots.")]
        protected float m_ScanAccuracy = 20;        
        [SerializeField]
        [Tooltip("Delay between auto-fire shots.")]
        protected float m_InactivityTime = 2f;
        [SerializeField]
        [Tooltip("Scanner Buffer Size.")]
        protected int m_TargetsBufferSize = 10;
      
        [SerializeField]
        [Tooltip("Reference to sensor component for retrieving detected obstacle, goal, and boundary gameobjects.")]
        protected GridSensorComponent3D m_SensorComponent;

        
        [SerializeField]
        [Tooltip("Reference to sensor component for retrieving detected goal gameobjects that can be disabled (scanned).")]
        protected GridSensorComponent3D m_SensorComponent_Scanner;
        // [SerializeField]
        // [Tooltip("Ship-to-ship forward axis angle below which agent is rewarded for following opponent.")]
        // protected float m_TargetDotProduct = -0.8f;
        [SerializeField]
        [Tooltip("Target Tag")]
        protected static string m_TargetTag = "collectible"; // same for all.

        protected float m_ShotTime;
        protected float m_MovedTime;
        protected float m_AddedTargetsTime;
        protected int m_VoxelsScanned;

        // protected float dotProductToTarget;
        protected float distanceToTarget;
        protected float angleToTargetsInFront;
        protected float angleToTargetsFacingAway;
        protected Vector3 vectorToTargetsInFront;
        protected Vector3 vectorToTargetsFacingAway;
        
        private VFXController m_VFXController;
        public override void Initialize()
        {
            base.Initialize();
            m_VFXController.Initialize();
            
            m_TargetFollowDistanceSqr = m_TargetFollowDistance * m_TargetFollowDistance;
            m_TargetScanDistanceSqr = m_TargetScanDistance * m_TargetScanDistance;
        }
        public override void OnEpisodeBegin()
        {
            ResetAgent();
            
            base.ResetAgent();
        }
   
        public override void CollectObservations(VectorSensor sensor)
        {
            base.CollectObservations(sensor);
            
            ObserveWithSensors();
            if (CanResetScannerRotation()) m_VFXController.ResetVFX();
            
            // sensor.AddObservation(NormTargetWalkAngle);
            // sensor.AddObservation(NormTargetLookAngle);
            sensor.AddObservation(angleToTargetsInFront); // 1
            sensor.AddObservation(angleToTargetsFacingAway); // 1
            sensor.AddObservation(distanceToTarget); // 1
            sensor.AddObservation(vectorToTargetsInFront.normalized); // 3
            sensor.AddObservation(vectorToTargetsFacingAway.normalized); // 3
            // sensor.AddObservation(dotProductToTarget); // 1

            
            // TODO for VoxelAgentTrain
            // Vector3 velocity = Normalization.Sigmoid(m_Drone.WorldVelocity);
            // // print("velocity:" + velocity);
            // // print("velocity:" + m_Drone.LocalVelocity);
            // Vector4 proximity = m_Drone.GetForwardProximity();
            // // print("proximity: " + proximity);
            // float proxPenalty = (1f - 1f / Mathf.Max(proximity.w, 0.1f)) * velocity.sqrMagnitude * 0.25f;
            // // print("proximity penalty: " + proxPenalty);
            // AddReward(proxPenalty);
            
            // already in base drone
            // sensor.AddObservation(velocity); // 3 
            // sensor.AddObservation(Normalization.Sigmoid(m_Drone.LocalSpin)); // 3
            // sensor.AddObservation(Normalization.Sigmoid(m_Drone.LocalVelocity)); // 3
            // sensor.AddObservation(proximity.w * 2f - 1f); // 1 
            // sensor.AddObservation((Vector3)proximity); // 3
            // 13 velocity related observations
            
        }
   
         protected void ObserveWithSensors()
        {
            // *** SCAN ***
            Vector3 pos = m_Body.WorldPosition;
            Vector3 fwd = m_Body.WorldForward;
            // m_Targets.Clear();

            // Find targets in vicinity.
            // if CanScan() removed because of reduction of FPS
            var _targetsFound = false;
            Vector3 _vectorToTargetsInFront = vectorToTargetsInFront;
            Vector3 _vectorToTargetsFacingAway = vectorToTargetsFacingAway;
            float _distanceToTargets = 0;
            float _angleToTargetsInFront = 0;
            float _angleToTargetsFacingAway = 0;
            
            _targetsFound = ScanForTargets(_targetsFound, fwd, pos, ref _vectorToTargetsInFront, ref _distanceToTargets, ref _angleToTargetsInFront, ref _vectorToTargetsFacingAway, ref _angleToTargetsFacingAway);
            UseScanner(fwd, pos);

            if (_targetsFound == false)
            {
                // Point point = new Point(PointType.ScanOutOfRange, m_Body.WorldPosition + fwd * m_SensorComponent.MaxDistance, Time.time);
                // Data.AddPoint(point);
                ResetAgent(false);
            }
            else
            {
                // IF targets are in vision and I AM NOT SCANNING: penalize. Will make the agent hurry to scan.
                print("penalizing while not scanning");
                AddReward(-0.0001f);
                
                var n_ObjectsDetectedBySensor = m_SensorComponent.GetDetectedGameObjects(m_TargetTag).Count();
                
                // avg vector to targets
                vectorToTargetsInFront = _vectorToTargetsInFront;
                vectorToTargetsFacingAway = _vectorToTargetsFacingAway;
                
                // avg distance to targets
                _distanceToTargets /= n_ObjectsDetectedBySensor;
                distanceToTarget = _distanceToTargets;
                
                // avg facing direction to targets (technically should be inferred from vectors)
                _angleToTargetsInFront /= n_ObjectsDetectedBySensor;
                angleToTargetsInFront = _angleToTargetsInFront;
                
                _angleToTargetsFacingAway /= n_ObjectsDetectedBySensor;
                angleToTargetsFacingAway = _angleToTargetsFacingAway;
                
                // print("in front of me: " + vectorToTargetsInFront);
                // print("facing away: " + vectorToTargetsFacingAway);
                
                // print("distance to targets: " + distanceToTarget);
                
                // print("angle to targets infront: " + angleToTargetsInFront);
                // print("angle to targets facingaway: " + angleToTargetsFacingAway);
            }

            // ResetVFX();
        }

         private bool ScanForTargets(bool _targetsFound, Vector3 fwd, Vector3 pos, ref Vector3 _vectorToTargetsInFront,
             ref float _distanceToTargets, ref float _angleToTargetsInFront, ref Vector3 _vectorToTargetsFacingAway,
             ref float _angleToTargetsFacingAway)
         {
             foreach (var target in m_SensorComponent.GetDetectedGameObjects(m_TargetTag))
             {
                 // extract voxel
                 VoxelController myVoxel = target.transform.parent.GetComponent<VoxelController>();

                 if (myVoxel)
                 {
                     // TODO update octree as scan point 
                     // collection of scan points for octree at targe'ts position
                     // Point point = new Point(PointType.ScanPoint, target.transform.position, Time.time);
                     // Data.AddPoint(point);

                     // update that a target was found, otherwise later a ScanOutOfRange point is added
                     _targetsFound = true;

                     var dotProductToTarget = Vector3.Dot(fwd, myVoxel.transform.forward);
                     Vector3 delta = target.transform.position - pos;

                     // dotProduct requirement: ONLY SCAN TARGETS IN FRONT
                     if (dotProductToTarget < 0)
                         // dotProductToTarget < m_TargetDotProduct
                         // && Vector3.Angle(fwd, delta) < m_TargetFollowAngle 
                         // && delta.sqrMagnitude < m_TargetFollowDistanceSqr)
                     {
                         _vectorToTargetsInFront += myVoxel.transform.position - pos;
                         _vectorToTargetsInFront /= 2f;

                         _distanceToTargets += Vector3.Distance(myVoxel.transform.position, pos);

                         _angleToTargetsInFront += Vector3.Angle(fwd, delta);
                     }
                     else
                     {
                         // objects i cannot scan
                         _vectorToTargetsFacingAway += myVoxel.transform.position - pos;
                         _vectorToTargetsFacingAway /= 2f;

                         _angleToTargetsFacingAway += Vector3.Angle(fwd, delta);
                     }
                 }
             }

             return _targetsFound;
         }

         private void UseScanner(Vector3 fwd, Vector3 pos)
         {
             foreach (var target in m_SensorComponent_Scanner.GetDetectedGameObjects(m_TargetTag))
             {
                 VoxelController myVoxel = target.transform.parent.GetComponent<VoxelController>();
                 if (myVoxel)
                 {
                     // dotProduct requirement: ONLY SCAN TARGETS IN FRONT
                     var dotProductToTarget = Vector3.Dot(fwd, myVoxel.transform.forward);
                     // distanceToTarget = Vector3.Distance(myVoxel.transform.position, pos);

                     // vector to target, used to get angle observation
                     Vector3 delta = target.transform.position - pos;

                     // if facing targets and chance to collect is successful
                     if (dotProductToTarget < 0 && UnityEngine.Random.Range(0, 101) <= m_ScanAccuracy)
                     {
                         // ScanTarget(target);
                         if (myVoxel.Collect())
                             OnVoxelScanned(target);

                         else
                         {
                             print("could not collect voxel" + target.transform.name);
                         }
                     }
                 }
             }
         }
         public void OnVoxelScanned(GameObject target)
         {
             m_VFXController.RotateVFXToTarget(target);
             m_VoxelsScanned++;
         }
         protected bool CanScan()
         {
             return Time.time - m_ShotTime >= m_ScanReloadTime;
         }
         protected bool NotMoving()
         {
             return Time.time - m_MovedTime >= m_InactivityTime / 4;
         }

         // after having scanned AND a period of time has passed since last scan, reset rotation == not scanning anymore
         // it needs the bool scanned otherwise it will always reset the position since time will always be higher
         protected bool CanResetScannerRotation()
         {
             return (Time.time - m_ShotTime >= m_InactivityTime);
         } 

         public void ResetAgent(bool fullReset = false)
         {
            // reset SCAN observations 
            vectorToTargetsInFront = vectorToTargetsFacingAway = transform.forward;

            distanceToTarget = -1f;

            angleToTargetsInFront = -1f;
            angleToTargetsFacingAway = -1f;

            // scanned = false;
            if (fullReset) 
            {
                m_VoxelsScanned = 0;
            }
        }
        

    }

}