using System.Collections;
using System.Collections.Generic;
using MBaske.Sensors.Grid;
using Unity.MLAgents.Sensors;
using UnityEngine;

namespace Ademord
{
    public class VoxelSpeedPigeonAgentTrain : VoxelPigeonAgentTrain
    {
        [SerializeField] protected bool m_SpeedSensitivityToTargetsInFOV;
        public override void Initialize()
        {
            base.Initialize();
            // TargetsInFOV = false;
        }
        
        public override void CollectObservations(VectorSensor sensor)
        {
            base.CollectObservations(sensor);
            
            if (m_SpeedSensitivityToTargetsInFOV)
            {
                targetsInFOV = AreTargetsInFOV(m_SensorComponent, m_TargetTag);
                if (targetsInFOV)
                {
                    m_SpeedErrorStrength = 0f;
                }
                else
                {
                    m_SpeedErrorStrength = 1f;
                }
            }
        }

        protected bool AreTargetsInFOV(GridSensorComponent3D sensor, string tag)
        {
            // this method uses yield so we have to query the results out
            foreach (var target in sensor.GetDetectedGameObjects(tag))
            {
                var myDetectableGameObject = target.transform.GetComponent<VoxelDetectableGameObject>();
                // check all the voxels and if one if visible then change the value.
                if (myDetectableGameObject.IsInSight() > 0)
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