using UnityEngine;
using UnityEngine.Rendering;
using System;
using System.Linq;
using System.Collections.Generic;
using Ademord.Drone;
using Unity.MLAgents.Actuators;

public class SceneDrone : MonoBehaviour
{
    // TODO delete commented
    private CharacterController3D characterController;
    public Vector3 Position => transform.position;
    // public Vector3 LocalPosition => transform.localPosition;
    // public Vector3 Velocity => rb.velocity;
    // public Vector3 VelocityNorm => DroneData.Normalize(rb.velocity);
    
    // TODO add on scan event?
    /// <summary>
    /// Optional: Invoked on <see cref="Bullet"/> hit 
    /// if <see cref="Bullet"/> collider is trigger.
    /// </summary>
    public event Action BulletHitEvent;
    
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
    /// Drone's velocity in world space.
    /// </summary>
    public Vector3 WorldVelocity => m_Rigidbody.velocity;

    /// <summary>
    /// Drone's velocity in local space.
    /// </summary>
    public Vector3 LocalVelocity => transform.InverseTransformVector(m_Rigidbody.velocity);

    /// <summary>
    /// Drone's angular velocity in local space.
    /// </summary>
    public Vector3 LocalSpin => transform.InverseTransformVector(m_Rigidbody.angularVelocity);

