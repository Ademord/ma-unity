using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Unity.MLAgents;
using Unity.MLAgents.Extensions;
using Unity.MLAgents.Actuators;
using Unity.MLAgents.Sensors;

public class MyAgent : Agent
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
            inFrontOfFlower = UnityEngine.Random.value > 0.5f;
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
        Vector3 moveVector = new Vector3(actions.ContinuousActions[0], 0, actions.ContinuousActions[1]);
        transform.position += Time.deltaTime * moveSpeed * moveVector;
        // rigidbody.AddForce(move * moveForce);

        // rotation
        float yawchange   = actions.ContinuousActions[2];
        Vector3 rotationVector = transform.rotation.eulerAngles;
        smoothYawChange = Mathf.MoveTowards(smoothYawChange, yawchange, 2f * Time.fixedDeltaTime);
        float yaw = rotationVector.y + smoothYawChange * Time.fixedDeltaTime * yawSpeed;
        transform.rotation = Quaternion.Euler(0, yaw, 0f);
    }

    public override void CollectObservations(VectorSensor sensor)
    {
        // sensor.AddObservation(transform.localPosition);
        // sensor.AddObservation(targetTransform.localPosition);
        // sensor.AddObservation(targetTransform.localPosition - transform.localPosition);
        
        if (nearestFlower is null)
        {
            sensor.AddObservation(new float[10]);
            return;
        }

        // [Quaternion:4] Observe the local rotation
        sensor.AddObservation(transform.localRotation.normalized);

        // [Vector:3] pointing to nearest flower
        Vector3 toFlower = nearestFlower.FlowerCenterVector - beakTip.localPosition;
        sensor.AddObservation(toFlower.normalized);
        
        // dot product observation - beak tip in front of flower?
        // +1 -> infront, -1 -> behind
        sensor.AddObservation(Vector3.Dot(toFlower.normalized, -nearestFlower.FlowerUpVector.normalized));
        // beak tip point to flower
        sensor.AddObservation(Vector3.Dot(beakTip.forward.normalized, -nearestFlower.FlowerUpVector.normalized));
        // relative distance from beak tip to flower
        sensor.AddObservation(toFlower.magnitude / TrainingArea.AreaDiameter);
        // 10 total observations
        
    }

    public override void Heuristic(in ActionBuffers actionsOut)
    {
        ActionSegment<float> continuousActions = actionsOut.ContinuousActions;
        continuousActions[0] = Input.GetAxisRaw("Horizontal");
        continuousActions[1] = Input.GetAxisRaw("Vertical");
        
        float yaw = 0f;
        if (Input.GetKey(KeyCode.LeftArrow)) yaw = -1f;
        else if (Input.GetKey(KeyCode.RightArrow)) yaw = 1f;
        continuousActions[2] = yaw;
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
            AddReward(-1f); // discourage getting outside
            floorMeshRenderer.material = loseMaterial;
            EndEpisode();
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
