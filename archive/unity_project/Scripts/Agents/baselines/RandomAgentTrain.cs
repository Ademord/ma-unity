using System.Collections;
using System.Collections.Generic;
using Unity.MLAgents.Actuators;
using UnityEngine;

namespace Ademord
{
    public class RandomAgentTrain : VoxelSpeedPigeonAgentTrain
    {
        public override void ManagedUpdate(ActionBuffers actions)
        {
            switch (steuernModus)
            {
                case SteuernModus.Manual:
                    characterController.ForwardInput = Random.Range(-1f, 1f);
                    characterController.SidesInput = Random.Range(-1f, 1f);
                    characterController.TurnInput = Random.Range(-1f, 1f);
                    characterController.VerticalInput = Random.Range(-1f, 1f);
                    break;
                
                case SteuernModus.PhysicsVelocity:
                    characterController.ForwardInput = Random.Range(-1f, 1f);;
                    characterController.SidesInput = Random.Range(-1f, 1f);;
                    characterController.TurnInput = Random.Range(-1f, 1f);;
                    characterController.VerticalInput = Random.Range(-1f, 1f);;
                    break;
                
                default:
                    Debug.LogError("No valid SteuernModus selected");
                    break;
            }
            
            m_Body.ManagedUpdate();
        }
    }

}