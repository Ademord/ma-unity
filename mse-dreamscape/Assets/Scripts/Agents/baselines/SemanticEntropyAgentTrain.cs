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
        private FixedSizedQueue m_EntropyLevelsTemporalBuffer;
        
        private float m_ShannonEntropyLevels; // acumulator
        // private float MaxEntropyLevel = 5f;
        
        public override void OnEpisodeBegin()
        {
            base.OnEpisodeBegin();

            ResetAgent();
        }

        protected new virtual void ResetAgent()
        {
            // this is the reward multiplier used by Chaplot.
            m_ShannonEntropyLevels = 0;
            m_EntropyLevelsTemporalBuffer = new FixedSizedQueue();
            m_EntropyLevelsTemporalBuffer.Limit = m_MaxEntropyTemporalBufferSize;
        }

        public override void CollectObservations(VectorSensor sensor)
        {
            base.CollectObservations(sensor);
            
            m_LingeringPenaltyStrength = 1 / (1 + GetRationalizedClassDensity());
                
            // version 2 of entropy: calculate shannon entropy level
            ManagedUpdate(m_detections);
            
            if (m_SemanticEntropyObservations)
            {
                Debug.Assert(m_LoadDetector, "LoadDetector must be loaded for Semantic Entropy Obs");
                // version 1 of entropy regulation: GetRationalizedClassDensity()
                sensor.AddObservation(m_LingeringPenaltyStrength); // 1
            }
            
            if (m_TrainSemanticEntropy)
            {
                m_LingeringPenaltyStrength = GetRationalizedShannonEntropy();
            }
        }

        protected float GetRationalizedShannonEntropy()
        {
            return (float) m_ShannonEntropyLevels / 1000 / m_MaxEntropyTemporalBufferSize;
        }
        
        private void ManagedUpdate(List<string> detections)
        {
            

            var query = detections.GroupBy(s => s)
                .Select(g => new { Class = g.Key, Count = g.Count() });

            string alpha = "abcdefghijklmnopqrstuvwxyz";
            var builder = new StringBuilder();
            builder.Append("z");
            int count = 0;
            int i = 0;
                
            foreach(var result in query) {
                // print("Name: " + result.Class + " Count: " + result.Count);

                // append this character N times to the string
                for (int j = 0; j < result.Count; j++)
                {
                    builder.Append(alpha[i]);
                }

                i++;
            }
            // compare with above
            int totalClassesDetected = m_detections.Distinct().Count();

            string classCountEncoding = builder.ToString();
            // used to compare if the entropy moves the same as the class density from Chaplot
            var detectionEntropy = GetShannonEntropy(classCountEncoding);
            m_ShannonEntropyLevels += m_EntropyLevelsTemporalBuffer.Enqueue((int)(detectionEntropy * 1000));
            // print("totalClassesDetected: " + totalClassesDetected + 
            //              "detectionEntropy: " + detectionEntropy + 
            //              "classCountEncoding: " + classCountEncoding + GetRationalizedShannonEntropy());

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
            m_TBStats.Add(m_BehaviorName + "/RationalizedShannonEntropy", GetRationalizedShannonEntropy());
            m_TBStats.Add(m_BehaviorName + "/LingeringPenaltyStrength ", m_LingeringPenaltyStrength);
        }

        
        public override void DrawGUIStats(bool drawSummary = true)
        {
            // base.DrawGUIStats(false);
            var palette = Colors.Palette(7, 1, 0.5f, 0.2f, 0.8f);

            m_GUIStats.Add(TargetSpeed, "Speed", "Target", Colors.Orange);
            m_GUIStats.Add(m_Body.AvgSpeed, "Speed", "Measured Avg.", Colors.Lightblue);

            // TODO move to a GUI label.
            m_GUIStats.Add(Data.LeafNodeInfo[PointType.DronePos].Count / 10f, "Octree", "Leaf Nodes Visited", palette[1]);
            m_GUIStats.Add(Data.LeafNodeInfo[PointType.ScanPoint].Count / 10f, "Octree", "Leaf Nodes Scan Points", palette[2]);
            
            m_GUIStats.Add(nodeCount, "Octree Discovery", "New Nodes Count", palette[3]);
            
            m_GUIStats.Add(valueTowardsSun.w, "Pigeon", "Value Towards North", palette[0]);
            m_GUIStats.Add(valueTowardsMagneticNorth.y, "Pigeon", "Rotation from Compass", palette[1]);
            
            m_GUIStats.Add(lingerCount, "Octree Linger", "lingerCount", palette[0]);

            m_GUIStats.Add(countObjectsDetected, "Detections", "Detections Count", palette[0]);
            
            // TODO move to a GUI label.
            m_GUIStats.Add(totalVoxelsScanned, "Voxels", "Total Voxel Scan Count", palette[1]);

            m_GUIStats.Add(m_VoxelsScanned, "Voxel Discovery", "Voxel Scan Count", palette[0]);
            m_GUIStats.Add(m_SpeedErrorStrength, "Voxel Discovery", "Speed Error Strength", palette[2]);

            m_GUIStats.Add(GetRationalizedClassDensity(), "Semantic Curiosity", "Sum Of Elements in SemanticMap", palette[2]);
            m_GUIStats.Add(GetRationalizedShannonEntropy(), "Semantic Curiosity", "Shannon Entropy Level", palette[1]);

            m_GUIStats.Add(m_LingeringPenaltyStrength, "Octree Linger Strength", "Lingering Penalty Strength", palette[1]);

            m_GUIStats.Add(GetNormWalkDirectionError(), "Direction Errors", "Walk Direction", Colors.Orange);
            m_GUIStats.Add(GetNormLookDirectionError(), "Direction Errors", "Look Direction", Colors.Lightblue);

            if (drawSummary)
            {
                float sum = 0;
                // penalties
                int i = 0;
                // speed
                sum += m_GUIStats.Add(GetSpeedErrorPenalty(), "Penalties", "Speed Error", palette[i++]);
                // octree
                sum += m_GUIStats.Add(GetLingeringPenalty(), "Penalties", "Lingering Error", palette[i++]);
                // shortest path
                sum += m_GUIStats.Add(GetDirectionalSpeedError(), "Penalties", "Directional Speed Error", palette[i++]);

                // ** rewards **
                i = 0;
                // speed TODO can be put inside speed error < speed error strength = 0.8 if going forward
                m_GUIStats.Add(GetMovingForwardReward(), "Rewards", "Moving Forward Reward", palette[i++]);

                // octree
                sum += m_GUIStats.Add(GetOctreeDiscoveryReward(), "Rewards", "Octree Node Discovery", palette[i++]);
                // voxel reward
                sum += m_GUIStats.Add(GetVoxelDiscoveryReward(), "Rewards", "Voxel Discovery", palette[i++]);
                // detector
                sum += m_GUIStats.Add(GetCountDetectionsReward(), "Rewards", "Detections", palette[i++]);
                // shortest path
                sum += m_GUIStats.Add(GetWalkDirectionReward(), "Rewards", "Walk Direction", palette[i++]) +
                       m_GUIStats.Add(GetLookDirectionReward(), "Rewards", "Look Direction", palette[i++]);
                // semantic curiosity
                sum += m_GUIStats.Add(GetSemanticCuriosityRewardChaplot(), "Rewards", "Chaplot's Semantic Curiosity ", palette[i++]);

                m_GUIStats.Add(sum, "Reward Sum", "", Colors.Lightblue);                
            }
        }
    }
}
 
