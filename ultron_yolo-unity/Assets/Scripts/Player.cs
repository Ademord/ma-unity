using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Player : MonoBehaviour
{
    public SnapshotCamera snapCam;
    public DetectorCamera detectorCam;
    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        detectorCam.CallTakeSnapshot();

        // if (Input.GetKeyDown(KeyCode.Space))
        // {
        //     detectorCam.CallTakeSnapshot();
        //     // snapCam.CallTakeSnapshot();
        // }

    }
}
