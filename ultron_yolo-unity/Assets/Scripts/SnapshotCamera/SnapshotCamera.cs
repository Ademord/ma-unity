using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

[RequireComponent(typeof(Camera))]
public class SnapshotCamera : MonoBehaviour
{
    #region Internal objects

    private Camera snapCam;

    private int resWidth = 256;
    private int resHeight = 256;
    #endregion

    #region MonoBehaviour implementation
    void Awake()
    {
        snapCam = GetComponent<Camera>();
        if (snapCam.targetTexture == null)
        {
            snapCam.targetTexture = new RenderTexture(resWidth, resHeight, 24);
        }
        else
        {
            resWidth = snapCam.targetTexture.width;
            resHeight = snapCam.targetTexture.height;
        }

        snapCam.gameObject.SetActive(false);
    }
    
    public void CallTakeSnapshot()
    {
        snapCam.gameObject.SetActive(true);
        
    }

    void LateUpdate()
    {
        if (snapCam.gameObject.activeInHierarchy)
        {
            // create a texture2d
            Texture2D snapshot = new Texture2D(resWidth, resHeight, TextureFormat.RGB24, false);
            snapCam.Render();
            // take pixels from camera into texture
            RenderTexture.active = snapCam.targetTexture;
            snapshot.ReadPixels(new Rect(0, 0, resWidth, resHeight), 0, 0);
            // save texture
            byte[] bytes = snapshot.EncodeToPNG();
            string fileName = SnapshotName();
            System.IO.File.WriteAllBytes(fileName, bytes);
            Debug.Log("snapshot taken");
            
            snapCam.gameObject.SetActive(false);

        }    
    }

    string SnapshotName()
    {
        return string.Format("{0}/Snapshots/snap_{1}x{2}_{3}.png",
            Application.dataPath, 
            resWidth, 
            resHeight, 
            DateTime.Now.ToString("yyyy-MM-dd_HH-mm-ss"));
    }
    #endregion 
}
