using System;
using UnityEngine;
using Random = UnityEngine.Random;

namespace Ademord
{
    public class Body : MonoBehaviour
    {
        public event EventHandler<BoundaryCollidedEventArgs> OnBoundaryCollisionEventHandler;
        public event EventHandler<VoxelCollectedEventArgs> OnGoalCollisionEventHandler;
        public Vector3 WorldPosition => m_Body.transform.position;
        public Vector3 WorldForward => m_Body.transform.forward;
        public Vector3 WorldVelocity => m_Body.velocity;
        public Vector3 LocalVelocity => Localize(m_Body.velocity);
        public Vector3 LocalAngularVelocity => Localize(m_Body.angularVelocity);
        
        public Vector3 AvgWorldVelocityXZ { get; private set; }
        public Vector3 AvgLocalVelocityXZ => Localize(AvgWorldVelocityXZ);
        public float AvgSpeed => AvgWorldVelocityXZ.magnitude;

        public Vector3 AvgWorldForwardXZ { get; private set; }
        public Quaternion AvgWorldRotationXZ { get; private set; }

        // public Vector3 Gyro => new Vector3(transform.right.y, transform.up.y, transform.forward.y);

        [SerializeField]
        private int m_BufferSize = 300;
        private int m_BufferIndex;

        private Vector3[] m_VelocityBuffer;
        private Vector3[] m_ForwardBuffer;

        private Rigidbody m_Body;
        private Quaternion m_DefRot;
        private Vector3 m_DefPos;
        private Vector3 m_DefFwd;

        [Space]
        [SerializeField]
        private float m_ControlIncrement = 0.025f;
        [SerializeField]
        private float m_ControlAttenuate = 0.95f;
        [SerializeField]
        private float m_BackwardSpeedFactor = 0.25f;
        
        /// <summary>
        /// Sets the brake zone depending on the <see cref="World's"/>'s radius.
        /// </summary>
        public float EnvironmentRadius
        {
            set
            {
                m_BrakeThreshRadius = value * 0.8f;
                m_BrakeThreshRadiusSqr = m_BrakeThreshRadius * m_BrakeThreshRadius;
            }
        }
        private float m_BrakeThreshRadius;
        private float m_BrakeThreshRadiusSqr;

        public void Initialize(float ExplorationLimit)
        {
            m_Body = GetComponent<Rigidbody>();
            m_DefRot = transform.rotation;
            m_DefPos = transform.position;
            m_DefFwd = transform.forward;

            m_VelocityBuffer = new Vector3[m_BufferSize];
            m_ForwardBuffer = new Vector3[m_BufferSize];
        }

        public void ManagedReset(bool randomizeRotation = false, Vector3 position = default)
        {
            AvgWorldForwardXZ = m_DefFwd;
            AvgWorldRotationXZ = m_DefRot;
            AvgWorldVelocityXZ = Vector3.zero;
            m_BufferIndex = 0;


            for (int i = 0; i < m_BufferSize; i++)
            {
                m_VelocityBuffer[i] = Vector3.zero;
                m_ForwardBuffer[i] = transform.forward;
            }

            // TODO look if this will be needed to change
            // m_Body.transform.localPosition = new Vector3(0, 3, 0);
            m_Body.rotation = Quaternion.Euler(Vector3.up * UnityEngine.Random.Range(0f, 360f));

            m_Body.position = position.Equals(default) ? m_DefPos : position;
            // m_Body.rotation = randomizeRotation
            //     ? Quaternion.LookRotation(Random.onUnitSphere, Random.onUnitSphere)
            //     : m_DefRot;

            m_Body.angularVelocity = Vector3.zero;
            Throttle_horizontal = 0;
            Throttle_vertical = 0;
            Yaw = 0;
        }
        
        public void ManagedUpdate()
        {
            m_VelocityBuffer[m_BufferIndex] = m_Body.velocity;
            m_ForwardBuffer[m_BufferIndex] = transform.forward;

            m_BufferIndex = ++m_BufferIndex % m_BufferSize;

            AvgWorldVelocityXZ = Vector3.zero;
            AvgWorldForwardXZ = Vector3.zero;

            for (int i = 0; i < m_BufferSize; i++)
            {
                AvgWorldVelocityXZ += m_VelocityBuffer[i];
                AvgWorldForwardXZ += m_ForwardBuffer[i];
            }

            float n = m_BufferSize;
            AvgWorldVelocityXZ = Vector3.ProjectOnPlane(AvgWorldVelocityXZ / n, Vector3.up);
            AvgWorldForwardXZ = Vector3.ProjectOnPlane(AvgWorldForwardXZ / n, Vector3.up).normalized;
            AvgWorldRotationXZ = Quaternion.LookRotation(AvgWorldForwardXZ);

            //Debug.Log($"Speed {AvgSpeed} / Height {AvgHeight}");
        }
        
