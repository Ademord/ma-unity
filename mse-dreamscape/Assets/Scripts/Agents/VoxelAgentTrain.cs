using UnityEngine;
using Unity.MLAgents;
using Unity.MLAgents.Actuators;

namespace Ademord
{
    public class VoxelAgentTrain : VoxelAgent
    {

        public override void Initialize()
        {
            base.Initialize();

        
        }

        public override void OnEpisodeBegin()
        {
            base.OnEpisodeBegin();

            ResetAgent();
            RandomizeTargets();
        }
        
        protected new virtual void ResetAgent()
        {
            m_VoxelsScanned = 0;
            totalVoxelsScanned = 0;
        }
        
        protected void RandomizeTargets()
        {
            RandomizeTargetSpeed();

            if (m_World != null)
                m_World.Reset(false); 

            // m_World.MoveToSafeRandomPosition(m_Drone.transform, true);
        }
        
        public override void SetRewards()
        {
            base.SetRewards();
            AddReward(GetVoxelDiscoveryReward());
        }

     
        public float GetVoxelDiscoveryReward()
        {
            // define reward
            var r = m_VoxelsScanned * 1f;
            // var r = (float) m_VoxelsScanned / (2 + m_VoxelsScanned) * 1f;
            return r;
        }
        
        protected virtual void AddTensorboardStats()
        {
            // m_TBStats.Add(m_BehaviorName + "/Look Error", GetNormLookDirectionError());
            // m_TBStats.Add(m_BehaviorName + "/Walk Error", GetNormWalkDirectionError());
        }

        public override void DrawGUIStats(bool drawSummary = true)
        {
            base.DrawGUIStats(false);
            var palette = Colors.Palette(4, 1, 0.5f, 0.2f, 0.8f);

            // m_GUIStats.Add(GetNormWalkDirectionError(), "Direction Errors", "Walk Direction", Colors.Orange);
            // m_GUIStats.Add(GetNormLookDirectionError(), "Direction Errors", "Look Direction", Colors.Lightblue);
        
            m_GUIStats.Add(m_VoxelsScanned, "Voxels", "Voxel Scan Count", palette[0]);
            m_GUIStats.Add(totalVoxelsScanned, "Voxels", "Total Voxel Scan Count", palette[1]);
            
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
        // http://fooplot.com/#W3sidHlwZSI6MCwiZXEiOiIoKGNvcyh4KjAuMDE3NDUzMjkpLTAuNSkqMileNCIsImNvbG9yIjoiIzAwMDAwMCJ9LHsidHlwZSI6MTAwMCwid2luZG93IjpbIi05MC41MTI5MTI3MjA0NDE3IiwiOTguNjYxOTg1MjQ4MzI3MTQiLCItMC42NjUiLCIxLjMzNSJdfV0-
    }
}