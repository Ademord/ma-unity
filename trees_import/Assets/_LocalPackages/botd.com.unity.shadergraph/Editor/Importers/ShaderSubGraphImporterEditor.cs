using UnityEditor;

using UnityEngine;
using Debug = System.Diagnostics.Debug;

[CustomEditor(typeof(ShaderSubGraphImporter))]
public class ShaderSubGraphImporterEditor : UnityEditor.AssetImporters.ScriptedImporterEditor
{
    public override void OnInspectorGUI()
    {
        if (GUILayout.Button("Open Shader Editor"))
        {
            AssetImporter importer = target as AssetImporter;
            Debug.Assert(importer != null, "importer != null");
            ShaderGraphImporterEditor.ShowGraphEditWindow(importer.assetPath);
        }
    }
}
