using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace Ademord
{
    public class Sun : MonoBehaviour
    {
        int rotationsPerMinute = 10;
        [SerializeField] private bool EnableRotation = false;
        void Update()
        {
            if (EnableRotation)
            {
                var angle = 6 * rotationsPerMinute * Time.deltaTime;
                transform.Rotate(0, angle, 0);
            }
        }
    }
}