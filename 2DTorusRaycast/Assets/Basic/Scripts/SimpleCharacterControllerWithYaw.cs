using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SimpleCharacterControllerWithYaw : MonoBehaviour
{
    [Tooltip("Move speed in meters/second")]
    public float moveSpeed = 2f;
    [Tooltip("Turn speed in degrees/second, left (+) or right (-)")]
    public float turnSpeed = 50;
  
    public bool IsGrounded { get; private set; }
    public float ForwardInput { get; set; }
    public float TurnInput { get; set; }
    public float YawInput { get; set; }
    
    new private Rigidbody rigidbody;
    
    private void Awake()
    {
        rigidbody = GetComponent<Rigidbody>();
    }
    
    private void FixedUpdate()
    {
        ProcessActions();
    }
    
    /// <summary>
    /// Processes input actions and converts them into movement
    /// </summary>
    private void ProcessActions()
    {
        // Turning
        if (TurnInput != 0f)
        {
            float angle = Mathf.Clamp(TurnInput, -1f, 1f) * turnSpeed;
            transform.Rotate(Vector3.up, Time.fixedDeltaTime * angle);
        }

        // Movement
        Vector3 move = Mathf.Clamp(ForwardInput, -1f, 1f) *
                       moveSpeed * Time.fixedDeltaTime * transform.forward;
        rigidbody.MovePosition(transform.position + move);
    }
}