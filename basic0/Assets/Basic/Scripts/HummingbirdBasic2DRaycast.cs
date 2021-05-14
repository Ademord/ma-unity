using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Unity.MLAgents;
using Unity.MLAgents.Extensions;
using Unity.MLAgents.Actuators;
using Unity.MLAgents.Sensors;

public class HummingbirdBasic2DRaycast : Agent
{

    [Tooltip("Force to apply when moving")]
    public float moveForce = 2f;

    [Tooltip("Speed to pitch up or down")]
    public float pitchSpeed = 100f;

    [Tooltip("Spped to rotate around the up axis")]
    public float yawSpeed = 100f;

    [Tooltip("Tip of the beek")]
    public Transform beakTip;

  
    new private Rigidbody rigidbody;
    private TrainingArea flowerArea;
    [SerializeField] private Flower nearestFlower;
    private float smoothPitchChange = 0f;
    private float smoothYawChange = 0f;
    private const float MaxPitchAngle = 80f;
    private const float BeakTipRadius = 0.008f;
    private bool isFrozen = false;

    
    // [SerializeField] private Transform targetTransform;
    [SerializeField] private Material winMaterial;
    [SerializeField] private Material loseMaterial;
    [SerializeField] private Material floorMaterial;
    [SerializeField] private MeshRenderer floorMeshRenderer;
    public override void Initialize()
    {
        rigidbody = GetComponent<Rigidbody>();
        flowerArea = GetComponentInParent<TrainingArea>();

 
    }
    
    public override void OnEpisodeBegin()
    {
        // floorMeshRenderer.material = floorMaterial;
    
        flowerArea.ResetFlowers();
        rigidbody.velocity = Vector3.zero;
        rigidbody.angularVelocity = Vector3.zero;
        MoveToSafeRandomPosition();
    }
    
    private void MoveToSafeRandomPosition()
    {
        bool safePositionFound = false;
        int attemptsRemaining = 100;
        Vector3 potentialPosition = Vector3.zero;
        Quaternion potentialRotation = new Quaternion();

        // loop until safe position
        while (!safePositionFound && attemptsRemaining > 0)
        {
            float height = 4f; // UnityEngine.Random.Range(1f, 8f);
            float radius = UnityEngine.Random.Range(2f, 7f);
            Quaternion direction = Quaternion.Euler(
                0, UnityEngine.Random.Range(-180f, 180f), 0f);
            potentialPosition = flowerArea.transform.localPosition
                + Vector3.up * height + direction * Vector3.forward * radius;
            // float pitch = UnityEngine.Random.Range(-60f, 60f);
            float pitch = 0;
            float yaw = UnityEngine.Random.Range(-180f, 180f);
            potentialRotation = Quaternion.Euler(pitch, yaw, 0f);

            // get a list of all colliders colliding with agent in potentialPosition
            Collider[] colliders = Physics.OverlapSphere(potentialPosition, 0.05f);
            // safe position if no colliders found
            safePositionFound = colliders.Length == 0;
        }

        Debug.Assert(safePositionFound, "Could not found a safe position");

        // set position, rotation
        transform.position = potentialPosition;
        transform.rotation = potentialRotation;
    }
    
    public override void OnActionReceived(ActionBuffers actions) {
        float moveX = actions.ContinuousActions[0];
        float moveY = 0;
        float moveZ = actions.ContinuousActions[1];
        Vector3 moveVector = new Vector3(moveX, moveY, moveZ);
        rigidbody.AddForce(moveVector * moveForce);
        Vector3 rotationVector = transform.rotation.eulerAngles;
        float yawchange   = actions.ContinuousActions[2];
        smoothYawChange = Mathf.MoveTowards(smoothYawChange, yawchange, 2f * Time.fixedDeltaTime);
        float yaw = rotationVector.y + smoothYawChange * Time.fixedDeltaTime * yawSpeed;
        
        transform.rotation = Quaternion.Euler(0, yaw, 0f);
    }

    public override void Heuristic(in ActionBuffers actionsOut)
    {
        ActionSegment<float> continuousActions = actionsOut.ContinuousActions;
     
        Vector3 moveX = Vector3.zero;
        Vector3 moveY = Vector3.zero;
        Vector3 moveZ = Vector3.zero;
        
        if (Input.GetKey(KeyCode.S)) moveZ = -transform.forward;
        else if (Input.GetKey(KeyCode.W)) moveZ = transform.forward;
        if (Input.GetKey(KeyCode.A)) moveX = -transform.right;
        else if (Input.GetKey(KeyCode.D)) moveX = transform.right;
        Vector3 combined = (moveX + moveY + moveZ).normalized;

        continuousActions[0] = combined.x;
        continuousActions[1] = combined.z;

        float yaw = 0f;
        if (Input.GetKey(KeyCode.LeftArrow)) yaw = -0.25f;
        else if (Input.GetKey(KeyCode.RightArrow)) yaw = 0.25f;
        continuousActions[2] = yaw;
    }

    private void OnTriggerEnter(Collider other)
    {
        if (other.TryGetComponent<Goal>(out Goal goal))
        {
            SetReward(+1f);
            floorMeshRenderer.material = winMaterial;
            EndEpisode();
        }
    }

    private void OnCollisionEnter(Collision collision)
    {
        // if (trainingMode && collision.collider.CompareTag("boundary"))
        if (collision.collider.CompareTag("platform"))
        {
            // boundary negative reward
            AddReward(-1f); // discourage getting outside
            floorMeshRenderer.material = loseMaterial;
            // EndEpisode();
        }
    }
    /// <summary>
    /// called every 0.02 seconds
    /// </summary>
    void FixedUpdate()
    {
        AddReward(-0.001f);
    }
    private void Update()
    {
        // Beektip to flower-line debug
        if (nearestFlower != null)
        {
            Debug.DrawLine(beakTip.position, nearestFlower.FlowerCenterVector, Color.green);
        }
    }
}
