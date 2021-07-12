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
        // private ScannerPool m_Scanner;
        

        private StatsRecorder m_Stats;
        public SceneDroneData Data { get; private set; }
        // public BlockWorld World { get; private set; }
        
        // [SerializeField]
        // [Range(2f, 10f)]
        // private float lookRadius = 5f; // replaced for m_TargetFollowDistance
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
        [Range(5f, 30f)]
        private float ExplorationLimit = 10f;
        [SerializeField]
        [Tooltip("Drone's Scanner Eye.")]
        private ScannerController m_ScannerComponent;
        [SerializeField]
        [Tooltip("Reference to sensor component for retrieving detected opponent gameobjects.")]
        private GridSensorComponent3D m_SensorComponent;

        [SerializeField]
        [Tooltip("Ship-to-ship forward axis angle below which agent is rewarded for following opponent.")]
        private float m_TargetDotProduct = -0.8f;
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
        private float m_ScanReloadTime = 0.2f;       
        [SerializeField]
        [Tooltip("Delay between auto-fire shots.")]
        private float m_ScanAccuracy = 20;        
        [SerializeField]
        [Tooltip("Delay between auto-fire shots.")]
        private float m_InactivityTime = 2f;
        [SerializeField]
        [Tooltip("Scanner Buffer Size.")]
        private int m_TargetsBufferSize = 10;
        private float m_ShotTime;
        private float m_MovedTime;
        private float m_AddedTargetsTime;
        private bool scanned;
        [SerializeField]
        [Tooltip("Step interval for writing stats to Tensorboard.")]
        private int m_StatsInterval = 120;
        private int m_CollisionCount;
        private int m_HitScoreCount;
        private GameObject m_VFX;
        public SceneDrone m_Drone { get; private set; }
        private float damping = 10;
        private float dotProductToTarget;

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
            // m_Scanner = FindObjectOfType<ScannerPool>();
            // m_ScannerComponent = GetComponent<ScannerController>();
            m_VFX = GameObject.Find("VFX");
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

            m_Targets = new List<GameObject>(m_TargetsBufferSize);

            m_TargetFollowDistanceSqr = m_TargetFollowDistance * m_TargetFollowDistance;
            m_TargetScanDistanceSqr = m_TargetScanDistance * m_TargetScanDistance;
            
        }

        public override void OnEpisodeBegin()
        {
            m_Drone.Reset();
            
            m_World.MoveToSafeRandomPosition(m_Drone.transform, true);
            m_World.Reset(); 

            ResetObservations(true);
        }
       
        public override void CollectObservations(VectorSensor sensor)
        {
            Vector3 pos = m_Drone.Position;

            if (IsNewGridPosition(pos))
            {
                Data.AddPoint(new Point(PointType.DronePos, pos, Time.time));
            }
            
            // scan all voxels seen by GridSensor
            ScanTargets();

            // this reward promotes to scan new parts of the island
            // Number of new leaf nodes created by this scan.
            int nodeCount = Data.Tree.Intersect(pos, scanPoint.Position);
            // print("new nodes discovered:" + nodeCount);
            float scanReward = (nodeCount * 0.05f) / Data.LookRadius;
            AddReward(scanReward);
            
            Data.StepUpdate(pos);
            
            float linger = lingerCount / 100f; // 0 - 2
            float lingerPenalty = -linger * 0.05f;
            // print("linger penalty:" + lingerPenalty);
            AddReward(lingerPenalty);
            
            Vector3 velocity = Normalization.Sigmoid(m_Drone.WorldVelocity);
            // print("velocity:" + velocity);
            // print("velocity:" + m_Drone.LocalVelocity);
            Vector4 proximity = m_Drone.GetForwardProximity();
            float proxPenalty = (1f - 1f / Mathf.Max(proximity.w, 0.1f)) * velocity.sqrMagnitude * 0.25f;
            print("proximity penalty: " + proxPenalty);
            AddReward(proxPenalty);
            
            sensor.AddObservation(velocity); // 3 
            sensor.AddObservation(linger - 1f); // 1
            sensor.AddObservation((Vector3)proximity); // 3
            sensor.AddObservation(proximity.w * 2f - 1f); // 1 
            sensor.AddObservation(Data.LookRadiusNorm); // 1 
            // total = 9
            sensor.AddObservation(Data.NodeDensities); // 8
            sensor.AddObservation(Data.IntersectRatios); // 8 
            // sensor.AddObservation(m_Drone.ScanBuffer.ToArray()); // 30
            // total = 25

            // print("throttle: " + m_Drone.Throttle_horizontal);
            // sensor.AddObservation(m_Drone.Throttle_horizontal); // 1
            // sensor.AddObservation(m_Drone.Throttle_vertical); // 1
            // sensor.AddObservation(m_Drone.Yaw); // 1
            sensor.AddObservation(m_Drone.NormPosition); // 1 
            sensor.AddObservation(m_Drone.NormOrientation); // 1
            // TODO remove observations
            sensor.AddObservation(Normalization.Sigmoid(m_Drone.LocalSpin)); // 3
            sensor.AddObservation(Normalization.Sigmoid(m_Drone.LocalVelocity)); // 3
            sensor.AddObservation(dotProductToTarget); // 1
            // total = 34
        }

        public override void OnActionReceived(ActionBuffers actions)
        {

            // if (actions.ContinuousActions[0] != 0f ||
            //     actions.ContinuousActions[1] != 0f ||
            //     actions.ContinuousActions[2] != 0f ||
            //     actions.ContinuousActions[3] != 0f)
            // {
            //     m_MovedTime = Time.time;
            // }

            // Drone.Move(new Vector3(vectorAction[2], vectorAction[3], vectorAction[4]));
            // var discrete_actions = actions.DiscreteActions;
            // var _actions = actions.ContinuousActions;
            // float speed = m_Drone.ManagedUpdate(discrete_actions[0] - 1, discrete_actions[1] - 1, discrete_actions[2] - 1);
            // m_Drone.ManagedUpdate(new Vector3(_actions[0], _actions[1], _actions[2]), _actions[3]);
            m_Drone.ManagedUpdate(actions);
            
            // if (Vector3.Distance(m_Drone.Position, Vector3.zero) > 10f)
            // {
            //     AddReward(-1);
            //     EndEpisode();
            // }
            // TODO log speed and other data 

            // thought process 1: replaced CheckTargets() from PilotAgent.cs with Scan;
            // var continuous_actions = actions.ContinuousActions;
            // scanPoint = m_Drone.Scan(continuous_actions[0], continuous_actions[1], Data.LookRadius);

            // thought process 2:  decided to make the drone only focus on moving itself to a location that gives it a reward.
            // it will learn to move towards its targets and if there are targets that meet the criteria it will scan them
            // VFX will spawn a scanner prefab in every location where the target is.
            
            // if agent strays too far away give a negative reward and end episode
            // print( "distance to center: " + Vector3.Distance(m_Drone.Position, Vector3.zero));
            // print("max distance to explore: " + ExplorationLimit);
            if (Vector3.Distance(m_Drone.Position, Vector3.zero) > ExplorationLimit)
            {
                AddReward(-1);
                EndEpisode();
            }
        }

        /// <inheritdoc/>
        public override void Heuristic(in ActionBuffers actionsOut)
        {
            // var actions = actionsOut.DiscreteActions;
            var actions = actionsOut.ContinuousActions;
            // bool shift = Input.GetKey(KeyCode.LeftShift);
            // int vert = Mathf.RoundToInt(Input.GetAxis("Vertical"));
            // print("vertical received: " + vert);
            // actions[0] = 1 + (shift ? 0 : vert); // throttle_horizontal
            // actions[1] = 1 + (shift ? vert : 0); // throttle_vertical
            // actions[2] = 1 + Mathf.RoundToInt(Input.GetAxis("Horizontal")); // yaw
            // print("throttle horizontal : " + actions[0]);
            // print("throttle vertical : " + actions[1]);
            // print("horizontal received: " + actions[2]);
            
            // Read input values and round them. GetAxisRaw works better in this case
            // because of the DecisionRequester, which only gets new decisions periodically.
            int forwardInput = Mathf.RoundToInt(Input.GetAxisRaw("Vertical"));
            int sidesInput = Mathf.RoundToInt(Input.GetAxisRaw("Horizontal"));
            int yaw = 0;
            if (Input.GetKey(KeyCode.E)) yaw = -1;
            else if (Input.GetKey(KeyCode.C)) yaw = 1;

            // vertical input
            int verticalInput = 0;
            if (Input.GetKey(KeyCode.R)) verticalInput = 1;
            else if (Input.GetKey(KeyCode.V)) verticalInput = -1;

            // int pitch = 0;
            // if (Input.GetKey(KeyCode.I)) pitch = 1;
            // else if (Input.GetKey(KeyCode.K)) pitch = -1;

            // Convert the actions (-1, 0, 1) to Discrete choices (0, 1, 2)
            // actions[0] = forwardInput >= 0 ? forwardInput : 2;
            // actions[1] = sidesInput >= 0 ? sidesInput : 2;
            // actions[2] = yaw >= 0 ? yaw : 2;
            // actions[3] = verticalInput >= 0 ? verticalInput : 2;
            
            // Convert the actions (-1, 0, 1) to Continuous choices
            actions[0] = Input.GetAxisRaw("Vertical"); //forward
            actions[1] = Input.GetAxisRaw("Horizontal"); 
            actions[2] = yaw * 1f; 
            actions[3] = verticalInput * 1f;
            // actions[4] = pitch >= 0 ? pitch : 2;
            
        }
        private void ScanTarget(GameObject target)
        {
            Vector3 pos = m_Drone.Position;
            Vector3 fwd = m_Drone.transform.forward;
            Vector3 vlc = m_Drone.WorldVelocity;
            // canScan logic moved outside of loop because it makes sense to be able to scan in bulks of BufferSize (10)
            // instead of pausing after every scan
            
            Vector3 delta = target.transform.position - pos;
            // Speed towards target.
            float speed = Vector3.Dot(delta.normalized, vlc);
            AddReward(speed * 0.01f);

            if ( CanScan() &&
                 Vector3.Angle(fwd, delta) < m_TargetScanAngle &&
                 delta.sqrMagnitude < m_TargetScanDistanceSqr)
            {
                // following m_baske's logic of shooting bullets forward
                // scanner will create a scan in the position and direction sent
                ScannerPosition = pos + fwd;
                // ScannerDirection = delta.normalized;
                // m_Bullets.Shoot(this);
                m_ScannerComponent.Scan(this, target.transform);
                m_ShotTime = Time.time;
                scanned = true;
                RotateVFXToTarget(target);
                // ResetObservations();
            }
        }

        private void ScanTargets()
        {
            // *** SCAN ***
            Vector3 pos = m_Drone.Position;
            Vector3 fwd = m_Drone.transform.forward;
            // m_Targets.Clear();

            // Find targets in vicinity.
            // if CanScan() removed because of reduction of FPS
            var _targetsFound = false;

            foreach (var target in m_SensorComponent.GetDetectedGameObjects(m_TargetTag))
            {
                // edit Data point to add
                Point point = new Point(PointType.ScanPoint, target.transform.position, Time.time);
                Data.AddPoint(point);
                // update that a target was found
                _targetsFound = true;
                
                VoxelController myVoxel = target.transform.parent.GetComponent<VoxelController>();
                Vector3 delta = target.transform.position - pos;
                dotProductToTarget = Vector3.Dot(fwd, myVoxel.transform.forward);
                if (dotProductToTarget < m_TargetDotProduct 
                    && Vector3.Angle(fwd, delta) < m_TargetFollowAngle 
                    && delta.sqrMagnitude < m_TargetFollowDistanceSqr)
                {        

                    if (UnityEngine.Random.Range(0, 101) <= m_ScanAccuracy) // chance to collect
                    {
                        // removing m_targets because the reload time slows down FPS. there is no nice way to do 
                        // bulk scanning
                        // m_Targets.Add(target);
                        ScanTarget(target);
                    }
                    // print("dotproduct to target: " + dotProductToTarget);
                }
                // m_AddedTargetsTime = Time.time;
            }
            
            // add scanpoint

            // ScanTargets();
            if (_targetsFound == false)
            {
                Point point = new Point(PointType.ScanOutOfRange, m_Drone.Position + fwd * m_TargetFollowDistance, Time.time);
                Data.AddPoint(point);
                ResetObservations(false);
            }
            ResetVFX();
        }
        private void ScanTargets_deprecated()
        {
            Vector3 pos = m_Drone.transform.position;
            Vector3 fwd = m_Drone.transform.forward;
            Vector3 vlc = m_Drone.WorldVelocity;
            // canScan logic moved outside of loop because it makes sense to be able to scan in bulks of BufferSize (10)
            // instead of pausing after every scan
            if (CanScan())
            {
                print("targets scanned: " + m_Targets.Count);
                foreach (var target in m_Targets)
                {
                    print("reading target");
                    Vector3 delta = target.transform.position - pos;
                    // Speed towards target.
                    float speed = Vector3.Dot(delta.normalized, vlc);
                    AddReward(speed * 0.01f);


                    if ( //Time.time - m_ShotTime >= m_ScanReloadTime / 50 &&
                         Vector3.Angle(fwd, delta) < m_TargetScanAngle &&
                         delta.sqrMagnitude < m_TargetScanDistanceSqr)
                    {
                        print("scanning target");
                        // following m_baske's logic of shooting bullets forward
                        // scanner will create a scan in the position and direction sent
                        ScannerPosition = pos + fwd;
                        // ScannerDirection = delta.normalized;
                        // m_Bullets.Shoot(this);
                        m_ScannerComponent.Scan(this, target.transform);
                        m_ShotTime = Time.time;
                        scanned = true;
                        if (m_VFX != null)
                        {
                            // m_VFX.transform.LookAt(target.transform);
                            // var desiredRotQ = Quaternion.LookRotation(delta, Vector3.up);
                            
                            Quaternion OriginalRot = m_VFX.transform.rotation;
                            m_VFX.transform.LookAt(target.transform);
                            Quaternion NewRot = m_VFX.transform.rotation;
                            m_VFX.transform.rotation = OriginalRot;
                            m_VFX.transform.rotation = Quaternion.Lerp(m_VFX.transform.rotation, NewRot, damping * Time.deltaTime);

                            // Vector3 lTargetDir = target.transform.position - m_VFX.transform.position;
                            // lTargetDir.y = 0.0f;
                            // m_VFX.transform.localRotation = Quaternion.RotateTowards(m_VFX.transform.localRotation,
                            //     Quaternion.LookRotation(lTargetDir), (1f * Time.deltaTime) *  5);
                        }
                    }
                }
  
            }
            ResetVFX();
            ResetObservations(false);
        }

        public void ResetObservations(bool fullReset)
        {
            // reset SCAN observations 
            dotProductToTarget = 100f;
            // distanceToTarget = 100f;
            scanned = false;

            if (fullReset)
            {
                // reset octree
                Data.Reset(m_Drone.Position, m_TargetFollowDistance, leafNodeSize); // lookRadius removed
            
                // reset octree scan related data
                scanPoint = default(Point);
                prevPos = GetVector3Int(m_Drone.Position);
                lingerCount = 0;
            }
           
        }
                
        private void RotateVFXToTarget(GameObject target)
        {
            if (m_VFX != null)
            {
                // m_VFX.transform.LookAt(target.transform);
                // var desiredRotQ = Quaternion.LookRotation(delta, Vector3.up);
                    
                Quaternion OriginalRot = m_VFX.transform.rotation;
                m_VFX.transform.LookAt(target.transform);
                Quaternion NewRot = m_VFX.transform.rotation;
                m_VFX.transform.rotation = OriginalRot;
                m_VFX.transform.rotation = Quaternion.Lerp(m_VFX.transform.rotation, NewRot, damping * Time.deltaTime);

                // Vector3 lTargetDir = target.transform.position - m_VFX.transform.position;
                // lTargetDir.y = 0.0f;
                // m_VFX.transform.localRotation = Quaternion.RotateTowards(m_VFX.transform.localRotation,
                //     Quaternion.LookRotation(lTargetDir), (1f * Time.deltaTime) *  5);
            }
        }

        private void ResetVFX()
        {
            // print("trying to reset VFX");
            if (CanResetScannerRotation())
            {
                m_ScannerComponent.Reset();
                if (m_VFX != null)
                {
                    var rotation = m_VFX.transform.rotation;
                    // m_VFX.transform.localRotation = 
                    var desiredRotQ = new Quaternion(0, rotation.y, 0, rotation.w);
                    m_VFX.transform.rotation = Quaternion.Lerp(rotation, desiredRotQ, Time.deltaTime * damping);
                }
                scanned = false;
            }
            // else
            // {
            //     print("could not reset");
            // }
        }
        private bool CanScan()
        {
            return Time.time - m_ShotTime >= m_ScanReloadTime;
        }
        private bool NotMoving()
        {
            return Time.time - m_MovedTime >= m_InactivityTime / 4;
        }
        
        // after having scanned AND a period of time has passed since last scan, reset rotation == not scanning anymore
        // it needs the bool scanned otherwise it will always reset the position since time will always be higher
        private bool CanResetScannerRotation()
        {
            return scanned && (Time.time - m_ShotTime >= m_InactivityTime);
        } 
        // if a period has passed after scannning
        private bool CanAddTargets()
        {
            print(m_Targets.Count);
            return (Time.time - m_AddedTargetsTime >= m_ScanReloadTime * m_Targets.Count * 0.8f);
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
            AddReward(1f);
            m_HitScoreCount++;
        }

        void Update()
        {
            // print("dotProductToTarget: " + (dotProductToTarget > 0.5));
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