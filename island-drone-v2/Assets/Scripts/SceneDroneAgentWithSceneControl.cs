using System;
using System.Collections.Generic;
using Ademord.Drone;
using MBaske.MLUtil;
using MBaske.Sensors.Grid;
using UnityEngine;
using Unity.MLAgents;
using Unity.MLAgents.Actuators;
using Unity.MLAgents.Sensors;

using System.Collections;
using System.IO;
using System.Text;

namespace Ademord.Drone
{
    public class SceneDroneAgentWithSceneControl : SceneDroneAgent
    {
        public string Path = "C:/TheGameStuff/ademord/island-drone-v2/Assets/Scripts/CSV";
        StreamWriter writer;

        public override void OnEpisodeBegin()
        {
            m_Drone.Reset();
            m_Drone.transform.localPosition = new Vector3(0, 3, 0);
            transform.rotation = Quaternion.Euler(Vector3.up * UnityEngine.Random.Range(0f, 360f));
            // m_World.MoveToSafeRandomPosition(m_Drone.transform, true);

            m_World.Reset(); 
            
            ResetObservations(true);
        }

        /// <summary>
        /// Write the observations and actions to a CSV file 
        /// </summary>
        public void writeToCsv()
        {
            string Data_nodeDensities = "";
            string Data_intersectRatios = "";
            string VectorFront_normalized = "";
            string VectorAway_normalized = "";

            for(int i =0; i < 8; i++)
            {
                Data_nodeDensities += Data.NodeDensities[i] + ",";
                Data_intersectRatios += Data.IntersectRatios[i] + ",";

            }
            VectorFront_normalized += 
                (
                    vectorToTargetsInFront.normalized.x + "," +
                    vectorToTargetsInFront.normalized.y + "," +
                    vectorToTargetsInFront.normalized.y + ","
                );

            VectorAway_normalized +=
                (
                    vectorToTargetsFacingAway.normalized.x + "," +
                    vectorToTargetsFacingAway.normalized.y + "," +
                    vectorToTargetsFacingAway.normalized.y + ","
                );
            // Convert all the observations to comma seperated values. 
            string observations =
                (
                    Data.LookRadiusNorm + "," + // 1 
                    Data_nodeDensities + // 8
                    Data_intersectRatios + // 8 
                    m_Drone.NormPosition + "," + // 1 
                    m_Drone.NormOrientation + "," + // 1
                    angleToTargetsInFront + "," + // 1
                    angleToTargetsFacingAway + "," + // 1
                    distanceToTarget + "," + // 1
                    VectorFront_normalized + // 3
                    VectorAway_normalized // 3
                );

            // Convert the actions to comma seperated values
            string actions =
                (
                    saved_actions.ContinuousActions[0] + "," +
                    saved_actions.ContinuousActions[1] + "," +
                    saved_actions.ContinuousActions[2] + "," +
                    saved_actions.ContinuousActions[3]
                    
                );

            // Write to the CSV
            writer.WriteLine(actions + "," + observations);
            writer.Flush();
        }

        /// <summary>
        /// Open / Create the CSV file with the name "data"
        /// </summary>
        void initCSV()
        {
            writer = new StreamWriter(Path + "/Data.csv", true);
            
        }

        /// <summary>
        /// Close the csv file and save it.
        /// </summary>
        void endCSV()
        {
            writer.Close();
        }


        private void Update()
        {

            // start recording
            if(Input.GetKeyDown(KeyCode.P))
            {
                try
                {
                    initCSV();
                }
                catch
                {
                    Debug.Log("Already recording");
                }
            }

            // stop recording
            if(Input.GetKeyDown(KeyCode.O))
            {
                try
                {
                    endCSV();
                }
                catch
                {
                    Debug.Log("Already Closed");
                }
            }

            // keep writing if the file is open
            try
            {
                writeToCsv();
            }
            catch
            {
                Debug.Log(""); // Quick and stupid fix
            }
        }

    }
}