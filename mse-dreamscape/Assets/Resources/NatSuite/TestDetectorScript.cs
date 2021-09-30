using UnityEngine;
using NatSuite.ML;
using NatSuite.ML.Features;
using NatSuite.ML.Vision;

public class TestDetectorScript : MonoBehaviour {
    
    [Header(@"NatML Hub")]
    public string accessKey;
    
    [Header(@"Prediction")]
    public Texture2D image;
    
    async void Start () {
        // Fetch the model data from Hub
        Debug.Log("Fetching model data from Hub");
        var modelData = await MLModelData.FromHub("@natsuite/tiny-yolo-v3", accessKey);
        // var modelData = await MLModelData.FromHub("@natsuite/mobilenet-v2", accessKey);
        // Deserialize the model
        var model = modelData.Deserialize();
        // Create the classification predictor
        var predictor = new TinyYOLOv3Predictor(model, modelData.labels);
        // Create an image feature and apply normalization
        var input = new MLImageFeature(image);
        (input.mean, input.std) = modelData.normalization;
        input.aspectMode = modelData.aspectMode;
        // Classify the image
        var detections = predictor.Predict(input);
        // Visualize
        Debug.Log("detections.Count" + detections.Length);
        foreach (var detection in detections)
        {
            Debug.Log($"Image contains {detection.label} with confidence {detection.score}");
        }        
        // Dispose the model
        model.Dispose();        
    }
}