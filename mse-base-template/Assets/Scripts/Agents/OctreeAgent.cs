using System.Collections;
using System.Collections.Generic;
using Unity.MLAgents.Sensors;
using UnityEngine;

namespace Ademord
{
    public class OctreeAgent : DroneAgent
    {
        public Vector3 WorldPosition => m_Body.WorldPosition;

        protected Point scanPoint;
        protected Vector3Int prevPos;
        protected int lingerCount; 
        
        public SceneDroneData Data { get; protected set; }

        [SerializeField]
        [Range(0.25f, 1f)]
        protected float leafNodeSize = 0.5f;

        [SerializeField]
        [Tooltip("Distance below which agent is rewarded for following goals.")]
        [Range(5f, 50f)]
        protected float m_TargetFollowDistance = 10f;
        
        public override void Initialize()
        {
            base.Initialize();

            Data = new SceneDroneData();
        }

        public override void OnEpisodeBegin()
        {
            ResetAgent();
            
            base.ResetAgent();
        }

        public override void CollectObservations(VectorSensor sensor)
        {
            base.CollectObservations(sensor);
            
            if (IsNewGridPosition(m_Body.WorldPosition))
            {
                Data.AddPoint(new Point(PointType.DronePos, m_Body.WorldPosition, Time.time));
            }
            
            // moved rewards to OctreeAgentTrain
            
            sensor.AddObservation(Data.LookRadiusNorm); // 1 
            sensor.AddObservation(Data.NodeDensities); // 8
            sensor.AddObservation(Data.IntersectRatios); // 8 
            
            // sensor.AddObservation(linger - 1f); // 1
            // sensor.AddObservation(m_Drone.ScanBuffer.ToArray()); // 30
        }
        
        
        protected void OnValidate()
        {
            leafNodeSize = Mathf.Pow(2f, Mathf.Round(Mathf.Log(leafNodeSize, 2f)));
        }
        protected Vector3Int GetVector3Int(Vector3 pos)
        {
            float s = Data.LeafNodeSize;
            return new Vector3Int(
                Mathf.RoundToInt(pos.x / s),
                Mathf.RoundToInt(pos.y / s),
                Mathf.RoundToInt(pos.z / s)
            );
        
        }
        protected bool IsNewGridPosition(Vector3 dronePos)
        {
            Vector3Int pos = GetVector3Int(dronePos);
            if (pos != prevPos)
            {
                prevPos = pos;
                lingerCount = 0;
                return true;
            }

            lingerCount = Mathf.Min(200, lingerCount + 1);
            return false;
        }
        protected new virtual void ResetAgent()
        {
            // reset octree
            Data.Reset(m_Body.WorldPosition, m_TargetFollowDistance, leafNodeSize); // lookRadius removed
        
            // reset octree scan related data
            scanPoint = default(Point);
            prevPos = GetVector3Int(m_Body.WorldPosition);
            lingerCount = 0;
            // m_VoxelsScanned = 0;
        }
    }

}
