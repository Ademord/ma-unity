using System.Collections;
using System.Collections.Generic;
using Unity.MLAgents.Actuators;
using Unity.MLAgents.Sensors;
using UnityEngine;

namespace Ademord
{
    public class OctreeAgentTrain : DroneAgentTrain
    {
        public Vector3 WorldPosition => m_Body.WorldPosition;

        protected Point scanPoint;
        protected Vector3Int prevPos;
        protected int lingerCount; 
        
        public SceneDroneData Data { get; protected set; }

        [SerializeField]
        [Range(0.25f, 8f)]
        protected float leafNodeSize = 4f;

        // [SerializeField]
        // [Tooltip("Distance below which agent is rewarded for following goals.")]
        // [Range(5f, 50f)]
        // protected float m_TargetFollowDistance = 10f;
        
        public override void Initialize()
        {
            base.Initialize();

            Data = new SceneDroneData();
        }

        public override void OnEpisodeBegin()
        {
            base.ResetAgent();

            ResetAgent();
            RandomizeTargets();
        }
        
        protected new virtual void ResetAgent()
        {
            // reset octree
            Data.Reset(m_Body.WorldPosition, m_SensorComponent.MaxDistance, leafNodeSize); // lookRadius removed
        
            // reset octree scan related data
            scanPoint = default(Point);
            prevPos = GetVector3Int(m_Body.WorldPosition);
            lingerCount = 0;
            // m_VoxelsScanned = 0;
        }

        protected void RandomizeTargets()
        {
            RandomizeTargetSpeed();

            // m_World.MoveToSafeRandomPosition(m_Drone.transform, true);
        }

        public override void CollectObservations(VectorSensor sensor)
        {
            base.CollectObservations(sensor);
            
            if (IsNewGridPosition(m_Body.WorldPosition))
            {
                Data.AddPoint(new Point(PointType.DronePos, m_Body.WorldPosition, Time.time));
            }
            Data.AddPoint(scanPoint);
            // moved rewards to OctreeAgentTrain
            
            sensor.AddObservation(Data.LookRadiusNorm); // 1 
            sensor.AddObservation(Data.NodeDensities); // 8
            sensor.AddObservation(Data.IntersectRatios); // 8 
            
            // sensor.AddObservation(linger - 1f); // 1
            // sensor.AddObservation(m_Drone.ScanBuffer.ToArray()); // 30
        }
        

        public override void SetRewards()
        {
            base.SetRewards();
            // print("adding octree rewards");
            AddReward(GetOctreeDiscoveryReward());
            AddReward(GetLingeringPenalty());
            Data.StepUpdate(m_Body.WorldPosition);
        }
        
        // used to check if exited boundaries 
        // used to add random forces
        // used to randomize targets after a certain stepcount
        public override void PostAction()
        {
            base.PostAction();
            
            // scanPoint = 
            PopulateOctree();
        }
    
        private void PopulateOctree()
        {
            // this adds a dead point at every out of scan range if there was nothing in the vision of the agent
            // if "no objects detected"
            // this works for a raycast laser
            // for the grid sensor you would have to add all the points that the agent sees at once through the grid sensor.
            // so add a sphere of nodes to the octree at each timestep
    
            // for every angle in a set of division of angles [15, 30, 45, ...]
            // for every boundary found by the gridsensor, add it to the octree as a scan point
            // for every obstacle ""                                                         ""
            // for every collectible ""                                                      "" 
            
            // add a scan point out of range if there was no object in between. 
            
            float scaling = m_SensorComponent.MaxDistance;
            Vector3[] pts = PointsOnSphere(128);
            
            foreach (Vector3 value in pts)
            {
                RaycastHit hit;
                // Vector3 scan = new Vector3(1f, 1f, 1f);
                Ray ray = new Ray(m_Body.WorldPosition, value);
                Point point = new Point(PointType.ScanOutOfRange, m_Body.WorldPosition + ray.direction * m_SensorComponent.MaxDistance, Time.time);
                bool hitSomething = Physics.Raycast(ray.origin, ray.direction, out hit, m_SensorComponent.MaxDistance);
                if (hitSomething && (hit.collider.tag.Equals("collectible") || hit.collider.tag.Equals("obstacle"))) // hit.collider.tag.Equals("boundary")
                {
                    print("agent hit something");
                    // scan.z = SceneDroneData.NormalizeDistance(hit.distance);
                    // Grid nodes align with blocks:
                    // Offset point slightly so it doesn't sit right on the boundary between two nodes.
                    point.Position = ray.origin + ray.direction * (hit.distance + 0.01f);
                    point.Type = PointType.ScanPoint;
                }
                
                Data.AddPoint(point);
            }
            
            
            // List<GameObject> uspheres = new List<GameObject>();
            // int i = 0;
            //
            // uspheres.Add(GameObject.CreatePrimitive(PrimitiveType.Sphere));
            // uspheres[i].transform.parent = transform;
            // uspheres[i].transform.position = point.Position ;
            
            // ScanBuffer.Add(scan);
            // we dont return a scan point because the drone does not have a ray cast
            // if the drone had a raycast then it would 
        }
        
