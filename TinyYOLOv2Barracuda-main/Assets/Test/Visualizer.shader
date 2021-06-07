Shader "Hidden/TinyYOLOv2/Visualizer"
{
    CGINCLUDE

    #include "UnityCG.cginc"
    #include "../Shader/Common.hlsl"

    StructuredBuffer<BoundingBox> _Boxes;

    float3 GetClassColor(uint i)
    {
        float h = frac(i * 0.74) * 6 - 2;
        return saturate(float3(abs(h - 1) - 1, 2 - abs(h), 2 - abs(h - 2)));
    }

    void Vertex(uint vid : SV_VertexID,
                uint iid : SV_InstanceID,
                out float4 position : SV_Position,
                out float4 color : COLOR)
    {
        BoundingBox box = _Boxes[iid];

        // Bounding box vertex
        float x = box.x + box.w * lerp(-0.5, 0.5, vid & 1);
        float y = box.y + box.h * lerp(-0.5, 0.5, vid < 2 || vid == 5);

        // Clip space to screen space
        x =  2 * x - 1;
        y = -2 * y + 1;

        // Aspect ratio compensation
        x = x * _ScreenParams.y / _ScreenParams.x;

        // Vertex attributes
        position = float4(x, y, 1, 1);
        color = float4(GetClassColor(box.classIndex), box.score);
    }

    float4 Fragment(float4 position : SV_Position,
                    float4 color : COLOR) : SV_Target
    {
        return color * color.a;
    }

    ENDCG

    SubShader
    {
        Pass
        {
            ZTest Always ZWrite Off Cull Off Blend One One
            CGPROGRAM
            #pragma vertex Vertex
            #pragma fragment Fragment
            ENDCG
        }
    }
}
