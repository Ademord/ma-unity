using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace Ademord
{
    public class Compass : MonoBehaviour
    {
        public Transform mPlayerTransform;
    
        [Tooltip("The direction towards which the compass points. Default for North is (0, 0, 1)")]
        public Vector3 kReferenceVector = new Vector3(0, 0, 1);
    
        // memalloc
        private Vector3 _mTempVector;
        private float _mTempAngle;

        // Update is called once per frame
        private void Update()
        {
            // get player transform, set y to 0 and normalize
            _mTempVector = mPlayerTransform.forward;
            _mTempVector.y = 0f;
            _mTempVector = _mTempVector.normalized;

            // get distance to reference, ensure y equals 0 and normalize
            _mTempVector = _mTempVector - kReferenceVector;
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
            transform.localRotation = Quaternion.AngleAxis(_mTempAngle, kReferenceVector);

        }
    }
}
