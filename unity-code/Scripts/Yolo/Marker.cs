using UnityEngine;
using UI = UnityEngine.UI;

namespace Yolo {

    sealed class Marker : MonoBehaviour
    {
        RectTransform _parent;
        RectTransform _xform;
        UI.Image _panel;
        UI.Text _label;

        void Start()
        {
            // print("creating new marker with parent: " + transform.parent);
            _xform = GetComponent<RectTransform>();
            // _parent = (RectTransform)_xform.parent;
            // _parent = (RectTransform)_xform.parent;
            _parent = transform.GetComponentInParent<Canvas>().GetComponent<RectTransform>();
            // print("parent: " + _parent.name);
            // print("xform parent check is null" + (_xform.parent == null));
            _panel = GetComponent<UI.Image>();
            _label = GetComponentInChildren<UI.Text>();
        }

        public void SetAttributes(in BoundingBox box)
        {
            // print(_parent.GetType());
            var rect = _parent.rect;
            // var rect = transform.GetComponentInParent<Canvas>().GetComponent<RectTransform>().rect;    
            // Bounding box position
            var x = box.x * rect.width;
            var y = (1 - box.y) * rect.height;
            var w = box.w * rect.width;
            var h = box.h * rect.height;

            _xform.anchoredPosition = new Vector2(x, y);
            _xform.SetSizeWithCurrentAnchors(RectTransform.Axis.Horizontal, w);
            _xform.SetSizeWithCurrentAnchors(RectTransform.Axis.Vertical, h);

            // Label (class name + score)
            var name = Config.GetLabel((int)box.classIndex);
            _label.text = $"{name} {(int)(box.score * 100)}%";

            // Panel color
            var hue = box.classIndex * 0.073f % 1.0f;
            var color = Color.HSVToRGB(hue, 1, 1);
            color.a = 0.4f;
            _panel.color = color;

            // Enable
            gameObject.SetActive(true);
        }

        public void Hide()
            => gameObject.SetActive(false);
    }

} // namespace TinyYoloV2