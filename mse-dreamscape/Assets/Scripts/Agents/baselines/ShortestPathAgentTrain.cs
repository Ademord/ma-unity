using System;
using Unity.MLAgents.Sensors;
using UnityEngine;

namespace Ademord
{
    public class ShortestPathAgentTrain : VoxelSpeedPigeonAgentTrain
    {
        [Header("Shortest Path Agent Parameters")]
        [SerializeField] private bool m_TrainShortestPath = true;
        [SerializeField] private bool m_AddShortestPathObservations = true;
        protected Vector3 m_closestTarget;
        protected float penaltyStrength = 1f;
        protected float distanceToTarget = 1f;

        public override void Initialize()
        {
            base.Initialize();

            m_closestTarget = new Vector3();
            m_World.OnObjectFullyScannedEventHandler += ObjectFullyScannedEvent;
        }
        public override void OnEpisodeBegin()
        {
            base.OnEpisodeBegin();

            SetClosestTarget();
        }

        public override void CollectObservations(VectorSensor sensor)
        {
            base.CollectObservations(sensor);

            if (m_AddShortestPathObservations)
            {
                // look and walk direction errors will dissolve when close to the target
                distanceToTarget = Vector3.Distance(m_closestTarget, m_Body.WorldPosition) - 1f;
                penaltyStrength = Math.Abs(distanceToTarget / (2 + distanceToTarget));
                // print("distance to target: " + distanceToTarget + ", penaltyStrength: " + penaltyStrength);
                
                // SetTargetDirections(vectorToTarget, vectorToTarget);
                // SetTargetDirections(m_Body.AvgWorldVelocityXZ, m_Body.WorldForward);
                SetTargetPositions(m_closestTarget, m_closestTarget);
                
                sensor.AddObservation(NormTargetWalkAngle);
                sensor.AddObservation(NormTargetLookAngle);
               
                // sensor.AddObservation(m_closestTarget); // 3
            }
        }
        
        public override void SetRewards()
        {
            base.SetRewards();
            if (m_TrainShortestPath)
            {
                AddReward(GetWalkDirectionReward());
                AddReward(GetLookDirectionReward());
            }
        }
        
        protected virtual void ObjectFullyScannedEvent(object sender, VoxelCollectedEventArgs e)
        {
            SetClosestTarget();
        }
        public void SetClosestTarget()
        {
            m_closestTarget  = GetClosestTarget();
            
            // safety
            if (m_closestTarget.magnitude == 0)
            {
                print("GetClosestTarget found no Target.");

            }
        }
        protected Vector3 GetClosestTarget()
        {
            return m_World.GetClosestTarget(m_Body.WorldPosition);
        }
        
        protected void SetTargetPositions(Vector3 walkPos, Vector3 lookPos)
        {
            Vector3 pos = m_Body.WorldPosition;
            SetTargetDirections(
                Vector3.ProjectOnPlane(walkPos - pos, Vector3.up),
                Vector3.ProjectOnPlane(lookPos - pos, Vector3.up));
        }
        protected void SetTargetDirections(Vector3 walkDirXZ, Vector3 lookDirXZ)
        {
            m_TargetWalkDirectionXZ = walkDirXZ.normalized;
            m_TargetLookDirectionXZ = lookDirXZ.normalized;
            TargetDirectionsToAngles();
        }

        protected void TargetDirectionsToAngles()
        {
            Vector3 fdw = m_Body.AvgWorldForwardXZ;
            TargetWalkAngle = Vector3.SignedAngle(fdw, m_TargetWalkDirectionXZ, Vector3.up);
            TargetLookAngle = Vector3.SignedAngle(fdw, m_TargetLookDirectionXZ, Vector3.up);
        }

        protected void TargetAnglesToDirections()
        {
            Vector3 fdw = m_Body.AvgWorldForwardXZ;
            m_TargetWalkDirectionXZ = Quaternion.AngleAxis(TargetWalkAngle, Vector3.up) * fdw;
            m_TargetLookDirectionXZ = Quaternion.AngleAxis(TargetLookAngle, Vector3.up) * fdw;
        }
        
        protected float GetNormWalkDirectionError()
        {
            
            return penaltyStrength * Vector3.Angle(m_Body.AvgWorldVelocityXZ, m_TargetWalkDirectionXZ) / 180f;
        }

        protected float GetWalkDirectionReward(float strength = 1, float exp = 8)
        {
           
            return Mathf.Pow(1 - GetNormWalkDirectionError(), exp) * strength;
            // return Mathf.Pow(1 - GetNormWalkDirectionError(), exp) * strength;
        }

        protected float GetNormLookDirectionError()
        {
            return penaltyStrength * Mathf.Abs(NormTargetLookAngle);
        }

        protected float GetLookDirectionReward(float strength = 1, float exp = 8)
        {
            return Mathf.Pow(1 - GetNormLookDirectionError(), exp) * strength;
        }
        
        protected float GetForwardSpeed()
        {
            return Vector3.Dot(m_Body.AvgWorldVelocityXZ, m_Body.AvgWorldForwardXZ);
        }

        protected float GetDirectionalSpeed()
        {
            return Vector3.Dot(m_Body.AvgWorldVelocityXZ, m_TargetWalkDirectionXZ);
        }

        protected override float GetSpeedError()
        {
            return Mathf.Min(Mathf.Abs(GetDirectionalSpeed() - TargetSpeed), MaxSpeed);
        }
        
        public override void AddTensorboardStats()
        {
            base.AddTensorboardStats();
            m_TBStats.Add(m_BehaviorName + "/Look Error", GetNormLookDirectionError());
            m_TBStats.Add(m_BehaviorName + "/Walk Error", GetNormWalkDirectionError());
        }

        public override void DrawGUIStats(bool drawSummary = true)
        {
            base.DrawGUIStats(false);

            m_GUIStats.Add(GetNormWalkDirectionError(), "Direction Errors", "Walk Direction", Colors.Orange);
            m_GUIStats.Add(GetNormLookDirectionError(), "Direction Errors", "Look Direction", Colors.Lightblue);

            var palette = Colors.Palette(4, 1, 0.5f, 0.2f, 0.8f);
            if (drawSummary)
            {
                float sum =
                    m_GUIStats.Add(GetWalkDirectionReward(), "Rewards", "Walk Direction", palette[2]) +
                    m_GUIStats.Add(GetLookDirectionReward(), "Rewards", "Look Direction", palette[3]);

                sum += m_GUIStats.Add(GetSpeedErrorPenalty(), "Penalties", "Speed Error", Colors.Orange);

                m_GUIStats.Add(sum, "Reward Sum", "", Colors.Lightblue);
            }
        }
    }
}