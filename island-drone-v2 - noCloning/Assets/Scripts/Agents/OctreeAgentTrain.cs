using UnityEngine;
using Unity.MLAgents;
using Unity.MLAgents.Actuators;

namespace Ademord
{
    public class OctreeAgentTrain : OctreeAgent
    {
         [SerializeField]
        protected bool m_DrawGUIStats;
        protected GUIStats m_GUIStats;

        [SerializeField]
        [Tooltip("Step interval for writing stats to Tensorboard.")]
        protected int m_TBStatsInterval = 60;
        protected StatsRecorder m_TBStats;

        [SerializeField, MinMaxSlider(0f, 5f)]
        protected MinMax m_TargetSpeedRange = new MinMax(0f, 5f);

        public override void Initialize()
        {
            base.Initialize();

            m_TBStats = Academy.Instance.StatsRecorder;
            m_GUIStats = GetComponent<GUIStats>();
            
            if (m_DrawGUIStats && m_GUIStats == null)
            {
                m_GUIStats = gameObject.AddComponent<GUIStats>();
            }
        }
        
        public override void OnActionReceived(ActionBuffers actionBuffers)
        {
            base.OnActionReceived(actionBuffers);

            if (m_Requester.DecisionStepCount % m_TBStatsInterval == 0)
            {
                AddTensorboardStats();
            }

            if (m_DrawGUIStats)
            {
                DrawGUIStats();
            }

            SetRewards();
            PostAction();
        }

        protected virtual void SetRewards()
        {
            AddReward(GetOctreeDiscoveryReward());
            AddReward(GetLingeringPenalty());
            AddReward(GetSpeedErrorPenalty());
            Data.StepUpdate(m_Body.WorldPosition);
        }

        protected virtual void PostAction() { }

        // SPEED

        protected void RandomizeTargetSpeed()
        {
            TargetSpeed = Random.Range(m_TargetSpeedRange.Min, m_TargetSpeedRange.Max);
        }

        protected float GetForwardSpeed()
        {
            return Vector3.Dot(m_Body.AvgWorldVelocityXZ, m_Body.AvgWorldForwardXZ);
        }

        // protected float GetDirectionalSpeed()
        // {
        //     return Vector3.Dot(m_Body.AvgWorldVelocityXZ, m_TargetWalkDirectionXZ);
        // }
        //
        // protected float GetSpeedError()
        // {
        //     return Mathf.Min(Mathf.Abs(GetDirectionalSpeed() - TargetSpeed), MaxSpeed);
        // }
        protected float GetSpeedError()
        {
            // this use case does not demand that the agent moves in a specific direction. shortest path does
            // since it provides more observability
            return Mathf.Min(Mathf.Abs(m_Body.AvgSpeed - TargetSpeed), MaxSpeed);
        }

        // TBD error/(2+error)*1.4 (assuming max speed = 5)
        // http://fooplot.com/#W3sidHlwZSI6MCwiZXEiOiJ4LygyK3gpKjEuNCIsImNvbG9yIjoiIzAwMDAwMCJ9LHsidHlwZSI6MTAwMH1d
        protected float GetSpeedErrorPenalty(float strength = 1)
        {
            if (TargetSpeed < MinSpeed)
            {
                // Penalize any movement.
                return -m_Body.WorldVelocity.magnitude;
            }

            float error = GetSpeedError();
            float norm = error / (2 + error) * 1.4f;
            return norm * -strength;
        }


        // STATS

        protected virtual void AddTensorboardStats()
        {
            m_TBStats.Add(m_BehaviorName + "/Speed Error", GetSpeedError());
            m_TBStats.Add(m_BehaviorName + "/Look Error", GetLingeringPenalty());
        }

        protected virtual void DrawGUIStats()
        {
            m_GUIStats.Add(TargetSpeed, "Speed", "Target", Colors.Orange);
            m_GUIStats.Add(m_Body.AvgSpeed, "Speed", "Measured Avg.", Colors.Lightblue);

            var palette = Colors.Palette(1, 1, 0.5f, 0.2f, 0.8f);

            float sum =
                m_GUIStats.Add(GetOctreeDiscoveryReward(), "Rewards", "Octree", palette[1]);

            sum += m_GUIStats.Add(GetLingeringPenalty(), "Penalties", "Speed Error", Colors.Orange) +
                   m_GUIStats.Add(GetSpeedErrorPenalty(), "Penalties", "Speed Error", Colors.Orange);
        
            m_GUIStats.Add(sum, "Reward Sum", "", Colors.Lightblue);
        }
        
        public float GetLingeringPenalty()
        {
            float linger = lingerCount / 100f; // 0 - 2
            return -linger * 0.1f;
        }
        public float GetOctreeDiscoveryReward()
        {
            Vector3 pos = m_Body.WorldPosition;
            int nodeCount = Data.Tree.Intersect(pos, scanPoint.Position);
            return (nodeCount * 0.1f) / Data.LookRadius;
        }
    }
}