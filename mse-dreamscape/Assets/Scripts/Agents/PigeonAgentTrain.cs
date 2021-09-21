using UnityEngine;
using Unity.MLAgents.Sensors;

namespace Ademord
{
    public class PigeonAgentTrain : OctreeAgentTrain
    {
        [Header("Pigeon Agent Parameters")]

        [SerializeField]
        protected MagneticNorth m_MagneticNorth;
        
        [Tooltip("The direction towards which the compass points. Default for North is (0, 0, 1)")]
        private Vector3 kReferenceVector = new Vector3(0, 0, 1);
        
        [SerializeField]
        protected Sun m_SunObject;

        private float angleTowardsSun;
        private float angleTowardsMagneticNorth;

        // memalloc
        private Vector3 _mTempVector;
        private float _mTempAngle;
        
        
        public override void Initialize()
        {
            base.Initialize();

            steuernModus = SteuernModus.PhysicsVelocity;
            m_SunObject = m_SunObject.GetComponent<Sun>();
        }
        
        public override void CollectObservations(VectorSensor sensor)
        {
            base.CollectObservations(sensor);
            
            // pigeon observations
            var vectortowardsSun = (m_Body.WorldPosition - m_SunObject.transform.position).normalized;
            var vectortowardsMagneticNorth = (m_Body.WorldPosition - m_MagneticNorth.transform.position).normalized;
            sensor.AddObservation(vectortowardsSun); // 3
            sensor.AddObservation(vectortowardsMagneticNorth); // 3
        }
        
        public float GetAngleMagneticNorth()
        {
            var vectortowardsMagneticNorth = (m_Body.WorldPosition - m_MagneticNorth.transform.position).normalized;
            // remove y component to act as a true compass
            vectortowardsMagneticNorth = new Vector3(vectortowardsMagneticNorth.x, 0, vectortowardsMagneticNorth.z);
            return 180 - Vector3.Angle(vectortowardsMagneticNorth, kReferenceVector);
        }

        public float GetAngleTowardsSun()
        {
            var vectortowardsSun = (m_Body.WorldPosition - m_SunObject.transform.position).normalized;
            // remove y component to act as a true compass
            // vectortowardsSun = new Vector3(vectortowardsSun.x, 0, vectortowardsSun.z);
            var vectorTowardsSun_plane = new Vector3(vectortowardsSun.x, 0, vectortowardsSun.z);
            return 90 - Vector3.Angle(vectortowardsSun, vectorTowardsSun_plane);
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
            m_GUIStats.Add(Data.LeafNodeInfo[PointType.ScanPoint].Count, "Octree", "Leaf Nodes Scan Points", palette[2]);
            
            m_GUIStats.Add(angleTowardsSun, "Pigeon", "Angle Towards Sun", palette[0]);
            m_GUIStats.Add(angleTowardsMagneticNorth, "Pigeon", "Angle Towards Magnetic North", palette[1]);
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
