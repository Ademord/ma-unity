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
            print("entering onepisodebegin");

            m_Drone.Reset();
            m_Drone.transform.localPosition = new Vector3(0, 3, 0);
            transform.rotation = Quaternion.Euler(Vector3.up * UnityEngine.Random.Range(0f, 360f));
            // m_World.MoveToSafeRandomPosition(m_Drone.transform, true);

            m_World.Reset(); 

            ResetObservations(true);
        }
    }
}