    /// <summary>
    /// Normalized throttle control value. 
    /// </summary>
    public float Throttle_horizontal { get; private set; }
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
            Stop();
        }
    }
    
    /// <summary>
    /// Sets the brake zone depending on the <see cref="AsteroidField"/>'s radius.
    /// </summary>
    public float EnvironmentRadius
    {
        set
        {
            m_brakeZoneLength = value * 0.1f;
            m_BrakeThreshRadius = value * 0.8f;
            m_BrakeThreshRadiusSqr = m_BrakeThreshRadius * m_BrakeThreshRadius;
        }
    }
    private float m_brakeZoneLength;
    private float m_BrakeThreshRadius;
    private float m_BrakeThreshRadiusSqr;

    
    
    // The path is only used for smoothing cam movement.
    // public SceneDronePath Path { get; private set; }
    public SceneDroneScanBuffer ScanBuffer { get; private set; }

    private const int scanBufferSize = 2;
    private const float proximitySensorRange = 1f;
    private const float maxVelocity = 0.2f;
    // private const float pathExtent = 2f;
    private const int layerMask = 1 << 6;
    // private const string layerMask = "collectible";
    private const float rotationSpeed = 2f;

    // private Rigidbody rb;
    // private LineRenderer laser;
    // private Transform ring1;
    // private Transform ring2;
    // private Transform ring3;
    // private Vector3 rot1 = Vector3.zero;
    // private Vector3 rot2 = Vector3.right * 90;
    // private Vector3 rot3 = Vector3.forward * 90;
    
    [Space]
    [SerializeField]
    private float m_ControlIncrement = 0.05f;
    [SerializeField]
    private float m_ControlAttenuate = 0.95f;
    [SerializeField]
    private float m_BackwardSpeedFactor = 0.25f;

    private Rigidbody m_Rigidbody;

    
    public void Initialize()
    {
        // Path = new SceneDronePath(pathExtent);
        ScanBuffer = new SceneDroneScanBuffer(scanBufferSize);
        characterController = GetComponent<CharacterController3D>();
        m_Rigidbody = GetComponent<Rigidbody>();

        // characterController = GetComponent<CharacterController3D>();

        // rb = GetComponent<Rigidbody>();
        // ring1 = transform.Find("Ring1");
        // ring2 = transform.Find("Ring2");
        // ring3 = transform.Find("Ring3");

        // laser = new GameObject().AddComponent<LineRenderer>();
        // laser.transform.parent = transform;
        // laser.transform.name = "Laser";
        // laser.material = new Material(Shader.Find("Sprites/Default"));
        // laser.widthMultiplier = 0.01f;
        // laser.receiveShadows = false;
        // laser.shadowCastingMode = ShadowCastingMode.Off;
        // laser.motionVectorGenerationMode = MotionVectorGenerationMode.ForceNoMotion;
        // laser.positionCount = 2;
        // laser.startColor = new Color(0f, 1f, 0.2f, 0.4f);
        // laser.endColor = laser.startColor;

        Reset();
    }
    private void Awake()
    {
        Stop();
    }
    public void Reset()
    {
        ScanBuffer.Clear();
        m_Rigidbody.angularVelocity = Vector3.zero;
        m_Rigidbody.velocity = Vector3.zero;
        // Path.Clear(Position);
        // laser.enabled = false;
    }
    private void Stop()
    {
        m_Rigidbody.angularVelocity = Vector3.zero;
        m_Rigidbody.velocity = Vector3.zero;

        Throttle_horizontal = 0;
        Throttle_vertical = 0;
        Yaw = 0;
        // Pitch = 0;
        // Roll = 0;
    }
    // public void Move(Vector3 velocity)
    // {
    //     rb.AddForce(velocity * maxVelocity, ForceMode.VelocityChange);
    //     // Path.Add(Position);
    // }
    public void ManagedUpdate(ActionBuffers actions)
    {
        float forwardInput = actions.ContinuousActions[0] <= 1 ? actions.ContinuousActions[0] : -1;
        float sidesInput = actions.ContinuousActions[1] <= 1 ? actions.ContinuousActions[1] : -1;
        float yaw = actions.ContinuousActions[2] <= 1 ? actions.ContinuousActions[2] : -1;
        // new vertical input
        float verticalInput = actions.ContinuousActions[3] <= 1 ? actions.ContinuousActions[3] : -1;
        // float pitch = actions.DiscreteActions[4] <= 1 ? actions.DiscreteActions[4] : -1;
        
        characterController.ForwardInput = forwardInput;
        characterController.TurnInput = yaw;
        characterController.SidesInput = sidesInput;
        characterController.VerticalInput = verticalInput;
        // characterController.PitchInput = pitch;
    }
    public void ManagedUpdate(Vector3 velocity, float yaw)
    {
        // float forwardInput = actions.DiscreteActions[0] <= 1 ? actions.DiscreteActions[0] : -1;
        // float sidesInput = actions.DiscreteActions[1] <= 1 ? actions.DiscreteActions[1] : -1;
        // float yaw = actions.DiscreteActions[2] <= 1 ? actions.DiscreteActions[2] : -1;
        // // new vertical input
        // float verticalInput = actions.DiscreteActions[3] <= 1 ? actions.DiscreteActions[3] : -1;
        // // float pitch = actions.DiscreteActions[4] <= 1 ? actions.DiscreteActions[4] : -1;
        //
        // characterController.ForwardInput = forwardInput;
        // characterController.TurnInput = yaw;
        // // characterController.SidesInput = sidesInput;
        // // characterController.VerticalInput = verticalInput;
        // characterController.PitchInput = pitch;

        // if agent strays too far away give a negative reward and end episode
        print("received movement vector: " + velocity);
        m_Rigidbody.AddForce(velocity * maxVelocity, ForceMode.VelocityChange);

    }
    public float ManagedUpdate(int throttle_horizontal, int throttle_vertical, int yaw)
    {
        Vector3 pos = LocalPosition;
        Vector3 fwd = transform.forward;
        Vector3 velocity = m_Rigidbody.velocity;
        Vector3 normal = pos.normalized;
        float sqrMag = pos.sqrMagnitude;

        // Update control values.

        Throttle_horizontal = throttle_horizontal == 0
            ? Throttle_horizontal * m_ControlAttenuate
            : Mathf.Clamp(Throttle_horizontal + throttle_horizontal * m_ControlIncrement, -1, 1);
      
        Throttle_vertical = throttle_vertical == 0
            ? Throttle_vertical * m_ControlAttenuate
            : Mathf.Clamp(Throttle_vertical + throttle_vertical * m_ControlIncrement, -1, 1);

        velocity += fwd * Throttle_horizontal + transform.up * Throttle_vertical;
            
        Yaw = yaw == 0
            ? Yaw * m_ControlAttenuate
            : Mathf.Clamp(Yaw + yaw * m_ControlIncrement, -1, 1);

       
        m_Rigidbody.AddTorque(transform.up * Yaw, ForceMode.VelocityChange);

        // Update observables.

        NormPosition = Mathf.Clamp01(sqrMag / m_BrakeThreshRadiusSqr) * 2 - 1;
        NormOrientation = Vector3.Angle(normal, fwd) / 90f - 1;

        // Counter outward velocity when ship enters brake zone. 

        if (sqrMag > m_BrakeThreshRadiusSqr && NormOrientation < 0)
        {
            float outwardVelocity = Vector3.Dot(normal, velocity);
            float brakeStrength = (pos.magnitude - m_BrakeThreshRadius) / m_brakeZoneLength;
            velocity -= outwardVelocity * brakeStrength * normal;
        }
        
        float fwdSpeed = Vector3.Dot(fwd, velocity);
        if (fwdSpeed < 0)
        {
            velocity *= m_BackwardSpeedFactor;
        }

        m_Rigidbody.velocity = velocity;

        return fwdSpeed;
    }
    
    // public Point Scan(float hrz, float vrt, float range)
    // {
    //     RaycastHit hit;
    //     Vector3 scan = new Vector3(hrz, vrt, 1f);
    //     Ray ray = new Ray(Position, Quaternion.Euler(vrt * 180f, hrz * 180f, 0f) * Vector3.forward);
    //     Point point = new Point(PointType.ScanOutOfRange, Position + ray.direction * range, Time.time);
    //     laser.enabled = Physics.Raycast(ray.origin, ray.direction, out hit, range, layerMask);
    //     if (laser.enabled)
    //     {
    //         scan.z = DroneData.NormalizeDistance(hit.distance);
    //         // Grid nodes align with blocks:
    //         // Offset point slightly so it doesn't sit right on the boundary between two nodes.
    //         point.Position = ray.origin + ray.direction * (hit.distance + 0.01f);
    //         point.Type = PointType.ScanPoint;
    //         laser.SetPosition(0, ray.origin);
    //         laser.SetPosition(1, hit.point);
    //     }
    //     ScanBuffer.Add(scan);
    //     return point;
    // }

    public Vector4 GetForwardProximity()
    {
        RaycastHit hit;
        Ray ray = new Ray(Position, m_Rigidbody.velocity);
        Vector4 result = new Vector4(0f, 0f, 0f, 1f);
        if (Physics.SphereCast(ray, 0.25f, out hit, proximitySensorRange, layerMask))
        {
            result = (hit.point - Position).normalized;
            result.w = hit.distance / proximitySensorRange;
        }
        return result;
    }

    private void FixedUpdate()
    {
        // Each ring's rotation represents drone movement along a world axis.
        // TODO add animator here
        Vector3 v = m_Rigidbody.velocity;
        
        // rot1.x += v.z * rotationSpeed;
        // rot2.y += v.x * rotationSpeed;
        // rot3.y += v.y * rotationSpeed;

        // ring1.rotation = Quaternion.Euler(rot1);
        // ring2.rotation = Quaternion.Euler(rot2);
        // ring3.rotation = Quaternion.Euler(rot3);
    }
}

