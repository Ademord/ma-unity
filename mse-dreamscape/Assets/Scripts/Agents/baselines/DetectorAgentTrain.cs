
using System;
using System.Collections.Generic;
using MBaske.Sensors.Grid;
using Unity.MLAgents.Sensors;
using UnityEngine;

namespace Ademord
{
    public class DetectorAgentTrain : ShortestPathAgentTrain
    {        
        [Header("Detector Agent Parameters")]
        [SerializeField] protected bool m_LoadDetector = true;
        [SerializeField] private bool m_AddDetectorObservations = true;
        [SerializeField] private bool m_TrainMaximizeDetections = true;
        // [SerializeField] SnapshotCamera snapCam;
        [SerializeField] protected DetectorCamera detectorCam;
        [SerializeField] GridSensorComponent3D m_SensorComponent_Detector;
        [SerializeField] private bool NormalizeDetectionsReward = true;
        protected int countObjectsDetected;
        private  int totalObjectsDetected;

        protected static string m_ObjectTag = "object"; // same for all.
        protected List<string> m_detections;

        public override void Initialize()
        {
            base.Initialize();

            m_detections = new List<string>();
            if (m_LoadDetector)
            {
                detectorCam.Initialize();
            }
        }

        void Update()
        {
            if (m_LoadDetector)
            {
                detectorCam.CallTakeSnapshot();
            }
        }
        public override void CollectObservations(VectorSensor sensor)
        {
            base.CollectObservations(sensor);

            if (m_LoadDetector)
            {
                var voxelsInFOV = AreTargetsInFOV(m_SensorComponent, m_TargetTag);
                m_detections = detectorCam.GetDetections();

                if (voxelsInFOV && m_detections.Count > 0)
                {
                    // print("found: " + String.Join(", ", detections));

                    // the agent gets a bit more information, but it should be the detections.Count, making it highly dependable on the performance of the OD
                    // countObjectsDetected = CountTargetsInFOV(m_SensorComponent_Detector, m_ObjectTag);
                    totalObjectsDetected += countObjectsDetected = m_detections.Count;
                }
            }
            
            if (m_AddDetectorObservations)
            {
                sensor.AddObservation(countObjectsDetected);
            }
        }
        public override void PostAction()
        {
            base.PostAction();
            countObjectsDetected = 0;
        }
        public override void SetRewards()
        {
            base.SetRewards();
            if (m_TrainMaximizeDetections)
            {
                AddReward(GetCountDetectionsReward());
            }
        }

        protected float GetCountDetectionsReward(float strength = 0.01f)
        {
            float r = 0;
            if (NormalizeDetectionsReward)
            {
                r = (float) countObjectsDetected / (2 + countObjectsDetected) * 1f;
            }
            else
            {
                r = countObjectsDetected * 1f;
            }
            return r * strength;
        }
        private int CountTargetsInFOV(GridSensorComponent3D sensor, string tag)
        {
            int count = 0;
            foreach (var target in sensor.GetDetectedGameObjects(tag))
            {
                count++;
            }

            return count;
        }
        public override void AddTensorboardStats()
        {
            base.AddTensorboardStats();
            m_TBStats.Add(m_BehaviorName + "/Objects Detected", countObjectsDetected);
            m_TBStats.Add(m_BehaviorName + "/Total Objects Detected", totalObjectsDetected);
        }

        public override void DrawGUIStats(bool drawSummary = true)
        {
            base.DrawGUIStats(false);
            var palette = Colors.Palette(4, 1, 0.5f, 0.2f, 0.8f);

            m_GUIStats.Add(countObjectsDetected, "Detections", "Detections Count", palette[0]);
            // m_GUIStats.Add(totalObjectsDetected, "Detections", "Total Detections Count", palette[1]);
            if (drawSummary)
            {
                float sum = 0;
                sum += m_GUIStats.Add(GetCountDetectionsReward(), "Rewards", "Walk Direction", palette[2]);
                // m_GUIStats.Add(GetSpeedErrorPenalty(), "Penalties", "Speed Error", Colors.Orange);

                m_GUIStats.Add(sum, "Reward Sum", "", Colors.Lightblue);                
            }
        }
    }
}