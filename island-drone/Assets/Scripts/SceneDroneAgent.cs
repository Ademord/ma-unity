using System;
using System.Collections.Generic;
using Ademord.Drone;
using MBaske.MLUtil;
using MBaske.Sensors.Grid;
using UnityEngine;
using Unity.MLAgents;
using Unity.MLAgents.Actuators;
using Unity.MLAgents.Sensors;

namespace Ademord.Drone
{
    public class SceneDroneAgent : Agent, IScannerOwner
    {
        /// <inheritdoc/>
        public Vector3 ScannerPosition { get; private set; }

        /// <inheritdoc/>
        public Vector3 ScannerDirection { get; private set; }
        private ScannerPool m_Scanner;

        private StatsRecorder m_Stats;
        public SceneDroneData Data { get; private set; }
        // public BlockWorld World { get; private set; }
        
        [SerializeField]
        [Range(2f, 10f)]
        private float lookRadius = 5f;
        [SerializeField]
        [Range(0.25f, 1f)]
        private float leafNodeSize = 0.5f;

        private Point scanPoint;
        private Vector3Int prevPos;
        private int lingerCount; 

        [Header("TrainingArea Parameters")]
        private TrainingAreaController3D m_World;

        [SerializeField]
        [Tooltip("Maximum exploration area the drone is allowed to cover.")]
        [Range(5f, 10f)]
        private float ExplorationLimit = 10f;
        
        [SerializeField]
        [Tooltip("Reference to sensor component for retrieving detected opponent gameobjects.")]
        private GridSensorComponent3D m_SensorComponent;
        [SerializeField]
        [Tooltip("Ship-to-ship forward axis angle below which agent is rewarded for following opponent.")]
        private float m_TargetFollowAngle = 30;
        [SerializeField]
        [Tooltip("Ship-to-ship distance below which agent is rewarded for following opponent.")]
        private float m_TargetFollowDistance = 50;
        private float m_TargetFollowDistanceSqr;
        [SerializeField]
        [Tooltip("Ship-to-ship forward axis angle below which target is locked and auto-fire triggered.")]
        private float m_TargetScanAngle = 10;
        [SerializeField]
        [Tooltip("Ship-to-ship distance below which target is locked and auto-fire triggered.")]
        private float m_TargetScanDistance = 20;
        private float m_TargetScanDistanceSqr;
        [SerializeField]
        [Tooltip("Delay between auto-fire shots.")]
        private float m_ReloadTime = 0.2f;
        private float m_ShotTime;
        [SerializeField]
        [Tooltip("Step interval for writing stats to Tensorboard.")]
        private int m_StatsInterval = 120;
        private int m_CollisionCount;
        private int m_HitScoreCount;
        public SceneDrone m_Drone { get; private set; }
        
        private IList<GameObject> m_Targets;
        [SerializeField]
        [Tooltip("Target Tag")]
        private static string m_TargetTag = "collectible"; // same for all.

        private void OnValidate()
        {
            leafNodeSize = Mathf.Pow(2f, Mathf.Round(Mathf.Log(leafNodeSize, 2f)));
        }

        public override void Initialize()
        {
            m_Stats = Academy.Instance.StatsRecorder;

            Data = new SceneDroneData();

            // Drone = GetComponentInChildren<SceneDrone>();
            m_Drone = GetComponentInChildren<SceneDrone>();
            m_Drone.Initialize();
            // m_Ship.BulletHitEvent += OnBulletHitSuffered;
            // m_Ship.CollisionEvent += OnCollision;
            
            m_World = GetComponentInChildren<TrainingAreaController3D>();
            m_World.Initialize();
            
            if (m_World != null)
            {
                // m_Asteroids.ScansCompleteEvent += OnAsteroidsScanned;
                m_Drone.EnvironmentRadius = m_World.FieldRadius;
            }

            m_Targets = new List<GameObject>(10);

            m_TargetFollowDistanceSqr = m_TargetFollowDistance * m_TargetFollowDistance;
            m_TargetScanDistanceSqr = m_TargetScanDistance * m_TargetScanDistance;
        }

        public override void OnEpisodeBegin()
        {
            Data.Reset(m_Drone.Position, lookRadius, leafNodeSize);
            m_Drone.Reset();
            // World.ReSet();

            scanPoint = default(Point);
            prevPos = GetVector3Int(m_Drone.Position);
            lingerCount = 0;
        }
       
