using System;
using System.Collections.Generic;
using System.Linq;
using Ademord.Drone;
using MBaske.MLUtil;
using MBaske.Sensors.Grid;
using UnityEngine;
using Unity.MLAgents;
using Unity.MLAgents.Actuators;
using Unity.MLAgents.Sensors;

namespace Ademord.Drone
{
    public enum SteuernModus : int
    {
        Manual = 1 << 0,
        PhysicsVelocity = 1 << 1,
        PhysicsThrottle = 1 << 2
    }
    
    public class SceneDroneAgent : Agent, IScannerOwner
    {
        /// <inheritdoc/>
        public Vector3 ScannerPosition { get; protected set; }

        /// <inheritdoc/>
        public Vector3 ScannerDirection { get; protected set; }
        // private ScannerPool m_Scanner;
        

        protected StatsRecorder m_Stats;
        public SceneDroneData Data { get; protected set; }
        // public BlockWorld World { get; private set; }
        protected GameObject m_VFX;
        public SceneDrone m_Drone { get; protected set; }
        
        // [SerializeField]
        // [Range(2f, 10f)]
        // private float lookRadius = 5f; // replaced for m_TargetFollowDistance
        [SerializeField]
        [Range(0.25f, 1f)]
        protected float leafNodeSize = 0.5f;

        protected Point scanPoint;
        protected Vector3Int prevPos;
        protected int lingerCount; 

        [Header("TrainingArea Parameters")]
        protected TrainingAreaController3D m_World;
        
        [SerializeField]
        [Tooltip("Maximum exploration area the drone is allowed to cover.")]
        [Range(5f, 30f)]
        protected float ExplorationLimit = 10f;
        [SerializeField]
        [Tooltip("Drone's Scanner Eye.")]
        protected ScannerController m_ScannerComponent;
        [SerializeField]
        [Tooltip("Reference to sensor component for retrieving detected obstacle, goal, and boundary gameobjects.")]
        protected GridSensorComponent3D m_SensorComponent;
        [SerializeField]
        [Tooltip("Reference to sensor component for retrieving detected goal gameobjects that can be disabled (scanned).")]
        protected GridSensorComponent3D m_SensorComponent_Scanner;
        // [SerializeField]
        // [Tooltip("Ship-to-ship forward axis angle below which agent is rewarded for following opponent.")]
        // protected float m_TargetDotProduct = -0.8f;
        [SerializeField]
        [Tooltip("Ship-to-ship forward axis angle below which agent is rewarded for following opponent.")]
        protected bool RestartOnCollision = false;
        [SerializeField]
        [Tooltip("Ship-to-ship forward axis angle below which agent is rewarded for following opponent.")]
        protected float m_TargetFollowAngle = 30;
        [SerializeField]
        [Tooltip("Ship-to-ship distance below which agent is rewarded for following opponent.")]
        protected float m_TargetFollowDistance = 50;
        protected float m_TargetFollowDistanceSqr;
        [SerializeField]
        [Tooltip("Ship-to-ship forward axis angle below which target is locked and auto-fire triggered.")]
        protected float m_TargetScanAngle = 10;
        [SerializeField]
        [Tooltip("Ship-to-ship distance below which target is locked and auto-fire triggered.")]
        protected float m_TargetScanDistance = 20;
        protected float m_TargetScanDistanceSqr;
        [SerializeField]
        [Tooltip("Delay between auto-fire shots.")]
        protected float m_ScanReloadTime = 0.2f;       
        [SerializeField]
        [Tooltip("Delay between auto-fire shots.")]
        protected float m_ScanAccuracy = 20;        
        [SerializeField]
        [Tooltip("Delay between auto-fire shots.")]
        protected float m_InactivityTime = 2f;
        [SerializeField]
        [Tooltip("Scanner Buffer Size.")]
        protected int m_TargetsBufferSize = 10;
        [SerializeField]
        [Tooltip("Target Tag")]
        protected static string m_TargetTag = "collectible"; // same for all.
        [SerializeField]
        [Tooltip("Step interval for writing stats to Tensorboard.")]
        protected int m_StatsInterval = 120;
        [SerializeField]  [BitMask(typeof(SteuernModus))]
        protected SteuernModus steuernModus;

        protected float m_ShotTime;
        protected float m_MovedTime;
        protected float m_AddedTargetsTime;
        protected bool scanned;