public class SceneDroneScanBuffer
{
    private Queue<Vector3> queue;
    private int sizeV;
    private int sizeF;
    private float[] na;

    public SceneDroneScanBuffer(int size)
    {
        sizeV = size;
        sizeF = size * 3;
        queue = new Queue<Vector3>();
        na = Enumerable.Repeat(-1f, sizeF).ToArray();
    }

    public void Clear()
    {
        queue.Clear();
    }

    public void Add(Vector3 scan)
    {
        queue.Enqueue(scan);
        if (queue.Count > sizeV)
        {
            queue.Dequeue();
        }
    }

    public float[] ToArray()
    {
        if (queue.Count > 0)
        {
            float[] floats = new float[sizeF];
            Array.Copy(na, floats, sizeF);
            int i = sizeF - queue.Count * 3;
            foreach (Vector3 v in queue)
            {
                floats[i++] = v.x;
                floats[i++] = v.y;
                floats[i++] = v.z;
            }
            // Latest scan -> last 3 array elements.
            return floats;
        }

        return na;
    }
}

// public class SceneDronePath
// {
//     public float Extent
//     {
//         get { return Mathf.Sqrt(extentSqr); }
//         set { extentSqr = value * value; }
//     }
//     public float Spacing
//     {
//         get { return Mathf.Sqrt(spacingSqr); }
//         set { spacingSqr = value * value; }
//     }
//     public int Count => buffer.Count;
//     public Vector3 Center => bounds.center;
//     public IOrderedEnumerable<Vector4> Chronological => buffer.OrderBy(p => p.w);
//
//     private HashSet<Vector4> buffer;
//     private Vector4 latest;
//     private Bounds bounds;
//     private float extentSqr;
//     private float spacingSqr;
//
//     public SceneDronePath(float extent = 1f, float spacing = 0)
//     {
//         Extent = extent;
//         Spacing = spacing;
//         buffer = new HashSet<Vector4>();
//         bounds = new Bounds();
//     }
//
//     public void Clear(Vector3 pos)
//     {
//         Clear();
//         AddChronological(pos);
//         ResetBounds(pos);
//     }
//
//     public void Clear()
//     {
//         buffer.Clear();
//         buffer.TrimExcess();
//     }
//
//     public void Add(Vector3 pos)
//     {
//         Trim();
//
//         if (spacingSqr < Mathf.Epsilon || (pos - (Vector3)latest).sqrMagnitude >= spacingSqr)
//         {
//             if (AddChronological(pos))
//             {
//                 UpdateBounds(pos);
//             }
//         }
//     }
//
//     public float GetLength()
//     {
//         IOrderedEnumerable<Vector4> sorted = Chronological;
//         Vector4 s = Vector4.zero;
//         float length = 0f;
//         foreach (Vector4 p in sorted)
//         {
//             length += (s.Equals(Vector4.zero) ? 0 : Vector3.Distance(s, p));
//             s = p;
//         }
//         return length;
//     }
//
//     public void Draw()
//     {
//         IOrderedEnumerable<Vector4> sorted = Chronological;
//         Vector4 s = Vector4.zero;
//         foreach (Vector4 p in sorted)
//         {
//             PopGizmos.Line(s.Equals(Vector4.zero) ? p : s, p, Color.yellow);
//             s = p;
//         }
//         Vector3 c = Center;
//         // Bounding Box
//         PopGizmos.Cube(c, Quaternion.identity, bounds.size, Color.gray);
//         // Crosshair
//         float l = 0.25f;
//         PopGizmos.Line(c + Vector3.left * l, c + Vector3.right * l, Color.white);
//         PopGizmos.Line(c + Vector3.up * l, c + Vector3.down * l, Color.white);
//         PopGizmos.Line(c + Vector3.forward * l, c + Vector3.back * l, Color.white);
//     }
//
//     public void Trim()
//     {
//         if (buffer.RemoveWhere(IsOutOfBounds) > 0)
//         {
//             RecalcBounds();
//         }
//     }
//
//     private bool IsOutOfBounds(Vector4 pos)
//     {
//         // Vector4 pos is a space&time location.
//         // Not casting to Vector3 would also remove old points
//         // with DronePath.Extent being the lifetime in seconds.
//         return ((Vector3)pos - (Vector3)latest).sqrMagnitude > extentSqr;
//     }
//
//     private void ResetBounds(Vector3 pos)
//     {
//         bounds.center = pos;
//         bounds.size = Vector3.zero;
//     }
//
//     private void RecalcBounds()
//     {
//         ResetBounds(latest);
//         foreach (Vector3 p in buffer)
//         {
//             UpdateBounds(p);
//         }
//     }
//
//     private void UpdateBounds(Vector3 pos)
//     {
//         bounds.min = Vector3.Min(bounds.min, pos);
//         bounds.max = Vector3.Max(bounds.max, pos);
//     }
//
//     private bool AddChronological(Vector3 pos)
//     {
//         latest = pos;
//         latest.w = Time.time;
//         return buffer.Add(latest);
//     }
// }