        public float ControlWithThrottle(float throttle_horizontal, float throttle_sideways, float throttle_vertical, float yaw)
        {
            Vector3 pos = LocalPosition;
            Vector3 fwd = transform.forward;
            Vector3 normal = pos.normalized;
            Vector3 up_v = transform.up;
            float sqrMag = pos.sqrMagnitude;

            // Update control values.

            Throttle_horizontal = throttle_horizontal == 0
                ? Throttle_horizontal * m_ControlAttenuate
                : Mathf.Clamp(Throttle_horizontal + throttle_horizontal * m_ControlIncrement, -1, 1);
              
            Throttle_sideways = throttle_sideways == 0
                ? Throttle_sideways * m_ControlAttenuate
                : Mathf.Clamp(Throttle_sideways + throttle_sideways * m_ControlIncrement, -1, 1);
          
            Throttle_vertical = throttle_vertical == 0
                ? Throttle_vertical * m_ControlAttenuate
                : Mathf.Clamp(Throttle_vertical + throttle_vertical * m_ControlIncrement, -1, 1);

            Vector3 fwd_velocity = fwd * Throttle_horizontal;
            Vector3 sideways_velocity = transform.right * Throttle_sideways;
            Vector3 vertical_velocity = up_v * Throttle_vertical; 

            Yaw = yaw == 0
                ? Yaw * m_ControlAttenuate
                : Mathf.Clamp(Yaw + yaw * m_ControlIncrement * 0.5f, -1, 1);

           
            m_Body.AddTorque(Yaw * 0.25f * up_v, ForceMode.VelocityChange);

            // Update observables.

            NormPosition = Mathf.Clamp01(sqrMag / m_BrakeThreshRadiusSqr) * 2 - 1;
            NormOrientation = Vector3.Angle(normal, up_v) / 90f - 1;
            
            // Sum all velocity changes
            
            Vector3 velocity = m_Body.velocity;
            velocity += (fwd_velocity + vertical_velocity + sideways_velocity);
            
            // Counter outward velocity when ship enters brake zone. 

            // if (sqrMag > m_BrakeThreshRadiusSqr && NormOrientation < 0)
            // {
            //     float outwardVelocity = Vector3.Dot(normal, velocity);
            //     float brakeStrength = (pos.magnitude - m_BrakeThreshRadius) / m_brakeZoneLength;
            //     velocity -= outwardVelocity * brakeStrength * normal;
            // }
            
            // Apply backward factor
            
            float fwdSpeed = Vector3.Dot(fwd, velocity);
            if (fwdSpeed < 0)
            {
                velocity *= m_BackwardSpeedFactor;
            }

            m_Body.velocity = velocity;

            return fwdSpeed;
        }
        
        public Vector4 GetForwardProximity(float proximitySensorRange = 1f)
        {
            RaycastHit hit;
            Ray ray = new Ray(WorldPosition, m_Body.velocity);
            Vector4 result = new Vector4(0f, 0f, 0f, 1f);
            if (Physics.SphereCast(ray, 0.25f, out hit, proximitySensorRange))
            {
                Debug.Log("proximity found something");
                result = (hit.point - WorldPosition).normalized;
                result.w = hit.distance / proximitySensorRange;
            }
            return result;
        }

        
        public void AddRandomForce(float strength = 10000)
        {
            m_Body.AddForce(Random.onUnitSphere * strength);
        }

 
        private Vector3 Localize(Vector3 v)
        {
            return transform.InverseTransformVector(v);
        }
        
        /// <summary>
        /// Drone's angular velocity in local space.
        /// </summary>
        public Vector3 LocalSpin => transform.InverseTransformVector(m_Body.angularVelocity);

        /// <summary>
        /// Normalized position on outward pointing normal,
        /// between center and brake threshold radius.
        /// </summary>
        public float NormPosition { get; private set; }

        /// <summary>
        /// Normalized forward angle relative to outward pointing normal.
        /// </summary>
        public float NormOrientation { get; private set; }

        /// <summary>
        /// Normalized throttle control value. 
        /// </summary>
        public float Throttle_horizontal { get; private set; }
        public float Throttle_sideways { get; private set; }
        public float Throttle_vertical { get; private set; }
        
        /// <summary>
        /// Normalized pitch control value. 
        /// </summary>
        public float Yaw { get; private set; }
        
        /// <summary>
        /// Ship's position in local space.
        /// </summary>
        public Vector3 LocalPosition
        {
            get { return transform.localPosition; }
            set
            {
                transform.localPosition = value;
                // Set on episode begin, all ships look towards center.
                transform.rotation = Quaternion.LookRotation(-value);
                ManagedReset();
            }
        }
        void OnCollisionEnter(Collision collision)
        {
            if (collision.collider.CompareTag("boundary"))
            {
                // m_OnCollisionEventHandler?.Invoke(this, EventArgs.Empty);
                BoundaryCollidedEventArgs args = new BoundaryCollidedEventArgs();
                args.CollisionCollider = collision.collider;
                NotifyBoundaryCollision(args);
            }
        }
        private void NotifyBoundaryCollision(BoundaryCollidedEventArgs e)
        {
            EventHandler<BoundaryCollidedEventArgs> handler = OnBoundaryCollisionEventHandler;
            if (handler != null)
            {
                handler(this, e);
            }
        }
        
        private void OnTriggerEnter(Collider collider)
        {
            if (collider.CompareTag("collectible"))
            {
                // m_OnCollisionEventHandler?.Invoke(this, EventArgs.Empty);
                VoxelCollectedEventArgs args = new VoxelCollectedEventArgs();
                args.CollisionCollider = collider;
                NotifyGoalCollision(args);
            }
        }
        private void NotifyGoalCollision(VoxelCollectedEventArgs e)
        {
            EventHandler<VoxelCollectedEventArgs> handler = OnGoalCollisionEventHandler;
            if (handler != null)
            {
                handler(this, e);
            }
           
        }
    }
    public class BoundaryCollidedEventArgs : EventArgs
    {
        // used to notify of collection
        public Collider CollisionCollider { get; set; }
    }
    

}