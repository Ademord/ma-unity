using System;
using UnityEngine;
using Unity.MLAgents;
using Unity.MLAgents.Actuators;
using Unity.MLAgentsExamples;
using Unity.MLAgents.Sensors;
using Random = UnityEngine.Random;

public class TorusRaycastWithYawAgent : Agent
{
    // This agent improves upong the 2D coin example
    // by adding the OrientationCube and the Direction Indicator
    // it also adds the target walking speed to add a reward for the target moving
    
    // observations: 
    
    // actions <SimpleAgentController>:
        // vertical (3)
        // horizontal as rotation (3)
    [Tooltip("The platform to be moved around")]
    public GameObject platform;

    private Vector3 startPosition;
    private SimpleCharacterControllerWithYaw characterController;
    new private Rigidbody rigidbody;
    private TrainingArea flowerArea;
    public float NectarObtained { get; private set; }
    private bool insideTorus;
    private Collider currentTorusSegment;
    [Header("Walk Speed")]
    [Range(0.1f, m_maxWalkingSpeed)]
    [SerializeField]
    [Tooltip(
        "The speed the agent will try to match.\n\n" +
        "TRAINING:\n" +
        "For VariableSpeed envs, this value will randomize at the start of each training episode.\n" +
        "Otherwise the agent will try to match the speed set here.\n\n" +
        "INFERENCE:\n" +
        "During inference, VariableSpeed agents will modify their behavior based on this value " +
        "whereas the CrawlerDynamic & CrawlerStatic agents will run at the speed specified during training "
    )]
    //The walking speed to try and achieve
    private float m_TargetWalkingSpeed = m_maxWalkingSpeed;

    const float m_maxWalkingSpeed = 15; //The max walking speed

    //The current target walking speed. Clamped because a value of zero will cause NaNs
    public float TargetWalkingSpeed
    {
        get { return m_TargetWalkingSpeed; }
        set { m_TargetWalkingSpeed = Mathf.Clamp(value, .1f, m_maxWalkingSpeed); }
    }
    //The direction an agent will walk during training.
    [Header("Target To Walk Towards")]
    public Transform TargetPrefab; //Target prefab to use in Dynamic envs
    private Transform m_Target; //Target the agent will walk towards during training.
    private PlantController m_TargetController;
  
    //This will be used as a stabilized model space reference point for observations
    //Because ragdolls can move erratically during training, using a stabilized reference transform improves learning
    OrientationCubeController m_OrientationCube;

    //The indicator graphic gameobject that points towards the target
    DirectionIndicator m_DirectionIndicator;

    /// <summary>
    /// Called once when the agent is first initialized
    /// </summary>
    public override void Initialize()
    {
        SpawnTarget(TargetPrefab, Vector3.zero); //spawn target
    
        m_OrientationCube = GetComponentInChildren<OrientationCubeController>();
        m_DirectionIndicator = GetComponentInChildren<DirectionIndicator>();

        startPosition = transform.position;
        characterController = GetComponent<SimpleCharacterControllerWithYaw>();
        rigidbody = GetComponent<Rigidbody>();
        flowerArea = GetComponentInParent<TrainingArea>();
        
    }
    // <summary>
    /// Called every time an episode begins. This is where we reset the challenge.
    /// </summary>
    public override void OnEpisodeBegin()
    {
        transform.position = startPosition;
        transform.rotation = Quaternion.Euler(Vector3.up * Random.Range(0f, 360f));
        rigidbody.velocity = Vector3.zero;

        // Reset platform position (5 meters away from the agent in a random direction)
        Vector3 targetPosition = Vector3.zero + Quaternion.Euler(Vector3.up * Random.Range(0f, 360f)) * Vector3.forward * 5f;
        m_Target.transform.localPosition = targetPosition;
        m_TargetController.ResetCollectibles();
        
        // UpdateOrientationObjects();
        NectarObtained = 0f;

        //Set our goal walking speed
        TargetWalkingSpeed = Random.Range(0.1f, m_maxWalkingSpeed);

        insideTorus = false;
        currentTorusSegment = null;
    }
    /// <summary>
    /// Spawns a target prefab at pos
    /// </summary>
    /// <param name="prefab"></param>
    /// <param name="pos"></param>
    void SpawnTarget(Transform prefab, Vector3 pos)
    {
        m_Target = Instantiate(prefab, pos, Quaternion.identity, transform.parent);
        m_TargetController = new PlantController(m_Target);

    }
    
