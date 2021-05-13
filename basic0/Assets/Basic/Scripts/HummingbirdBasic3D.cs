using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Unity.MLAgents;
using Unity.MLAgents.Extensions;
using Unity.MLAgents.Actuators;
using Unity.MLAgents.Sensors;

public class HummingbirdBasic3D : Agent
{

    [Tooltip("Force to apply when moving")]
    public float moveForce = 2f;

    [Tooltip("Speed to pitch up or down")]
    public float pitchSpeed = 100f;

    [Tooltip("Spped to rotate around the up axis")]
    public float yawSpeed = 100f;

    [Tooltip("Tip of the beek")]
    public Transform beakTip;

    [Tooltip("Agent's Camera")]
    public Camera agentCamera;

    [Tooltip("Train or gameplay mode")]
    public bool trainingMode;
    
    new private Rigidbody rigidbody;
    private TrainingArea flowerArea;
    [SerializeField] private Flower nearestFlower;
    private float smoothPitchChange = 0f;
    private float smoothYawChange = 0f;
    private const float MaxPitchAngle = 80f;
    private const float BeakTipRadius = 0.008f;
    private bool isFrozen = false;
    public float NectarObtained { get; private set; }

    
    [SerializeField] private Transform targetTransform;
    [SerializeField] private Material winMaterial;
    [SerializeField] private Material loseMaterial;
    [SerializeField] private Material floorMaterial;
    [SerializeField] private MeshRenderer floorMeshRenderer;
    public override void Initialize()
    {
        rigidbody = GetComponent<Rigidbody>();
        flowerArea = GetComponentInParent<TrainingArea>();

        // if not training mode, no max steps, play forever
        if (!trainingMode)
        {
            MaxStep = 0;
        }
    }
    
    public override void OnEpisodeBegin()
    {
        floorMeshRenderer.material = floorMaterial;
        // transform.localPosition = Vector3.zero;
        // transform.localPosition = new Vector3(Random.Range(-7f, 8f), Random.Range(1f, 8f) , Random.Range(-7f, 8f));
        targetTransform.transform.position = new Vector3(Random.Range(-7f, 8f), 0 , Random.Range(7f, -8f));
        
        flowerArea.ResetFlowers();

        NectarObtained = 0f;
        
        rigidbody.velocity = Vector3.zero;
        rigidbody.angularVelocity = Vector3.zero;
        
        bool inFrontOfFlower = false;

        if (trainingMode)
        {
            inFrontOfFlower = UnityEngine.Random.value > 0.4f;
        }
        
        MoveToSafeRandomPosition(inFrontOfFlower);

        // UpdateNearestFlower();

    }

    // public void UpdateNearestFlower()
    // {
    //     // nearestFlower = targetTransform;
    // }
    
