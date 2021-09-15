using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace Ademord
{
    public class VFXController : MonoBehaviour
    {
        // public BlockWorld World { get; private set; }
        protected GameObject m_VFX;

        // public SceneDrone m_Drone { get; protected set; }
        [SerializeField] [Tooltip("Drone's Scanner Eye.")]
        protected ScannerController m_ScannerComponent;

        // damping of VFX rotation
        protected float damping = 10;

        public void Initialize()
        {
            m_VFX = GameObject.Find("VFX");
        }

        public void RotateVFXToTarget(GameObject target)
        {
            if (m_VFX != null)
            {
                // m_VFX.transform.LookAt(target.transform);
                // var desiredRotQ = Quaternion.LookRotation(delta, Vector3.up);

                // TODO look if it is necessary
                m_VFX.transform.LookAt(target.transform);
                m_ScannerComponent.transform.LookAt(target.transform);

                // Quaternion OriginalRot = m_VFX.transform.rotation;
                // Quaternion NewRot = m_VFX.transform.rotation;
                // m_VFX.transform.rotation = OriginalRot;
                // m_VFX.transform.rotation = Quaternion.Lerp(m_VFX.transform.rotation, NewRot, damping * Time.deltaTime);

                // Vector3 lTargetDir = target.transform.position - m_VFX.transform.position;
                // lTargetDir.y = 0.0f;
                // m_VFX.transform.localRotation = Quaternion.RotateTowards(m_VFX.transform.localRotation,
                //     Quaternion.LookRotation(lTargetDir), (1f * Time.deltaTime) *  5);
            }
        }

        public void ResetVFX()
        {
            // print("trying to reset VFX after scanning");

            m_ScannerComponent.Reset();
            if (m_VFX != null)
            {
                var rotation = m_VFX.transform.rotation;
                // m_VFX.transform.localRotation = 
                var desiredRotQ = new Quaternion(0, rotation.y, 0, rotation.w);
                m_VFX.transform.rotation = Quaternion.Lerp(rotation, desiredRotQ, Time.deltaTime * damping);
            }
            // scanned = false;
        }
    }
}