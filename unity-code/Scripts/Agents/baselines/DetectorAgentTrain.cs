
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
        [SerializeField] protected bool m_LoadDetector;
        [SerializeField] protected bool m_AddDetectorObservations;
        [SerializeField] protected bool m_TrainObjectDetectionMaximization;
        // [SerializeField] SnapshotCamera snapCam;
        [SerializeField] protected DetectorCamera detectorCam;
        // [SerializeField] protected NatDetectorCam detectorCam;
        // [SerializeField] GridSensorComponent3D m_SensorComponent_Detector;
        [SerializeField] protected bool NormalizeDetectionsReward;
        protected int countObjectsDetected;
        protected  int totalObjectsDetected;

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
            else
            {
                detectorCam.gameObject.SetActive(false);
            }
        }

        // todo remove when using natdetector
        public new void Update()
        {
            base.Update();

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
                // var voxelsInFOV = AreTargetsInFOV(m_SensorComponent, m_TargetTag);
                m_detections = detectorCam.GetDetections();
                // print("voxelsInFOV: " + voxelsInFOV);
                // if (voxelsInFOV && m_detections.Count > 0)
                
                // removed the condition above because other detectors that DO NOT see voxels would never get this metric recorded...
                if (m_detections.Count > 0)
                {
                    // print("found: " + String.Join(", ", m_detections));

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
            countObjectsDetected = 0;
            base.PostAction();
        }
        public override void SetRewards()
        {
            // print("SetRewards DetectorAgentTrain");
            // print("m_TrainObjectDetectionMaximization: " + m_TrainObjectDetectionMaximization);
            // print("m_EnableTrainDebuggingLogs: " + m_EnableTrainDebuggingLogs);

            base.SetRewards();
            if (m_TrainObjectDetectionMaximization)
            {
                if (m_EnableTrainDebuggingLogs)
                {
                    print("GetCountDetectionsReward()" + GetCountDetectionsReward());
                }
                else
                {
                    print("NOT m_TrainObjectDetectionMaximization");

                }
                AddReward(GetCountDetectionsReward());
            }
        }

        protected float GetCountDetectionsReward(float strength = 1f)
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
            m_TBStats.Add(m_BehaviorName + "/Detections Count", countObjectsDetected);
            m_TBStats.Add(m_BehaviorName + "/Detections Total Count", totalObjectsDetected);
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