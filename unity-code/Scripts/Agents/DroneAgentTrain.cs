using System.Runtime.CompilerServices;
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
        [Header("VFX Parameters")]
        [Tooltip("Disable VFX during training.")]
        [SerializeField] protected bool m_EnableVFX;
        [Tooltip("VFX of Scanner Drone that rotates towards objects being scanned.")]
        [SerializeField] public VFXController m_VFXController;
        [Tooltip("Disable print messages of which methods are begin trained.")]
        [SerializeField] protected bool m_EnableTrainDebuggingLogs;
        [Header("GUI Parameters")]
        [SerializeField]
        protected bool m_DrawGUIStats;
        protected GUIStats m_GUIStats;
        [SerializeField]
        [Tooltip("Step interval for writing stats to Tensorboard.")]
        protected int m_TBStatsInterval = 60;
        protected StatsRecorder m_TBStats;

       
        [Header("Speed Parameters")]
        [SerializeField] protected bool m_TrainMovingForward;
        [SerializeField] protected bool m_TrainTargetSpeed;
        [SerializeField, MinMaxSlider(0f, 4f)] protected MinMax m_TargetSpeedRange;

        protected Vector3 m_TargetWalkDirectionXZ;
        protected Vector3 m_TargetLookDirectionXZ;
        protected float m_SpeedErrorStrength = 1;
        protected bool targetsInFOV = false;
        
        [SerializeField] private int m_MaxSpeedPenaltyBufferSize = 30;
        private FixedSizedQueueWithFloats m_SpeedPenaltyCountBuffer;

        public override void Initialize()
        {
            base.Initialize();

            m_TBStats = Academy.Instance.StatsRecorder;
            m_GUIStats = GetComponent<GUIStats>();
            if (m_VFXController == null)
            {
                Debug.LogError("No VFXController set.");
            }

            m_VFXController.Initialize(m_EnableVFX);
            
            // VFX determines all drone renderings and GUI.
            m_DrawGUIStats = m_EnableVFX && m_DrawGUIStats;

            if (m_DrawGUIStats && m_GUIStats == null)
            {
                m_GUIStats = gameObject.AddComponent<GUIStats>();
            }
        }

        public override void OnEpisodeBegin()
        {
            base.OnEpisodeBegin();

            ResetAgent();
        }
        public void ResetAgent()
        {
            targetsInFOV = false;
                
            m_SpeedPenaltyCountBuffer = new FixedSizedQueueWithFloats();
            m_SpeedPenaltyCountBuffer.Limit = m_MaxSpeedPenaltyBufferSize;
            
            // print("ResetAgent: DroneAgentTrain");
            if (m_DrawGUIStats)
            {
                m_GUIStats.Clear();
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

        public virtual void SetRewards()
        {
            if (m_TrainMovingForward)
            {
                if (m_EnableTrainDebuggingLogs) print("m_TrainMovingForward");
                AddReward(GetMovingForwardReward());
            }

            if (m_TrainTargetSpeed)
            {
                if (m_EnableTrainDebuggingLogs) print("m_TrainTargetSpeed");
                AddReward(GetSpeedErrorPenalty());
            }
        }

        // used to check if exited boundaries 
        // used to add random forces
        // used to randomize targets after a certain stepcount
        public virtual void PostAction()
        {
            var penalty = GetSpeedErrorPenaltyValue();
            m_SpeedPenaltyCountBuffer.Enqueue(penalty);
            
            if (EnvironmentType == EnvironmentType.OpenWorld && m_OutsideBounds)
            {
                if (m_OutsideBounds) print("Penalizing for being outside the allowed bounds of 30m.");
                    // print("Body position: " + m_Body.WorldPosition);
                    AddReward(-0.01f);
            }
        }
        
        // SPEED
        protected void RandomizeTargetSpeed()
        {
            TargetSpeed = m_TargetSpeedRange.Max;
            // TargetSpeed = Random.Range(m_TargetSpeedRange.Min, m_TargetSpeedRange.Max);
        }

        protected virtual float GetSpeedError()
        {
            // adapted so that : i dont care if the drone goes faster than maxSpeed, penalize if he is slower than max speed
            
            return Mathf.Abs(Mathf.Min(m_Body.AvgSpeed - TargetSpeed, 0f));
            // return Mathf.Min(Mathf.Abs(m_Body.AvgSpeed - TargetSpeed), MaxSpeed);
            // return Mathf.Min(Mathf.Abs(GetDirectionalSpeed() - TargetSpeed), MaxSpeed);
        }

        // TBD error/(2+error)*1.4 (assuming max speed = 5)
        // http://fooplot.com/#W3sidHlwZSI6MCwiZXEiOiJ4LygyK3gpKjEuNCIsImNvbG9yIjoiIzAwMDAwMCJ9LHsidHlwZSI6MTAwMH1d
        protected float GetSpeedErrorPenalty(float strength = 0.1f)
        {
            return m_SpeedPenaltyCountBuffer.Average();
        }

        private float GetSpeedErrorPenaltyValue(float strength = 0.1f)
        {
            if (targetsInFOV) return 0;
            
            if (TargetSpeed < MinSpeed)
            {
                // Penalize any movement.
                print("penalizing any movement");
                return -m_Body.WorldVelocity.magnitude;
            }

            float error = GetSpeedError();
            // print("speedError: " + error);
            // float norm = error / (2 + error) * 1.4f;
            float adjustedError = error / (2 + error);
            // adjustedError = Mathf.Min(adjustedError, 0);
            return m_SpeedErrorStrength * -adjustedError;
        }

        protected float GetMovingForwardReward()
        {
            // print("moving forward: " + movingForward);
            return movingForward ? 0.001f: 0;
        }
        // STATS

        public virtual void AddTensorboardStats()
        {
            m_TBStats.Add(m_BehaviorName + "/Speed Error", GetSpeedError());
            m_TBStats.Add(m_BehaviorName + "/Speed Error Strength", m_SpeedErrorStrength);
            m_TBStats.Add(m_BehaviorName + "/0: Moving Forward", movingForward ? 1 : 0);
        }

        public virtual void DrawGUIStats(bool drawSummary = true)
        {
            m_GUIStats.Add(TargetSpeed, "Speed", "Target", Colors.Orange);
            m_GUIStats.Add(m_Body.AvgSpeed, "Speed", "Measured Avg.", Colors.Lightblue);

            if (drawSummary)
            {
                m_GUIStats.Add(GetSpeedErrorPenalty(), "Penalties", "Speed Error", Colors.Orange);
                m_GUIStats.Add(GetMovingForwardReward(), "Rewards", "Moving Forward Reward", Colors.Orange);
            }
        }
    }
}