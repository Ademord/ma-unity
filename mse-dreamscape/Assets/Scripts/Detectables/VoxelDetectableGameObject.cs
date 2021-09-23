using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace Ademord
{
    public class VoxelDetectableGameObject : MBaske.Sensors.Grid.DetectableGameObject
    {
        [SerializeField] 
        public Body m_AgentBody;
        protected Collider m_Collider;
        public float FacingAgent() => Vector3.Dot(transform.forward, m_AgentBody.WorldForward) < 0 ? 1 : 0;
        public float IsInSight() => !Physics.Linecast(transform.position, m_AgentBody.WorldPosition) ? 1 : 0;
        // public float IsInSightComplex() => !ComplexRaycast(m_AgentBody.WorldPosition, m_Collider, 5)? 1: 0;

        void Start()
        {
            m_Collider = transform.GetComponent<Collider>();
        }
        
        public override void AddObservables()
        {
            Observables.Add("InSight", IsInSight);
            Observables.Add("FacingAgent", FacingAgent);
        }
    }
}