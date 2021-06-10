using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UI = UnityEngine.UI;
using Yolo;

[RequireComponent(typeof(Camera))]
public class DetectorCamera : MonoBehaviour
{
    #region Editable attributes

    [SerializeField, Range(0, 1)] float _scoreThreshold = 0.1f;
    [SerializeField, Range(0, 1)] float _overlapThreshold = 0.5f;
    [SerializeField] ResourceSet _resources = null;
    [SerializeField] Canvas _previewUI = null;
    [SerializeField] Marker _markerPrefab = null;

    // Thresholds are exposed to the runtime UI.
    public float scoreThreshold { set => _scoreThreshold = value; }
    public float overlapThreshold { set => _overlapThreshold = value; }

    #endregion
    
    #region Internal objects

    private Camera snapCam;
    private int resWidth = 256;
    private int resHeight = 256;
    
    ObjectDetector _detector;
    Marker[] _markers = new Marker[50];
    
    #endregion

    #region MonoBehaviour implementation
    void Awake()
    {
        snapCam = GetComponent<Camera>();
        RectTransform canvasRect = _previewUI.GetComponent<Canvas>().GetComponent<RectTransform>();
        resWidth = (int) canvasRect.rect.width;
        resHeight = (int) canvasRect.rect.height;
        print("reswidth: " + canvasRect.rect.width);
        print("resheight: " + canvasRect.rect.height);
        
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
        
        // Object detector initialization
        _detector = new ObjectDetector(_resources);
        // Marker populating
        for (var i = 0; i < _markers.Length; i++)
            _markers[i] = Instantiate(
                _markerPrefab, 
                _previewUI.transform);
    }
    void Start()
    {
       
    }

    // void OnDisable()
    // {
    //     _detector?.Dispose();
    //     _detector = null;
    // }

    // void OnDestroy()
    // {
    //     for (var i = 0; i < _markers.Length; i++) Destroy(_markers[i]);
    // }
    
    public void CallTakeSnapshot()
    {
        snapCam.gameObject.SetActive(true);
        
    }
    void LateUpdate()
    {
        if (snapCam.gameObject.activeInHierarchy)
        {
            // make the camera render and pass that texture to the object detector
            snapCam.Render();
            if (_detector != null)
            {
                _detector.ProcessImage(snapCam.targetTexture, _scoreThreshold, _overlapThreshold);

                // Marker update
                var i = 0;
                List<string> found = new List<string>();
                foreach (var box in _detector.DetectedObjects)
                {
                    if (i < _markers.Length)
                    {
                        var name = Config.GetLabel((int)box.classIndex);
                        found.Add(name);
                        _markers[i++].SetAttributes(box);
                    }
                    else
                    {
                        break;
                    }
                }
                print("found: " + String.Join(", ", found));

                for (; i < _markers.Length; i++) _markers[i].Hide();
            }
            else
            {
                print("could not show you detected objects, detector is null");
            }
        
            snapCam.gameObject.SetActive(false);
        }    
    }
    #endregion 
}