using UnityEngine;
using System;
using System.Collections.Generic;

namespace MeshVoxelizerProject
{

    public class VoxelizerDemo : MonoBehaviour
    {
        public Transform TargetPrefab; //Target prefab to use in Dynamic envs

        public int size = 16;

        public bool drawAABBTree;

        private MeshVoxelizer m_voxelizer;

        void Start()
        {
            MeshFilter filter = GetComponent<MeshFilter>();
            MeshRenderer renderer = GetComponent<MeshRenderer>();

            if(filter == null || renderer == null)
            {
                filter = GetComponentInChildren<MeshFilter>();
                renderer = GetComponentInChildren<MeshRenderer>();
            }

            if (filter == null || renderer == null) return;
            
            // turn off this meshRenderer
            // renderer.enabled = false;

            Mesh mesh = filter.mesh;
            Material mat = renderer.material;

            Box3 bounds = new Box3(mesh.bounds.min, mesh.bounds.max);

            m_voxelizer = new MeshVoxelizer(size, size, size);
            m_voxelizer.Voxelize(mesh.vertices, mesh.triangles, bounds);
            // multiply scale to match parent's
            Vector3 scale = new Vector3(bounds.Size.x / size, bounds.Size.y / size, bounds.Size.z / size) * transform.parent.transform.localScale.x;
            Vector3 m = new Vector3(bounds.Min.x, bounds.Min.y, bounds.Min.z) * transform.parent.transform.localScale.x;
            mesh = CreateMesh(m_voxelizer.Voxels, scale, m);
            
            // do not create a voxelized mesh, we already instantiate a block per position
            // GameObject go = new GameObject("Voxelized");
            // go.transform.parent = transform;
            // go.transform.localPosition = Vector3.zero;
            // go.transform.localScale = Vector3.one;
            // go.transform.localRotation = Quaternion.identity;
            //
            // filter = go.AddComponent<MeshFilter>();
            // renderer = go.AddComponent<MeshRenderer>();
            //
            // filter.mesh = mesh;
            // renderer.material = mat;
        }

        private void OnRenderObject()
        {
            var camera = Camera.current;

            if (drawAABBTree && m_voxelizer != null)
            {
                Matrix4x4 m = transform.localToWorldMatrix;

                foreach (Box3 box in m_voxelizer.Bounds)
                {   
                    DrawLines.DrawBounds(camera, Color.red, box, m);
                }
            }

        }

