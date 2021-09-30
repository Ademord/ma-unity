/* 
*   Tiny YOLO v3
*   Copyright (c) 2021 Yusuf Olokoba.
*/

namespace NatSuite.ML.Visualizers {

    using UnityEngine;
    using UnityEngine.UI;

    /// <summary>
    /// </summary>
    public class TinyYOLOv3Detection : MonoBehaviour {

        #region --Client API--
        /// <summary>
        /// Render an object detection rectangle.
        /// </summary>
        /// <param name="image">Image panel that detection is displayed on.</param>
        /// <param name="rect">Normalized detection rect.</param>
        /// <param name="label">Detection label</param>
        public void Render (RawImage image, Rect rect, string label, float score) {
            // Position
            var transform = this.transform as RectTransform;
            var imageTransform = image.transform as RectTransform;
            transform.anchorMin = 0.5f * Vector2.one;
            transform.anchorMax = 0.5f * Vector2.one;
            transform.pivot = Vector2.zero;
            transform.sizeDelta = Vector2.Scale(imageTransform.rect.size, rect.size);
            transform.anchoredPosition = Rect.NormalizedToPoint(imageTransform.rect, rect.position);
            // Display label
            labelText.text = $"{label}: {score:0.##}";
        }
        #endregion


        #region --Operations--
        [SerializeField] protected Text labelText;
        #endregion
    }
}