/* 
*   Detector Cam
*   Copyright (c) 2021 Yusuf Olokoba.
*/

namespace NatSuite.Examples {

    using UnityEngine;
    using NatSuite.ML;
    using NatSuite.ML.Features;
    using NatSuite.ML.Vision;
    using NatSuite.ML.Visualizers;

    public class NatDetectorCam : MonoBehaviour {

        [Header("Visualization")]
        public TinyYOLOv3Visualizer visualizer;

        public Camera previewCamera;
        // private Texture2D previewTexture;
        Texture2D webcamTexture;
        MLModelData modelData;
        MLModel model;
        TinyYOLOv3Predictor predictor;
        public string accessKey;
       
        async void Start () {
            // Start the camera preview
            if (previewCamera == null) Debug.LogError("previewCamera is null");
            if (previewCamera.targetTexture == null)
            {
                Debug.Log("detectorCam.targetTexture is null.. setting..");
                RectTransform canvasRect = visualizer.GetComponent<Canvas>().GetComponent<RectTransform>();
                previewCamera.targetTexture = new RenderTexture((int) canvasRect.rect.width, (int) canvasRect.rect.height, 24);
            }

            // inefficient
            var previewTexture = toTexture2D(previewCamera.targetTexture);

            // Display the camera preview
            visualizer.Render(previewTexture);
            
            // Fetch the model data
            Debug.Log("Fetching model from NatML Hub");
            modelData = await MLModelData.FromHub("@natsuite/tiny-yolo-v3", accessKey);

            // Deserialize the model
            model = modelData.Deserialize();
            
            // Create the Predictor
            predictor = new TinyYOLOv3Predictor(model, modelData.labels);
        }

        void Update () {
            // inefficient
            var previewTexture = toTexture2D(previewCamera.targetTexture);
            
            // Check that the model has been downloaded
            if (predictor == null) return;
            else print("model was found");
            
            // Predict
            var input = new MLImageFeature(previewTexture);
            (input.mean, input.std) = modelData.normalization;
            input.aspectMode = modelData.aspectMode;
            var detections = predictor.Predict(input);
            
            // Visualize
            visualizer.Render(previewTexture, detections);
            Debug.Log("detections.Count" + detections.Length);
            foreach (var detection in detections)
            {
                Debug.Log($"Image contains {detection.label} with confidence {detection.score}");
            }
        }

        void OnDisable () {
            // Dispose the predictor and model
            model?.Dispose();
        }
        
        Texture2D toTexture2D(RenderTexture rTex)
        {
            Texture2D tex = new Texture2D(512, 512, TextureFormat.RGB24, false);
            // ReadPixels looks at the active RenderTexture.
            RenderTexture.active = rTex;
            tex.ReadPixels(new Rect(0, 0, rTex.width, rTex.height), 0, 0);
            tex.Apply();
            return tex;
        }
    }
}