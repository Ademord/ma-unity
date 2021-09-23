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
        private Vector3 kReferenceVectorSun = new Vector3(0, 1, 0);
        private Vector3 kReferenceVectorMagneticNorth = new Vector3(0, 0, 1);
        
        [SerializeField]
        protected Sun m_SunObject;

        private Quaternion valueTowardsSun;
        private Quaternion valueTowardsMagneticNorth;

        // memalloc
        private Vector3 _mTempVector;
        private float _mTempAngle;
        
        
        public override void Initialize()
        {
            base.Initialize();

            m_SunObject = m_SunObject.GetComponent<Sun>();
            m_MagneticNorth = m_MagneticNorth.GetComponent<MagneticNorth>();
        }
        
        public override void CollectObservations(VectorSensor sensor)
        {
            base.CollectObservations(sensor);

            valueTowardsSun = GetRotationTowardsMagneticNorthCompassStyle();
            valueTowardsMagneticNorth = GetRotationTowardsSunCompassStyle();
            // print("valueTowardsSun: " + valueTowardsSun + "valueTowardsSun: " + valueTowardsSun.w);
            // print("valueTowardsMagneticNorth: " + valueTowardsMagneticNorth + "valueTowardsMagneticNorth.z: " + valueTowardsMagneticNorth.z + "valueTowardsMagneticNorth.w: " + valueTowardsMagneticNorth.w);
            sensor.AddObservation(valueTowardsSun); // 4
            sensor.AddObservation(valueTowardsMagneticNorth); // 4

            // total 8 obs
        }

        public Quaternion GetRotationTowardsSunCompassStyle()
        {
            // get player transform, set y to 0 and normalize
            _mTempVector = m_Body.WorldForward;
            _mTempVector.z = 0f;
            _mTempVector = _mTempVector.normalized;

            // get distance to reference, ensure y equals 0 and normalize
            _mTempVector = _mTempVector - kReferenceVectorSun;
            _mTempVector.z = 0;
            _mTempVector = _mTempVector.normalized;

            // if the distance between the two vectors is 0, this causes an issue with angle computation afterwards  
            if (_mTempVector == Vector3.zero)
            {
                _mTempVector = new Vector3(1, 0, 0);
            }

            // compute the rotation angle in radians and adjust it 
            _mTempAngle = Mathf.Atan2(_mTempVector.x, _mTempVector.y);
            _mTempAngle = (_mTempAngle * Mathf.Rad2Deg + 90f) * 2f;

            // set rotation
            return Quaternion.AngleAxis(_mTempAngle, kReferenceVectorSun);
        } 
        public Quaternion GetRotationTowardsMagneticNorthCompassStyle()
        {
            // get player transform, set y to 0 and normalize
            _mTempVector = m_Body.WorldForward;
            _mTempVector.y = 0f;
            _mTempVector = _mTempVector.normalized;

            // get distance to reference, ensure y equals 0 and normalize
            _mTempVector = _mTempVector - kReferenceVectorMagneticNorth;
            _mTempVector.y = 0;
            _mTempVector = _mTempVector.normalized;

            // if the distance between the two vectors is 0, this causes an issue with angle computation afterwards  
            if (_mTempVector == Vector3.zero)
            {
                _mTempVector = new Vector3(1, 0, 0);
            }

            // compute the rotation angle in radians and adjust it 
            _mTempAngle = Mathf.Atan2(_mTempVector.x, _mTempVector.z);
            _mTempAngle = (_mTempAngle * Mathf.Rad2Deg + 90f) * 2f;

            // set rotation
            return Quaternion.AngleAxis(_mTempAngle, kReferenceVectorMagneticNorth);
        }
        public Vector3 GetVectorTowardsMagneticNorth()
        {
            // var vectortowardsMagneticNorth = (m_Body.WorldPosition - m_MagneticNorth.transform.position).normalized;
            // // remove y component to act as a true compass
            // vectortowardsMagneticNorth = new Vector3(vectortowardsMagneticNorth.x, 0, vectortowardsMagneticNorth.z);
            // return 180 - Vector3.Angle(vectortowardsMagneticNorth, kReferenceVector);
            // return 90 - Vector3.Angle(vectortowardsSun, vectorTowardsSun_plane);

            return (GetVector3Int(m_Body.WorldPosition) - m_MagneticNorth.transform.position);
        }

        public Vector3 GetVectorTowardsSun()
        {
            return (GetVector3Int(m_Body.WorldPosition) - m_SunObject.transform.position);
        }
        
        public override void DrawGUIStats(bool drawSummary = true)
        {
            base.DrawGUIStats(false);
            var palette = Colors.Palette(4, 1, 0.5f, 0.2f, 0.8f);

            // m_GUIStats.Add(lingerCount, "Octree", "lingerCount", palette[0]);
            // // this metric shows how much of the area the agent actually visited
            // m_GUIStats.Add(Data.LeafNodeInfo[PointType.DronePos].Count, "Octree", "Leaf Nodes Visited", palette[1]);
            // // if scanner is smaller (not panoramic) then scan ouf of range nodes will show how much the agent looked around.
            // // m_GUIStats.Add(Data.LeafNodeInfo[PointType.ScanOutOfRange].Count, "Octree", "Leaf Nodes ScanOutOfRange", palette[2]);
            // m_GUIStats.Add(Data.LeafNodeInfo[PointType.ScanPoint].Count, "Octree", "Leaf Nodes Scan Points", palette[2]);
            
            m_GUIStats.Add(valueTowardsSun.w, "Pigeon", "Value Towards North", palette[0]);
            m_GUIStats.Add(valueTowardsMagneticNorth.z, "Pigeon", "Rotation from Compass", palette[1]);
            // m_GUIStats.Add(valueTowardsMagneticNorth.w, "Pigeon", "Value Towards Magnetic North", palette[1]);
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
