using System.Collections.Concurrent;
using System.Linq;
using Unity.MLAgents.Sensors;
using UnityEngine;

namespace Ademord
{
    // this FixedQueue<int> is used to accumulate the class density across time as defined by Chaplot.
    //https://stackoverflow.com/questions/5852863/fixed-size-queue-which-automatically-dequeues-old-values-upon-new-enques
    public class FixedSizedQueue
    {
        public ConcurrentQueue<int> q = new ConcurrentQueue<int>();
        private object lockObject = new object();
        public int Limit { get; set; }
        public int Enqueue(int obj)
        {
            // add new incoming elements
            int sum = obj;
            q.Enqueue(obj);

            // remove exceeding elements and update sum
            lock (lockObject)
            {
                int overflow;
                while (q.Count > Limit && q.TryDequeue(out overflow))
                {
                    sum -= overflow;
                }
            }
            return sum;
        }

        public float Average()
        {
            return q.Average();
        }
    }
    
    public class FixedSizedQueueWithFloats
    {
        public ConcurrentQueue<float> q = new ConcurrentQueue<float>();
        private object lockObject = new object();
        public int Limit { get; set; }
        public float Enqueue(float obj)
        {
            // add new incoming elements
            float sum = obj;
            q.Enqueue(obj);

            // remove exceeding elements and update sum
            lock (lockObject)
            {
                float overflow;
                while (q.Count > Limit && q.TryDequeue(out overflow))
                {
                    sum -= overflow;
                }
            }
            return sum;
        }

        public float Average()
        {
            return q.Average();
        }
    }
    
    public class SemanticCuriosityAgentTrain : DetectorAgentTrain
    {
        [Header("Semantic Curiosity Agent Parameters")]
        [SerializeField] protected bool m_AddSemanticCuriosityObservations;
        [SerializeField] protected bool m_TrainSemanticCuriosity;
        [SerializeField] private int m_MaxTemporalBufferSize = 10;
        
        private FixedSizedQueue m_ClassCountBuffer;
        private float m_SumOfElementsInSemanticMap;
        private float m_CuriosityRewardCoefficientChaplot = 2.5f * 0.01f;
        
        public override void OnEpisodeBegin()
        {
            base.OnEpisodeBegin();

            ResetAgent();
        }

        protected new virtual void ResetAgent()
        {
            // this is the reward multiplier used by Chaplot.
            m_SumOfElementsInSemanticMap = 0f;
            m_ClassCountBuffer = new FixedSizedQueue();
            m_ClassCountBuffer.Limit = m_MaxTemporalBufferSize;
        }

        public override void CollectObservations(VectorSensor sensor)
        {
            base.CollectObservations(sensor);


            int totalClassesDetected = m_detections.Distinct().Count();
            m_SumOfElementsInSemanticMap += m_ClassCountBuffer.Enqueue(totalClassesDetected);
            
            // print("totalClassesDetected: " + totalClassesDetected + 
            //       "m_ClassCountBuffer: " + String.Join(", ", m_ClassCountBuffer.q.ToList()) + 
            //       "m_SumOfElementsInSemanticMap: " + GetRationalizedClassDensity());
            
            if (m_AddSemanticCuriosityObservations)
            {
                Debug.Assert(m_LoadDetector, "LoadDetector must be loaded for Semantic Curiosity Obs");
                sensor.AddObservation(GetRationalizedClassDensity()); // 1

                // the total different number of classes seen across time is what they want. how many different classes detections across time
                // m_SumOfElementsInSemanticMap += list_classCountBuffer.Distinct().Count();
            }
        }
        public override void SetRewards()
        {
            base.SetRewards();
            
            if (m_TrainSemanticCuriosity)
            {
                if (m_EnableTrainDebuggingLogs) print("m_TrainSemanticCuriosity");
                AddReward(GetSemanticCuriosityRewardChaplot());
            }
        }

        protected float GetSemanticCuriosityRewardChaplot()
        {
            return m_CuriosityRewardCoefficientChaplot * GetRationalizedClassDensity();
        }

        protected float GetRationalizedClassDensity()
        {
            return (float) m_SumOfElementsInSemanticMap / m_MaxTemporalBufferSize;
        }
        public override void AddTensorboardStats()
        {
            base.AddTensorboardStats();
            m_TBStats.Add(m_BehaviorName + "/Entropy: SumOfElementsInSemanticMap ", m_SumOfElementsInSemanticMap);
        }

        public override void DrawGUIStats(bool drawSummary = true)
        {
            base.DrawGUIStats(false);
            var palette = Colors.Palette(4, 1, 0.5f, 0.2f, 0.8f);

            m_GUIStats.Add(GetRationalizedClassDensity(), "Semantic Curiosity", "Sum Of Elements in SemanticMap", palette[2]);

            if (drawSummary)
            {
                float sum = 0;
                sum += m_GUIStats.Add(GetSemanticCuriosityRewardChaplot(), "Rewards", "Chaplot's Semantic Curiosity ", Colors.Orange);

                m_GUIStats.Add(sum, "Reward Sum", "", Colors.Lightblue);                
            }
        }
    }
}