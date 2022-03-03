using UnityEngine;
using System.Collections.Generic;

namespace Ademord
{
    public class GraphFactory : MonoBehaviour
    {
        [SerializeField]
        private bool m_FitBounds;
        [SerializeField]
        private Graph m_GraphPrefab;
        [SerializeField]
        private Camera m_TargetCamera;
        private Dictionary<string, Graph> m_Graphs;
        private bool HasGraphs => m_Graphs != null;

        public bool HasGraph(string name, out Graph graph)
        {
            LazyInit();
            return m_Graphs.TryGetValue(name, out graph);
        }

        public Graph AddGraph(string name, int width = 0, int height = 0)
        {
            LazyInit();

            Graph graph = Instantiate(m_GraphPrefab, transform);
            graph.transform.name = name;
            graph.Name = name;
            graph.FitBounds = m_FitBounds;

            if (width > 0)
            {
                graph.Size.x = width;
            }
            if (height > 0)
            {
                graph.Size.y = height;
            }
            
            graph.UpdateLayout();
            m_Graphs.Add(name, graph);

            return graph;
        }

        private void LazyInit()
        {
            if (!HasGraphs)
            {
                m_Graphs = new Dictionary<string, Graph>();

                // var cam = FindObjectOfType<Camera>(true);
                var cam = m_TargetCamera;
                GetComponent<Canvas>().worldCamera = cam;
                cam.gameObject.SetActive(true);
                gameObject.SetActive(true);
                // GetComponent<Canvas>().sortingLayerID = 0;
            }
        }

        private void Update()
        {
            if (HasGraphs && !m_FitBounds && Input.GetKeyDown(KeyCode.R))
            {
               foreach (var graph in m_Graphs.Values)
               {
                    graph.ResetBounds();
               }
            }
        }

        private void OnValidate()
        {
            if (HasGraphs)
            {
                foreach (var graph in m_Graphs.Values)
                {
                    graph.FitBounds = m_FitBounds;
                    graph.ResetBounds();
                }
            }
        }
    }
}