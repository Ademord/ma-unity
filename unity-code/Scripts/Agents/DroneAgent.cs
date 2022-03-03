using System;
using MBaske.Sensors.Grid;
using UnityEngine;
using Unity.MLAgents.Sensors;
using Unity.MLAgents.Actuators;


namespace Ademord
{
    public enum SteuernModus : int
    {
        Manual = 1 << 0,
        PhysicsVelocity = 1 << 1,
        PhysicsThrottle = 1 << 2
    }
    public enum EnvironmentType : int
    {
        Base = 1 << 0,
        OpenWorld = 1 << 1,
        Forest = 1 << 2,
        Neighborhood = 1 << 3
    }

    public class DroneAgent : ActivatableAgent, IControllableDrone
    {
        protected CharacterController3D characterController;
        public Vector3 LocalVelocity => m_Body.AvgLocalVelocityXZ;
        public Vector3 WorldVelocity => m_Body.AvgWorldVelocityXZ;

        // public Vector3 WorldVelocity => m_Rigidbody.velocity;
        // public Vector3 LocalVelocity => transform.InverseTransformVector(m_Rigidbody.velocity);

        public const float MaxSpeed = 5;
        public const float MinSpeed = 0.5f;

        public float NormTargetSpeed
        {
            set { TargetSpeed = (value + 1) * 0.5f * MaxSpeed; }
            get { return m_NormTargetSpeed; }
        }

        protected float TargetSpeed
        {
            set
            {
                m_TargetSpeed = value < MinSpeed ? 0 : value;
                m_NormTargetSpeed = m_TargetSpeed / MaxSpeed * 2 - 1;
            }
            get { return m_TargetSpeed; }
        }

        private float m_NormTargetSpeed;
        private float m_TargetSpeed;

        public float NormTargetWalkAngle { set; get; }

        protected float TargetWalkAngle
        {
            set { NormTargetWalkAngle = value / 180f; }
            get { return NormTargetWalkAngle * 180; }
        }

        public float NormTargetLookAngle { set; get; }

        protected float TargetLookAngle
        {
            set { NormTargetLookAngle = value / 180f; }
            get { return NormTargetLookAngle * 180; }
        }

        [Header("Drone Agent Parameters")]
        [Tooltip("Reference to sensor component for retrieving detected obstacle, goal, and boundary gameobjects.")]
        [SerializeField]
        protected GridSensorComponent3D m_SensorComponent;

        protected Body m_Body;

        [SerializeField] protected TrainingAreaController3D m_World;

        [SerializeField] [Tooltip("Maximum exploration area the drone is allowed to cover.")] [Range(5f, 30f)]
        protected float ExplorationLimit = 10f;

        [SerializeField] [Tooltip("Restart Episode on Collisions.")]
        protected bool RestartOnCollision = false;

        [SerializeField] [BitMask(typeof(SteuernModus))]
        protected SteuernModus steuernModus;

        [SerializeField] 
        protected EnvironmentType EnvironmentType;
        protected Vector3 m_StartingPosition;
        protected bool m_OutsideBounds;

        protected bool movingForward;
        protected float m_movingForwardSpeed;
        protected float EpisodeTimer;

        public override void Initialize()
        {
            base.Initialize();

            m_Body = GetComponentInChildren<Body>();
            m_Body.Initialize(ExplorationLimit);
            m_Body.OnBoundaryCollisionEventHandler += BoundaryCollisionEvent;

            characterController = GetComponentInChildren<CharacterController3D>();
            // print(steuernModus);
            characterController.steuernModus = steuernModus;

            m_StartingPosition = m_Body.WorldPosition;
            m_OutsideBounds = false;

            // Path = new SceneDronePath(pathExtent);
            // ScanBuffer = new SceneDroneScanBuffer(scanBufferSize);
            
            if (m_World != null)
            {
                m_World = m_World.GetComponent<TrainingAreaController3D>();
                m_World.Initialize(ExplorationLimit);
            }
            else
            {
                Debug.Log("Warning: No Training Area was Specified");
                Debug.LogWarning("Warning: No Training Area was Specified");
            }
            print("current environment type: " + EnvironmentType);

            
        }

        public override void OnEpisodeBegin()
        {
            ResetAgent();
        }

        public void ResetAgent()
        {
            // print("ResetAgent: DroneAgent");
            m_Body.ManagedReset(true);
            EpisodeTimer = 0;
        }