        // protected float dotProductToTarget;
        protected float distanceToTarget;
        protected float angleToTargetsInFront;
        protected float angleToTargetsFacingAway;
        protected Vector3 vectorToTargetsInFront;
        protected Vector3 vectorToTargetsFacingAway;
        // damping of VFX rotation
        protected float damping = 10;
        protected int m_HitScoreCount;

       
        
        // private int m_CollisionCount;
        // private IList<GameObject> m_Targets;
        
        protected void OnValidate()
        {
            leafNodeSize = Mathf.Pow(2f, Mathf.Round(Mathf.Log(leafNodeSize, 2f)));
        }

        public override void Initialize()
        {
            // debug why Heuristic not running
            // print("entering initialize");
            // m_Scanner = FindObjectOfType<ScannerPool>();
            // m_ScannerComponent = GetComponent<ScannerController>();
            m_VFX = GameObject.Find("VFX");
            m_Stats = Academy.Instance.StatsRecorder;
            Data = new SceneDroneData();

            // Drone = GetComponentInChildren<SceneDrone>();
            m_Drone = GetComponentInChildren<SceneDrone>();
            m_Drone.Initialize(steuernModus);
            m_Drone.OnCollisionEvent += CollisionEvent;
            // m_Ship.BulletHitEvent += OnBulletHitSuffered;
            // m_Ship.CollisionEvent += OnCollision;
            
            m_World = GetComponentInChildren<TrainingAreaController3D>();
            m_World.Initialize();
            
            
            if (m_World != null)
            {
                // m_Asteroids.ScansCompleteEvent += OnAsteroidsScanned;
                m_Drone.EnvironmentRadius = m_World.FieldRadius;
            }

            // m_Targets = new List<GameObject>(m_TargetsBufferSize);

            m_TargetFollowDistanceSqr = m_TargetFollowDistance * m_TargetFollowDistance;
            m_TargetScanDistanceSqr = m_TargetScanDistance * m_TargetScanDistance;
            
        }

        public override void OnEpisodeBegin()
        {
            print("entering onepisodebegin");

            m_Drone.Reset();
            m_Drone.transform.localPosition = new Vector3(0, 3, 0);
            transform.rotation = Quaternion.Euler(Vector3.up * UnityEngine.Random.Range(0f, 360f));
            // m_World.MoveToSafeRandomPosition(m_Drone.transform, true);

            // m_World.Reset(); 

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
            float scanReward = (nodeCount * 0.001f) / Data.LookRadius;
            AddReward(scanReward);
            
            Data.StepUpdate(pos);
            AddReward(-1f / MaxStep);
            // print("LocalSpin" + m_Drone.LocalSpin); 
            
            // run 32 removed lingering penalty
            // float linger = lingerCount / 100f; // 0 - 2
            // float lingerPenalty = -linger * 0.001f;
            // // print("linger penalty:" + lingerPenalty);
            // AddReward(lingerPenalty);
            
            // run 29 removed velocity related observations

            // Vector3 velocity = Normalization.Sigmoid(m_Drone.WorldVelocity);
            // // print("velocity:" + velocity);
            // // print("velocity:" + m_Drone.LocalVelocity);
            // Vector4 proximity = m_Drone.GetForwardProximity();
            // // print("proximity: " + proximity);
            // float proxPenalty = (1f - 1f / Mathf.Max(proximity.w, 0.1f)) * velocity.sqrMagnitude * 0.25f;
            // // print("proximity penalty: " + proxPenalty);
            // AddReward(proxPenalty);
            
            // sensor.AddObservation(velocity); // 3 
            // sensor.AddObservation(Normalization.Sigmoid(m_Drone.LocalSpin)); // 3
            // sensor.AddObservation(Normalization.Sigmoid(m_Drone.LocalVelocity)); // 3
            // sensor.AddObservation(proximity.w * 2f - 1f); // 1 
            // sensor.AddObservation((Vector3)proximity); // 3
            // 13 velocity related observations
            
            // sensor.AddObservation(linger - 1f); // 1
            sensor.AddObservation(Data.LookRadiusNorm); // 1 
            sensor.AddObservation(Data.NodeDensities); // 8
            sensor.AddObservation(Data.IntersectRatios); // 8 
            // sensor.AddObservation(m_Drone.ScanBuffer.ToArray()); // 30
            // 18
            // print("throttle: " + m_Drone.Throttle_horizontal);
            // sensor.AddObservation(m_Drone.Throttle_horizontal); // 1
            // sensor.AddObservation(m_Drone.Throttle_vertical); // 1
            // sensor.AddObservation(m_Drone.Yaw); // 1
            // sensor.AddObservation(m_Drone.Position); // 1 
            sensor.AddObservation(m_Drone.NormPosition); // 1 
            sensor.AddObservation(m_Drone.NormOrientation); // 1
            // sensor.AddObservation(dotProductToTarget); // 1
            sensor.AddObservation(angleToTargetsInFront); // 1
            sensor.AddObservation(angleToTargetsFacingAway); // 1
            sensor.AddObservation(distanceToTarget); // 1
            sensor.AddObservation(vectorToTargetsInFront.normalized); // 3
            sensor.AddObservation(vectorToTargetsFacingAway.normalized); // 3
            // 28    
        }

