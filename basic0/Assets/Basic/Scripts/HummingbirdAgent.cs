using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Unity.MLAgents;
using Unity.MLAgents.Extensions;
using Unity.MLAgents.Actuators;
using Unity.MLAgents.Sensors;

public class HummingbirdAgent : Agent
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

    [SerializeField] private Transform targetTransform;
    [SerializeField] private Material winMaterial;
    [SerializeField] private Material loseMaterial;
    [SerializeField] private MeshRenderer floorMeshRenderer;
    public override void OnEpisodeBegin()
    {
        // transform.localPosition = Vector3.zero;
        transform.localPosition = new Vector3(Random.Range(-6f, 6f), 0 , Random.Range(-1f, 6f));
        targetTransform.localPosition = new Vector3(Random.Range(-6f, 6f), 0 , Random.Range(-3f, -6f));
    }

    public override void OnActionReceived(ActionBuffers actions)
    {
        // Debug.Log(actions.DiscreteActions[0]);
        // Debug.Log(actions.ContinuousActions[0]);
        float moveX = actions.ContinuousActions[0];
        float moveZ = actions.ContinuousActions[1];

        float moveSpeed = 3f;
        transform.position += Time.deltaTime * moveSpeed * new Vector3(moveX, 0, moveZ);
    }

    public override void CollectObservations(VectorSensor sensor)
    {
        // sensor.AddObservation(transform.localPosition);
        // sensor.AddObservation(targetTransform.localPosition);
        sensor.AddObservation(targetTransform.localPosition - transform.localPosition);
    }

    public override void Heuristic(in ActionBuffers actionsOut)
    {
        ActionSegment<float> continuousActions = actionsOut.ContinuousActions;
        continuousActions[0] = Input.GetAxisRaw("Horizontal");
        continuousActions[1] = Input.GetAxisRaw("Vertical");
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
        if (collision.collider.CompareTag("boundary"))
        {
            // boundary negative reward
            AddReward(-1f); // discourage getting outside
            floorMeshRenderer.material = loseMaterial;
            EndEpisode();
        }
    }

    void FixedUpdate()
    {
        AddReward(-0.1f);
    }
}
