using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace Ademord
{
    public class MagneticNorth : MonoBehaviour
    {
        int rotationsPerMinute = 10;

        void Update()
        {
            var angle = 6 * rotationsPerMinute * Time.deltaTime;
            transform.Rotate(0, 0, angle);
        }
    }
}