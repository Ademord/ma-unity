/* 
*   Tiny YOLO v3
*   Copyright (c) 2021 Yusuf Olokoba.
*/

namespace NatSuite.Examples {

    using UnityEngine;
    using NatSuite.ML;
    using NatSuite.ML.Features;
    using NatSuite.ML.Vision;
    using NatSuite.ML.Visualizers;
    using Stopwatch = System.Diagnostics.Stopwatch;

    public sealed class TinyYOLOv3Sample : MonoBehaviour {

        [Header(@"NatML Hub")]
        public string accessKey;

        [Header(@"Prediction")]
        public Texture2D image;

        [Header(@"UI")]
        public TinyYOLOv3Visualizer visualizer;

        async void Start () {
            Debug.Log("Fetching model from NatML Hub...");
            // Fetch model data from NatML Hub
            var modelData = await MLModelData.FromHub("@natsuite/tiny-yolo-v3", accessKey);
            // Deserialize the model
            var model = modelData.Deserialize();
            // Create the Tiny YOLO v3 predictor
            var predictor = new TinyYOLOv3Predictor(model, modelData.labels);
            // Create input feature
            var inputFeature = new MLImageFeature(image);
            (inputFeature.mean, inputFeature.std) = modelData.normalization;
            inputFeature.aspectMode = modelData.aspectMode;
            // Detect
            var watch = Stopwatch.StartNew();
            var detections = predictor.Predict(inputFeature);
            watch.Stop();
            // Visualize
            Debug.Log($"Detected {detections.Length} objects after {watch.Elapsed.TotalMilliseconds}ms");
            visualizer.Render(image, detections);
            // Dispose the model
            model.Dispose();
        }
    }
}