        private Mesh CreateMesh(int[,,] voxels, Vector3 scale, Vector3 min)
        {
            List<Vector3> verts = new List<Vector3>();
            List<int> indices = new List<int>();

            for (int z = 0; z < size; z+=1)
            {
                for (int y = 0; y < size; y+=1)
                {
                    for (int x = 0; x < size; x+=1)
                    {
                        if (voxels[x, y, z] != 1) continue;

                        Vector3 pos = min + new Vector3(x * scale.x, y * scale.y, z * scale.z);
                        
                        // if (x == size - 1 || voxels[x + 1, y, z] == 0)
                        //     AddRightQuad(verts, indices, scale, pos);
                        //
                        // if (x == 0 || voxels[x - 1, y, z] == 0)
                        //     AddLeftQuad(verts, indices, scale, pos);
                        //
                        // if (y == size - 1 || voxels[x, y + 1, z] == 0)
                        //     AddTopQuad(verts, indices, scale, pos);

                        // if (y == 0 || voxels[x, y - 1, z] == 0)
                           // AddBottomQuad(verts, indices, scale, pos);

                        if (z == size - 1 || voxels[x, y, z + 1] == 0)
                        {
                            // AddFrontQuad(verts, indices, scale, pos);
                            // print("y:" + y);
                            var shift = 0.5f;
                            Vector3 pos_prefab = min + new Vector3((x + shift) * scale.x, (y + shift) * scale.y , (z + shift) * scale.z) ;
                            // Vector3 pos_prefab = min + new Vector3((x+0.5f) * scale.x, (y+0.5f) * scale.y , z * scale.z * 1.04f) ;
                            var new_cube = Instantiate(TargetPrefab,transform.parent.transform.position + pos_prefab, Quaternion.identity, transform);
                            new_cube.transform.localScale = new Vector3(size/400f, size/400f, size/2000f);
                            // LineRenderer lineRenderer = new_cube.GetComponent<LineRenderer>();
                            // lineRenderer.SetVertexCount(2);
                            // lineRenderer.SetPosition(0, new_cube.position);
                            // lineRenderer.SetPosition(1, new_cube.forward + new_cube.position);
                        }
                        
                        if (z == 0 || voxels[x, y, z - 1] == 0)
                        {
                            // AddBackQuad(verts, indices, scale, pos);
                            var shift = 0.5f;
                            Vector3 pos_prefab = min + new Vector3((x + shift) * scale.x, (y + shift) * scale.y , (z + shift) * scale.z) ;
                            var new_cube = Instantiate(TargetPrefab, transform.parent.transform.position + pos_prefab, Quaternion.identity, transform);
                            new_cube.transform.localScale = new Vector3(size/400f, size/400f, size/2000f);
                            new_cube.transform.Rotate(new Vector3(-180, 0, 0));
 
                            // LineRenderer lineRenderer = new_cube.GetComponent<LineRenderer>();
                            // lineRenderer.SetVertexCount(2);
                            // lineRenderer.SetPosition(0, new_cube.position);
                            // lineRenderer.SetPosition(1, new_cube.forward + new_cube.position);

                        }
                    }
                }
            }

            if(verts.Count > 65000)
            {
                Debug.Log("Mesh has too many verts. You will have to add code to split it up.");
                return new Mesh();
            }

            Mesh mesh = new Mesh();
            mesh.SetVertices(verts);
            mesh.SetTriangles(indices, 0);

            mesh.RecalculateBounds();
            mesh.RecalculateNormals();

            return mesh;
        }

        private void AddRightQuad(List<Vector3> verts, List<int> indices, Vector3 scale, Vector3 pos)
        {
            int count = verts.Count;

            verts.Add(pos + new Vector3(1 * scale.x, 0 * scale.y, 1 * scale.z));
            verts.Add(pos + new Vector3(1 * scale.x, 1 * scale.y, 0 * scale.z));
            verts.Add(pos + new Vector3(1 * scale.x, 0 * scale.y, 0 * scale.z));

            verts.Add(pos + new Vector3(1 * scale.x, 0 * scale.y, 1 * scale.z));
            verts.Add(pos + new Vector3(1 * scale.x, 1 * scale.y, 1 * scale.z));
            verts.Add(pos + new Vector3(1 * scale.x, 1 * scale.y, 0 * scale.z));

            indices.Add(count + 2); indices.Add(count + 1); indices.Add(count + 0);
            indices.Add(count + 5); indices.Add(count + 4); indices.Add(count + 3);
        }

        private void AddLeftQuad(List<Vector3> verts, List<int> indices, Vector3 scale, Vector3 pos)
        {
            int count = verts.Count;

            verts.Add(pos + new Vector3(0 * scale.x, 0 * scale.y, 1 * scale.z));
            verts.Add(pos + new Vector3(0 * scale.x, 1 * scale.y, 0 * scale.z));
            verts.Add(pos + new Vector3(0 * scale.x, 0 * scale.y, 0 * scale.z));

            verts.Add(pos + new Vector3(0 * scale.x, 0 * scale.y, 1 * scale.z));
            verts.Add(pos + new Vector3(0 * scale.x, 1 * scale.y, 1 * scale.z));
            verts.Add(pos + new Vector3(0 * scale.x, 1 * scale.y, 0 * scale.z));

            indices.Add(count + 0); indices.Add(count + 1); indices.Add(count + 2);
            indices.Add(count + 3); indices.Add(count + 4); indices.Add(count + 5);
        }

