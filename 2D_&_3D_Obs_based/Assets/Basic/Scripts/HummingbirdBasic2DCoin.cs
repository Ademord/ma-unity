using Unity.MLAgents;
using Unity.MLAgents.Actuators;
using UnityEngine;

public class HummingbirdBasic2DCoin : Agent
{
    [Tooltip("The platform to be moved around")]
    public GameObject platform;

    private Vector3 startPosition;
    private SimpleCharacterController characterController;
    new private Rigidbody rigidbody;
    private TrainingArea flowerArea;
    //The direction an agent will walk during training.
    [Header("Target To Walk Towards")]
    public Transform TargetPrefab; //Target prefab to use in Dynamic envs
    private Transform m_Target; //Target the agent will walk towards during training.

    /// <summary>
    /// Called once when the agent is first initialized
    /// </summary>
    public override void Initialize()
    {
        startPosition = transform.position;
        characterController = GetComponent<SimpleCharacterController>();
        rigidbody = GetComponent<Rigidbody>();
        flowerArea = GetComponentInParent<TrainingArea>();
        SpawnTarget(TargetPrefab, Vector3.zero); //spawn target
    }
    // <summary>
    /// Called every time an episode begins. This is where we reset the challenge.
    /// </summary>
    public override void OnEpisodeBegin()
    {
        // flowerArea.ResetFlowers();
        // Reset agent position, rotation
        transform.position = startPosition;
        transform.rotation = Quaternion.Euler(Vector3.up * Random.Range(0f, 360f));
        rigidbody.velocity = Vector3.zero;
        // MoveToSafeRandomPosition();

        // Reset platform position (5 meters away from the agent in a random direction)
        Vector3 targetPosition = Vector3.zero + Quaternion.Euler(Vector3.up * Random.Range(0f, 360f)) * Vector3.forward * 5f;
        m_Target.transform.localPosition = targetPosition;
        // SpawnTarget(TargetPrefab, transform.position); //spawn target
    }
    /// <summary>
    /// Spawns a target prefab at pos
    /// </summary>
    /// <param name="prefab"></param>
    /// <param name="pos"></param>
    void SpawnTarget(Transform prefab, Vector3 pos)
    {
        m_Target = Instantiate(prefab, pos, Quaternion.identity, transform.parent);
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
    }
    /// <summary>
    /// Respond to entering a trigger collider
    /// </summary>
    /// <param name="other">The object (with trigger collider) that was touched</param>
    private void OnTriggerEnter(Collider other)
    {
        // If the other object is a collectible, reward and end episode
        if (other.CompareTag("collectible"))
        {
            AddReward(1f);
            EndEpisode();
            Debug.Log("entered flower!");
        }
    }
    private void OnCollisionEnter(Collision collision)
    {
        // if (trainingMode && collision.collider.CompareTag("boundary"))
        if (collision.collider.CompareTag("platform"))
        {
            // boundary negative reward
            AddReward(-1f); // discourage getting outside
            // EndEpisode();
            Debug.Log("hit the wall!");

        }
    }
    private void Update()
    {
        Debug.DrawLine(transform.position, m_Target.position, Color.green);
    }
    
}