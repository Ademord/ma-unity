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
        protected bool runOnce = true;
        private float _FacingAgent() => Vector3.Dot(transform.forward, m_AgentBody.WorldForward) < 0 ? 1 : 0;
        private float _IsInSight(int layer) => !Physics.Linecast(m_AgentBody.WorldPosition, transform.position,  layer) ? 1 : 0;
        public float FacingAgent() => m_AgentBody != null ? _FacingAgent(): 1;
        public float IsInSight(int layer = Layer.ObstacleMask) => m_AgentBody != null ? _IsInSight(layer): 1 ;
        // public float IsInSight(int layerObjectIsIn = 1 << 0)
        // {
        //     float isInSight = 1;
        //
        //     RaycastHit[] coverHits;
        //
        //     coverHits = Physics.RaycastAll(m_AgentBody.WorldPosition,  transform.position - m_AgentBody.WorldPosition, 100, Layer.ObstacleMask);
        //
        //     if (coverHits.Length > 0)
        //     {
        //         for (int i = 0; i < coverHits.Length; i++)
        //         {
        //             isInSight = 0;
        //             
        //             // print("linecast hit: " + coverHits[i].transform.name); // + " from: " + coverHits[i].transform.parent.name
        //             //
        //             // if (coverHits[i].transform.gameObject.CompareTag("obstacle"))
        //             // {
        //             //     print("HIT AN OBSTACLE!");
        //             // }
        //         }
        //     }
        //
        //     return isInSight;
        //
        //     // var obstructionLayers = ~layerObjectIsIn;
        //     // if (!Physics.Linecast(transform.position, m_AgentBody.WorldPosition, ~obstructionLayers))
        //     // {
        //     //     print("Linecast to DOG is CLEAR: " + transform.name);
        //     //     return 1;
        //     // }
        //     // else
        //     // {
        //     //     print("Linecast to DOG is OBSTRUCTED: " + transform.name);
        //     //     return 0;
        //     // }
        // }  
        // public float IsInSightComplex() => !ComplexRaycast(m_AgentBody.WorldPosition, m_Collider, 5)? 1: 0;

        void Start()
        {
            m_Collider = transform.GetComponent<Collider>();
        }
        
        public override void AddObservables()
        {
            // Observables.Add("InSight", IsInSight);
            // Observables.Add("FacingAgent", FacingAgent);
        }
    }
}