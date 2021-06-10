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

    const float m_maxWalkingSpeed = 2; //The max walking speed

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

    [Tooltip("Move speed in meters/second")]
    public float feedSpeed = 1f;
    private float lastVerticalMove;
    private float lastHorizontalMove;
    private float lastRotation;
    
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
        
        NectarObtained = 0f;
        lastVerticalMove = 0f;
        lastHorizontalMove = 0f;

        //Set our goal walking speed
        TargetWalkingSpeed = Random.Range(0.1f, m_maxWalkingSpeed);
        // Debug.Log("TargetWalkingSpeed: " + TargetWalkingSpeed);
        insideTorus = false;
        currentTorusSegment = null;
        
        UpdateOrientationObjects();
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
        // Debug.Log("m_OrientationCube is null" + m_OrientationCube is null);
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
        int yaw = 0;

        if (Input.GetKey(KeyCode.E)) yaw = -1;
        else if (Input.GetKey(KeyCode.C)) yaw = 1;
        // Convert the actions to Discrete choices (0, 1, 2)
        ActionSegment<int> actions = actionsOut.DiscreteActions;
        actions[0] = vertical >= 0 ? vertical : 2;
        actions[1] = horizontal >= 0 ? horizontal : 2;
        actions[2] = yaw >= 0 ? yaw : 2;
    }
    /// <summary>
    /// React to actions coming from either the neural net or human input
    /// </summary>
    /// <param name="actions">The actions received</param>
    public override void OnActionReceived(ActionBuffers actions)
    {
        // AddReward(-1f / MaxStep);
        MoveAgent(actions);
    }

    public void MoveAgent(ActionBuffers actions)
    {
        // Convert actions from Discrete (0, 1, 2) to expected input values (-1, 0, +1)
        // of the character controller
        float vertical = actions.DiscreteActions[0] <= 1 ? actions.DiscreteActions[0] : -1;
        float horizontal = actions.DiscreteActions[1] <= 1 ? actions.DiscreteActions[1] : -1;
        float yaw = actions.DiscreteActions[2] <= 1 ? actions.DiscreteActions[2] : -1;
        
        // motivate to move in a strafe
        if (horizontal != 0)
        {
            // run33
            // AddReward(0.01f);
            // run32 no stacked == reward only inside
            if (insideTorus)
            { 
                AddReward(0.01f);
            }
        }

        // // penalize if moving in opposite fashion (LEFT-RIGHT-LEFT-RIGHT)
        // if (lastHorizontalMove == -horizontal)
        // {
        //     print("Penalized: Last horizontal move was opposite");
        //     AddReward(-0.01f);
        // } 
        // if (lastVerticalMove == -vertical)
        // {
        //     print("Penalized: Last vertical move was opposite");
        //     AddReward(-0.01f);
        // }
        // if (lastRotation == -yaw)
        // {
        //     print("Penalized: Last rotation move was opposite");
        //     AddReward(-0.01f);
        // }

        lastHorizontalMove = horizontal;
        lastVerticalMove = vertical;
        lastRotation = yaw;
        
        characterController.ForwardInput = vertical;
        characterController.TurnInput = yaw;
        characterController.SidesInput = horizontal;
        
        Collider[] colliders = Physics.OverlapSphere(transform.position, 0.01f);
        foreach (Collider collider in colliders)
        {
            insideTorus = collider.CompareTag("collectible");
            // Debug.Log("inside torus: " + insideTorus);
            GiveReward(collider);
        }
    }
  
    private void OnCollisionEnter(Collision collision)
    {
        if (collision.collider.CompareTag("platform"))
        {
            // boundary negative reward
            AddReward(-1f); 
            EndEpisode();
            Debug.Log("hit the wall!");

        }
    }
    private void GiveReward(Collider collider)
    {
        if (insideTorus)
        {
            float insideReward = 0;
            float movingReward = 0;

            
            TorusSegmentController torusSegment = collider.transform.parent.gameObject.GetComponent<TorusSegmentController>();
            float nectarReceived = torusSegment.Feed(feedSpeed);
            NectarObtained += nectarReceived;
            if (NectarObtained > 0)
            {
                insideReward = 1f;
            }
            
            if (NectarObtained >= torusSegment.MAX_NECTAR_AMOUNT * 3.8f) //  * (4f/characterController.moveSpeed)
            {
                EndEpisode();
            }
            var cubeForward = m_OrientationCube.transform.forward;
            
            // Set reward for this step according to mixture of the following elements.
            // a. Match target speed
            //This reward will approach 1 if it matches perfectly and approach zero as it deviates
            var matchSpeedReward = GetMatchingVelocityReward(cubeForward * TargetWalkingSpeed, rigidbody.velocity);
            // b. Rotation alignment with target direction.
            //This reward will approach 1 if it faces the target direction perfectly and approach zero as it deviates
            var lookAtTargetReward = (Vector3.Dot(cubeForward, transform.forward) + 1) * .5F;

            // runs .18
            // var result_reward = insideReward; //  + 0.10f * insideReward * (lookAtTargetReward + matchSpeedReward);

            // runs 19.
            var result_reward = insideReward * lookAtTargetReward; //  + 0.10f * insideReward * (lookAtTargetReward + matchSpeedReward);
          
            // add reward
            AddReward(result_reward);
            // Debug.Log("Rewards obtained: " + result_reward);
        }
    }

    /// <summary>
    /// Normalized value of the difference in actual speed vs goal walking speed.
    /// </summary>
    public float GetMatchingVelocityReward(Vector3 velocityGoal, Vector3 actualVelocity)
    {
        //distance between our actual velocity and goal velocity
        var velDeltaMagnitude = Mathf.Clamp(Vector3.Distance(actualVelocity, velocityGoal), 0, TargetWalkingSpeed);

        //return the value on a declining sigmoid shaped curve that decays from 1 to 0
        //This reward will approach 1 if it matches perfectly and approach zero as it deviates
        return Mathf.Pow(1 - Mathf.Pow(velDeltaMagnitude / TargetWalkingSpeed, 2), 2);
    }

    public override void CollectObservations(VectorSensor sensor)
    {
        sensor.AddObservation(insideTorus);
    }

    private void FixedUpdate()
    {
        UpdateOrientationObjects();
    }
}