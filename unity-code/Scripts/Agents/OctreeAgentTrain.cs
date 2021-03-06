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
        protected Vector3Int prevPos;
        protected List<Point> scanPoints;
        protected int lingerCount; 
        // variable of new nodes discovered since 3 methods use it and modify it all the time otherwise
        protected int nodeCount;

        public SceneDroneData Data { get; protected set; }

        [Header("Octree Agent Parameters")]
        [SerializeField] protected bool m_AddOctreeObservations = true;
        [SerializeField] protected bool m_TrainOctreeDiscovery = true;
        [SerializeField] protected bool m_TrainLingerPolicy = true;
        
        [SerializeField]
        [Range(0.25f, 16f)]
        protected float leafNodeSize = 4f;
        protected float actualConstrainedLeafNodeVolume;
        protected List<int> explorationMilestones;

        
        [SerializeField]
        [Range(1, 128)]
        int m_OctreePanoramicScanResolution = 26;
        
        [SerializeField]
        bool m_DrawPanoramicResolutionGuidelines = false;

        protected float m_LingeringPenaltyStrength;
        
        public override void Initialize()
        {
            print("entering octree initialize");
            base.Initialize();
            m_LingeringPenaltyStrength = 1f;
            scanPoints = new List<Point>();
            Data = new SceneDroneData();

            float amountOfOctantsPerAxis = 160 / leafNodeSize;
            actualConstrainedLeafNodeVolume =
                amountOfOctantsPerAxis * amountOfOctantsPerAxis * (amountOfOctantsPerAxis / 8) / 2; 
                // (amountOfOctantsPerAxis / 8) / 2 accounting for only one level of the octree.
                // the drone doesnt need to explore on this specific setup the top part of the island (objects are not flying, so this is not being tested as
                // "exploration capabilities", plus the boundary is at 32 meters of height, so the agent with a 16m radius grid sensor does not need to 
                // move to fully both octree nodes to have a view of what is inside them
            print("actualConstrainedLeafNodeVolume: " + actualConstrainedLeafNodeVolume);
        }

        public override void OnEpisodeBegin()
        {
            base.OnEpisodeBegin();

            ResetAgent();
            RandomizeTargets();
        }
        
        protected new virtual void ResetAgent()
        {
            print("ResetAgent: OctreeAgent");
            // reset octree
            Data.Reset(m_Body.WorldPosition, m_SensorComponent.MaxDistance, leafNodeSize); // lookRadius removed
            // scanPoint = default(Point); = default(List<Point>);
            scanPoints.Clear();
            // reset octree scan related data
            prevPos = GetVector3Int(m_Body.WorldPosition);
            lingerCount = 0;
            nodeCount = 0;
            // m_VoxelsScanned = 0;

            explorationMilestones = new List<int>()
            {
                10, 20, 30, 40, 50, 60, 70, 80, 90, 95, 98, 100
                
            };
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
            scanPoints = PopulateOctree();
            nodeCount = GetNewNodesCount();
            // new scanPoints are added to the octree on post action

            if (m_AddOctreeObservations)
            {
                sensor.AddObservation((lingerCount / 100f) - 1f); // 1, lingerCount / 100f is constrained to 0-2 so -1 makes it from -1 to 1
                sensor.AddObservation(Data.LookRadiusNorm); // 1 
                sensor.AddObservation(Data.NodeDensities); // 8
                sensor.AddObservation(Data.IntersectRatios); // 8 
                // total 18 obs
                // sensor.AddObservation(m_Drone.ScanBuffer.ToArray()); // 30
            }
        }
        
        public override void SetRewards()
        {
            base.SetRewards();

            if (m_TrainOctreeDiscovery)
            {
                if (m_EnableTrainDebuggingLogs) print("m_TrainOctreeDiscovery");
                AddReward(GetOctreeDiscoveryReward());
            }

            if (m_TrainLingerPolicy)
            {
                if (m_EnableTrainDebuggingLogs) print("m_TrainLingerPolicy");
                AddReward(GetLingeringPenalty());
            }
            
            Data.StepUpdate(m_Body.WorldPosition);
        }
        
        public override void PostAction()
        {
            base.PostAction();
            foreach (var point in scanPoints)
            {
                Data.AddPoint(point);
            }
            scanPoints.Clear();
        }
    
        private List<Point> PopulateOctree()
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
            Vector3[] raycast_pts = PointsOnSphere(m_OctreePanoramicScanResolution);
            Point[] scan_points = new Point[m_OctreePanoramicScanResolution];

            int idx_scan_points = 0;
            foreach (Vector3 value in raycast_pts)
            {
                RaycastHit hit;
                // Vector3 scan = new Vector3(1f, 1f, 1f);
                Ray ray = new Ray(m_Body.WorldPosition, value);
                Point point = new Point(PointType.ScanOutOfRange, m_Body.WorldPosition + ray.direction * m_SensorComponent.MaxDistance, Time.time);
                bool hitSomething = Physics.Raycast(ray.origin, ray.direction, out hit, m_SensorComponent.MaxDistance);
                if (hitSomething && (hit.collider.tag.Equals("collectible") || hit.collider.tag.Equals("obstacle"))) // hit.collider.tag.Equals("boundary")
                {
                    // scan.z = SceneDroneData.NormalizeDistance(hit.distance);
                    // Grid nodes align with blocks:
                    // Offset point slightly so it doesn't sit right on the boundary between two nodes.
                    point.Position = ray.origin + ray.direction * (hit.distance + 0.01f);
                    point.Type = PointType.ScanPoint;
                }
                
                scan_points[idx_scan_points++] = point;

                if (m_DrawPanoramicResolutionGuidelines)
                {
                    // visualization
                    List<GameObject> uspheres = new List<GameObject>();
                    int i = 0;
                    uspheres.Add(GameObject.CreatePrimitive(PrimitiveType.Sphere));
                    uspheres[i].transform.parent = transform;
                    uspheres[i].transform.position = point.Position;                    
                }
            }

            return new List<Point>(scan_points);
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
            if (targetsInFOV) return 0;
            
            float linger = lingerCount / 100f; // 0 - 2
            return -linger * m_LingeringPenaltyStrength;
        }
        public float GetOctreeDiscoveryReward(float strength = 2f)
        {
            var reward = (nodeCount * 1f) / Data.LookRadius * strength;
            // reward = (float) reward / (1 + reward) * strength;

            return reward;
            // return (nodeCount * 0.1f) / Data.LookRadius;
        }

        public int GetNewNodesCount()
        {
            Vector3 pos = m_Body.WorldPosition;
            int nodeCount = 0;
            // changed to support multiple scanpoints being found every timestep t
            foreach (var point in scanPoints)
            {
                // print("adding points : nodecount: " + nodeCount);
                nodeCount += Data.Tree.Intersect(pos, point.Position);
            }
            return nodeCount;
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
            // how much space it covers
            m_TBStats.Add(m_BehaviorName + "/Octree: Lingering Count", lingerCount);
            m_TBStats.Add(m_BehaviorName + "/Octree: Lingering Penalty", GetLingeringPenalty());
            m_TBStats.Add(m_BehaviorName + "/Octree: Leaf Nodes Visited", Data.LeafNodeInfo[PointType.DronePos].Count);
            // how quickly it finds scan points
            m_TBStats.Add(m_BehaviorName + "/Octree: Scan Points Found", Data.LeafNodeInfo[PointType.ScanPoint].Count);
            m_TBStats.Add(m_BehaviorName + "/Octree: New Nodes Count", nodeCount);
            m_TBStats.Add(m_BehaviorName + "/Octree: Discovery Reward", GetOctreeDiscoveryReward());
            // new DARPA metrics
            // must iterate backwards to remove elements from the list
            float exploredLeafNodeVolume = Data.LeafNodeInfo[PointType.DronePos].Count / actualConstrainedLeafNodeVolume * 100f;
            
            for (int i = explorationMilestones.Count - 1; i > -1; i--)
            {
                var explorationMilestone = explorationMilestones[i];
                if (exploredLeafNodeVolume >= explorationMilestone)
                {
                    print(m_BehaviorName + "/Octree: Time To ActualLeafNodeVolumePercentage {" + explorationMilestone + "%}: " + EpisodeTimer);
                    m_TBStats.Add(m_BehaviorName + "/Octree: Time To ActualLeafNodeVolumePercentage {" + explorationMilestone + "%}", EpisodeTimer);
                    // remove so it is not logged again this episode
                    explorationMilestones.RemoveAt(i);
                    AddReward(1f);

                    if (explorationMilestones.Count == 0)
                    {
                        EndEpisode();
                    }
                }
            }
        }

        public override void DrawGUIStats(bool drawSummary = true)
        {
            base.DrawGUIStats(false);
            var palette = Colors.Palette(4, 1, 0.5f, 0.2f, 0.8f);

            // m_GUIStats.Add(lingerCount, "Octree Linger", "lingerCount", palette[0]);
            // this metric shows how much of the area the agent actually visited
            m_GUIStats.Add(Data.LeafNodeInfo[PointType.DronePos].Count / 10, "Octree", "Leaf Nodes Visited", palette[1]);
            // if scanner is smaller (not panoramic) then scan ouf of range nodes will show how much the agent looked around.
            // m_GUIStats.Add(Data.LeafNodeInfo[PointType.ScanOutOfRange].Count, "Octree", "Leaf Nodes ScanOutOfRange", palette[2]);
            m_GUIStats.Add(Data.LeafNodeInfo[PointType.ScanPoint].Count / 10, "Octree", "Leaf Nodes Scan Points", palette[2]);
            m_GUIStats.Add(nodeCount, "Octree", "New Nodes Count", palette[3]);
            // m_GUIStats.Add(coveragePercentage, "Octree", "Coverage %", palette[3]);

            if (drawSummary)
            {
                // rewards
            
                float sum =
                    m_GUIStats.Add(GetOctreeDiscoveryReward(), "Rewards", "Octree Node Discovery", palette[0]) +
                    m_GUIStats.Add(GetMovingForwardReward(), "Rewards", "Moving Forward Reward", palette[1]);

            
                // penalties
                sum += m_GUIStats.Add(GetLingeringPenalty(), "Penalties", "Lingering Error", palette[0]) +
                       m_GUIStats.Add(GetSpeedErrorPenalty(), "Penalties", "Speed Error", palette[1]);

                m_GUIStats.Add(sum, "Reward Sum", "", Colors.Lightblue);
            }
        }
    }
}
