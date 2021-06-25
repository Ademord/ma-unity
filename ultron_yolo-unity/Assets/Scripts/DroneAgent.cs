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
    // agent variables
    private Vector3 startPosition;
    private CharacterController2D characterController;
    new private Rigidbody rigidbody;
    
    // observations
    private float distanceToTarget;
    private float dotProductToTarget;
 
    [Header("TrainingArea Parameters")]
    // public Transform TargetPrefab; //Target prefab to use in Dynamic envs
    // public Transform m_Target; //Target the agent will walk towards during training.
    public Transform trainingArea;
    private TrainingAreaController trainingAreaController;

    // [Tooltip("Move speed in meters/second")]
    // public float feedSpeed = 1f;
    // private float lastVerticalMove;
    // private float lastHorizontalMove;
    // private float lastRotation;
    
    // game rules
    [Header("Collectible Parameters")]
    private GameObject lastHit;
    public LayerMask collectibleLayerMask;
    private Vector3 collision = Vector3.zero;

    private int SCANNER_RAYCAST_DISTANCE = 6;
    public float REWARD_DOT_PRODUCT_TO_TARGET = -0.8f;
    public float REWARD_DISTANCE_TO_TARGET = 4f;

    private int countCollected = 0;
    /// Called once when the agent is first initialized
    public override void Initialize()
    {   
        // agent variables
        startPosition = new Vector3(0f, 0.5f, 0f);
        characterController = GetComponent<CharacterController2D>();
        rigidbody = GetComponent<Rigidbody>();
        // training area variables
        // trainingArea = transform.Find("TrainingArea");
        trainingAreaController = trainingArea.GetComponent<TrainingAreaController>();
    }
    
    /// Called every time an episode begins. This is where we reset the challenge.
    public override void OnEpisodeBegin()
    {
        transform.position = startPosition;
        transform.rotation = Quaternion.Euler(Vector3.up * Random.Range(0f, 360f));
        rigidbody.velocity = Vector3.zero;
        lastHit = null;
        dotProductToTarget = -1f;
        distanceToTarget = -1f;
        countCollected = 0;
        trainingAreaController.Reset();
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
        // if (horizontal != 0)
        // {
        //     AddReward(0.01f);
        // }

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
        if (Vector3.Distance(transform.position, Vector3.zero) > 15f)
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
        // print("observed a distanceToTarget: " + distanceToTarget);
        // print("observed a dotProductToTarget: " + dotProductToTarget);

        sensor.AddObservation(distanceToTarget);
        sensor.AddObservation(dotProductToTarget);
    }
   
    // Update is called once per frame
    void Update()
    {
        var ray = new Ray(transform.position, transform.forward);
        RaycastHit hit;
        // check if raycast hits something in COLLECTIBLE layerMask
        if (Physics.Raycast(ray, out hit, SCANNER_RAYCAST_DISTANCE, collectibleLayerMask))
        {
            // found a target, record variables
            lastHit = hit.transform.gameObject;

            // draw collision
            collision = hit.point;
            // give reward if not given before AND dot product < .6
            
            VoxelController myVoxel = lastHit.GetComponent<VoxelController>();

            if (myVoxel != null && myVoxel.CanBeCollected && dotProductToTarget < 0)
            {
                // if there is something to be collected, give infos
                dotProductToTarget = Vector3.Dot(lastHit.transform.forward, transform.forward);
                distanceToTarget = Vector3.Distance(lastHit.transform.position, transform.position);
                // add reward to motivate to go for the scan
                // print("adding reward:" + dotProductToTarget);
                AddReward(Math.Abs(dotProductToTarget));

                // try to collect
                if (dotProductToTarget < REWARD_DOT_PRODUCT_TO_TARGET && distanceToTarget < REWARD_DISTANCE_TO_TARGET)
                {
                    print("Trying to collect..");
                    bool collected = myVoxel.Collect();
                    if (collected)
                    {
                        print("collected !");
                        countCollected++;
                        AddReward(0.1f);
                    }
                }

            }
            else
            {
                lastHit = null;
                dotProductToTarget = -1f;
                distanceToTarget = -1f;
            }
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