        public override void CollectObservations(VectorSensor sensor)
        {
            // print("Normalization.Sigmoid(m_Body.LocalVelocity): " + Normalization.Sigmoid(m_Body.LocalVelocity));
            // print("m_NormTargetSpeed: " + m_NormTargetSpeed);
            // print("WorldPosition: " + m_Body.WorldPosition);
            // print("AvgWorldRotationXZ: " + m_Body.AvgWorldRotationXZ);

            sensor.AddObservation(m_NormTargetSpeed); // 1
            sensor.AddObservation(Normalization.Sigmoid(m_Body.LocalVelocity)); //3
            sensor.AddObservation(Normalization.Sigmoid(m_Body.LocalAngularVelocity)); //3

            sensor.AddObservation(m_Body.AvgWorldRotationXZ); // 4 
            sensor.AddObservation(m_Body.WorldPosition); // 3

            var distanceToOrigin = Vector3.Distance(m_Body.WorldPosition, m_StartingPosition);
            if (EnvironmentType == EnvironmentType.OpenWorld || SemanticEntropyAgentTrain.IsConfigOffline())
                if ( distanceToOrigin > 60f || // max distance from origin 
                     m_Body.WorldPosition.y <= m_StartingPosition.y - 5f ||  // min height
                     m_Body.WorldPosition.y >= m_StartingPosition.y + 8f)    // max height
                {
                    m_OutsideBounds = true;
                }
                else
                {
                    m_OutsideBounds = false;
                }

            sensor.AddObservation(m_OutsideBounds);
            sensor.AddObservation(distanceToOrigin);

            // total 14 obs
            // AddReward(-10f / MaxStep); // for above 10k steps, try to stay at -0.001 / step
            AddReward(-0.001f);
        }

         public override void OnActionReceived(ActionBuffers actions)
         {
             if (actions.ContinuousActions[0] > 0.1f) // || Math.Abs(actions.ContinuousActions[1] ) > 0.1f
             {
                 movingForward = true;
                 m_movingForwardSpeed = ((int)(Math.Max(actions.ContinuousActions[0], Math.Abs(actions.ContinuousActions[1])) * 10f))/10f;
             }
             else
             {
                 movingForward = false;
                 m_movingForwardSpeed = 0f;
             }
             
             ManagedUpdate(actions);
         }

        public override void Heuristic(in ActionBuffers actionsOut)
        { 
            var actions = actionsOut.ContinuousActions;
            // Read input values and round them. GetAxisRaw works better in this case
            // because of the DecisionRequester, which only gets new decisions periodically.
            
            // rotation input
            int yaw = 0;
            if (Input.GetKey(KeyCode.E)) yaw = -1;
            else if (Input.GetKey(KeyCode.C)) yaw = 1;

            // vertical input
            int verticalInput = 0;
            if (Input.GetKey(KeyCode.R)) verticalInput = 1;
            else if (Input.GetKey(KeyCode.V)) verticalInput = -1;
            
            // Convert the actions (-1, 0, 1) to Continuous choices
            actions[0] = Input.GetAxisRaw("Vertical"); //forward
            actions[1] = Input.GetAxisRaw("Horizontal"); 
            actions[2] = yaw * 1f; 
            actions[3] = verticalInput * 1f;
        }
        
        public virtual void ManagedUpdate(ActionBuffers actions)
        {
            switch (steuernModus)
            {
                case SteuernModus.Manual:
                    characterController.ForwardInput = actions.ContinuousActions[0];
                    characterController.SidesInput = actions.ContinuousActions[1];
                    characterController.TurnInput = actions.ContinuousActions[2];
                    characterController.VerticalInput = actions.ContinuousActions[3];
                    break;
                
                case SteuernModus.PhysicsVelocity:
                    characterController.ForwardInput = actions.ContinuousActions[1];
                    characterController.SidesInput = actions.ContinuousActions[0];
                    characterController.TurnInput = actions.ContinuousActions[2];
                    characterController.VerticalInput = actions.ContinuousActions[3];
                    break;
                
                case SteuernModus.PhysicsThrottle:
                    // m_Body.ControlWithThrottle(
                    //     actions.ContinuousActions[0],
                    //     actions.ContinuousActions[1], 
                    //     actions.ContinuousActions[3], // [3] is vertical
                    //     actions.ContinuousActions[2]
                    // );
                    break;

                default:
                    Debug.LogError("No SteuernModus selected");
                    break;
            }
            
            m_Body.ManagedUpdate();
        }
       
        public void Update()
        {
            // end episode if all collectibles have been collected
            // print("m_World != null: " + (m_World != null));
            // print("m_World.trainingElements.Count: " + m_World.trainingElements.Count);
            // print("m_World.EverythingHasBeenCollected: " + m_World.EverythingHasBeenCollected);
            EpisodeTimer += Time.deltaTime;
            
            if (m_World != null && m_World.m_NSpawnTargets > 0 && m_World.EverythingHasBeenCollected)
            {
                print("collected all the items!");
                // AddReward(1f);
                EndEpisode();
            }
        }

        protected virtual void BoundaryCollisionEvent(object sender, BoundaryCollidedEventArgs e)
        {
            Debug.Log("hit the wall!");
            AddReward(-5f);
            if (RestartOnCollision)
            {
                EndEpisode();
            }
        }
   
        private void FixedUpdate()
        {
            // Each ring's rotation represents drone movement along a world axis.
            // TODO add animator here
            Vector3 v = m_Body.WorldVelocity;
            
            // rot1.x += v.z * rotationSpeed;
            // rot2.y += v.x * rotationSpeed;
            // rot3.y += v.y * rotationSpeed;

            // ring1.rotation = Quaternion.Euler(rot1);
            // ring2.rotation = Quaternion.Euler(rot2);
            // ring3.rotation = Quaternion.Euler(rot3);
        }
        
        
    }
}