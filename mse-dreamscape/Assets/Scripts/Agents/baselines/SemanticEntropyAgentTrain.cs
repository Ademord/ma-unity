using System;
using System.Collections;
using System.Collections.Concurrent;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Unity.MLAgents.Sensors;
using UnityEngine;

namespace Ademord
{
    // this FixedQueue<float> is used to accumulate the entropy across time.
    //https://stackoverflow.com/questions/5852863/fixed-size-queue-which-automatically-dequeues-old-values-upon-new-enques
    public class FixedSizedQueueFloat
    {
        ConcurrentQueue<float> q = new ConcurrentQueue<float>();
        private object lockObject = new object();
        public float Limit { get; set; }
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
    }
    
    public class SemanticEntropyAgentTrain : SemanticCuriosityAgentTrain
    {
        [Header("Semantic Curiosity Agent Parameters")]
        [SerializeField] private bool m_SemanticEntropyObservations = true;
        [SerializeField] private bool m_TrainSemanticEntropy = true;
        [SerializeField] private int m_MaxEntropyTemporalBufferSize = 10;
        
        private float m_ShannonEntropyLevels;
        private FixedSizedQueueFloat m_EntropyLevelsTemporalBuffer;
        private float MaxEntropyLevel = 5f;
        
        public override void OnEpisodeBegin()
        {
            base.OnEpisodeBegin();

            ResetAgent();
        }

        protected new virtual void ResetAgent()
        {
            // this is the reward multiplier used by Chaplot.
            m_ShannonEntropyLevels = 0;
            m_EntropyLevelsTemporalBuffer = new FixedSizedQueueFloat();
            m_EntropyLevelsTemporalBuffer.Limit = m_MaxEntropyTemporalBufferSize;
        }

        public override void CollectObservations(VectorSensor sensor)
        {
            base.CollectObservations(sensor);

            if (m_SemanticEntropyObservations)
            {
                var detections = detectorCam.GetDetections();
                
                ManagedUpdate(detections);
                if (m_TrainSemanticEntropy)
                {
                    m_LingeringPenaltyStrength = m_ShannonEntropyLevels/MaxEntropyLevel;
                }
            }
        }

        private void ManagedUpdate(List<string> detections)
        {
            var query = detections.GroupBy(s => s)
                .Select(g => new { Class = g.Key, Count = g.Count() });

            string alpha = "abcdefghijklmnopqrstuvwxyz";
            var builder = new StringBuilder();
            int count = 0;
            int i = 0;
                
            foreach(var result in query) {
                print("Name: " + result.Class + " Count: " + result.Count);
                // append this character N times to the string
                for (int j = 0; j < result.Count; j++)
                {
                    builder.Append(alpha[i]);
                }

                i++;
            }
            string classCountEncoding = builder.ToString();
            
            // used to compare if the entropy moves the same as the class density from Chaplot
            var detectionEntropy = GetShannonEntropy(classCountEncoding);
            m_ShannonEntropyLevels += m_EntropyLevelsTemporalBuffer.Enqueue(detectionEntropy);
        }
        // https://codereview.stackexchange.com/questions/868/calculating-entropy-of-a-string
        /// <summary>
        /// returns bits of entropy represented in a given string, per 
        /// http://en.wikipedia.org/wiki/Entropy_(information_theory) 
        /// </summary>
        public static float GetShannonEntropy(string s)
        {
            var map = new Dictionary<char, int>();
            foreach (char c in s)
            {
                if (!map.ContainsKey(c))
                    map.Add(c, 1);
                else
                    map[c] += 1;
            }
            // var map = new FrequencyTable<char>(); foreach (char c in s) { map.Add(c); }

            double result = 0.0;
            int len = s.Length;
            foreach (var item in map)
            {
                var frequency = (double)item.Value / len;
                result -= frequency * (Math.Log(frequency) / Math.Log(2));
            }

            return (float)result;
        }
        
        //TODO
        public override void AddTensorboardStats()
        {
            base.AddTensorboardStats();
            m_TBStats.Add(m_BehaviorName + "/SumOfElementsInSemanticMap ", m_ShannonEntropyLevels);
        }

        
        public override void DrawGUIStats(bool drawSummary = true)
        {
            base.DrawGUIStats(false);
            var palette = Colors.Palette(5, 1, 0.5f, 0.2f, 0.8f);

            m_GUIStats.Add(m_ShannonEntropyLevels, "Semantic Curiosity", "Shannon Entropy Level", palette[0]);

            if (drawSummary)
            {
                float sum = 0;
                sum += m_GUIStats.Add(GetVoxelDiscoveryReward(), "Rewards", "Voxel Discovery", palette[0]) +
                       m_GUIStats.Add(GetMovingForwardReward(), "Rewards", "Moving Forward Reward", palette[1]);
                sum += m_GUIStats.Add(GetSemanticCuriosityRewardChaplot(), "Rewards", "Chaplot's Semantic Curiosity ", palette[2]);
                sum += m_GUIStats.Add(GetLingeringPenalty(), "Penalties", "Lingering Error", palette[3]);

                m_GUIStats.Add(sum, "Reward Sum", "", Colors.Lightblue);                
            }
        }
    }
}
 