        public override void CollectObservations(VectorSensor sensor)
        {
            // TODO octree storage
            // Vector3 pos = m_Drone.Position;
            // if (IsNewGridPosition(pos))
            // {
            //     Data.AddPoint(new Point(PointType.DronePos, pos, Time.time));
            // }
            //
            // Data.AddPoint(scanPoint);
            // // Number of new leaf nodes created by this scan.
            // int nodeCount = Data.Tree.Intersect(pos, scanPoint.Position);
            // float scanReward = (nodeCount * 0.1f) / Data.LookRadius;
            // AddReward(scanReward);
            //
            // Data.StepUpdate(pos);
            
            // TODO ACTIVATE
            // float linger = lingerCount / 100f; // 0 - 2
            // float lingerPenalty = -linger * 0.1f;
            // AddReward(lingerPenalty);
            //
            // Vector3 velocity = Normalization.Sigmoid(m_Drone.WorldVelocity);
            // Vector4 proximity = m_Drone.GetForwardProximity();
            // float proxPenalty = (1f - 1f / Mathf.Max(proximity.w, 0.1f)) * velocity.sqrMagnitude * 0.25f;
            // AddReward(proxPenalty);
            //
            // sensor.AddObservation(linger - 1f); // 1
            // // sensor.AddObservation(velocity); // 3 
            // sensor.AddObservation((Vector3)proximity); // 3
            // sensor.AddObservation(proximity.w * 2f - 1f); // 1 
            // sensor.AddObservation(Data.LookRadiusNorm); // 1 
            // sensor.AddObservation(Data.NodeDensities); // 8
            // sensor.AddObservation(Data.IntersectRatios); // 8 
            // sensor.AddObservation(m_Drone.ScanBuffer.ToArray()); // 30
            
            ///////////
            sensor.AddObservation(m_Drone.Throttle_horizontal); // 1
            sensor.AddObservation(m_Drone.Throttle_vertical); // 1
            sensor.AddObservation(m_Drone.Yaw); // 1
            sensor.AddObservation(m_Drone.NormPosition); // 1 
            sensor.AddObservation(m_Drone.NormOrientation); // 1
            sensor.AddObservation(Normalization.Sigmoid(m_Drone.LocalSpin)); // 3
            sensor.AddObservation(Normalization.Sigmoid(m_Drone.LocalVelocity)); // 3

            Vector3 pos = m_Drone.transform.position;
            Vector3 fwd = m_Drone.transform.forward;
            m_Targets.Clear();

            // Find targets in vicinity.
            foreach (var target in m_SensorComponent.GetDetectedGameObjects(m_TargetTag))
            {
                Vector3 delta = target.transform.position - pos;
                if (Vector3.Angle(fwd, delta) < m_TargetFollowAngle && 
                    delta.sqrMagnitude < m_TargetFollowDistanceSqr)
                {
                    print("adding targets");
                    m_Targets.Add(target);
                }
            }
        }

        public override void OnActionReceived(ActionBuffers actions)
        {
            // Drone.Move(new Vector3(vectorAction[2], vectorAction[3], vectorAction[4]));
            var discrete_actions = actions.DiscreteActions;
            float speed = m_Drone.ManagedUpdate(discrete_actions[0] - 1, discrete_actions[1] - 1, discrete_actions[2] - 1);
            // TODO log speed and other data 
            
            // thought process 1: replaced CheckTargets() from PilotAgent.cs with Scan;
            // var continuous_actions = actions.ContinuousActions;
            // scanPoint = m_Drone.Scan(continuous_actions[0], continuous_actions[1], Data.LookRadius);

            // thought process 2:  decided to make the drone only focus on moving itself to a location that gives it a reward.
            // it will learn to move towards its targets and if there are targets that meet the criteria it will scan them
            // VFX will spawn a scanner prefab in every location where the target is.
            ScanTargets();
        }

        /// <inheritdoc/>
        public override void Heuristic(in ActionBuffers actionsOut)
        {
            var actions = actionsOut.DiscreteActions;
            bool shift = Input.GetKey(KeyCode.LeftShift);
            int vert = Mathf.RoundToInt(Input.GetAxis("Vertical"));
            print("vertical received: " + vert);
            actions[0] = 1 + (shift ? 0 : vert); // throttle_horizontal
            actions[1] = 1 + (shift ? vert : 0); // throttle_vertical
            actions[2] = 1 + Mathf.RoundToInt(Input.GetAxis("Horizontal")); // yaw
            print("throttle horizontal : " + actions[0]);
            print("throttle vertical : " + actions[1]);
            print("horizontal received: " + actions[2]);
        }
        
        private void ScanTargets()
        {
            Vector3 pos = m_Drone.transform.position;
            Vector3 fwd = m_Drone.transform.forward;
            Vector3 vlc = m_Drone.WorldVelocity;

            foreach (var target in m_Targets)
            {
                Vector3 delta = target.transform.position - pos;
                // Speed towards target.
                float speed = Vector3.Dot(delta.normalized, vlc);
                AddReward(speed * 0.01f);


                if (CanShoot() &&
                    Vector3.Angle(fwd, delta) < m_TargetScanAngle &&
                    delta.sqrMagnitude < m_TargetScanDistanceSqr)
                {
                    // following m_baske's logic of shooting bullets forward
                    // scanner will create a scan in the position and direction sent
                    // ScannerPosition = pos + fwd;
                    // ScannerDirection = delta.normalized;
                    // m_Bullets.Shoot(this);
                    m_Scanner.Scan(this, target.transform);
                    m_ShotTime = Time.time;
                }
            }
        }
        private bool CanShoot()
        {
            return Time.time - m_ShotTime >= m_ReloadTime;
        }
        private bool IsNewGridPosition(Vector3 dronePos)
        {
            Vector3Int pos = GetVector3Int(dronePos);
            if (pos != prevPos)
            {
                prevPos = pos;
                lingerCount = 0;
                return true;
            }

            lingerCount = Mathf.Min(200, lingerCount + 1);
            return false;
        }

        private Vector3Int GetVector3Int(Vector3 pos)
        {
            float s = Data.LeafNodeSize;
            return new Vector3Int(
                Mathf.RoundToInt(pos.x / s),
                Mathf.RoundToInt(pos.y / s),
                Mathf.RoundToInt(pos.z / s)
            );
        }
        /// <inheritdoc/>
        public void OnVoxelScanned()
        {
            AddReward(1);
            m_HitScoreCount++;
            
            // end episode if all collectibles have been collected
            if (m_World.EverythingHasBeenCollected)
            {
                print("collected all the items!");
                EndEpisode();
            }
        }

        private void OnApplicationQuit()
        {
            // m_Drone.VoxelScannedEvent -= OnBulletHitSuffered;
            // m_Drone.CollisionEvent -= OnCollision;
        }

    }
}