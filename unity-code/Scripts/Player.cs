using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Player : MonoBehaviour
{
    public SnapshotCamera snapCam;
    public DetectorCamera detectorCam;
    
    void Update()
    {
        detectorCam.CallTakeSnapshot();
    
        // if (Input.GetKeyDown(KeyCode.Space))
        // {
        //     snapCam.CallTakeSnapshot();
        // }

    }
}
