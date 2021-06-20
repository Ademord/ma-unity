using System;
using UnityEngine;
using Unity.MLAgents;
using Unity.MLAgents.Actuators;
using Unity.MLAgentsExamples;
using Unity.MLAgents.Sensors;
using Random = UnityEngine.Random;

public class DroneAgent : Agent
{
    // This agent improves upong the 2D coin example
    // by adding the OrientationCube and the Direction Indicator
    // it also adds the target walking speed to add a reward for the target moving
    
    // observations: 
    
    // actions <SimpleAgentController>:
        // vertical (3)
        // horizontal as rotation (3)
    private Vector3 startPosition;
    private SimpleCharacterControllerWithYaw characterController;
    new private Rigidbody rigidbody;
    private TrainingArea flowerArea;

   
    private int SCANNER_RAYCAST_DISTANCE = 5;
    private float distanceToTarget;

    private float dotProductToTarget;
    // public float NectarObtained { get; private set; }
    // private bool insideTorus;
    // private Collider currentTorusSegment;

    // [Header("Walk Speed")]
    // [Range(0.1f, m_maxWalkingSpeed)]
    // [SerializeField]
    //The walking speed to try and achieve
    // private float m_TargetWalkingSpeed = m_maxWalkingSpeed;

    // const float m_maxWalkingSpeed = 2; //The max walking speed

    //The current target walking speed. Clamped because a value of zero will cause NaNs
    // public float TargetWalkingSpeed
    // {
    //     get { return m_TargetWalkingSpeed; }
    //     set { m_TargetWalkingSpeed = Mathf.Clamp(value, .1f, m_maxWalkingSpeed); }
    // }
    //The direction an agent will walk during training.
    [Header("Target Parameters")]
    public Transform TargetPrefab; //Target prefab to use in Dynamic envs
    private Transform m_Target; //Target the agent will walk towards during training.
    private PlantController m_TargetController;
  
    // [Tooltip("Move speed in meters/second")]
    // public float feedSpeed = 1f;
    // private float lastVerticalMove;
    // private float lastHorizontalMove;
    // private float lastRotation;
    private Vector3 targetSpawnPosition = new Vector3(0f, 1.5f, 0f);
    
    // Start is called before the first frame update
    private GameObject lastHit;
    [Header("Collectible Parameters")]
    public LayerMask collectibleLayerMask;
    public Material disabledMaterial;
    public float REWARD_DOT_PRODUCT_TO_TARGET = -0.98f;
    public float REWARD_DISTANCE_TO_TARGET = 3f;
    
    private Vector3 collision = Vector3.zero;
    
    /// <summary>
    /// Called once when the agent is first initialized
    /// </summary>
    public override void Initialize()
    {   
        print("entered initialize " + DateTime.Now.ToString("HH:mm:ss tt"));
        SpawnTarget(TargetPrefab, targetSpawnPosition); //spawn target
    
     
        startPosition = transform.position;
        characterController = GetComponent<SimpleCharacterControllerWithYaw>();
        rigidbody = GetComponent<Rigidbody>();
        // flowerArea = GetComponentInParent<TrainingArea>();
        print("exited initialize " + DateTime.Now.ToString("HH:mm:ss tt"));

    }
    // <summary>
    /// Called every time an episode begins. This is where we reset the challenge.
    /// </summary>
    public override void OnEpisodeBegin()
    {
        print("entered onEpBegin " + DateTime.Now.ToString("HH:mm:ss tt"));

        transform.position = startPosition;
        transform.rotation = Quaternion.Euler(Vector3.up * Random.Range(0f, 360f));
        rigidbody.velocity = Vector3.zero;
        lastHit = null;
        dotProductToTarget = -1f;
        distanceToTarget = -1f;
        // Reset target position (5 meters away from the agent in a random direction)
        Vector3 targetPosition = targetSpawnPosition + Quaternion.Euler(Vector3.up * Random.Range(0f, 360f)) * Vector3.forward * 5f;
        m_Target.transform.localPosition = targetPosition;
        // TODO in line 124
        // m_TargetController.ResetCollectibles();
        
        // NectarObtained = 0f;
        // lastVerticalMove = 0f;
        // lastHorizontalMove = 0f;

        //Set our goal walking speed
        // TargetWalkingSpeed = Random.Range(0.1f, m_maxWalkingSpeed);
        // Debug.Log("TargetWalkingSpeed: " + TargetWalkingSpeed);
        // insideTorus = false;
        // currentTorusSegment = null;
        print("exited onEpBegin " + DateTime.Now.ToString("HH:mm:ss tt"));

    }
    /// <summary>
    /// Spawns a target prefab at pos
    /// </summary>
    /// <param name="prefab"></param>
    /// <param name="pos"></param>
    void SpawnTarget(Transform prefab, Vector3 pos)
    {
        m_Target = Instantiate(prefab, pos, Quaternion.identity, transform.parent);
        // TODO enable or refactor this later
        // m_TargetController = new PlantController(m_Target);

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
        // print("vertical: " + vertical);
        // print("horizontal: " + vertical);
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
            AddReward(0.01f);
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

        // lastHorizontalMove = horizontal;
        // lastVerticalMove = vertical;
        // lastRotation = yaw;
        
        characterController.ForwardInput = vertical;
        characterController.TurnInput = yaw;
        characterController.SidesInput = horizontal;
        // if agent strays too far away give a negative reward and end episode
        if (Vector3.Distance(transform.position, Vector3.zero) > 10f)
        {
            AddReward(-1);
            EndEpisode();
        }
    }
  
    private void OnCollisionEnter(Collision collision)
    {
        if (collision.collider.CompareTag("boundary"))
        {
            // boundary negative reward
            AddReward(-1f); 
            EndEpisode();
            Debug.Log("hit the wall!");

        }
    }

    public override void CollectObservations(VectorSensor sensor)
    {
        print("observed a distanceToTarget: " + distanceToTarget);
        print("observed a dotProductToTarget: " + dotProductToTarget);
        
        sensor.AddObservation(distanceToTarget);
        sensor.AddObservation(dotProductToTarget);
    }
   
    // Update is called once per frame
    void Update()
    {
        var ray = new Ray(transform.position, transform.forward);
        RaycastHit hit;
        if (Physics.Raycast(ray, out hit, SCANNER_RAYCAST_DISTANCE, collectibleLayerMask))
        {
            // found a target, record variables
            lastHit = hit.transform.gameObject;
            dotProductToTarget = Vector3.Dot(lastHit.transform.forward, transform.forward);
            distanceToTarget = Vector3.Distance(lastHit.transform.position, transform.position);
            
            // if (lastHit.CompareTag("collectible"))
            // {
                // draw collision
            collision = hit.point;
            
            // give reward if not given before AND dot product < .6
            MeshRenderer meshRenderer = lastHit.GetComponent<MeshRenderer>();
            if (meshRenderer.material != disabledMaterial && 
                dotProductToTarget < REWARD_DOT_PRODUCT_TO_TARGET &&
                distanceToTarget < REWARD_DISTANCE_TO_TARGET)
            {
                print("giving reward here");
                meshRenderer.material = disabledMaterial;
            }
                // else
                // {
                //     print("NOT giving reward here");
                // }
            // }
        }
        else
        {
            lastHit = null;
            dotProductToTarget = -1f;
            distanceToTarget = -1f;
        }
    }
    private void OnDrawGizmos()
    {
        // Update();
        Gizmos.color = Color.red;
        Gizmos.DrawWireSphere(collision, 0.2f);
    }
}