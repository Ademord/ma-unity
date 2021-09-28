
using System;
using MBaske.Sensors.Grid;
using Unity.MLAgents.Sensors;
using UnityEngine;

namespace Ademord
{
    public class DetectorAgentTrain : ShortestPathAgentTrain
    {        
        [Header("Detector Agent Parameters")]
        [SerializeField] private bool m_AddDetectorObservations = true;
        [SerializeField] private bool m_TrainMaximizeDetections = true;
        [SerializeField] SnapshotCamera snapCam;
        [SerializeField] DetectorCamera detectorCam;
        [SerializeField] GridSensorComponent3D m_SensorComponent_Detector;
        [SerializeField] private bool NormalizeDetectionsReward = true;

        protected static string m_ObjectTag = "object"; // same for all.

        int countObjectsDetected;
        int totalObjectsDetected;

        public override void CollectObservations(VectorSensor sensor)
        {
            base.CollectObservations(sensor);
            
            if (m_AddDetectorObservations)
            {
                detectorCam.CallTakeSnapshot();
                
                var voxelsInFOV = AreTargetsInFOV(m_SensorComponent, m_TargetTag);
                var detections = detectorCam.GetDetections();
                // if (targetsInFOV && detections.Count == 0)
                // {
                //     print("there is a problem with your setup, gridsensor should not see objects");
                // }
                print("voxelsInFOV: " + voxelsInFOV);
                if (voxelsInFOV && detections.Count > 0)
                {
                    countObjectsDetected = CountTargetsInFOV(m_SensorComponent_Detector, m_ObjectTag);
                    totalObjectsDetected += countObjectsDetected;
                    print("there are detections > i am passing objects in FOV: " + countObjectsDetected);
                    // sensor.AddObservation(NormTargetLookAngle);
                    sensor.AddObservation(countObjectsDetected);

                    if (countObjectsDetected == 0)

                    {
                        print("there are detections but the gridsensor doesnt see any objects. please make wider.");
                    }
                    
                }
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

        protected float GetCountDetectionsReward(float strength = 1)
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
            m_TBStats.Add(m_BehaviorName + "/Total Objetcs Detected", totalObjectsDetected);
        }

        public override void DrawGUIStats(bool drawSummary = true)
        {
            base.DrawGUIStats(false);
            var palette = Colors.Palette(4, 1, 0.5f, 0.2f, 0.8f);

            m_GUIStats.Add(countObjectsDetected, "Detections", "Detections Count", palette[0]);
            m_GUIStats.Add(totalObjectsDetected, "Detections", "Total Detections Count", palette[1]);
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