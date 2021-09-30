/* 
*   Tiny YOLO v3
*   Copyright (c) 2021 Yusuf Olokoba.
*/

namespace NatSuite.ML.Vision {

    using System;
    using System.Collections.Generic;
    using UnityEngine;
    using NatSuite.ML.Extensions;
    using NatSuite.ML.Features;
    using NatSuite.ML.Internal;
    using NatSuite.ML.Types;

    /// <summary>
    /// Tiny YOLO v3 predictor for general object detection.
    /// This predictor accepts an image feature and produces a list of detections.
    /// Each detection is comprised of a normalized rect, label, and detection score.
    /// </summary>
    public sealed class TinyYOLOv3Predictor : IMLPredictor<(Rect rect, string label, float score)[]> {

        #region --Client API--
        /// <summary>
        /// Class labels.
        /// </summary>
        public readonly string[] labels;

        /// <summary>
        /// Create the TinyYOLO v3 predictor.
        /// </summary>
        /// <param name="model">TinyYOLO v3 ML model.</param>
        /// <param name="labels">Classification labels.</param>
        public TinyYOLOv3Predictor (MLModel model, string[] labels) {
            this.model = model;
            this.labels = labels;
            this.inputType = new MLImageType(416, 416, typeof(float));
        }

        /// <summary>
        /// Detect objects in an image.
        /// </summary>
        /// <param name="inputs">Input image.</param>
        /// <returns>Detected objects in normalized coordinates.</returns>
        public unsafe (Rect rect, string label, float score)[] Predict (params MLFeature[] inputs) {
            // Check
            if (inputs.Length != 1)
                throw new ArgumentException(@"Tiny YOLO v3 predictor expects a single feature", nameof(inputs));
            // Check type
            var input = inputs[0];
            if (!input.GetImageSize(out var imageWidth, out var imageHeight))
                throw new ArgumentException(@"Tiny YOLO v3 predictor expects an an array or image feature", nameof(inputs));
            // Predict
            var inputSize = new MLArrayFeature<float>(new [] { (float)imageHeight, imageWidth }, new [] { 1, 2 });
            var inputFeature = (input as IMLFeature).Create(inputType);
            var sizeFeature = (inputSize as IMLFeature).Create(inputSize.type);
            var outputFeatures = model.Predict(inputFeature, sizeFeature);
            inputFeature.ReleaseFeature();
            sizeFeature.ReleaseFeature();
            // Marshal
            var boxes = new MLArrayFeature<float>(outputFeatures[0]);   // (1,P,4)
            var scores = new MLArrayFeature<float>(outputFeatures[1]);  // (1,80,P)
            var classes = new MLArrayFeature<int>(outputFeatures[2]);   // (1,P,3)
            var (widthInv, heightInv) = (1f / imageWidth, 1f / imageHeight);
            var result = new List<(Rect, string, float)>();
            for (var i = 0; i < classes.shape[1]; i++) {
                var classIdx = classes[0,i,1];
                var boxIdx = classes[0,i,2];
                var rect = Rect.MinMaxRect(
                    boxes[0,boxIdx,1] * widthInv,
                    (imageHeight - boxes[0,boxIdx,2]) * heightInv,
                    boxes[0,boxIdx,3] * widthInv,
                    (imageHeight - boxes[0,boxIdx,0]) * heightInv
                );
                var label = labels[classIdx];
                var score = scores[0,classIdx,boxIdx];
                result.Add((rect, label, score));
            }
            foreach (var feature in outputFeatures)
                feature.ReleaseFeature();
            // Return
            return result.ToArray();
        }
        #endregion


        #region --Operations--
        private readonly IMLModel model;
        private readonly MLImageType inputType;

        void IDisposable.Dispose () { } // Not used
        #endregion
    }
}