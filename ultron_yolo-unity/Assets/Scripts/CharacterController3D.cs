using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CharacterController3D : MonoBehaviour
{
    [Tooltip("Move speed in meters/second")]
    public float moveSpeed = 2f;
    [Tooltip("Turn speed in degrees/second, left (+) or right (-)")]
    public float turnSpeed = 50f;
  
    // public bool IsGrounded { get; private set; }
    public float ForwardInput { get; set; }
    public float TurnInput { get; set; }
    public float SidesInput { get; set; }
    public float VerticalInput { get; set; }
    // public float PitchInput { get; set; }
    // float smoothYawInput = 0f;

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
        // if (PitchInput != 0f)
        // {
        //     float angle = Mathf.Clamp(PitchInput, -1f, 1f) * turnSpeed;
        //     transform.Rotate(Vector3.left, Time.fixedDeltaTime * angle);
        // }
        
        // Movement
        // Vector3 move = Mathf.Clamp(ForwardInput, -1f, 1f) *
        //                moveSpeed * Time.fixedDeltaTime * transform.forward;
        // var diagonal_move = new Vector3(SidesInput, 0.0f, ForwardInput);
        // var move = moveSpeed * diagonal_move; // * Time.deltaTime
        // rigidbody.AddForce(move, ForceMode.VelocityChange); //ForceMode.VelocityChange
        // rigidbody.MovePosition(transform.position + move);
        // transform.Translate(move);   
        
        // NEW METHOD .18
        // float strafe = Input.GetAxis("Strafe") * speed;
        // float translation = Input.GetAxis("Vertical") * speed;
        // float rotation = Input.GetAxis("Horizontal") * rotationSpeed;      

        float strafe = SidesInput * moveSpeed;
        float translation = ForwardInput * moveSpeed;
        float verticalTranslation = VerticalInput * moveSpeed / 4f;
            
        strafe *= Time.deltaTime;
        translation *= Time.deltaTime;
        verticalTranslation *= Time.deltaTime;
        // rotation *= Time.deltaTime;

        transform.Translate(strafe, verticalTranslation, translation);
        // transform.Rotate(0, rotation, 0);
        
        // // Yaw Prerrequisites (cast YawInput to SmoothYawInput
        // Vector3 rotationVector = transform.rotation.eulerAngles;
        // Debug.Log("yaw Input before clamp: " + YawInput);
        // YawInput = Mathf.Clamp(YawInput, -1f, 1f);
        // Debug.Log("yaw Input after clamp: " + YawInput);
        // smoothYawInput = Mathf.MoveTowards(smoothYawInput, YawInput, 2f * Time.fixedDeltaTime);
        // // Yaw
        // float yaw = yawSpeed * Time.fixedDeltaTime * smoothYawInput + rotationVector.y;
        // // Yaw : apply rotation
        // transform.rotation = Quaternion.Euler(0f, yaw, 0f);
    }
}