    private void MoveToSafeRandomPosition(bool inFrontOfFlower)
    {
        bool safePositionFound = false;
        int attemptsRemaining = 100;
        Vector3 potentialPosition = Vector3.zero;
        Quaternion potentialRotation = new Quaternion();

        // loop until safe position
        while (!safePositionFound && attemptsRemaining > 0)
        {
            attemptsRemaining -= 1;
            if (inFrontOfFlower)
            {
                Flower randomFlower = flowerArea.flowers[
                    UnityEngine.Random.Range(0, flowerArea.flowers.Count)];
                // position in front of flower
                float distanceFromFlower = UnityEngine.Random.Range(0.1f, 0.2f);
                potentialPosition = randomFlower.transform.position
                    + randomFlower.FlowerUpVector * distanceFromFlower;

                // Point beek at flower
                Vector3 toFlower = randomFlower.FlowerCenterVector - potentialPosition;
                potentialRotation = Quaternion.LookRotation(toFlower, Vector3.up);

            }
            else
            {
                // transform.localPosition = new Vector3(Random.Range(-7f, 8f), Random.Range(1f, 8f) , Random.Range(-7f, 8f));

                // float height = UnityEngine.Random.Range(1.2f, 2.5f);
                float height = 2.9f; // UnityEngine.Random.Range(1f, 8f);
                float radius = UnityEngine.Random.Range(2f, 7f);
                Quaternion direction = Quaternion.Euler(
                    0, UnityEngine.Random.Range(-180f, 180f), 0f);
                potentialPosition = flowerArea.transform.position
                    + Vector3.up * height + direction * Vector3.forward * radius;
                // float pitch = UnityEngine.Random.Range(-60f, 60f);
                float pitch = 0;
                float yaw = UnityEngine.Random.Range(-180f, 180f);
                // float yaw = 0;
                potentialRotation = Quaternion.Euler(pitch, yaw, 0f);
            }

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
        if (isFrozen) return;
        
        // transform.position += Time.deltaTime * moveSpeed * new Vector3(moveX, 0, moveZ);
        float moveSpeed = 3f;
        Vector3 moveVector = new Vector3(actions.ContinuousActions[0], actions.ContinuousActions[1], actions.ContinuousActions[2]);
        // transform.position += Time.deltaTime * moveSpeed * moveVector;
        rigidbody.AddForce(moveVector * moveForce);

        Vector3 rotationVector = transform.rotation.eulerAngles;

        float pitchChange = actions.ContinuousActions[3];
        smoothPitchChange = Mathf.MoveTowards(smoothPitchChange, pitchChange, 2f*Time.fixedDeltaTime);
        float pitch = rotationVector.x + smoothPitchChange * Time.fixedDeltaTime * pitchSpeed;
        if (pitch > 180f) pitch -= 360f;
        pitch = Mathf.Clamp(pitch, - MaxPitchAngle, +MaxPitchAngle);

        float yawchange   = actions.ContinuousActions[4];
        smoothYawChange = Mathf.MoveTowards(smoothYawChange, yawchange, 2f * Time.fixedDeltaTime);
        float yaw = rotationVector.y + smoothYawChange * Time.fixedDeltaTime * yawSpeed;

        transform.rotation = Quaternion.Euler(pitch, yaw, 0f);
    }

    public override void CollectObservations(VectorSensor sensor)
    {
        // sensor.AddObservation(transform.localPosition);
        // sensor.AddObservation(targetTransform.localPosition);
        // sensor.AddObservation(targetTransform.localPosition - transform.localPosition);

        if (nearestFlower is null)
        {
            Debug.Log("nearest flower is null");
            sensor.AddObservation(new float[10]);
            return;
        }
        else
        {
            Debug.Log("nearest flower is not null");
        }

        // [Quaternion:4] Observe the local rotation
        // sensor.AddObservation(transform.localRotation.normalized);

        // [Vector:3] pointing to nearest flower
        Vector3 toFlower = nearestFlower.FlowerCenterVector - beakTip.localPosition;
        sensor.AddObservation(toFlower);
        // sensor.AddObservation(toFlower.normalized);
        
        // // dot product observation - beak tip in front of flower?
        // // +1 -> infront, -1 -> behind
        // sensor.AddObservation(Vector3.Dot(toFlower.normalized, -nearestFlower.FlowerUpVector.normalized));
        // // beak tip point to flower
        // sensor.AddObservation(Vector3.Dot(beakTip.forward.normalized, -nearestFlower.FlowerUpVector.normalized));
        // // relative distance from beak tip to flower
        sensor.AddObservation(toFlower.magnitude / TrainingArea.AreaDiameter);
        // // 10 total observations
        // 4 observations
    }

    public override void Heuristic(in ActionBuffers actionsOut)
    {
        ActionSegment<float> continuousActions = actionsOut.ContinuousActions;
        // continuousActions[0] = Input.GetAxisRaw("Horizontal");
        // // continuousActions[1] = Input.GetAxisRaw("Vertical");
        // continuousActions[2] = Input.GetAxisRaw("Vertical");


        Vector3 moveX = Vector3.zero;
        Vector3 moveY = Vector3.zero;
        Vector3 moveZ = Vector3.zero;

        if (Input.GetKey(KeyCode.S)) moveZ = -transform.forward;
        else if (Input.GetKey(KeyCode.W)) moveZ = transform.forward;

        if (Input.GetKey(KeyCode.A)) moveX = -transform.right;
        else if (Input.GetKey(KeyCode.D)) moveX = transform.right;

        if (Input.GetKey(KeyCode.E)) moveY = transform.up;
        else if (Input.GetKey(KeyCode.C)) moveY = -transform.up;

        Vector3 combined = (moveX + moveY + moveZ).normalized;

        continuousActions[0] = combined.x;
        continuousActions[1] = combined.y;
        continuousActions[2] = combined.z;


        float pitch = 0f;
        float yaw = 0f;

        if (Input.GetKey(KeyCode.DownArrow)) pitch = 0.25f;
        else if (Input.GetKey(KeyCode.UpArrow)) pitch = -0.25f;
        // yaw left / down
        if (Input.GetKey(KeyCode.LeftArrow)) yaw = -0.25f;
        else if (Input.GetKey(KeyCode.RightArrow)) yaw = 0.25f;
        continuousActions[3] = pitch;
        continuousActions[4] = yaw;

    }

    public void FreezeAgent()
    {
        Debug.Assert(trainingMode == false, "Freeze/unfreeze not supported in training");
        isFrozen = true;
        rigidbody.Sleep();
    }
    public void UnfreezeAgent()
    {
        Debug.Assert(trainingMode == false, "Freeze/unfreeze not supported in training");
        isFrozen = false;
        rigidbody.WakeUp();
    }

    private void OnTriggerEnter(Collider other)
    {
        if (other.TryGetComponent<Goal>(out Goal goal))
        {
            AddReward(+1f);
            floorMeshRenderer.material = winMaterial;
            EndEpisode();
        }
    }

    private void OnCollisionEnter(Collision collision)
    {
        // if (trainingMode && collision.collider.CompareTag("boundary"))
        if (collision.collider.CompareTag("boundary"))
        {
            // boundary negative reward
            AddReward(-0.5f); // discourage getting outside
            floorMeshRenderer.material = loseMaterial;
            // EndEpisode();
        }
    }
    /// <summary>
    /// called every 0.02 seconds
    /// </summary>
    void FixedUpdate()
    {
        AddReward(-0.1f);
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