        private void AddTopQuad(List<Vector3> verts, List<int> indices, Vector3 scale, Vector3 pos)
        {
            int count = verts.Count;

            verts.Add(pos + new Vector3(0 * scale.x, 1 * scale.y, 1 * scale.z));
            verts.Add(pos + new Vector3(1 * scale.x, 1 * scale.y, 0 * scale.z));
            verts.Add(pos + new Vector3(0 * scale.x, 1 * scale.y, 0 * scale.z));

            verts.Add(pos + new Vector3(0 * scale.x, 1 * scale.y, 1 * scale.z));
            verts.Add(pos + new Vector3(1 * scale.x, 1 * scale.y, 1 * scale.z));
            verts.Add(pos + new Vector3(1 * scale.x, 1 * scale.y, 0 * scale.z));

            indices.Add(count + 0); indices.Add(count + 1); indices.Add(count + 2);
            indices.Add(count + 3); indices.Add(count + 4); indices.Add(count + 5);
        }

        private void AddBottomQuad(List<Vector3> verts, List<int> indices, Vector3 scale, Vector3 pos)
        {
            int count = verts.Count;

            verts.Add(pos + new Vector3(0 * scale.x, 0 * scale.y, 1 * scale.z));
            verts.Add(pos + new Vector3(1 * scale.x, 0 * scale.y, 0 * scale.z));
            verts.Add(pos + new Vector3(0 * scale.x, 0 * scale.y, 0 * scale.z));

            verts.Add(pos + new Vector3(0 * scale.x, 0 * scale.y, 1 * scale.z));
            verts.Add(pos + new Vector3(1 * scale.x, 0 * scale.y, 1 * scale.z));
            verts.Add(pos + new Vector3(1 * scale.x, 0 * scale.y, 0 * scale.z));

            indices.Add(count + 2); indices.Add(count + 1); indices.Add(count + 0);
            indices.Add(count + 5); indices.Add(count + 4); indices.Add(count + 3);
        }

        private void AddFrontQuad(List<Vector3> verts, List<int> indices, Vector3 scale, Vector3 pos)
        {
            int count = verts.Count;

            verts.Add(pos + new Vector3(0 * scale.x, 1 * scale.y, 1 * scale.z));
            verts.Add(pos + new Vector3(1 * scale.x, 0 * scale.y, 1 * scale.z));
            verts.Add(pos + new Vector3(0 * scale.x, 0 * scale.y, 1 * scale.z));

            verts.Add(pos + new Vector3(0 * scale.x, 1 * scale.y, 1 * scale.z));
            verts.Add(pos + new Vector3(1 * scale.x, 1 * scale.y, 1 * scale.z));
            verts.Add(pos + new Vector3(1 * scale.x, 0 * scale.y, 1 * scale.z));

            indices.Add(count + 2); indices.Add(count + 1); indices.Add(count + 0);
            indices.Add(count + 5); indices.Add(count + 4); indices.Add(count + 3);
        }

        private void AddBackQuad(List<Vector3> verts, List<int> indices, Vector3 scale, Vector3 pos)
        {
            int count = verts.Count;

            verts.Add(pos + new Vector3(0 * scale.x, 1 * scale.y, 0 * scale.z));
            verts.Add(pos + new Vector3(1 * scale.x, 0 * scale.y, 0 * scale.z));
            verts.Add(pos + new Vector3(0 * scale.x, 0 * scale.y, 0 * scale.z));

            verts.Add(pos + new Vector3(0 * scale.x, 1 * scale.y, 0 * scale.z));
            verts.Add(pos + new Vector3(1 * scale.x, 1 * scale.y, 0 * scale.z));
            verts.Add(pos + new Vector3(1 * scale.x, 0 * scale.y, 0 * scale.z));

            indices.Add(count + 0); indices.Add(count + 1); indices.Add(count + 2);
            indices.Add(count + 3); indices.Add(count + 4); indices.Add(count + 5);
        }

    }

}