using System.Collections;
using System.Collections.Generic;
using Unity.MLAgents.Sensors;
using UnityEngine;

namespace Ademord
{
    public class VoxelSpeedPigeonRWNAgentTrain : VoxelPigeonAgentTrain
    {
        public override float GetVoxelDiscoveryReward()
        {
            // define reward
            // var r = m_VoxelsScanned * 1f;
            var r = (float) m_VoxelsScanned / (2 + m_VoxelsScanned) * 1f;
            return r;
        }
        

    }
}