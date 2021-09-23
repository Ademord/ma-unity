using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace Ademord
{
    public class QuidditchAgent : DroneAgentTrain
    {
        private int goalCount = 0;
        private int totalGoalCount = 0;
        public override void Initialize()
        {
            base.Initialize();
            
            m_Body.OnGoalCollisionEventHandler += GoalCollisionEvent;
        }
        public override void OnEpisodeBegin()
        {
            base.OnEpisodeBegin();

            ResetAgent();
            RandomizeTargets();
        }
        protected new virtual void ResetAgent()
        {
            // print("ResetAgent: QuidditchAgent");
            goalCount = 0;
            totalGoalCount = 0;
        }

        protected void RandomizeTargets()
        {
            RandomizeTargetSpeed();

            if (m_World != null)
                m_World.Reset(true); 
            
            m_World.MoveToSafeRandomPosition(m_Body.transform, true);
        }
        public override void SetRewards()
        {
            base.SetRewards();
            // print("adding octree rewards");
            AddReward(GetGoalsReward());

        }
        public override void PostAction()
        {
            base.PostAction();
            goalCount = 0;
        }
        public float GetGoalsReward()
        {
            var r = goalCount * 1f;
            return r;
        }
        
        protected virtual void GoalCollisionEvent(object sender, VoxelCollectedEventArgs e)
        {
            var goal = e.CollisionCollider.transform.parent.GetComponent<VoxelController>();
            // print("trying to collllect voxel: " + goal);
            if (goal.Collect())
            {
                // print("collected a quidditch goal!");
                goalCount++;
                totalGoalCount++;
            }
        }
        public override void DrawGUIStats(bool drawSummary = true)
        {
            base.DrawGUIStats(false);
            var palette = Colors.Palette(4, 1, 0.5f, 0.2f, 0.8f);

            // m_GUIStats.Add(GetNormWalkDirectionError(), "Direction Errors", "Walk Direction", Colors.Orange);
            // m_GUIStats.Add(GetNormLookDirectionError(), "Direction Errors", "Look Direction", Colors.Lightblue);
        
            m_GUIStats.Add(goalCount, "Goals", "Goal Count", palette[0]);
            m_GUIStats.Add(totalGoalCount, "Goals", "Total Goal Count", palette[1]);
            
            if (drawSummary)
            {
                // rewards
            
                float sum =
                    m_GUIStats.Add(GetGoalsReward(), "Rewards", "Goal Reward", palette[0]) +
                    m_GUIStats.Add(GetMovingForwardReward(), "Rewards", "Moving Forward Reward", palette[1]);
            
                // penalties
                sum += m_GUIStats.Add(GetSpeedErrorPenalty(), "Penalties", "Speed Error", palette[1]);

                m_GUIStats.Add(sum, "Reward Sum", "", Colors.Lightblue);
            }
        }
    }
}
