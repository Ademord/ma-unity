using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace Ademord
{
    public class VFXController : MonoBehaviour
    {

        // public SceneDrone m_Drone { get; protected set; }
        // [SerializeField] 
        // [Tooltip("Drone's Scanner Eye.")]
        // protected ScannerController m_ScannerComponent;
        
        [SerializeField] protected GameObject m_ScanningLight;
        [SerializeField] protected GameObject m_FlickeringLight;
        [SerializeField] protected GameObject m_VFXOffReplacementSphere;
        // [SerializeField] protected bool useVFX = true;

        // damping of VFX rotation
        protected float damping = 10;
        protected Quaternion DefRotation;

        private void Start()
        {
            if (!gameObject.activeInHierarchy)
            {
                m_VFXOffReplacementSphere.SetActive(true);
            }
            
        }

        public void RotateVFXToTarget(GameObject target)
        {
            if (gameObject.activeInHierarchy)
            {
                m_ScanningLight.SetActive(false);
                m_FlickeringLight.SetActive(true);
                // transform.LookAt(target.transform);
                // m_ScannerComponent.transform.LookAt(target.transform);
            }

            // if (m_VFX != null)
            // {
            //     // m_VFX.transform.LookAt(target.transform);
            //     // var desiredRotQ = Quaternion.LookRotation(delta, Vector3.up);
            //
            //     // TODO look if it is necessary
            //     transform.LookAt(target.transform);
            //     m_ScannerComponent.transform.LookAt(target.transform);
            //
            //     // Quaternion OriginalRot = m_VFX.transform.rotation;
            //     // Quaternion NewRot = m_VFX.transform.rotation;
            //     // m_VFX.transform.rotation = OriginalRot;
            //     // m_VFX.transform.rotation = Quaternion.Lerp(m_VFX.transform.rotation, NewRot, damping * Time.deltaTime);
            //
            //     // Vector3 lTargetDir = target.transform.position - m_VFX.transform.position;
            //     // lTargetDir.y = 0.0f;
            //     // m_VFX.transform.localRotation = Quaternion.RotateTowards(m_VFX.transform.localRotation,
            //     //     Quaternion.LookRotation(lTargetDir), (1f * Time.deltaTime) *  5);
            // }
        }

        public void ResetVFX()
        {
            // print("trying to reset VFX after scanning");
            // if (m_VFX != null)
            if (gameObject.activeInHierarchy)
            {
                m_ScanningLight.SetActive(true);
                m_FlickeringLight.SetActive(false);

                // m_ScannerComponent.Reset();
                // var rotation = transform.rotation;
                // // m_VFX.transform.localRotation = 
                // var desiredRotQ = new Quaternion(0, rotation.y, 0, rotation.w);
                // transform.rotation = Quaternion.Lerp(rotation, DefRotation, Time.deltaTime * damping);
            }
        }
    }
}