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
            
            // m_World.MoveToSafeRandomPosition(m_Drone.transform, true);
        }
        public override void SetRewards()
        {
            base.SetRewards();
            // print("adding octree rewards");
            AddReward(GetGoalsReward());

        }

        public float GetGoalsReward()
        {
            // define reward
            var r = goalCount * 1;
            
            // add to accumulator
            totalGoalCount += goalCount;
            goalCount = 0;
            
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
            }
        } 
    }
}
