using System;
using System.Collections.Generic;
using Ademord.Drone;
using MBaske.MLUtil;
using MBaske.Sensors.Grid;
using UnityEngine;
using Unity.MLAgents;
using Unity.MLAgents.Actuators;
using Unity.MLAgents.Sensors;

namespace Ademord.Drone
{
    public class SceneDroneAgentWithSceneControl : SceneDroneAgent
    {
        public override void OnEpisodeBegin()
        {
            m_Drone.Reset();
            m_World.MoveToSafeRandomPosition(m_Drone.transform, true);

            m_World.Reset(); 

            ResetObservations(true);
        }
    }
}