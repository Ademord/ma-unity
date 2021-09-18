using MBaske.Sensors.Grid;
using UnityEngine;
using Unity.MLAgents;
using Unity.MLAgents.Actuators;
using Unity.MLAgents.Sensors;

namespace Ademord
{
    public interface ITrain
    {
        void OnEpisodeBegin();
        void CollectObservations(VectorSensor sensor);
        void PostAction();
        void SetRewards();
        void AddTensorboardStats();
        void DrawGUIStats(bool drawSummary);
    }
    public class DroneAgentTrain : DroneAgent, ITrain
    {
   
        [SerializeField]
        protected bool m_DrawGUIStats;
        protected GUIStats m_GUIStats;

        [SerializeField]
        [Tooltip("Step interval for writing stats to Tensorboard.")]
        protected int m_TBStatsInterval = 60;
        protected StatsRecorder m_TBStats;

        [SerializeField, MinMaxSlider(0f, 10f)]
        protected MinMax m_TargetSpeedRange = new MinMax(0f, 10f);

        protected Vector3 m_TargetWalkDirectionXZ;
        protected Vector3 m_TargetLookDirectionXZ;


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

        public override void OnEpisodeBegin()
        {
            ResetAgent();
            
            base.OnEpisodeBegin();
        }
        public override void ResetAgent()
        {
            base.ResetAgent();

            if (m_DrawGUIStats)
            {
                m_GUIStats.Clear();
            }
        }
        
        public override void OnActionReceived(ActionBuffers actionBuffers)
        {
            // motivate forward movements
            if (actionBuffers.ContinuousActions[0] > 0)
            {
                AddReward(0.00001f);
            }
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

        public virtual void SetRewards()
        {
            // print("adding speed rewards");
            AddReward(GetSpeedErrorPenalty());
        }

        public virtual void PostAction() { }
        
        
        // SPEED
        protected void RandomizeTargetSpeed()
        {
            // // if no targets invision
            //     TargetSpeed = MaxSpeed
            // // else 
            //     TargetSpeed = MinSpeed
            
            TargetSpeed = m_TargetSpeedRange.Max;
            // TargetSpeed = Random.Range(m_TargetSpeedRange.Min, m_TargetSpeedRange.Max);
        }

        protected float GetForwardSpeed()
        {
            return Vector3.Dot(m_Body.AvgWorldVelocityXZ, m_Body.AvgWorldForwardXZ);
        }

        protected float GetDirectionalSpeed()
        {
            return Vector3.Dot(m_Body.AvgWorldVelocityXZ, m_TargetWalkDirectionXZ);
        }

        protected float GetSpeedError()
        {
            return Mathf.Min(Mathf.Abs(m_Body.AvgSpeed - TargetSpeed), MaxSpeed);
            // return Mathf.Min(Mathf.Abs(GetDirectionalSpeed() - TargetSpeed), MaxSpeed);
        }

        // TBD error/(2+error)*1.4 (assuming max speed = 5)
        // http://fooplot.com/#W3sidHlwZSI6MCwiZXEiOiJ4LygyK3gpKjEuNCIsImNvbG9yIjoiIzAwMDAwMCJ9LHsidHlwZSI6MTAwMH1d
        protected float GetSpeedErrorPenalty(float strength = 1)
        {
            if (TargetSpeed < MinSpeed)
            {
                // Penalize any movement.
                print("penbalizing any movement");
                return -m_Body.WorldVelocity.magnitude;
            }

            float error = GetSpeedError();
            float norm = error / (2 + error) * 1.4f;
            return norm * -strength;
        }

        // STATS

        public virtual void AddTensorboardStats()
        {
            m_TBStats.Add(m_BehaviorName + "/Speed Error", GetSpeedError());
        }

        public virtual void DrawGUIStats(bool drawSummary = true)
        {
            m_GUIStats.Add(TargetSpeed, "Speed", "Target", Colors.Orange);
            m_GUIStats.Add(m_Body.AvgSpeed, "Speed", "Measured Avg.", Colors.Lightblue);

            if (drawSummary)
            {
                m_GUIStats.Add(GetSpeedErrorPenalty(), "Penalties", "Speed Error", Colors.Orange);
            }
        }
    }
}