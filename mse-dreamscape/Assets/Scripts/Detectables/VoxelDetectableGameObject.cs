using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace Ademord
{
    public class VoxelDetectableGameObject : MBaske.Sensors.Grid.DetectableGameObject
    {
        // public void Update()
        // {
        //     print("agent body: " + m_AgentBody.WorldPosition);
        //     print("my body: " + transform.position);
        //     
        // }
        [SerializeField] protected Body m_AgentBody;
        public float FacingAgent() => Vector3.Dot(transform.forward, m_AgentBody.WorldForward) < 0 ? 1 : 0;
        public float IsInSight() => !Physics.Linecast(transform.position, m_AgentBody.WorldPosition) ? 1 : 0;

        public override void AddObservables()
        {
            Observables.Add("InSight", IsInSight);
            Observables.Add("FacingAgent", FacingAgent);
        }
    }
}