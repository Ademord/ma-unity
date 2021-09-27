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

    private Camera detectorCam;
    private int resWidth = 256;
    private int resHeight = 256;
    
    ObjectDetector _detector;
    Marker[] _markers = new Marker[50];
    List<string> detections = new List<string>();

    #endregion

    #region MonoBehaviour implementation
    void Awake()
    {
        detectorCam = GetComponent<Camera>();
        RectTransform canvasRect = _previewUI.GetComponent<Canvas>().GetComponent<RectTransform>();
        resWidth = (int) canvasRect.rect.width;
        resHeight = (int) canvasRect.rect.height;
        print("reswidth: " + canvasRect.rect.width);
        print("resheight: " + canvasRect.rect.height);
        
        if (detectorCam.targetTexture == null)
        {
            detectorCam.targetTexture = new RenderTexture(resWidth, resHeight, 24);
        }
        else
        {
            resWidth = detectorCam.targetTexture.width;
            resHeight = detectorCam.targetTexture.height;
        }
        detectorCam.gameObject.SetActive(false);
        
        // Object detector initialization
        _detector = new ObjectDetector(_resources);
        if (_detector == null)
        {
            Debug.LogError("Detector is null");
        }
        // Marker populating
        for (var i = 0; i < _markers.Length; i++)
            _markers[i] = Instantiate(
                _markerPrefab, 
                _previewUI.transform);
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
        detectorCam.gameObject.SetActive(true);
    }

    public List<string> GetDetections() => detections;
    
    void LateUpdate()
    {
        if (detectorCam.gameObject.activeInHierarchy)
        {
            // make the camera render and pass that texture to the object detector
            detectorCam.Render();
            if (_detector != null)
            {
                // print("trying to detect something...");
                detections.Clear();
                _detector.ProcessImage(detectorCam.targetTexture, _scoreThreshold, _overlapThreshold);
    
                // Marker update
                var i = 0;
                foreach (var box in _detector.DetectedObjects)
                {
                    if (i < _markers.Length)
                    {
                        var name = Config.GetLabel((int)box.classIndex);
                        detections.Add(name);

                        _markers[i++].SetAttributes(box);
                    }
                    else
                    {
                        break;
                    }
                }
                // print("found: " + String.Join(", ", detections));

                for (; i < _markers.Length; i++) _markers[i].Hide();
            }
            detectorCam.gameObject.SetActive(false);
        }    
    }
    #endregion 
}