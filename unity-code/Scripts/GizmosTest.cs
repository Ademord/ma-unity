using UnityEngine;
using Gizmos = Popcron.Gizmos;

[ExecuteAlways]
public class GizmosTest : MonoBehaviour
{
    //this will draw in scene view and in game view, in both play mode and edit mode
    private void OnRenderObject()
    {
        //draw a line from the position of the object, to world center
        //with the color green, and dashed as well
        Gizmos.Line(transform.position, Vector3.one, Color.green, true);

        //draw a cube at the position of the object, with the correct rotation and scale
        Gizmos.Cube(transform.position, transform.rotation, transform.lossyScale);
        Gizmos.Cube(transform.position, transform.rotation,  new Vector3(3f, 3f, 3f), Color.green);

        print("rendering gizmos: " + Gizmos.Enabled);
    }

    private void Update()
    {
        //use custom material, if null it uses a default line material
        // PopGizmos.Material = material;
        
        //toggle gizmo drawing
        if (Input.GetKeyDown(KeyCode.F3))
        {
            Gizmos.Enabled = !Gizmos.Enabled;
        }
        
        //draw a cube at the position of the object, with the correct rotation and scale
        Gizmos.Cube(transform.position, transform.rotation,  new Vector3(3f, 3f, 3f), Color.green);
        // //can also draw from update
        // PopGizmos.Cone(transform.position, transform.rotation, 15f, 45f, Color.green);
    }
}