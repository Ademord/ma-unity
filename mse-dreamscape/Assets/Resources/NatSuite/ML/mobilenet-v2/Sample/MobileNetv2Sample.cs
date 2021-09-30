/* 
*   MobileNet v2
*   Copyright (c) 2021 Yusuf Olokoba.
*/

namespace NatSuite.Examples {

    using System.Threading.Tasks;
    using UnityEngine;
    using UnityEngine.UI;
    using NatSuite.ML;
    using NatSuite.ML.Features;
    using NatSuite.ML.Vision;

    public sealed class MobileNetv2Sample : MonoBehaviour {

        [Header(@"NatML Hub")]
        public string accessKey;

        [Header(@"Prediction")]
        public Texture2D image;
        public RawImage rawImage;
        public AspectRatioFitter aspectFitter;

        MLModelData modelData;
        MLModel model;
        MobileNetv2Predictor predictor;

        async void Start () {
            Debug.Log("Fetching model from NatML Hub");
            // Fetch model data from NatML Hub
            modelData = await MLModelData.FromHub("@natsuite/mobilenet-v2", accessKey);
            // Deserialize the model
            model = modelData.Deserialize();
            // Create the predictor
            predictor = new MobileNetv2Predictor(model, modelData.labels);
            // Create input feature
            var inputFeature = new MLImageFeature(image);
            (inputFeature.mean, inputFeature.std) = modelData.normalization;
            // Classify
            var (label, score) = predictor.Predict(inputFeature);
            // Display
            rawImage.texture = image;
            aspectFitter.aspectRatio = (float)image.width / image.height;
            Debug.Log($"Predicted {label} with confidence {score:0.##}");
        }
    }
}