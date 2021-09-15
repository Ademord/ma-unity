using System;
using System.Collections.Generic;
using Ademord.Drone;
using MBaske.MLUtil;
using MBaske.Sensors.Grid;
using UnityEngine;
using Unity.MLAgents;
using Unity.MLAgents.Actuators;
using Unity.MLAgents.Sensors;

namespace Ademord
{
    public class DroneAgentTrainSceneControl : DroneAgentTrain
    {
        
        public override void OnEpisodeBegin()
        {
            RandomizeTargets();

            base.OnEpisodeBegin();
            
        }
        protected void RandomizeTargets()
        {
            RandomizeTargetSpeed();

            // m_World.MoveToSafeRandomPosition(m_Drone.transform, true);
        }
    }
}