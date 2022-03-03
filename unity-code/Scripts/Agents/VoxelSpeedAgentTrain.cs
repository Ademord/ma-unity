using System.Collections;
using System.Collections.Generic;
using Unity.MLAgents.Sensors;
using UnityEngine;

namespace Ademord
{
    public class VoxelSpeedAgentTrain : VoxelAgentTrain
    {
        private bool TargetsInFOV;
        public override void Initialize()
        {
            base.Initialize();
            TargetsInFOV = false;
        }
        
        public override void CollectObservations(VectorSensor sensor)
        {
            base.CollectObservations(sensor);

            TargetsInFOV = CheckForTargetsInFOV();
            if (TargetsInFOV)
            {
                m_SpeedErrorStrength = 0.25f;
            }
            else
            {
                m_SpeedErrorStrength = 1f;
            }
        }

        protected bool CheckForTargetsInFOV()
        {
            // this method uses yield so we have to query the results out
            foreach (var target in m_SensorComponent.GetDetectedGameObjects(m_TargetTag))
            {
                var myVoxel = target.transform.GetComponent<VoxelDetectableGameObject>();
                // check all the voxels and if one if visible then change the value.
                if (myVoxel.IsInSight() > 0)
                {
                    return true;
                }
            }

            return false;
        }
        public override void DrawGUIStats(bool drawSummary = true)
        {
            base.DrawGUIStats(false);
            var palette = Colors.Palette(4, 1, 0.5f, 0.2f, 0.8f);

            // m_GUIStats.Add(GetNormWalkDirectionError(), "Direction Errors", "Walk Direction", Colors.Orange);
            // m_GUIStats.Add(GetNormLookDirectionError(), "Direction Errors", "Look Direction", Colors.Lightblue);
        
            m_GUIStats.Add(m_SpeedErrorStrength, "Voxels", "Speed Error Strength", palette[2]);
            
            if (drawSummary)
            {
                // rewards
            
                float sum =
                    m_GUIStats.Add(GetVoxelDiscoveryReward(), "Rewards", "Voxel Discovery", palette[0]) +
                    m_GUIStats.Add(GetMovingForwardReward(), "Rewards", "Moving Forward Reward", palette[1]);

            
                // penalties
                sum += m_GUIStats.Add(GetSpeedErrorPenalty(), "Penalties", "Speed Error", palette[1]);

                m_GUIStats.Add(sum, "Reward Sum", "", Colors.Lightblue);
            }
        }
    }
}