        // void Start ()
        // {
        //     float scaling = m_SensorComponent.MaxDistance;
        //     Vector3[] pts = PointsOnSphere(128);
        //     List<GameObject> uspheres = new List<GameObject>();
        //     int i = 0;
        //
        //     foreach (Vector3 value in pts)
        //     {
        //         uspheres.Add(GameObject.CreatePrimitive(PrimitiveType.Sphere));
        //         uspheres[i].transform.parent = transform;
        //         uspheres[i].transform.localPosition = value * scaling;
        //         i++;
        //     }
        // }
 
        Vector3[] PointsOnSphere(int n)
        {
            List<Vector3> upts = new List<Vector3>();
            float inc = Mathf.PI * (3 - Mathf.Sqrt(5));
            float off = 2.0f / n;
            float x = 0;
            float y = 0;
            float z = 0;
            float r = 0;
            float phi = 0;
     
            for (var k = 0; k < n; k++){
                y = k * off - 1 + (off /2);
                r = Mathf.Sqrt(1 - y * y);
                phi = k * inc;
                x = Mathf.Cos(phi) * r;
                z = Mathf.Sin(phi) * r;
         
                upts.Add(new Vector3(x, y, z));
            }
            Vector3[] pts = upts.ToArray();
            return pts;
        }
        public float GetLingeringPenalty()
        {
            float linger = lingerCount / 100f; // 0 - 2
            return -linger * 0.1f;
        }
        public float GetOctreeDiscoveryReward()
        {
            Vector3 pos = m_Body.WorldPosition;
            int nodeCount = Data.Tree.Intersect(pos, scanPoint.Position);
            return (nodeCount * 0.1f) / Data.LookRadius;
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
                // print("pos != prevPos");
                prevPos = pos;
                lingerCount = 0;
                return true;
            }
            lingerCount = Mathf.Min(200, lingerCount + 1);
            return false;
        }
        
        public override void AddTensorboardStats()
        {
            base.AddTensorboardStats();
            // m_TBStats.Add(m_BehaviorName + "/Speed Error", GetSpeedError());
            // m_TBStats.Add(m_BehaviorName + "/Look Error", GetLingeringPenalty());
        }

        public override void DrawGUIStats(bool drawSummary = true)
        {
            base.DrawGUIStats(false);
            var palette = Colors.Palette(4, 1, 0.5f, 0.2f, 0.8f);

            m_GUIStats.Add(lingerCount, "Octree", "lingerCount", palette[0]);
            // this metric shows how much of the area the agent actually visited
            m_GUIStats.Add(Data.LeafNodeInfo[PointType.DronePos].Count, "Octree", "Leaf Nodes Visited", palette[1]);
            // if scanner is smaller (not panoramic) then scan ouf of range nodes will show how much the agent looked around.
            // m_GUIStats.Add(Data.LeafNodeInfo[PointType.ScanOutOfRange].Count, "Octree", "Leaf Nodes ScanOutOfRange", palette[2]);
            
            m_GUIStats.Add(Data.LeafNodeInfo[PointType.ScanPoint].Count, "Octree", "Leaf Nodes Scan Points", palette[3]);
            // m_GUIStats.Add(coveragePercentage, "Octree", "Coverage %", palette[3]);

            if (drawSummary)
            {
                // rewards
            
                float sum =
                    m_GUIStats.Add(GetOctreeDiscoveryReward(), "Rewards", "Octree Node Discovery", palette[0]);
            
                // penalties
                sum += m_GUIStats.Add(GetLingeringPenalty(), "Penalties", "Lingering Error", palette[1]) +
                       m_GUIStats.Add(GetSpeedErrorPenalty(), "Penalties", "Speed Error", palette[2]);

                m_GUIStats.Add(sum, "Reward Sum", "", Colors.Lightblue);
            }
        }
    }
}