    /// <summary>
    /// Update OrientationCube and DirectionIndicator
    /// </summary>
    void UpdateOrientationObjects()
    {
        m_OrientationCube.UpdateOrientation(transform, m_Target);
        if (m_DirectionIndicator)
        {
            m_DirectionIndicator.MatchOrientation(m_OrientationCube.transform);
        }
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
    
    // <summary>
    /// Controls the agent with human input
    /// </summary>
    /// <param name="actionsOut">The actions parsed from keyboard input</param>
    public override void Heuristic(in ActionBuffers actionsOut)
    {
        // Read input values and round them. GetAxisRaw works better in this case
        // because of the DecisionRequester, which only gets new decisions periodically.
        int vertical = Mathf.RoundToInt(Input.GetAxisRaw("Vertical"));
        int horizontal = Mathf.RoundToInt(Input.GetAxisRaw("Horizontal"));

        // Convert the actions to Discrete choices (0, 1, 2)
        ActionSegment<int> actions = actionsOut.DiscreteActions;
        actions[0] = vertical >= 0 ? vertical : 2;
        actions[1] = horizontal >= 0 ? horizontal : 2;
    }
    /// <summary>
    /// React to actions coming from either the neural net or human input
    /// </summary>
    /// <param name="actions">The actions received</param>
    public override void OnActionReceived(ActionBuffers actions)
    {
        // Convert actions from Discrete (0, 1, 2) to expected input values (-1, 0, +1)
        // of the character controller
        float vertical = actions.DiscreteActions[0] <= 1 ? actions.DiscreteActions[0] : -1;
        float horizontal = actions.DiscreteActions[1] <= 1 ? actions.DiscreteActions[1] : -1;

        characterController.ForwardInput = vertical;
        characterController.TurnInput = horizontal;
        characterController.YawInput = horizontal;
        
        Collider[] colliders = Physics.OverlapSphere(transform.position, 0.01f);
        foreach (Collider collider in colliders)
        {
            insideTorus = collider.CompareTag("collectible");
            Debug.Log("inside torus: " + insideTorus);
            GiveReward(collider);
        }
    }
    /// <summary>
    /// Called when the agent's collider enters a trigger collider
    /// </summary>
    /// <param name="other">The trigger collider</param>
    // private void OnTriggerEnter(Collider other)
    // {
    //     TriggerEnterOrStay(other);
    // }
    // /// <summary>
    // /// Called when the agent's collider stays inside a trigger collider
    // /// </summary>
    // /// <param name="other">The trigger collider</param>
    // private void OnTriggerStay(Collider other)
    // {
    //     TriggerEnterOrStay(other);
    // }
    
    /// <summary>
    /// Enter or stay in a trigger collider
    /// </summary>
    /// <param name="collider"></param>
    // private void TriggerEnterOrStay(Collider collider)
    // {
    //     if (collider.CompareTag("collectible"))
    //     {
    //         insideTorus = true;
    //         currentTorusSegment = collider;
    //     }
    // }
    //
    // private void OnTriggerExit(Collider other)
    // {
    //        insideTorus = false;
    //        currentTorusSegment = null;
    // }
    //
    // private void OnCollisionExit(Collision other)
    // {
    //     insideTorus = false;
    //     currentTorusSegment = null;    
    // }

    private void OnCollisionEnter(Collision collision)
    {
        if (collision.collider.CompareTag("platform"))
        {
            // boundary negative reward
            AddReward(-10f); 
            // EndEpisode();
            Debug.Log("hit the wall!");

        }
    }
    private void GiveReward(Collider collider)
    {
        // Debug.DrawLine(transform.position, m_Target.position, Color.green);
        if (insideTorus)
        {
            float insideReward = 0;
            float movingReward = 0;
            float facingReward = 0;

            // Debug.Log("I am inside a TorusColliderSegment");
            
            TorusSegmentController torusSegment = collider.transform.parent.gameObject.GetComponent<TorusSegmentController>();
            float nectarReceived = torusSegment.Feed(1);
            NectarObtained += nectarReceived;
            // Debug.Log("Obtained nectar: " + NectarObtained);

            if (NectarObtained > 0)
            {
                insideReward = 0.1f;
            }
            
            if (NectarObtained == torusSegment.MAX_NECTAR_AMOUNT * 4)
            {
                EndEpisode();
            }
            
            // if moving
            // movingReward = 
            
            // if looking at flower
            facingReward = 0.2f * Mathf.Clamp01(Vector3.Dot(transform.forward.normalized,
                    -m_Target.transform.up.normalized));

            Debug.Log("Rewards obtained: " + insideReward + ", "+ facingReward);
            AddReward(insideReward + movingReward + facingReward);
        }
    }

    public override void CollectObservations(VectorSensor sensor)
    {
        sensor.AddObservation(insideTorus);
    }

    private void FixedUpdate()
    {     
       
    }
}