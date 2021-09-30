/* 
*   Detector Cam
*   Copyright (c) 2021 Yusuf Olokoba.
*/

using System.Collections.Generic;

namespace NatSuite.Examples {

    using UnityEngine;
    using NatSuite.ML;
    using NatSuite.ML.Features;
    using NatSuite.ML.Vision;
    using NatSuite.ML.Visualizers;

    public class NatDetectorCam : MonoBehaviour, IDetectorCamera
    {
        [Header("Visualization")]
        public TinyYOLOv3Visualizer visualizer;

        public Camera previewCamera;
        // private Texture2D previewTexture;
        Texture2D webcamTexture;
        MLModelData modelData;
        MLModel model;
        TinyYOLOv3Predictor predictor;
        public string accessKey;
        List<string> detections = new List<string>();

        public List<string> GetDetections() => detections;

        private int resWidth = 256;
        private int resHeight = 256;
        
        public async void Initialize () {
            // Start the camera preview
            if (previewCamera == null) Debug.LogError("previewCamera is null");
            RectTransform canvasRect = visualizer.transform.parent.GetComponent<Canvas>().GetComponent<RectTransform>();
            resWidth = (int) canvasRect.rect.width; resHeight = (int) canvasRect.rect.height;
            // print("reswidth: " + canvasRect.rect.width); print("resheight: " + canvasRect.rect.height);
        
            float cachedCameraAspect = previewCamera.aspect;
            previewCamera.targetTexture = new RenderTexture(resWidth, resHeight, 24);;
            previewCamera.aspect = cachedCameraAspect;

            // Display the camera preview
            visualizer.Render(previewCamera.targetTexture);
            // Fetch the model data
            modelData = await MLModelData.FromHub("@natsuite/tiny-yolo-v3", accessKey);
            // Deserialize the model
            model = modelData.Deserialize();
            // Create the Predictor
            predictor = new TinyYOLOv3Predictor(model, modelData.labels);
        }

        void Update () {
            // Check that the model has been downloaded
            if (predictor == null) return;
            // Predict
            var input = new MLImageFeature(toTexture2D(previewCamera.targetTexture));
            (input.mean, input.std) = modelData.normalization;
            input.aspectMode = modelData.aspectMode;
            var currentDetections = predictor.Predict(input);
            // Visualize
            visualizer.Render(previewCamera.targetTexture, currentDetections);
            // Store
            detections.Clear();
            foreach (var detection in currentDetections)
            {
                detections.Add(detection.label);
                // Debug.Log($"Image contains {detection.label} with confidence {detection.score}");
            }
        }

        void OnDisable () {
            // Dispose the predictor and model
            model?.Dispose();
        }
        
        Texture2D toTexture2D(RenderTexture rTex)
        {
            // print("rendertexture rTex.width: " + rTex.width);
            Texture2D tex = new Texture2D(rTex.width, rTex.height, TextureFormat.RGB24, false);
            // ReadPixels looks at the active RenderTexture.
            RenderTexture.active = rTex;
            tex.ReadPixels(new Rect(0, 0, rTex.width, rTex.height), 0, 0);
            tex.Apply();
            return tex;
        }
        
    }
}