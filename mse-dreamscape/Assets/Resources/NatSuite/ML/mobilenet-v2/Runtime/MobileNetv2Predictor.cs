/* 
*   MobileNet v2
*   Copyright (c) 2021 Yusuf Olokoba.
*/

namespace NatSuite.ML.Vision {

    using System;
    using System.Linq;
    using NatSuite.ML.Extensions;
    using NatSuite.ML.Features;
    using NatSuite.ML.Internal;

    /// <summary>
    /// MobileNet v2 classification predictor.
    /// This predictor classifies an image with the ImageNet labels.
    /// </summary>
    public sealed class MobileNetv2Predictor : IMLPredictor<(string label, float confidence)> { // DEPLOY

        #region --Client API--
        /// <summary>
        /// Classification labels.
        /// </summary>
        public readonly string[] labels;

        /// <summary>
        /// Create the MobileNet v2 classification predictor.
        /// </summary>
        /// <param name="model">MobileNet v2 ML model.</param>
        /// <param name="labels">Classification labels.</param>
        public MobileNetv2Predictor (MLModel model, string[] labels) {
            this.model = model;
            this.labels = labels;
        }

        /// <summary>
        /// Classify an image.
        /// </summary>
        /// <param name="inputs">Input image feature.</param>
        /// <returns>Output label with unnormalized confidence value.</returns>
        public unsafe (string label, float confidence) Predict (params MLFeature[] inputs) {
            // Check
            if (inputs.Length != 1)
                throw new ArgumentException(@"MobileNet v2 predictor expects a single feature", nameof(inputs));
            // Check type
            var input = inputs[0];
            if (!input.GetImageSize(out var imageWidth, out var imageHeight))
                throw new ArgumentException(@"MobileNet v2 predictor expects an an array or image feature", nameof(inputs));
            // Predict
            var inputType = model.inputs[0];
            var inputFeature = (input as IMLFeature).Create(inputType);
            var outputFeatures = model.Predict(inputFeature);
            inputFeature.ReleaseFeature();
            // Find label
            var logits = new MLArrayFeature<float>(outputFeatures[0]);
            var argMax = Enumerable
                .Range(0, logits.shape[1])
                .Aggregate((i, j) => logits[0, i] > logits[0, j] ? i : j);
            var result = (labels[argMax], logits[argMax]);
            // Return
            foreach (var feature in outputFeatures)
                feature.ReleaseFeature();
            return result;
        }
        #endregion


        #region --Operations--
        private readonly IMLModel model;

        void IDisposable.Dispose () { } // Nop
        #endregion
    }
}