        public override void OnActionReceived(ActionBuffers actions)
        {
            // penalize rotations
            if (actions.ContinuousActions[2] != 0f)
            {
                // print("penalizing for rotating: " + actions.ContinuousActions[2]);
                AddReward(-0.0001f);
            }
            
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
            
            // added a boundary so removed this code
            // if (Vector3.Distance(m_Drone.Position, Vector3.zero) > ExplorationLimit)
            // {
            //     AddReward(-1);
            //     EndEpisode();
            // }
        }

        /// <inheritdoc/>
        public override void Heuristic(in ActionBuffers actionsOut)
        { 
            // print("entering heuristic");

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
        protected void ScanTarget(GameObject target)
        {
            Vector3 pos = m_Drone.Position;
            Vector3 fwd = m_Drone.transform.forward;
            Vector3 vlc = m_Drone.WorldVelocity;
            // canScan logic moved outside of loop because it makes sense to be able to scan in bulks of BufferSize (10)
            // instead of pausing after every scan
            
            Vector3 delta = target.transform.position - pos;
            // reward speed towards target.
            float speed = Vector3.Dot(delta.normalized, vlc);
            AddReward(speed * 0.01f);

            if (CanScan()) 
                 // Vector3.Angle(fwd, delta) < m_TargetScanAngle &&
                 // delta.sqrMagnitude < m_TargetScanDistanceSqr)
            {
                // following m_baske's logic of shooting bullets forward
                // scanner will create a scan in the position and direction sent
                // ScannerPosition = pos + fwd;
                // ScannerDirection = delta.normalized;
                // m_Bullets.Shoot(this);
                m_ScannerComponent.Scan(this, target.transform);
                m_ShotTime = Time.time;
                scanned = true;
                RotateVFXToTarget(target);
                // ResetObservations();
            }
        }

        protected void ScanTargets()
        {
            // *** SCAN ***
            Vector3 pos = m_Drone.Position;
            Vector3 fwd = m_Drone.transform.forward;
            // m_Targets.Clear();

            // Find targets in vicinity.
            // if CanScan() removed because of reduction of FPS
            var _targetsFound = false;
            Vector3 _vectorToTargetsInFront = vectorToTargetsInFront;
            Vector3 _vectorToTargetsFacingAway = vectorToTargetsFacingAway;
            float _distanceToTargets = 0;
            float _angleToTargetsInFront = 0;
            float _angleToTargetsFacingAway = 0;
            foreach (var target in m_SensorComponent.GetDetectedGameObjects(m_TargetTag))
            {
                // extract voxel
                VoxelController myVoxel = target.transform.parent.GetComponent<VoxelController>();
                
                if (myVoxel)
                {
                    // collection of scan points for octree at targe'ts position
                    Point point = new Point(PointType.ScanPoint, target.transform.position, Time.time);
                    Data.AddPoint(point);

                    // update that a target was found, otherwise later a ScanOutOfRange point is added
                    _targetsFound = true;
                    
                    var dotProductToTarget = Vector3.Dot(fwd, myVoxel.transform.forward);
                    Vector3 delta = target.transform.position - pos;

                    // dotProduct requirement: ONLY SCAN TARGETS IN FRONT
                    if (dotProductToTarget < 0)
                        // dotProductToTarget < m_TargetDotProduct
                        // && Vector3.Angle(fwd, delta) < m_TargetFollowAngle 
                        // && delta.sqrMagnitude < m_TargetFollowDistanceSqr)
                    {
                        _vectorToTargetsInFront += myVoxel.transform.position - pos;
                        _vectorToTargetsInFront /= 2f;

                        _distanceToTargets += Vector3.Distance(myVoxel.transform.position, pos);

                        _angleToTargetsInFront += Vector3.Angle(fwd, delta);
                    }
                    else
                    {
                        // objects i cannot scan
                        _vectorToTargetsFacingAway += myVoxel.transform.position - pos;
                        _vectorToTargetsFacingAway /= 2f;
                    
                        _angleToTargetsFacingAway += Vector3.Angle(fwd, delta);

                    }
                }
            }

            foreach (var target in m_SensorComponent_Scanner.GetDetectedGameObjects(m_TargetTag))
            {
             
                VoxelController myVoxel = target.transform.parent.GetComponent<VoxelController>();
                // dotProduct requirement: ONLY SCAN TARGETS IN FRONT
                var dotProductToTarget = Vector3.Dot(fwd, myVoxel.transform.forward);
                // distanceToTarget = Vector3.Distance(myVoxel.transform.position, pos);
                
                // vector to target, used to get angle observation
                Vector3 delta = target.transform.position - pos;

                // if facing targets and chance to collect is successful
                if (dotProductToTarget < 0 && UnityEngine.Random.Range(0, 101) <= m_ScanAccuracy) 
                    {
                        ScanTarget(target);
                    }
                    // print("dotproduct to target: " + dotProductToTarget);
                // m_AddedTargetsTime = Time.time;
            }

            if (_targetsFound == false)
            {
                Point point = new Point(PointType.ScanOutOfRange, m_Drone.Position + fwd * m_TargetFollowDistance, Time.time);
                Data.AddPoint(point);
                ResetObservations(false);
                // if (CanResetScannerRotation())
                // {
                // }
                
            }
            else
            {
                // IF targets are in vision and I AM NOT SCANNING: penalize. Will make the agent hurry to scan.
                print("penalizing while not scanning");
                AddReward(-0.0001f);
                
                var n_ObjectsDetectedBySensor = m_SensorComponent.GetDetectedGameObjects(m_TargetTag).Count();
                
                // avg vector to targets
                vectorToTargetsInFront = _vectorToTargetsInFront;
                vectorToTargetsFacingAway = _vectorToTargetsFacingAway;
                
                // avg distance to targets
                _distanceToTargets /= n_ObjectsDetectedBySensor;
                distanceToTarget = _distanceToTargets;
                
                // avg facing direction to targets (technically should be inferred from vectors)
                _angleToTargetsInFront /= n_ObjectsDetectedBySensor;
                angleToTargetsInFront = _angleToTargetsInFront;
                
                _angleToTargetsFacingAway /= n_ObjectsDetectedBySensor;
                angleToTargetsFacingAway = _angleToTargetsFacingAway;
                
                // print("in front of me: " + vectorToTargetsInFront);
                // print("facing away: " + vectorToTargetsFacingAway);
                
                // print("distance to targets: " + distanceToTarget);
                
                // print("angle to targets infront: " + angleToTargetsInFront);
                // print("angle to targets facingaway: " + angleToTargetsFacingAway);
            }

            ResetVFX();
        }
        // private void ScanTargets_deprecated()
        // {
        //     Vector3 pos = m_Drone.transform.position;
        //     Vector3 fwd = m_Drone.transform.forward;
        //     Vector3 vlc = m_Drone.WorldVelocity;
        //     // canScan logic moved outside of loop because it makes sense to be able to scan in bulks of BufferSize (10)
        //     // instead of pausing after every scan
        //     if (CanScan())
        //     {
        //         print("targets scanned: " + m_Targets.Count);
        //         foreach (var target in m_Targets)
        //         {
        //             print("reading target");
        //             Vector3 delta = target.transform.position - pos;
        //             // Speed towards target.
        //             float speed = Vector3.Dot(delta.normalized, vlc);
        //             AddReward(speed * 0.01f);
        //
        //
        //             if ( //Time.time - m_ShotTime >= m_ScanReloadTime / 50 &&
        //                  Vector3.Angle(fwd, delta) < m_TargetScanAngle &&
        //                  delta.sqrMagnitude < m_TargetScanDistanceSqr)
        //             {
        //                 print("scanning target");
        //                 // following m_baske's logic of shooting bullets forward
        //                 // scanner will create a scan in the position and direction sent
        //                 ScannerPosition = pos + fwd;
        //                 // ScannerDirection = delta.normalized;
        //                 // m_Bullets.Shoot(this);
        //                 m_ScannerComponent.Scan(this, target.transform);
        //                 m_ShotTime = Time.time;
        //                 scanned = true;
        //                 if (m_VFX != null)
        //                 {
        //                     // m_VFX.transform.LookAt(target.transform);
        //                     // var desiredRotQ = Quaternion.LookRotation(delta, Vector3.up);
        //                     
        //                     Quaternion OriginalRot = m_VFX.transform.rotation;
        //                     m_VFX.transform.LookAt(target.transform);
        //                     Quaternion NewRot = m_VFX.transform.rotation;
        //                     m_VFX.transform.rotation = OriginalRot;
        //                     m_VFX.transform.rotation = Quaternion.Lerp(m_VFX.transform.rotation, NewRot, damping * Time.deltaTime);
        //
        //                     // Vector3 lTargetDir = target.transform.position - m_VFX.transform.position;
        //                     // lTargetDir.y = 0.0f;
        //                     // m_VFX.transform.localRotation = Quaternion.RotateTowards(m_VFX.transform.localRotation,
        //                     //     Quaternion.LookRotation(lTargetDir), (1f * Time.deltaTime) *  5);
        //                 }
        //             }
        //         }
        //
        //     }
        //     ResetVFX();
        //     ResetObservations(false);
        // }

        public void ResetObservations(bool fullReset)
        {
            // reset SCAN observations 
            vectorToTargetsInFront = vectorToTargetsFacingAway = m_Drone.transform.forward;

            distanceToTarget = -1f;
            // distanceToTarget = 100f;
            
            angleToTargetsInFront = -1f;
            angleToTargetsFacingAway = -1f;

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
                
        protected void RotateVFXToTarget(GameObject target)
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

        protected void ResetVFX()
        {
            // print("trying to reset VFX after scanning");
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
            else
            {
                // print("could not reset");
            }
        }
        protected bool CanScan()
        {
            return Time.time - m_ShotTime >= m_ScanReloadTime;
        }
        protected bool NotMoving()
        {
            return Time.time - m_MovedTime >= m_InactivityTime / 4;
        }
        
        // after having scanned AND a period of time has passed since last scan, reset rotation == not scanning anymore
        // it needs the bool scanned otherwise it will always reset the position since time will always be higher
        protected bool CanResetScannerRotation()
        {
            return (Time.time - m_ShotTime >= m_InactivityTime);
        } 
        // if a period has passed after scannning
        // private bool CanAddTargets()
        // {
        //     print(m_Targets.Count);
        //     return (Time.time - m_AddedTargetsTime >= m_ScanReloadTime * m_Targets.Count * 0.8f);
        // }
        protected bool IsNewGridPosition(Vector3 dronePos)
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

        protected Vector3Int GetVector3Int(Vector3 pos)
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
            AddReward(0.1f);
            m_HitScoreCount++;
        }

        void Update()
        {
            // print("dotProductToTarget: " + (dotProductToTarget > 0.5));
            // print("distanceToTarget: " + distanceToTarget);
            // end episode if all collectibles have been collected
            if (m_World.trainingElements.Count > 0 && m_World.EverythingHasBeenCollected)
            {
                print("collected all the items!");
                // AddReward(1f);
                EndEpisode();
            }
        }

        protected virtual void CollisionEvent(object sender, EventArgs e)
        {
            if (RestartOnCollision)
            {
                EndEpisode();
            }
            AddReward(-1f);
            Debug.Log("hit the wall!");
            
            // print("in front of me: " + vectorToTargetsInFront);
            // print("facing away: " + vectorToTargetsFacingAway);
                
            // print("distance to targets: " + distanceToTarget);
                
            // print("angle to targets infront: " + angleToTargetsInFront);
            // print("angle to targets facingaway: " + angleToTargetsFacingAway);
        }


        private void OnApplicationQuit()
        {
            // m_Drone.VoxelScannedEvent -= OnBulletHitSuffered;
            // m_Drone.CollisionEvent -= OnCollision;
        }
        
    }
}