Shader "NatureManufacture/URP/Lit/Top Cover"
{
    Properties
    {
        _AlphaCutoff("Alpha Cutoff", Range(0, 1)) = 0
        _BaseColor("Base Color", Color) = (1, 1, 1, 0)
        [NoScaleOffset]_BaseColorMap("Base Map", 2D) = "white" {}
        [ToggleUI]_BaseUsePlanarUV("Base Use Planar UV", Float) = 0
        _BaseTilingOffset("Base Tiling and Offset", Vector) = (1, 1, 0, 0)
        [NoScaleOffset]_BaseNormalMap("Base Normal Map", 2D) = "white" {}
        _BaseNormalScale("Base Normal Scale", Range(0, 8)) = 1
        [NoScaleOffset]_BaseMaskMap("Base Mask Map MT(R) AO(G) SM(A)", 2D) = "white" {}
        _BaseMetallic("Base Metallic", Range(0, 1)) = 1
        _BaseAORemapMin("Base AO Remap Min", Range(0, 1)) = 0
        _BaseAORemapMax("Base AO Remap Max", Range(0, 1)) = 1
        _BaseSmoothnessRemapMin("Base Smoothness Remap Min", Range(0, 1)) = 0
        _BaseSmoothnessRemapMax("Base Smoothness Remap Max", Range(0, 1)) = 1
        [NoScaleOffset]_CoverMaskA("Cover Mask (A)", 2D) = "white" {}
        _CoverMaskPower("Cover Mask Power", Range(0, 10)) = 1
        _Cover_Amount("Cover Amount", Range(0, 2)) = 2
        _Cover_Amount_Grow_Speed("Cover Amount Grow Speed", Range(0, 3)) = 3
        _Cover_Max_Angle("Cover Max Angle", Range(0.001, 90)) = 35
        _Cover_Min_Height("Cover Min Height", Float) = -10000
        _Cover_Min_Height_Blending("Cover Min Height Blending", Range(0, 500)) = 1
        _CoverBaseColor("Cover Base Color", Color) = (1, 1, 1, 0)
        [NoScaleOffset]_CoverBaseColorMap("Cover Base Map", 2D) = "white" {}
        [ToggleUI]_CoverUsePlanarUV("Cover Use Planar UV", Float) = 1
        _CoverTilingOffset("Cover Tiling Offset", Vector) = (1, 1, 0, 0)
        [NoScaleOffset]_CoverNormalMap("Cover Normal Map", 2D) = "white" {}
        _CoverNormalScale("Cover Normal Scale", Range(0, 8)) = 1
        _CoverNormalBlendHardness("Cover Normal Blend Hardness", Range(0, 8)) = 1
        _CoverHardness("Cover Hardness", Range(0, 10)) = 5
        _CoverHeightMapMin("Cover Height Map Min", Float) = 0
        _CoverHeightMapMax("Cover Height Map Max", Float) = 1
        _CoverHeightMapOffset("Cover Height Map Offset", Float) = 0
        [NoScaleOffset]_CoverMaskMap("Cover Mask Map MT(R) AO(G) H(B) SM(A)", 2D) = "white" {}
        _CoverMetallic("Cover Metallic", Range(0, 1)) = 1
        _CoverAORemapMin("Cover AO Remap Min", Range(0, 1)) = 0
        _CoverAORemapMax("Cover AO Remap Max", Range(0, 1)) = 1
        _CoverSmoothnessRemapMin("Cover Smoothness Remap Min", Range(0, 1)) = 0
        _CoverSmoothnessRemapMax("Cover Smoothness Remap Max", Range(0, 1)) = 1
        [NoScaleOffset]_DetailMap("Detail Map Base (R) Ny(G) Sm(B) Nx(A)", 2D) = "white" {}
        _DetailTilingOffset("Detail Tiling Offset", Vector) = (1, 1, 0, 0)
        _DetailAlbedoScale("Detail Albedo Scale", Range(0, 2)) = 0
        _DetailNormalScale("Detail Normal Scale", Range(0, 2)) = 0
        _DetailSmoothnessScale("Detail Smoothness Scale", Range(0, 2)) = 0
        _WetColor("Wet Color Vertex(R)", Color) = (0.7735849, 0.7735849, 0.7735849, 0)
        _WetSmoothness("Wet Smoothness Vertex(R)", Range(0, 1)) = 1
        [HideInInspector][NoScaleOffset]unity_Lightmaps("unity_Lightmaps", 2DArray) = "" {}
        [HideInInspector][NoScaleOffset]unity_LightmapsInd("unity_LightmapsInd", 2DArray) = "" {}
        [HideInInspector][NoScaleOffset]unity_ShadowMasks("unity_ShadowMasks", 2DArray) = "" {}
        [Toggle]_USEDYNAMICCOVERTSTATICMASKF("Use Dynamic Cover (T) Static Mask (F)", Float) = 1
    }
    SubShader
    {
        Tags
        {
            "RenderPipeline"="UniversalPipeline"
            "RenderType"="Opaque"
            "UniversalMaterialType" = "Lit"
            "Queue"="AlphaTest"
        }
        Pass
        {
            Name "Universal Forward"
            Tags
            {
                "LightMode" = "UniversalForward"
            }

            // Render State
            Cull Back
        Blend One Zero
        ZTest LEqual
        ZWrite On

            // Debug
            // <None>

            // --------------------------------------------------
            // Pass

            HLSLPROGRAM

            // Pragmas
            #pragma target 4.5
        #pragma exclude_renderers gles gles3 glcore
        #pragma multi_compile_instancing
        #pragma multi_compile_fog
        #pragma multi_compile _ DOTS_INSTANCING_ON
        #pragma vertex vert
        #pragma fragment frag

            // DotsInstancingOptions: <None>
            // HybridV1InjectedBuiltinProperties: <None>

            // Keywords
            #pragma multi_compile _ _SCREEN_SPACE_OCCLUSION
        #pragma multi_compile _ LIGHTMAP_ON
        #pragma multi_compile _ DIRLIGHTMAP_COMBINED
        #pragma multi_compile _ _MAIN_LIGHT_SHADOWS _MAIN_LIGHT_SHADOWS_CASCADE _MAIN_LIGHT_SHADOWS_SCREEN
        #pragma multi_compile _ADDITIONAL_LIGHTS_VERTEX _ADDITIONAL_LIGHTS _ADDITIONAL_OFF
        #pragma multi_compile _ _ADDITIONAL_LIGHT_SHADOWS
        #pragma multi_compile _ _SHADOWS_SOFT
        #pragma multi_compile _ LIGHTMAP_SHADOW_MIXING
        #pragma multi_compile _ SHADOWS_SHADOWMASK
            #pragma shader_feature_local _ _USEDYNAMICCOVERTSTATICMASKF_ON

        #if defined(_USEDYNAMICCOVERTSTATICMASKF_ON)
            #define KEYWORD_PERMUTATION_0
        #else
            #define KEYWORD_PERMUTATION_1
        #endif


            // Defines
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define _AlphaClip 1
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define _NORMALMAP 1
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define _NORMAL_DROPOFF_TS 1
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define ATTRIBUTES_NEED_NORMAL
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define ATTRIBUTES_NEED_TANGENT
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define ATTRIBUTES_NEED_TEXCOORD0
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define ATTRIBUTES_NEED_TEXCOORD1
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define ATTRIBUTES_NEED_COLOR
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define VARYINGS_NEED_POSITION_WS
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define VARYINGS_NEED_NORMAL_WS
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define VARYINGS_NEED_TANGENT_WS
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define VARYINGS_NEED_TEXCOORD0
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define VARYINGS_NEED_COLOR
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define VARYINGS_NEED_VIEWDIRECTION_WS
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define VARYINGS_NEED_FOG_AND_VERTEX_LIGHT
        #endif

            #define FEATURES_GRAPH_VERTEX
            /* WARNING: $splice Could not find named fragment 'PassInstancing' */
            #define SHADERPASS SHADERPASS_FORWARD
            /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */

            // Includes
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Shadows.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"

            // --------------------------------------------------
            // Structs and Packing

            struct Attributes
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 positionOS : POSITION;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 normalOS : NORMAL;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 tangentOS : TANGENT;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 uv0 : TEXCOORD0;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 uv1 : TEXCOORD1;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 color : COLOR;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            uint instanceID : INSTANCEID_SEMANTIC;
            #endif
            #endif
        };
        struct Varyings
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 positionCS : SV_POSITION;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 positionWS;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 normalWS;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 tangentWS;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 texCoord0;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 color;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 viewDirectionWS;
            #endif
            #if defined(LIGHTMAP_ON)
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float2 lightmapUV;
            #endif
            #endif
            #if !defined(LIGHTMAP_ON)
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 sh;
            #endif
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 fogFactorAndVertexLight;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 shadowCoord;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
            #endif
        };
        struct SurfaceDescriptionInputs
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 WorldSpaceNormal;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 TangentSpaceNormal;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 WorldSpaceTangent;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 WorldSpaceBiTangent;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 AbsoluteWorldSpacePosition;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 uv0;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 VertexColor;
            #endif
        };
        struct VertexDescriptionInputs
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 ObjectSpaceNormal;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 ObjectSpaceTangent;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 ObjectSpacePosition;
            #endif
        };
        struct PackedVaryings
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 positionCS : SV_POSITION;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 interp0 : TEXCOORD0;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 interp1 : TEXCOORD1;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 interp2 : TEXCOORD2;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 interp3 : TEXCOORD3;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 interp4 : TEXCOORD4;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 interp5 : TEXCOORD5;
            #endif
            #if defined(LIGHTMAP_ON)
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float2 interp6 : TEXCOORD6;
            #endif
            #endif
            #if !defined(LIGHTMAP_ON)
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 interp7 : TEXCOORD7;
            #endif
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 interp8 : TEXCOORD8;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 interp9 : TEXCOORD9;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
            #endif
        };

            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            output.positionCS = input.positionCS;
            output.interp0.xyz =  input.positionWS;
            output.interp1.xyz =  input.normalWS;
            output.interp2.xyzw =  input.tangentWS;
            output.interp3.xyzw =  input.texCoord0;
            output.interp4.xyzw =  input.color;
            output.interp5.xyz =  input.viewDirectionWS;
            #if defined(LIGHTMAP_ON)
            output.interp6.xy =  input.lightmapUV;
            #endif
            #if !defined(LIGHTMAP_ON)
            output.interp7.xyz =  input.sh;
            #endif
            output.interp8.xyzw =  input.fogFactorAndVertexLight;
            output.interp9.xyzw =  input.shadowCoord;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.positionWS = input.interp0.xyz;
            output.normalWS = input.interp1.xyz;
            output.tangentWS = input.interp2.xyzw;
            output.texCoord0 = input.interp3.xyzw;
            output.color = input.interp4.xyzw;
            output.viewDirectionWS = input.interp5.xyz;
            #if defined(LIGHTMAP_ON)
            output.lightmapUV = input.interp6.xy;
            #endif
            #if !defined(LIGHTMAP_ON)
            output.sh = input.interp7.xyz;
            #endif
            output.fogFactorAndVertexLight = input.interp8.xyzw;
            output.shadowCoord = input.interp9.xyzw;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        #endif

            // --------------------------------------------------
            // Graph

            // Graph Properties
            CBUFFER_START(UnityPerMaterial)
        float _AlphaCutoff;
        float4 _BaseColor;
        float4 _BaseColorMap_TexelSize;
        float _BaseUsePlanarUV;
        float4 _BaseTilingOffset;
        float4 _BaseNormalMap_TexelSize;
        float _BaseNormalScale;
        float4 _BaseMaskMap_TexelSize;
        float _BaseMetallic;
        float _BaseAORemapMin;
        float _BaseAORemapMax;
        float _BaseSmoothnessRemapMin;
        float _BaseSmoothnessRemapMax;
        float4 _CoverMaskA_TexelSize;
        float _CoverMaskPower;
        float _Cover_Amount;
        float _Cover_Amount_Grow_Speed;
        float _Cover_Max_Angle;
        float _Cover_Min_Height;
        float _Cover_Min_Height_Blending;
        float4 _CoverBaseColor;
        float4 _CoverBaseColorMap_TexelSize;
        float _CoverUsePlanarUV;
        float4 _CoverTilingOffset;
        float4 _CoverNormalMap_TexelSize;
        float _CoverNormalScale;
        float _CoverNormalBlendHardness;
        float _CoverHardness;
        float _CoverHeightMapMin;
        float _CoverHeightMapMax;
        float _CoverHeightMapOffset;
        float4 _CoverMaskMap_TexelSize;
        float _CoverMetallic;
        float _CoverAORemapMin;
        float _CoverAORemapMax;
        float _CoverSmoothnessRemapMin;
        float _CoverSmoothnessRemapMax;
        float4 _DetailMap_TexelSize;
        float4 _DetailTilingOffset;
        float _DetailAlbedoScale;
        float _DetailNormalScale;
        float _DetailSmoothnessScale;
        float4 _WetColor;
        float _WetSmoothness;
        CBUFFER_END

        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_BaseColorMap);
        SAMPLER(sampler_BaseColorMap);
        TEXTURE2D(_BaseNormalMap);
        SAMPLER(sampler_BaseNormalMap);
        TEXTURE2D(_BaseMaskMap);
        SAMPLER(sampler_BaseMaskMap);
        TEXTURE2D(_CoverMaskA);
        SAMPLER(sampler_CoverMaskA);
        TEXTURE2D(_CoverBaseColorMap);
        SAMPLER(sampler_CoverBaseColorMap);
        TEXTURE2D(_CoverNormalMap);
        SAMPLER(sampler_CoverNormalMap);
        TEXTURE2D(_CoverMaskMap);
        SAMPLER(sampler_CoverMaskMap);
        TEXTURE2D(_DetailMap);
        SAMPLER(sampler_DetailMap);

            // Graph Functions
            
        // f948cdce565a6e706cc57cb23fbf9d95
        #include "./NM_Object_VSPro_Indirect.cginc"

        void AddPragma_float(float3 A, out float3 Out){
            #pragma instancing_options renderinglayer procedural:setupVSPro
            Out = A;
        }

        struct Bindings_NMObjectVSProIndirect_0cfe1e4f145944241ab304331e53c93b
        {
        };

        void SG_NMObjectVSProIndirect_0cfe1e4f145944241ab304331e53c93b(float3 Vector3_314C8600, Bindings_NMObjectVSProIndirect_0cfe1e4f145944241ab304331e53c93b IN, out float3 ObjectSpacePosition_1)
        {
            float3 _Property_5ec158abd968858c9d31ab40df5e9e6f_Out_0 = Vector3_314C8600;
            float3 _InjectSetupCustomFunction_dec9b26544b4a788b8ecb4117dc3d24a_Out_1;
            InjectSetup_float(_Property_5ec158abd968858c9d31ab40df5e9e6f_Out_0, _InjectSetupCustomFunction_dec9b26544b4a788b8ecb4117dc3d24a_Out_1);
            float3 _AddPragmaCustomFunction_b2a053178906d0848480a1f463521a1b_Out_1;
            AddPragma_float(_InjectSetupCustomFunction_dec9b26544b4a788b8ecb4117dc3d24a_Out_1, _AddPragmaCustomFunction_b2a053178906d0848480a1f463521a1b_Out_1);
            ObjectSpacePosition_1 = _AddPragmaCustomFunction_b2a053178906d0848480a1f463521a1b_Out_1;
        }

        void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
        {
            RGBA = float4(R, G, B, A);
            RGB = float3(R, G, B);
            RG = float2(R, G);
        }

        void Unity_Divide_float(float A, float B, out float Out)
        {
            Out = A / B;
        }

        void Unity_Multiply_float(float4 A, float4 B, out float4 Out)
        {
            Out = A * B;
        }

        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }

        void Unity_Branch_float2(float Predicate, float2 True, float2 False, out float2 Out)
        {
            Out = Predicate ? True : False;
        }

        struct Bindings_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6
        {
            float3 AbsoluteWorldSpacePosition;
            half4 uv0;
        };

        void SG_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6(UnityTexture2D Texture2D_80A3D28F, float4 Vector4_2EBA7A3B, float Boolean_7ABB9909, Bindings_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6 IN, out float4 XZ_2)
        {
            UnityTexture2D _Property_3e01b4d2fc68d48ba3acbba9d5881e59_Out_0 = Texture2D_80A3D28F;
            float _Property_30834f691775a0898a45b1c868520436_Out_0 = Boolean_7ABB9909;
            float _Split_89ed63cb625cb3878c183d0b71c03400_R_1 = IN.AbsoluteWorldSpacePosition[0];
            float _Split_89ed63cb625cb3878c183d0b71c03400_G_2 = IN.AbsoluteWorldSpacePosition[1];
            float _Split_89ed63cb625cb3878c183d0b71c03400_B_3 = IN.AbsoluteWorldSpacePosition[2];
            float _Split_89ed63cb625cb3878c183d0b71c03400_A_4 = 0;
            float4 _Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4;
            float3 _Combine_cf2d04ff119ad88493f6460431765cbb_RGB_5;
            float2 _Combine_cf2d04ff119ad88493f6460431765cbb_RG_6;
            Unity_Combine_float(_Split_89ed63cb625cb3878c183d0b71c03400_R_1, _Split_89ed63cb625cb3878c183d0b71c03400_B_3, 0, 0, _Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4, _Combine_cf2d04ff119ad88493f6460431765cbb_RGB_5, _Combine_cf2d04ff119ad88493f6460431765cbb_RG_6);
            float4 _Property_8a66888ec47d0687ab1cb2f8abdc9da8_Out_0 = Vector4_2EBA7A3B;
            float _Split_2f0f52f6ef8c0e81af0da6476402bc1f_R_1 = _Property_8a66888ec47d0687ab1cb2f8abdc9da8_Out_0[0];
            float _Split_2f0f52f6ef8c0e81af0da6476402bc1f_G_2 = _Property_8a66888ec47d0687ab1cb2f8abdc9da8_Out_0[1];
            float _Split_2f0f52f6ef8c0e81af0da6476402bc1f_B_3 = _Property_8a66888ec47d0687ab1cb2f8abdc9da8_Out_0[2];
            float _Split_2f0f52f6ef8c0e81af0da6476402bc1f_A_4 = _Property_8a66888ec47d0687ab1cb2f8abdc9da8_Out_0[3];
            float _Divide_e64179199923c58289b6aa94ea6c9178_Out_2;
            Unity_Divide_float(1, _Split_2f0f52f6ef8c0e81af0da6476402bc1f_R_1, _Divide_e64179199923c58289b6aa94ea6c9178_Out_2);
            float4 _Multiply_14cec4902d0a00829e4555071a1b8ad1_Out_2;
            Unity_Multiply_float(_Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4, (_Divide_e64179199923c58289b6aa94ea6c9178_Out_2.xxxx), _Multiply_14cec4902d0a00829e4555071a1b8ad1_Out_2);
            float2 _Vector2_16c15d3bbdd14b85bd48e3a6cb318af7_Out_0 = float2(_Split_2f0f52f6ef8c0e81af0da6476402bc1f_R_1, _Split_2f0f52f6ef8c0e81af0da6476402bc1f_G_2);
            float2 _Vector2_f8d75f54e7705083bbec539a60185577_Out_0 = float2(_Split_2f0f52f6ef8c0e81af0da6476402bc1f_B_3, _Split_2f0f52f6ef8c0e81af0da6476402bc1f_A_4);
            float2 _TilingAndOffset_d91e2d25acd34686b562b7fe7e9d1d27_Out_3;
            Unity_TilingAndOffset_float(IN.uv0.xy, _Vector2_16c15d3bbdd14b85bd48e3a6cb318af7_Out_0, _Vector2_f8d75f54e7705083bbec539a60185577_Out_0, _TilingAndOffset_d91e2d25acd34686b562b7fe7e9d1d27_Out_3);
            float2 _Branch_8e5a4e8f4d52fc8aadd1f46485afc933_Out_3;
            Unity_Branch_float2(_Property_30834f691775a0898a45b1c868520436_Out_0, (_Multiply_14cec4902d0a00829e4555071a1b8ad1_Out_2.xy), _TilingAndOffset_d91e2d25acd34686b562b7fe7e9d1d27_Out_3, _Branch_8e5a4e8f4d52fc8aadd1f46485afc933_Out_3);
            float4 _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0 = SAMPLE_TEXTURE2D(_Property_3e01b4d2fc68d48ba3acbba9d5881e59_Out_0.tex, _Property_3e01b4d2fc68d48ba3acbba9d5881e59_Out_0.samplerstate, _Branch_8e5a4e8f4d52fc8aadd1f46485afc933_Out_3);
            float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_R_4 = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0.r;
            float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_G_5 = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0.g;
            float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_B_6 = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0.b;
            float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_A_7 = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0.a;
            XZ_2 = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0;
        }

        void Unity_Multiply_float(float A, float B, out float Out)
        {
            Out = A * B;
        }

        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
        }

        void Unity_Saturate_float(float In, out float Out)
        {
            Out = saturate(In);
        }

        void Unity_Absolute_float(float In, out float Out)
        {
            Out = abs(In);
        }

        void Unity_SquareRoot_float4(float4 In, out float4 Out)
        {
            Out = sqrt(In);
        }

        void Unity_Sign_float(float In, out float Out)
        {
            Out = sign(In);
        }

        void Unity_Ceiling_float(float In, out float Out)
        {
            Out = ceil(In);
        }

        void Unity_Lerp_float4(float4 A, float4 B, float4 T, out float4 Out)
        {
            Out = lerp(A, B, T);
        }

        struct Bindings_BlendOverlayBaseColor_acdb3dfca72bd6b42bbc35f4613331a2
        {
        };

        void SG_BlendOverlayBaseColor_acdb3dfca72bd6b42bbc35f4613331a2(float4 Color_9AA111D3, float Vector1_FBE622A2, float Vector1_8C15C351, Bindings_BlendOverlayBaseColor_acdb3dfca72bd6b42bbc35f4613331a2 IN, out float3 OutVector4_1)
        {
            float4 _Property_012510d774fb7f8b860f5270dca4500f_Out_0 = Color_9AA111D3;
            float4 _SquareRoot_c2c57d0223a9538aa9240890c3cacb0c_Out_1;
            Unity_SquareRoot_float4(_Property_012510d774fb7f8b860f5270dca4500f_Out_0, _SquareRoot_c2c57d0223a9538aa9240890c3cacb0c_Out_1);
            float _Property_a00e29241d12f983b30177515b367ec9_Out_0 = Vector1_FBE622A2;
            float _Sign_343a45ede7349283a681c6bd9998fd8e_Out_1;
            Unity_Sign_float(_Property_a00e29241d12f983b30177515b367ec9_Out_0, _Sign_343a45ede7349283a681c6bd9998fd8e_Out_1);
            float _Add_681019b8f5d3d68bb482d419c9fc61a9_Out_2;
            Unity_Add_float(_Sign_343a45ede7349283a681c6bd9998fd8e_Out_1, 1, _Add_681019b8f5d3d68bb482d419c9fc61a9_Out_2);
            float _Multiply_e8f4cb722712a880ac0db6c7461427f7_Out_2;
            Unity_Multiply_float(_Add_681019b8f5d3d68bb482d419c9fc61a9_Out_2, 0.5, _Multiply_e8f4cb722712a880ac0db6c7461427f7_Out_2);
            float _Ceiling_95ad15988aa9b98184875fa754feae01_Out_1;
            Unity_Ceiling_float(_Multiply_e8f4cb722712a880ac0db6c7461427f7_Out_2, _Ceiling_95ad15988aa9b98184875fa754feae01_Out_1);
            float _Property_2db1c747a05ee284a8b00076062f91a4_Out_0 = Vector1_8C15C351;
            float _Multiply_9564ecda5193bc8286d9ff771c9226cd_Out_2;
            Unity_Multiply_float(_Property_2db1c747a05ee284a8b00076062f91a4_Out_0, _Property_2db1c747a05ee284a8b00076062f91a4_Out_0, _Multiply_9564ecda5193bc8286d9ff771c9226cd_Out_2);
            float4 _Lerp_b3cdb01fc3c5b988ac9b184943bf7c01_Out_3;
            Unity_Lerp_float4(_SquareRoot_c2c57d0223a9538aa9240890c3cacb0c_Out_1, (_Ceiling_95ad15988aa9b98184875fa754feae01_Out_1.xxxx), (_Multiply_9564ecda5193bc8286d9ff771c9226cd_Out_2.xxxx), _Lerp_b3cdb01fc3c5b988ac9b184943bf7c01_Out_3);
            float4 _Multiply_39d1daff98488f8ea2cd794ad4f20926_Out_2;
            Unity_Multiply_float(_Lerp_b3cdb01fc3c5b988ac9b184943bf7c01_Out_3, _Lerp_b3cdb01fc3c5b988ac9b184943bf7c01_Out_3, _Multiply_39d1daff98488f8ea2cd794ad4f20926_Out_2);
            OutVector4_1 = (_Multiply_39d1daff98488f8ea2cd794ad4f20926_Out_2.xyz);
        }

        void Unity_Clamp_float(float In, float Min, float Max, out float Out)
        {
            Out = clamp(In, Min, Max);
        }

        void Unity_Multiply_float(float2 A, float2 B, out float2 Out)
        {
            Out = A * B;
        }

        void Unity_Add_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A + B;
        }

        void Unity_DotProduct_float2(float2 A, float2 B, out float Out)
        {
            Out = dot(A, B);
        }

        void Unity_OneMinus_float(float In, out float Out)
        {
            Out = 1 - In;
        }

        void Unity_SquareRoot_float(float In, out float Out)
        {
            Out = sqrt(In);
        }

        void Unity_Sign_float3(float3 In, out float3 Out)
        {
            Out = sign(In);
        }

        void Unity_Normalize_float3(float3 In, out float3 Out)
        {
            Out = normalize(In);
        }

        void Unity_Branch_float3(float Predicate, float3 True, float3 False, out float3 Out)
        {
            Out = Predicate ? True : False;
        }

        struct Bindings_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8
        {
            float3 WorldSpaceNormal;
            float3 WorldSpaceTangent;
            float3 WorldSpaceBiTangent;
            float3 AbsoluteWorldSpacePosition;
            half4 uv0;
        };

        void SG_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8(UnityTexture2D Texture2D_80A3D28F, float4 Vector4_82674548, float Boolean_9FF42DF6, Bindings_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8 IN, out float4 XZ_2)
        {
            float _Property_1ef12cf3201a938993fe6a7951b0e754_Out_0 = Boolean_9FF42DF6;
            UnityTexture2D _Property_3e01b4d2fc68d48ba3acbba9d5881e59_Out_0 = Texture2D_80A3D28F;
            float _Split_89ed63cb625cb3878c183d0b71c03400_R_1 = IN.AbsoluteWorldSpacePosition[0];
            float _Split_89ed63cb625cb3878c183d0b71c03400_G_2 = IN.AbsoluteWorldSpacePosition[1];
            float _Split_89ed63cb625cb3878c183d0b71c03400_B_3 = IN.AbsoluteWorldSpacePosition[2];
            float _Split_89ed63cb625cb3878c183d0b71c03400_A_4 = 0;
            float4 _Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4;
            float3 _Combine_cf2d04ff119ad88493f6460431765cbb_RGB_5;
            float2 _Combine_cf2d04ff119ad88493f6460431765cbb_RG_6;
            Unity_Combine_float(_Split_89ed63cb625cb3878c183d0b71c03400_R_1, _Split_89ed63cb625cb3878c183d0b71c03400_B_3, 0, 0, _Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4, _Combine_cf2d04ff119ad88493f6460431765cbb_RGB_5, _Combine_cf2d04ff119ad88493f6460431765cbb_RG_6);
            float4 _Property_3fa1d6f912feb481ba60f2e55e62e746_Out_0 = Vector4_82674548;
            float _Split_a2e12fa5931da084b2949343a539dfd8_R_1 = _Property_3fa1d6f912feb481ba60f2e55e62e746_Out_0[0];
            float _Split_a2e12fa5931da084b2949343a539dfd8_G_2 = _Property_3fa1d6f912feb481ba60f2e55e62e746_Out_0[1];
            float _Split_a2e12fa5931da084b2949343a539dfd8_B_3 = _Property_3fa1d6f912feb481ba60f2e55e62e746_Out_0[2];
            float _Split_a2e12fa5931da084b2949343a539dfd8_A_4 = _Property_3fa1d6f912feb481ba60f2e55e62e746_Out_0[3];
            float _Divide_c36b770dfaa0bb8f85ab27da5fd794f0_Out_2;
            Unity_Divide_float(1, _Split_a2e12fa5931da084b2949343a539dfd8_R_1, _Divide_c36b770dfaa0bb8f85ab27da5fd794f0_Out_2);
            float4 _Multiply_14cec4902d0a00829e4555071a1b8ad1_Out_2;
            Unity_Multiply_float(_Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4, (_Divide_c36b770dfaa0bb8f85ab27da5fd794f0_Out_2.xxxx), _Multiply_14cec4902d0a00829e4555071a1b8ad1_Out_2);
            float2 _Vector2_6845d21872714d889783b0cb707df3e9_Out_0 = float2(_Split_a2e12fa5931da084b2949343a539dfd8_R_1, _Split_a2e12fa5931da084b2949343a539dfd8_G_2);
            float2 _Vector2_e2e2263627c6098e96a5b5d29350ad03_Out_0 = float2(_Split_a2e12fa5931da084b2949343a539dfd8_B_3, _Split_a2e12fa5931da084b2949343a539dfd8_A_4);
            float2 _TilingAndOffset_17582d056c0b8a8dab1017d37497fe59_Out_3;
            Unity_TilingAndOffset_float(IN.uv0.xy, _Vector2_6845d21872714d889783b0cb707df3e9_Out_0, _Vector2_e2e2263627c6098e96a5b5d29350ad03_Out_0, _TilingAndOffset_17582d056c0b8a8dab1017d37497fe59_Out_3);
            float2 _Branch_1e152f3aac57448f8518bf2852c000c3_Out_3;
            Unity_Branch_float2(_Property_1ef12cf3201a938993fe6a7951b0e754_Out_0, (_Multiply_14cec4902d0a00829e4555071a1b8ad1_Out_2.xy), _TilingAndOffset_17582d056c0b8a8dab1017d37497fe59_Out_3, _Branch_1e152f3aac57448f8518bf2852c000c3_Out_3);
            float4 _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0 = SAMPLE_TEXTURE2D(_Property_3e01b4d2fc68d48ba3acbba9d5881e59_Out_0.tex, _Property_3e01b4d2fc68d48ba3acbba9d5881e59_Out_0.samplerstate, _Branch_1e152f3aac57448f8518bf2852c000c3_Out_3);
            _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0.rgb = UnpackNormal(_SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0);
            float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_R_4 = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0.r;
            float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_G_5 = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0.g;
            float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_B_6 = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0.b;
            float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_A_7 = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0.a;
            float2 _Vector2_ad6bd100e273d78fa409a30a77bfa2cc_Out_0 = float2(_SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_R_4, _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_G_5);
            float3 _Sign_3a6ebf59931cf08cb0482e0144ddac24_Out_1;
            Unity_Sign_float3(IN.WorldSpaceNormal, _Sign_3a6ebf59931cf08cb0482e0144ddac24_Out_1);
            float _Split_6299d4ddcc4c74828aea40a46fdb896e_R_1 = _Sign_3a6ebf59931cf08cb0482e0144ddac24_Out_1[0];
            float _Split_6299d4ddcc4c74828aea40a46fdb896e_G_2 = _Sign_3a6ebf59931cf08cb0482e0144ddac24_Out_1[1];
            float _Split_6299d4ddcc4c74828aea40a46fdb896e_B_3 = _Sign_3a6ebf59931cf08cb0482e0144ddac24_Out_1[2];
            float _Split_6299d4ddcc4c74828aea40a46fdb896e_A_4 = 0;
            float2 _Vector2_b76cb1842101e58b9e636d49b075c612_Out_0 = float2(_Split_6299d4ddcc4c74828aea40a46fdb896e_G_2, 1);
            float2 _Multiply_31e8db88ee20c985a9850d1a58f3282b_Out_2;
            Unity_Multiply_float(_Vector2_ad6bd100e273d78fa409a30a77bfa2cc_Out_0, _Vector2_b76cb1842101e58b9e636d49b075c612_Out_0, _Multiply_31e8db88ee20c985a9850d1a58f3282b_Out_2);
            float _Split_5ed44bf2eca0868f81eb18100f49d1fa_R_1 = IN.WorldSpaceNormal[0];
            float _Split_5ed44bf2eca0868f81eb18100f49d1fa_G_2 = IN.WorldSpaceNormal[1];
            float _Split_5ed44bf2eca0868f81eb18100f49d1fa_B_3 = IN.WorldSpaceNormal[2];
            float _Split_5ed44bf2eca0868f81eb18100f49d1fa_A_4 = 0;
            float2 _Vector2_70e5837843f28b8b9d64cada3697bd5a_Out_0 = float2(_Split_5ed44bf2eca0868f81eb18100f49d1fa_R_1, _Split_5ed44bf2eca0868f81eb18100f49d1fa_B_3);
            float2 _Add_1145b2f896593d80aa864a34e6702562_Out_2;
            Unity_Add_float2(_Multiply_31e8db88ee20c985a9850d1a58f3282b_Out_2, _Vector2_70e5837843f28b8b9d64cada3697bd5a_Out_0, _Add_1145b2f896593d80aa864a34e6702562_Out_2);
            float _Split_2bc77ca2d17bd78cb2383770ce50b179_R_1 = _Add_1145b2f896593d80aa864a34e6702562_Out_2[0];
            float _Split_2bc77ca2d17bd78cb2383770ce50b179_G_2 = _Add_1145b2f896593d80aa864a34e6702562_Out_2[1];
            float _Split_2bc77ca2d17bd78cb2383770ce50b179_B_3 = 0;
            float _Split_2bc77ca2d17bd78cb2383770ce50b179_A_4 = 0;
            float _Multiply_ab12aea87465a78eaf7fc66c2598d266_Out_2;
            Unity_Multiply_float(_SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_B_6, _Split_5ed44bf2eca0868f81eb18100f49d1fa_G_2, _Multiply_ab12aea87465a78eaf7fc66c2598d266_Out_2);
            float3 _Vector3_433840b555db308b97e9b14b6a957195_Out_0 = float3(_Split_2bc77ca2d17bd78cb2383770ce50b179_R_1, _Multiply_ab12aea87465a78eaf7fc66c2598d266_Out_2, _Split_2bc77ca2d17bd78cb2383770ce50b179_G_2);
            float3x3 Transform_c7914cc45a011c89b3f53c55afb51673_tangentTransform_World = float3x3(IN.WorldSpaceTangent, IN.WorldSpaceBiTangent, IN.WorldSpaceNormal);
            float3 _Transform_c7914cc45a011c89b3f53c55afb51673_Out_1 = TransformWorldToTangent(_Vector3_433840b555db308b97e9b14b6a957195_Out_0.xyz, Transform_c7914cc45a011c89b3f53c55afb51673_tangentTransform_World);
            float3 _Normalize_09bf8a2bd0a4d38e8b97d5c674f79b44_Out_1;
            Unity_Normalize_float3(_Transform_c7914cc45a011c89b3f53c55afb51673_Out_1, _Normalize_09bf8a2bd0a4d38e8b97d5c674f79b44_Out_1);
            float3 _Branch_9eadf909a90f2f80880f8c56ecc2a91f_Out_3;
            Unity_Branch_float3(_Property_1ef12cf3201a938993fe6a7951b0e754_Out_0, _Normalize_09bf8a2bd0a4d38e8b97d5c674f79b44_Out_1, (_SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0.xyz), _Branch_9eadf909a90f2f80880f8c56ecc2a91f_Out_3);
            XZ_2 = (float4(_Branch_9eadf909a90f2f80880f8c56ecc2a91f_Out_3, 1.0));
        }

        void Unity_NormalStrength_float(float3 In, float Strength, out float3 Out)
        {
            Out = float3(In.rg * Strength, lerp(1, In.b, saturate(Strength)));
        }

        void Unity_NormalBlend_float(float3 A, float3 B, out float3 Out)
        {
            Out = SafeNormalize(float3(A.rg + B.rg, A.b * B.b));
        }

        void Unity_Subtract_float(float A, float B, out float Out)
        {
            Out = A - B;
        }

        void Unity_Power_float(float A, float B, out float Out)
        {
            Out = pow(A, B);
        }

        void Unity_Lerp_float3(float3 A, float3 B, float3 T, out float3 Out)
        {
            Out = lerp(A, B, T);
        }

        void Unity_Remap_float(float In, float2 InMinMax, float2 OutMinMax, out float Out)
        {
            Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
        }

        void Unity_Multiply_float(float3 A, float3 B, out float3 Out)
        {
            Out = A * B;
        }

        void Unity_Lerp_float(float A, float B, float T, out float Out)
        {
            Out = lerp(A, B, T);
        }

        struct Bindings_BlendOverlayDetailSmoothness_06e12138dc89c0040b45a57abe520a1a
        {
        };

        void SG_BlendOverlayDetailSmoothness_06e12138dc89c0040b45a57abe520a1a(float Vector1_32317166, float Vector1_FBE622A2, float Vector1_8C15C351, Bindings_BlendOverlayDetailSmoothness_06e12138dc89c0040b45a57abe520a1a IN, out float SmoothnessOverlay_1)
        {
            float _Property_728cc50521e9e988ac9cbff4872d5139_Out_0 = Vector1_32317166;
            float _Property_a00e29241d12f983b30177515b367ec9_Out_0 = Vector1_FBE622A2;
            float _Sign_343a45ede7349283a681c6bd9998fd8e_Out_1;
            Unity_Sign_float(_Property_a00e29241d12f983b30177515b367ec9_Out_0, _Sign_343a45ede7349283a681c6bd9998fd8e_Out_1);
            float _Add_681019b8f5d3d68bb482d419c9fc61a9_Out_2;
            Unity_Add_float(_Sign_343a45ede7349283a681c6bd9998fd8e_Out_1, 1, _Add_681019b8f5d3d68bb482d419c9fc61a9_Out_2);
            float _Multiply_e8f4cb722712a880ac0db6c7461427f7_Out_2;
            Unity_Multiply_float(_Add_681019b8f5d3d68bb482d419c9fc61a9_Out_2, 0.5, _Multiply_e8f4cb722712a880ac0db6c7461427f7_Out_2);
            float _Ceiling_95ad15988aa9b98184875fa754feae01_Out_1;
            Unity_Ceiling_float(_Multiply_e8f4cb722712a880ac0db6c7461427f7_Out_2, _Ceiling_95ad15988aa9b98184875fa754feae01_Out_1);
            float _Property_2db1c747a05ee284a8b00076062f91a4_Out_0 = Vector1_8C15C351;
            float _Lerp_b3cdb01fc3c5b988ac9b184943bf7c01_Out_3;
            Unity_Lerp_float(_Property_728cc50521e9e988ac9cbff4872d5139_Out_0, _Ceiling_95ad15988aa9b98184875fa754feae01_Out_1, _Property_2db1c747a05ee284a8b00076062f91a4_Out_0, _Lerp_b3cdb01fc3c5b988ac9b184943bf7c01_Out_3);
            SmoothnessOverlay_1 = _Lerp_b3cdb01fc3c5b988ac9b184943bf7c01_Out_3;
        }

            // Graph Vertex
            struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };

        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            Bindings_NMObjectVSProIndirect_0cfe1e4f145944241ab304331e53c93b _NMObjectVSProIndirect_adbe93754e069e8e87df45ef6e4b343e;
            float3 _NMObjectVSProIndirect_adbe93754e069e8e87df45ef6e4b343e_ObjectSpacePosition_1;
            SG_NMObjectVSProIndirect_0cfe1e4f145944241ab304331e53c93b(IN.ObjectSpacePosition, _NMObjectVSProIndirect_adbe93754e069e8e87df45ef6e4b343e, _NMObjectVSProIndirect_adbe93754e069e8e87df45ef6e4b343e_ObjectSpacePosition_1);
            #endif
            description.Position = _NMObjectVSProIndirect_adbe93754e069e8e87df45ef6e4b343e_ObjectSpacePosition_1;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }

            // Graph Pixel
            struct SurfaceDescription
        {
            float3 BaseColor;
            float3 NormalTS;
            float3 Emission;
            float Metallic;
            float Smoothness;
            float Occlusion;
            float Alpha;
            float AlphaClipThreshold;
        };

        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            UnityTexture2D _Property_e4c53213449c7682b60df6ae54f219f0_Out_0 = UnityBuildTexture2DStructNoScale(_BaseColorMap);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 _Property_115fcc827510f38798b214d835c27637_Out_0 = _BaseTilingOffset;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_d83b8f290862b285bbe2f157190e1315_Out_0 = _BaseUsePlanarUV;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            Bindings_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6 _PlanarNM_6c8b686076db2a8c8b7d6cd91cf435f0;
            _PlanarNM_6c8b686076db2a8c8b7d6cd91cf435f0.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            _PlanarNM_6c8b686076db2a8c8b7d6cd91cf435f0.uv0 = IN.uv0;
            float4 _PlanarNM_6c8b686076db2a8c8b7d6cd91cf435f0_XZ_2;
            SG_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6(_Property_e4c53213449c7682b60df6ae54f219f0_Out_0, _Property_115fcc827510f38798b214d835c27637_Out_0, _Property_d83b8f290862b285bbe2f157190e1315_Out_0, _PlanarNM_6c8b686076db2a8c8b7d6cd91cf435f0, _PlanarNM_6c8b686076db2a8c8b7d6cd91cf435f0_XZ_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 _Property_13c79aaf332e20868551d934a2cb7112_Out_0 = _BaseColor;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 _Multiply_3d0c2fda612cfe87aa84bc17ad099a61_Out_2;
            Unity_Multiply_float(_PlanarNM_6c8b686076db2a8c8b7d6cd91cf435f0_XZ_2, _Property_13c79aaf332e20868551d934a2cb7112_Out_0, _Multiply_3d0c2fda612cfe87aa84bc17ad099a61_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            UnityTexture2D _Property_b561c414493a8f8299227a27e437f045_Out_0 = UnityBuildTexture2DStructNoScale(_DetailMap);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 _Property_70f1cc2b73af738d80b0d405e4bed8c5_Out_0 = _DetailTilingOffset;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Split_cda27505033cfc8eaf60fe914f0949b9_R_1 = _Property_70f1cc2b73af738d80b0d405e4bed8c5_Out_0[0];
            float _Split_cda27505033cfc8eaf60fe914f0949b9_G_2 = _Property_70f1cc2b73af738d80b0d405e4bed8c5_Out_0[1];
            float _Split_cda27505033cfc8eaf60fe914f0949b9_B_3 = _Property_70f1cc2b73af738d80b0d405e4bed8c5_Out_0[2];
            float _Split_cda27505033cfc8eaf60fe914f0949b9_A_4 = _Property_70f1cc2b73af738d80b0d405e4bed8c5_Out_0[3];
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float2 _Vector2_42d7e955009b6f8cb4d913530ff92840_Out_0 = float2(_Split_cda27505033cfc8eaf60fe914f0949b9_R_1, _Split_cda27505033cfc8eaf60fe914f0949b9_G_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float2 _Vector2_5452a0299d10b280aec51f7407d4d2ac_Out_0 = float2(_Split_cda27505033cfc8eaf60fe914f0949b9_B_3, _Split_cda27505033cfc8eaf60fe914f0949b9_A_4);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float2 _TilingAndOffset_e1c5b97bd253ca8f9f3d26f598e6d7fd_Out_3;
            Unity_TilingAndOffset_float(IN.uv0.xy, _Vector2_42d7e955009b6f8cb4d913530ff92840_Out_0, _Vector2_5452a0299d10b280aec51f7407d4d2ac_Out_0, _TilingAndOffset_e1c5b97bd253ca8f9f3d26f598e6d7fd_Out_3);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 _SampleTexture2D_fa4ac40fc922b9869e37c06690c0f530_RGBA_0 = SAMPLE_TEXTURE2D(_Property_b561c414493a8f8299227a27e437f045_Out_0.tex, _Property_b561c414493a8f8299227a27e437f045_Out_0.samplerstate, _TilingAndOffset_e1c5b97bd253ca8f9f3d26f598e6d7fd_Out_3);
            float _SampleTexture2D_fa4ac40fc922b9869e37c06690c0f530_R_4 = _SampleTexture2D_fa4ac40fc922b9869e37c06690c0f530_RGBA_0.r;
            float _SampleTexture2D_fa4ac40fc922b9869e37c06690c0f530_G_5 = _SampleTexture2D_fa4ac40fc922b9869e37c06690c0f530_RGBA_0.g;
            float _SampleTexture2D_fa4ac40fc922b9869e37c06690c0f530_B_6 = _SampleTexture2D_fa4ac40fc922b9869e37c06690c0f530_RGBA_0.b;
            float _SampleTexture2D_fa4ac40fc922b9869e37c06690c0f530_A_7 = _SampleTexture2D_fa4ac40fc922b9869e37c06690c0f530_RGBA_0.a;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Multiply_d0f6aeb5b3f04288b51a5ded8986b5a4_Out_2;
            Unity_Multiply_float(_SampleTexture2D_fa4ac40fc922b9869e37c06690c0f530_R_4, 2, _Multiply_d0f6aeb5b3f04288b51a5ded8986b5a4_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Add_d382719213f8618f88c54f7c3dfbd8c2_Out_2;
            Unity_Add_float(_Multiply_d0f6aeb5b3f04288b51a5ded8986b5a4_Out_2, -1, _Add_d382719213f8618f88c54f7c3dfbd8c2_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_02e7dd176dc59f8a9a62453677916b24_Out_0 = _DetailAlbedoScale;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Multiply_fd406247e3137a8b8777918477740653_Out_2;
            Unity_Multiply_float(_Add_d382719213f8618f88c54f7c3dfbd8c2_Out_2, _Property_02e7dd176dc59f8a9a62453677916b24_Out_0, _Multiply_fd406247e3137a8b8777918477740653_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Saturate_d6f590fb1b9d188e981ebb0ec4d36ba9_Out_1;
            Unity_Saturate_float(_Multiply_fd406247e3137a8b8777918477740653_Out_2, _Saturate_d6f590fb1b9d188e981ebb0ec4d36ba9_Out_1);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Absolute_dc927550b803d18ba3ff372995e6d25c_Out_1;
            Unity_Absolute_float(_Saturate_d6f590fb1b9d188e981ebb0ec4d36ba9_Out_1, _Absolute_dc927550b803d18ba3ff372995e6d25c_Out_1);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            Bindings_BlendOverlayBaseColor_acdb3dfca72bd6b42bbc35f4613331a2 _BlendOverlayBaseColor_f3cd25d5b673648eb831a3f388201f73;
            float3 _BlendOverlayBaseColor_f3cd25d5b673648eb831a3f388201f73_OutVector4_1;
            SG_BlendOverlayBaseColor_acdb3dfca72bd6b42bbc35f4613331a2(_Multiply_3d0c2fda612cfe87aa84bc17ad099a61_Out_2, _Add_d382719213f8618f88c54f7c3dfbd8c2_Out_2, _Absolute_dc927550b803d18ba3ff372995e6d25c_Out_1, _BlendOverlayBaseColor_f3cd25d5b673648eb831a3f388201f73, _BlendOverlayBaseColor_f3cd25d5b673648eb831a3f388201f73_OutVector4_1);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            UnityTexture2D _Property_f4db51ec2412c48cbcf2128b7bd8caf8_Out_0 = UnityBuildTexture2DStructNoScale(_CoverBaseColorMap);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 _Property_e35c79b8cccfbe8ca0a3c33e8d32e319_Out_0 = _CoverTilingOffset;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_e3d8b38b51331e879b1d4012d65f53e6_Out_0 = _CoverUsePlanarUV;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            Bindings_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6 _PlanarNM_c2ec737ef76d6286b8eedb44a2d24e50;
            _PlanarNM_c2ec737ef76d6286b8eedb44a2d24e50.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            _PlanarNM_c2ec737ef76d6286b8eedb44a2d24e50.uv0 = IN.uv0;
            float4 _PlanarNM_c2ec737ef76d6286b8eedb44a2d24e50_XZ_2;
            SG_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6(_Property_f4db51ec2412c48cbcf2128b7bd8caf8_Out_0, _Property_e35c79b8cccfbe8ca0a3c33e8d32e319_Out_0, _Property_e3d8b38b51331e879b1d4012d65f53e6_Out_0, _PlanarNM_c2ec737ef76d6286b8eedb44a2d24e50, _PlanarNM_c2ec737ef76d6286b8eedb44a2d24e50_XZ_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 _Property_7d3af9045f54ef8ba8629ebbbc3f4ad7_Out_0 = _CoverBaseColor;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 _Multiply_2eb83c7af5b6f58eabeec7b502517470_Out_2;
            Unity_Multiply_float(_PlanarNM_c2ec737ef76d6286b8eedb44a2d24e50_XZ_2, _Property_7d3af9045f54ef8ba8629ebbbc3f4ad7_Out_0, _Multiply_2eb83c7af5b6f58eabeec7b502517470_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            UnityTexture2D _Property_356186a26fec8686a13bc6b57fd8f3ee_Out_0 = UnityBuildTexture2DStructNoScale(_CoverMaskA);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 _UV_045cea9e82354980a778f44d92578382_Out_0 = IN.uv0;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 _SampleTexture2D_0eef6ae3dab6e185bd0f65edecd80314_RGBA_0 = SAMPLE_TEXTURE2D(_Property_356186a26fec8686a13bc6b57fd8f3ee_Out_0.tex, _Property_356186a26fec8686a13bc6b57fd8f3ee_Out_0.samplerstate, (_UV_045cea9e82354980a778f44d92578382_Out_0.xy));
            float _SampleTexture2D_0eef6ae3dab6e185bd0f65edecd80314_R_4 = _SampleTexture2D_0eef6ae3dab6e185bd0f65edecd80314_RGBA_0.r;
            float _SampleTexture2D_0eef6ae3dab6e185bd0f65edecd80314_G_5 = _SampleTexture2D_0eef6ae3dab6e185bd0f65edecd80314_RGBA_0.g;
            float _SampleTexture2D_0eef6ae3dab6e185bd0f65edecd80314_B_6 = _SampleTexture2D_0eef6ae3dab6e185bd0f65edecd80314_RGBA_0.b;
            float _SampleTexture2D_0eef6ae3dab6e185bd0f65edecd80314_A_7 = _SampleTexture2D_0eef6ae3dab6e185bd0f65edecd80314_RGBA_0.a;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_4e8240836843df81941cdf6cf2cdd638_Out_0 = _CoverMaskPower;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Multiply_8b5250e5dfc73a84a41399a13b83c0a1_Out_2;
            Unity_Multiply_float(_SampleTexture2D_0eef6ae3dab6e185bd0f65edecd80314_A_7, _Property_4e8240836843df81941cdf6cf2cdd638_Out_0, _Multiply_8b5250e5dfc73a84a41399a13b83c0a1_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Clamp_030a7c32684c258084338456eaddc77a_Out_3;
            Unity_Clamp_float(_Multiply_8b5250e5dfc73a84a41399a13b83c0a1_Out_2, 0, 1, _Clamp_030a7c32684c258084338456eaddc77a_Out_3);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Split_8ba5b67899f36b8f9dcf5c84092c0560_R_1 = IN.VertexColor[0];
            float _Split_8ba5b67899f36b8f9dcf5c84092c0560_G_2 = IN.VertexColor[1];
            float _Split_8ba5b67899f36b8f9dcf5c84092c0560_B_3 = IN.VertexColor[2];
            float _Split_8ba5b67899f36b8f9dcf5c84092c0560_A_4 = IN.VertexColor[3];
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float2 _Vector2_65060e9a9f687a89b68e32dc876be645_Out_0 = float2(_SampleTexture2D_fa4ac40fc922b9869e37c06690c0f530_A_7, _SampleTexture2D_fa4ac40fc922b9869e37c06690c0f530_G_5);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float2 _Multiply_5d4c3baed6515c8b86a289c70fca8f5d_Out_2;
            Unity_Multiply_float(_Vector2_65060e9a9f687a89b68e32dc876be645_Out_0, float2(2, 2), _Multiply_5d4c3baed6515c8b86a289c70fca8f5d_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float2 _Add_98b310e19c5fa5899c39cc45969c15ea_Out_2;
            Unity_Add_float2(_Multiply_5d4c3baed6515c8b86a289c70fca8f5d_Out_2, float2(-1, -1), _Add_98b310e19c5fa5899c39cc45969c15ea_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_08b99582093b36869beb5ea3d18e765d_Out_0 = _DetailNormalScale;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float2 _Multiply_bf0b80fdb3271784900e5b5ea4c5550f_Out_2;
            Unity_Multiply_float(_Add_98b310e19c5fa5899c39cc45969c15ea_Out_2, (_Property_08b99582093b36869beb5ea3d18e765d_Out_0.xx), _Multiply_bf0b80fdb3271784900e5b5ea4c5550f_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Split_26c1e73f8436c78ebdae5b51365a072b_R_1 = _Multiply_bf0b80fdb3271784900e5b5ea4c5550f_Out_2[0];
            float _Split_26c1e73f8436c78ebdae5b51365a072b_G_2 = _Multiply_bf0b80fdb3271784900e5b5ea4c5550f_Out_2[1];
            float _Split_26c1e73f8436c78ebdae5b51365a072b_B_3 = 0;
            float _Split_26c1e73f8436c78ebdae5b51365a072b_A_4 = 0;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _DotProduct_50aca3ce0da1ad849d7ff4a99df3a322_Out_2;
            Unity_DotProduct_float2(_Multiply_bf0b80fdb3271784900e5b5ea4c5550f_Out_2, _Multiply_bf0b80fdb3271784900e5b5ea4c5550f_Out_2, _DotProduct_50aca3ce0da1ad849d7ff4a99df3a322_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Saturate_491f2ee8417b8782aee83358b89eeb08_Out_1;
            Unity_Saturate_float(_DotProduct_50aca3ce0da1ad849d7ff4a99df3a322_Out_2, _Saturate_491f2ee8417b8782aee83358b89eeb08_Out_1);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _OneMinus_46ad3170d736808d98bf74ffa45e0414_Out_1;
            Unity_OneMinus_float(_Saturate_491f2ee8417b8782aee83358b89eeb08_Out_1, _OneMinus_46ad3170d736808d98bf74ffa45e0414_Out_1);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _SquareRoot_dfeae899ebfeae8f9257c340ca22ce38_Out_1;
            Unity_SquareRoot_float(_OneMinus_46ad3170d736808d98bf74ffa45e0414_Out_1, _SquareRoot_dfeae899ebfeae8f9257c340ca22ce38_Out_1);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 _Vector3_ed3f80ed87524e8c99f98b224af5a610_Out_0 = float3(_Split_26c1e73f8436c78ebdae5b51365a072b_R_1, _Split_26c1e73f8436c78ebdae5b51365a072b_G_2, _SquareRoot_dfeae899ebfeae8f9257c340ca22ce38_Out_1);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            UnityTexture2D _Property_2cc39234d3d334899f94126a216a50fc_Out_0 = UnityBuildTexture2DStructNoScale(_BaseNormalMap);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            Bindings_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8 _PlanarNMn_4fde70f39e45398dbb9972941e88e2bf;
            _PlanarNMn_4fde70f39e45398dbb9972941e88e2bf.WorldSpaceNormal = IN.WorldSpaceNormal;
            _PlanarNMn_4fde70f39e45398dbb9972941e88e2bf.WorldSpaceTangent = IN.WorldSpaceTangent;
            _PlanarNMn_4fde70f39e45398dbb9972941e88e2bf.WorldSpaceBiTangent = IN.WorldSpaceBiTangent;
            _PlanarNMn_4fde70f39e45398dbb9972941e88e2bf.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            _PlanarNMn_4fde70f39e45398dbb9972941e88e2bf.uv0 = IN.uv0;
            float4 _PlanarNMn_4fde70f39e45398dbb9972941e88e2bf_XZ_2;
            SG_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8(_Property_2cc39234d3d334899f94126a216a50fc_Out_0, _Property_115fcc827510f38798b214d835c27637_Out_0, _Property_d83b8f290862b285bbe2f157190e1315_Out_0, _PlanarNMn_4fde70f39e45398dbb9972941e88e2bf, _PlanarNMn_4fde70f39e45398dbb9972941e88e2bf_XZ_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_020d569f63e9a2849e23988ff74eb005_Out_0 = _BaseNormalScale;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 _NormalStrength_0c71fb166ae841839a0a12ecc5afa6fe_Out_2;
            Unity_NormalStrength_float((_PlanarNMn_4fde70f39e45398dbb9972941e88e2bf_XZ_2.xyz), _Property_020d569f63e9a2849e23988ff74eb005_Out_0, _NormalStrength_0c71fb166ae841839a0a12ecc5afa6fe_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 _NormalBlend_be36dd49bea74c8f8dd52fa3a85a9534_Out_2;
            Unity_NormalBlend_float(_Vector3_ed3f80ed87524e8c99f98b224af5a610_Out_0, _NormalStrength_0c71fb166ae841839a0a12ecc5afa6fe_Out_2, _NormalBlend_be36dd49bea74c8f8dd52fa3a85a9534_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            UnityTexture2D _Property_a383045772822c87acd099bb4cd6c478_Out_0 = UnityBuildTexture2DStructNoScale(_CoverNormalMap);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            Bindings_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8 _PlanarNMn_79abde32a0223a89907c9f09efac8db7;
            _PlanarNMn_79abde32a0223a89907c9f09efac8db7.WorldSpaceNormal = IN.WorldSpaceNormal;
            _PlanarNMn_79abde32a0223a89907c9f09efac8db7.WorldSpaceTangent = IN.WorldSpaceTangent;
            _PlanarNMn_79abde32a0223a89907c9f09efac8db7.WorldSpaceBiTangent = IN.WorldSpaceBiTangent;
            _PlanarNMn_79abde32a0223a89907c9f09efac8db7.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            _PlanarNMn_79abde32a0223a89907c9f09efac8db7.uv0 = IN.uv0;
            float4 _PlanarNMn_79abde32a0223a89907c9f09efac8db7_XZ_2;
            SG_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8(_Property_a383045772822c87acd099bb4cd6c478_Out_0, _Property_e35c79b8cccfbe8ca0a3c33e8d32e319_Out_0, _Property_e3d8b38b51331e879b1d4012d65f53e6_Out_0, _PlanarNMn_79abde32a0223a89907c9f09efac8db7, _PlanarNMn_79abde32a0223a89907c9f09efac8db7_XZ_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_c688e246111fd881820a97415e14d8a3_Out_0 = _CoverNormalBlendHardness;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 _NormalStrength_0e5e0831ba0e98878220ca6021ea52a2_Out_2;
            Unity_NormalStrength_float((_PlanarNMn_79abde32a0223a89907c9f09efac8db7_XZ_2.xyz), _Property_c688e246111fd881820a97415e14d8a3_Out_0, _NormalStrength_0e5e0831ba0e98878220ca6021ea52a2_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Split_8cadce726725318fbacd47f436a8231d_R_1 = IN.WorldSpaceNormal[0];
            float _Split_8cadce726725318fbacd47f436a8231d_G_2 = IN.WorldSpaceNormal[1];
            float _Split_8cadce726725318fbacd47f436a8231d_B_3 = IN.WorldSpaceNormal[2];
            float _Split_8cadce726725318fbacd47f436a8231d_A_4 = 0;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_ce4e5954a0b7ff8c819fa53963327595_Out_0 = _Cover_Amount;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_384059e6344fb98a85eccad78dd82f36_Out_0 = _Cover_Amount_Grow_Speed;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Subtract_70fd06876db7fa85b0cc0bce8d926dff_Out_2;
            Unity_Subtract_float(4, _Property_384059e6344fb98a85eccad78dd82f36_Out_0, _Subtract_70fd06876db7fa85b0cc0bce8d926dff_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Divide_1a3a6334c3d8bc8f8ac262c7833e15d5_Out_2;
            Unity_Divide_float(_Property_ce4e5954a0b7ff8c819fa53963327595_Out_0, _Subtract_70fd06876db7fa85b0cc0bce8d926dff_Out_2, _Divide_1a3a6334c3d8bc8f8ac262c7833e15d5_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Absolute_f218d2b85ebf288f91234faffedb5f7b_Out_1;
            Unity_Absolute_float(_Divide_1a3a6334c3d8bc8f8ac262c7833e15d5_Out_2, _Absolute_f218d2b85ebf288f91234faffedb5f7b_Out_1);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Power_a9b8d4b65c44a98e9813f61c0e2dc0a3_Out_2;
            Unity_Power_float(_Absolute_f218d2b85ebf288f91234faffedb5f7b_Out_1, _Subtract_70fd06876db7fa85b0cc0bce8d926dff_Out_2, _Power_a9b8d4b65c44a98e9813f61c0e2dc0a3_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Clamp_95d579f83746cb82be79cf6739990e0b_Out_3;
            Unity_Clamp_float(_Power_a9b8d4b65c44a98e9813f61c0e2dc0a3_Out_2, 0, 2, _Clamp_95d579f83746cb82be79cf6739990e0b_Out_3);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Multiply_02a8aa0fa6974e81aa84caba54f63896_Out_2;
            Unity_Multiply_float(_Split_8cadce726725318fbacd47f436a8231d_G_2, _Clamp_95d579f83746cb82be79cf6739990e0b_Out_3, _Multiply_02a8aa0fa6974e81aa84caba54f63896_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Saturate_ada5e8f9ebdcb38d8f5e61e8d97424b9_Out_1;
            Unity_Saturate_float(_Multiply_02a8aa0fa6974e81aa84caba54f63896_Out_2, _Saturate_ada5e8f9ebdcb38d8f5e61e8d97424b9_Out_1);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Clamp_38bac9e8ef351789b5fd4f2201f1df7b_Out_3;
            Unity_Clamp_float(_Split_8cadce726725318fbacd47f436a8231d_G_2, 0, 0.9999, _Clamp_38bac9e8ef351789b5fd4f2201f1df7b_Out_3);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_9babc76177853482826cae0163ffe988_Out_0 = _Cover_Max_Angle;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Divide_3b22550205905d8da5870f9db56e44ff_Out_2;
            Unity_Divide_float(_Property_9babc76177853482826cae0163ffe988_Out_0, 45, _Divide_3b22550205905d8da5870f9db56e44ff_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _OneMinus_99a85b6952a41288afc86da0a6ca6ea0_Out_1;
            Unity_OneMinus_float(_Divide_3b22550205905d8da5870f9db56e44ff_Out_2, _OneMinus_99a85b6952a41288afc86da0a6ca6ea0_Out_1);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Subtract_2b63f3aaee26f686971dca1d28da283c_Out_2;
            Unity_Subtract_float(_Clamp_38bac9e8ef351789b5fd4f2201f1df7b_Out_3, _OneMinus_99a85b6952a41288afc86da0a6ca6ea0_Out_1, _Subtract_2b63f3aaee26f686971dca1d28da283c_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Clamp_6bd9bb4add91fe8eb80a958a6b1a2d01_Out_3;
            Unity_Clamp_float(_Subtract_2b63f3aaee26f686971dca1d28da283c_Out_2, 0, 2, _Clamp_6bd9bb4add91fe8eb80a958a6b1a2d01_Out_3);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Divide_a09d2d461b07e98999aba746fb52a3fc_Out_2;
            Unity_Divide_float(1, _Divide_3b22550205905d8da5870f9db56e44ff_Out_2, _Divide_a09d2d461b07e98999aba746fb52a3fc_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Multiply_89a8f5a279c73b898d4ca5d075786b53_Out_2;
            Unity_Multiply_float(_Clamp_6bd9bb4add91fe8eb80a958a6b1a2d01_Out_3, _Divide_a09d2d461b07e98999aba746fb52a3fc_Out_2, _Multiply_89a8f5a279c73b898d4ca5d075786b53_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Absolute_f98ce5feb185a68784b9b35eb71ec465_Out_1;
            Unity_Absolute_float(_Multiply_89a8f5a279c73b898d4ca5d075786b53_Out_2, _Absolute_f98ce5feb185a68784b9b35eb71ec465_Out_1);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_27e768ffa9c13e8ab65d48e7712e5b66_Out_0 = _CoverHardness;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Power_b9fdc3921d5b85878a1ec4baa1975184_Out_2;
            Unity_Power_float(_Absolute_f98ce5feb185a68784b9b35eb71ec465_Out_1, _Property_27e768ffa9c13e8ab65d48e7712e5b66_Out_0, _Power_b9fdc3921d5b85878a1ec4baa1975184_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_c442c20fdade808b8e1b93cfd6625ab9_Out_0 = _Cover_Min_Height;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _OneMinus_55530ddc82048c8aa2d082334edf6a57_Out_1;
            Unity_OneMinus_float(_Property_c442c20fdade808b8e1b93cfd6625ab9_Out_0, _OneMinus_55530ddc82048c8aa2d082334edf6a57_Out_1);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Split_7e5d084c5e6bfa83a9203dac971ea31e_R_1 = IN.AbsoluteWorldSpacePosition[0];
            float _Split_7e5d084c5e6bfa83a9203dac971ea31e_G_2 = IN.AbsoluteWorldSpacePosition[1];
            float _Split_7e5d084c5e6bfa83a9203dac971ea31e_B_3 = IN.AbsoluteWorldSpacePosition[2];
            float _Split_7e5d084c5e6bfa83a9203dac971ea31e_A_4 = 0;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Add_e4067b215657d98ab6ec4e0295ddfece_Out_2;
            Unity_Add_float(_OneMinus_55530ddc82048c8aa2d082334edf6a57_Out_1, _Split_7e5d084c5e6bfa83a9203dac971ea31e_G_2, _Add_e4067b215657d98ab6ec4e0295ddfece_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Add_a4387dfc1ea3ee8da0b04f433a7c63d0_Out_2;
            Unity_Add_float(_Add_e4067b215657d98ab6ec4e0295ddfece_Out_2, 1, _Add_a4387dfc1ea3ee8da0b04f433a7c63d0_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Clamp_570e1129ecb02c8b8be79d85f19d5ae1_Out_3;
            Unity_Clamp_float(_Add_a4387dfc1ea3ee8da0b04f433a7c63d0_Out_2, 0, 1, _Clamp_570e1129ecb02c8b8be79d85f19d5ae1_Out_3);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_5da709b259ac268bb134d927bcffa4b8_Out_0 = _Cover_Min_Height_Blending;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Add_c322347d9ddbcd83ba52983e9316c387_Out_2;
            Unity_Add_float(_Add_e4067b215657d98ab6ec4e0295ddfece_Out_2, _Property_5da709b259ac268bb134d927bcffa4b8_Out_0, _Add_c322347d9ddbcd83ba52983e9316c387_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Divide_078ffa7d6c597f819511c95d33b7d90e_Out_2;
            Unity_Divide_float(_Add_c322347d9ddbcd83ba52983e9316c387_Out_2, _Add_e4067b215657d98ab6ec4e0295ddfece_Out_2, _Divide_078ffa7d6c597f819511c95d33b7d90e_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _OneMinus_b9f8edced35e7b8cab9ca581d822e31f_Out_1;
            Unity_OneMinus_float(_Divide_078ffa7d6c597f819511c95d33b7d90e_Out_2, _OneMinus_b9f8edced35e7b8cab9ca581d822e31f_Out_1);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Add_95cd1778448bfe8d9f9fa9129235f2c2_Out_2;
            Unity_Add_float(_OneMinus_b9f8edced35e7b8cab9ca581d822e31f_Out_1, -0.5, _Add_95cd1778448bfe8d9f9fa9129235f2c2_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Clamp_23e760e01b7e0780a71d88813b5828d7_Out_3;
            Unity_Clamp_float(_Add_95cd1778448bfe8d9f9fa9129235f2c2_Out_2, 0, 1, _Clamp_23e760e01b7e0780a71d88813b5828d7_Out_3);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Add_674fcef023d728848510150af810a103_Out_2;
            Unity_Add_float(_Clamp_570e1129ecb02c8b8be79d85f19d5ae1_Out_3, _Clamp_23e760e01b7e0780a71d88813b5828d7_Out_3, _Add_674fcef023d728848510150af810a103_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Clamp_5b677be9d499c082bcbe316853b0adff_Out_3;
            Unity_Clamp_float(_Add_674fcef023d728848510150af810a103_Out_2, 0, 1, _Clamp_5b677be9d499c082bcbe316853b0adff_Out_3);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Multiply_7ea7400ed65a3582b000796fb39748e9_Out_2;
            Unity_Multiply_float(_Power_b9fdc3921d5b85878a1ec4baa1975184_Out_2, _Clamp_5b677be9d499c082bcbe316853b0adff_Out_3, _Multiply_7ea7400ed65a3582b000796fb39748e9_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Multiply_4d295791f4e23186acea64f2f4de94ea_Out_2;
            Unity_Multiply_float(_Saturate_ada5e8f9ebdcb38d8f5e61e8d97424b9_Out_1, _Multiply_7ea7400ed65a3582b000796fb39748e9_Out_2, _Multiply_4d295791f4e23186acea64f2f4de94ea_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 _Lerp_21eaf65c617b2d858b3b33154d55757a_Out_3;
            Unity_Lerp_float3(_NormalBlend_be36dd49bea74c8f8dd52fa3a85a9534_Out_2, _NormalStrength_0e5e0831ba0e98878220ca6021ea52a2_Out_2, (_Multiply_4d295791f4e23186acea64f2f4de94ea_Out_2.xxx), _Lerp_21eaf65c617b2d858b3b33154d55757a_Out_3);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3x3 Transform_1e4c3a2d6240958ab6858efb88c1d06a_transposeTangent = transpose(float3x3(IN.WorldSpaceTangent, IN.WorldSpaceBiTangent, IN.WorldSpaceNormal));
            float3 _Transform_1e4c3a2d6240958ab6858efb88c1d06a_Out_1 = normalize(mul(Transform_1e4c3a2d6240958ab6858efb88c1d06a_transposeTangent, _Lerp_21eaf65c617b2d858b3b33154d55757a_Out_3.xyz).xyz);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Split_600a9d271d96798a94ab28118977defd_R_1 = _Transform_1e4c3a2d6240958ab6858efb88c1d06a_Out_1[0];
            float _Split_600a9d271d96798a94ab28118977defd_G_2 = _Transform_1e4c3a2d6240958ab6858efb88c1d06a_Out_1[1];
            float _Split_600a9d271d96798a94ab28118977defd_B_3 = _Transform_1e4c3a2d6240958ab6858efb88c1d06a_Out_1[2];
            float _Split_600a9d271d96798a94ab28118977defd_A_4 = 0;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Multiply_2e5b010626435f8492a2690396ced19d_Out_2;
            Unity_Multiply_float(_Split_600a9d271d96798a94ab28118977defd_G_2, _Clamp_95d579f83746cb82be79cf6739990e0b_Out_3, _Multiply_2e5b010626435f8492a2690396ced19d_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Multiply_5a2397e0153ddb8f9bd457d9a301dc8b_Out_2;
            Unity_Multiply_float(_Clamp_95d579f83746cb82be79cf6739990e0b_Out_3, _Property_27e768ffa9c13e8ab65d48e7712e5b66_Out_0, _Multiply_5a2397e0153ddb8f9bd457d9a301dc8b_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Multiply_3aad76eaff60dd888c3e1783ecf03943_Out_2;
            Unity_Multiply_float(_Multiply_5a2397e0153ddb8f9bd457d9a301dc8b_Out_2, _Multiply_7ea7400ed65a3582b000796fb39748e9_Out_2, _Multiply_3aad76eaff60dd888c3e1783ecf03943_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Multiply_05614e740451f18f8301586390aa5a0a_Out_2;
            Unity_Multiply_float(_Multiply_2e5b010626435f8492a2690396ced19d_Out_2, _Multiply_3aad76eaff60dd888c3e1783ecf03943_Out_2, _Multiply_05614e740451f18f8301586390aa5a0a_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            UnityTexture2D _Property_a14f2476a35d208b988233c852f919ef_Out_0 = UnityBuildTexture2DStructNoScale(_CoverMaskMap);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            Bindings_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6 _PlanarNM_6858a0e821f26a8d87846d325e9bd170;
            _PlanarNM_6858a0e821f26a8d87846d325e9bd170.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            _PlanarNM_6858a0e821f26a8d87846d325e9bd170.uv0 = IN.uv0;
            float4 _PlanarNM_6858a0e821f26a8d87846d325e9bd170_XZ_2;
            SG_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6(_Property_a14f2476a35d208b988233c852f919ef_Out_0, _Property_e35c79b8cccfbe8ca0a3c33e8d32e319_Out_0, _Property_e3d8b38b51331e879b1d4012d65f53e6_Out_0, _PlanarNM_6858a0e821f26a8d87846d325e9bd170, _PlanarNM_6858a0e821f26a8d87846d325e9bd170_XZ_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Split_16313c20ccdeaa86a639068877a69a2f_R_1 = _PlanarNM_6858a0e821f26a8d87846d325e9bd170_XZ_2[0];
            float _Split_16313c20ccdeaa86a639068877a69a2f_G_2 = _PlanarNM_6858a0e821f26a8d87846d325e9bd170_XZ_2[1];
            float _Split_16313c20ccdeaa86a639068877a69a2f_B_3 = _PlanarNM_6858a0e821f26a8d87846d325e9bd170_XZ_2[2];
            float _Split_16313c20ccdeaa86a639068877a69a2f_A_4 = _PlanarNM_6858a0e821f26a8d87846d325e9bd170_XZ_2[3];
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_673896519f419589938b37e782b90141_Out_0 = _CoverHeightMapMin;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_c35906332422438da3b19f45cbd5ac17_Out_0 = _CoverHeightMapMax;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float2 _Vector2_81cbe1e5ea789e8697223cd3bfbca76c_Out_0 = float2(_Property_673896519f419589938b37e782b90141_Out_0, _Property_c35906332422438da3b19f45cbd5ac17_Out_0);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_88ab0068f899fc8ba94efdaec5e8966b_Out_0 = _CoverHeightMapOffset;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float2 _Add_cd623e3135271489b0d45b4d7edc5f7e_Out_2;
            Unity_Add_float2(_Vector2_81cbe1e5ea789e8697223cd3bfbca76c_Out_0, (_Property_88ab0068f899fc8ba94efdaec5e8966b_Out_0.xx), _Add_cd623e3135271489b0d45b4d7edc5f7e_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Remap_9a23d5f76fa8c38dbd73f43bd6397b0b_Out_3;
            Unity_Remap_float(_Split_16313c20ccdeaa86a639068877a69a2f_B_3, float2 (0, 1), _Add_cd623e3135271489b0d45b4d7edc5f7e_Out_2, _Remap_9a23d5f76fa8c38dbd73f43bd6397b0b_Out_3);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Multiply_0093be0fd848498b89a0fa282608e715_Out_2;
            Unity_Multiply_float(_Multiply_05614e740451f18f8301586390aa5a0a_Out_2, _Remap_9a23d5f76fa8c38dbd73f43bd6397b0b_Out_3, _Multiply_0093be0fd848498b89a0fa282608e715_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Multiply_d3190f97afd0398083623ecf71a41b1a_Out_2;
            Unity_Multiply_float(_Split_8ba5b67899f36b8f9dcf5c84092c0560_G_2, _Multiply_0093be0fd848498b89a0fa282608e715_Out_2, _Multiply_d3190f97afd0398083623ecf71a41b1a_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Saturate_cbcee34e7e6e6d8091d840550ab1c74a_Out_1;
            Unity_Saturate_float(_Multiply_d3190f97afd0398083623ecf71a41b1a_Out_2, _Saturate_cbcee34e7e6e6d8091d840550ab1c74a_Out_1);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Multiply_da35b9d9e4dd8c81871a9aea42c157ee_Out_2;
            Unity_Multiply_float(_Clamp_030a7c32684c258084338456eaddc77a_Out_3, _Saturate_cbcee34e7e6e6d8091d840550ab1c74a_Out_1, _Multiply_da35b9d9e4dd8c81871a9aea42c157ee_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Clamp_c95f5515948375878df6581a36d8b203_Out_3;
            Unity_Clamp_float(_Multiply_da35b9d9e4dd8c81871a9aea42c157ee_Out_2, 0, 1, _Clamp_c95f5515948375878df6581a36d8b203_Out_3);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            #if defined(_USEDYNAMICCOVERTSTATICMASKF_ON)
            float _UseDynamicCoverTStaticMaskF_0694902516172b8fa469c5d8b8e938c6_Out_0 = _Clamp_c95f5515948375878df6581a36d8b203_Out_3;
            #else
            float _UseDynamicCoverTStaticMaskF_0694902516172b8fa469c5d8b8e938c6_Out_0 = _Clamp_030a7c32684c258084338456eaddc77a_Out_3;
            #endif
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 _Lerp_87882219e20a6d818c0de017d739125f_Out_3;
            Unity_Lerp_float3(_BlendOverlayBaseColor_f3cd25d5b673648eb831a3f388201f73_OutVector4_1, (_Multiply_2eb83c7af5b6f58eabeec7b502517470_Out_2.xyz), (_UseDynamicCoverTStaticMaskF_0694902516172b8fa469c5d8b8e938c6_Out_0.xxx), _Lerp_87882219e20a6d818c0de017d739125f_Out_3);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 _Property_4c7bd3690d9d8a838e2524f5908e09ee_Out_0 = _WetColor;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 _Multiply_77c751a5503e948d8952b403163b4eeb_Out_2;
            Unity_Multiply_float((_Property_4c7bd3690d9d8a838e2524f5908e09ee_Out_0.xyz), _Lerp_87882219e20a6d818c0de017d739125f_Out_3, _Multiply_77c751a5503e948d8952b403163b4eeb_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _OneMinus_9b165e3f6c2fdd88a5f3a51230f8dd33_Out_1;
            Unity_OneMinus_float(_Split_8ba5b67899f36b8f9dcf5c84092c0560_R_1, _OneMinus_9b165e3f6c2fdd88a5f3a51230f8dd33_Out_1);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 _Lerp_538fa3f69b550a8bbe8ee20906ecc752_Out_3;
            Unity_Lerp_float3(_Lerp_87882219e20a6d818c0de017d739125f_Out_3, _Multiply_77c751a5503e948d8952b403163b4eeb_Out_2, (_OneMinus_9b165e3f6c2fdd88a5f3a51230f8dd33_Out_1.xxx), _Lerp_538fa3f69b550a8bbe8ee20906ecc752_Out_3);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_486692dad4d34a8c8410b4771efbf96b_Out_0 = _CoverNormalScale;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 _NormalStrength_d60a055f00d779808337e9d909827806_Out_2;
            Unity_NormalStrength_float((_PlanarNMn_79abde32a0223a89907c9f09efac8db7_XZ_2.xyz), _Property_486692dad4d34a8c8410b4771efbf96b_Out_0, _NormalStrength_d60a055f00d779808337e9d909827806_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 _Lerp_6861b6a37faf5e868527d229073a4d0f_Out_3;
            Unity_Lerp_float3(_NormalBlend_be36dd49bea74c8f8dd52fa3a85a9534_Out_2, _NormalStrength_d60a055f00d779808337e9d909827806_Out_2, (_UseDynamicCoverTStaticMaskF_0694902516172b8fa469c5d8b8e938c6_Out_0.xxx), _Lerp_6861b6a37faf5e868527d229073a4d0f_Out_3);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            UnityTexture2D _Property_a1adaaa2a22b0e829756ccb08eab9146_Out_0 = UnityBuildTexture2DStructNoScale(_BaseMaskMap);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            Bindings_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6 _PlanarNM_d26fd10040332c89b94151832fa36c95;
            _PlanarNM_d26fd10040332c89b94151832fa36c95.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            _PlanarNM_d26fd10040332c89b94151832fa36c95.uv0 = IN.uv0;
            float4 _PlanarNM_d26fd10040332c89b94151832fa36c95_XZ_2;
            SG_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6(_Property_a1adaaa2a22b0e829756ccb08eab9146_Out_0, _Property_115fcc827510f38798b214d835c27637_Out_0, _Property_d83b8f290862b285bbe2f157190e1315_Out_0, _PlanarNM_d26fd10040332c89b94151832fa36c95, _PlanarNM_d26fd10040332c89b94151832fa36c95_XZ_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Split_c8dcaee88e16428ab476271a494e0946_R_1 = _PlanarNM_d26fd10040332c89b94151832fa36c95_XZ_2[0];
            float _Split_c8dcaee88e16428ab476271a494e0946_G_2 = _PlanarNM_d26fd10040332c89b94151832fa36c95_XZ_2[1];
            float _Split_c8dcaee88e16428ab476271a494e0946_B_3 = _PlanarNM_d26fd10040332c89b94151832fa36c95_XZ_2[2];
            float _Split_c8dcaee88e16428ab476271a494e0946_A_4 = _PlanarNM_d26fd10040332c89b94151832fa36c95_XZ_2[3];
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_06c41396a31ba582877d3a10387f69e6_Out_0 = _BaseMetallic;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Multiply_1e8010b400ec9689a4d8570c8fb2dd6e_Out_2;
            Unity_Multiply_float(_Split_c8dcaee88e16428ab476271a494e0946_R_1, _Property_06c41396a31ba582877d3a10387f69e6_Out_0, _Multiply_1e8010b400ec9689a4d8570c8fb2dd6e_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_2dbdbebc756fb1819344efcc68c07d00_Out_0 = _BaseAORemapMin;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_bdc878630dfca586bff66e5b4bfffe30_Out_0 = _BaseAORemapMax;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float2 _Vector2_7f058afa3dd186869dd0f2d889a637bb_Out_0 = float2(_Property_2dbdbebc756fb1819344efcc68c07d00_Out_0, _Property_bdc878630dfca586bff66e5b4bfffe30_Out_0);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Remap_736c05b9e06ff78597a5b300523c5e04_Out_3;
            Unity_Remap_float(_Split_c8dcaee88e16428ab476271a494e0946_G_2, float2 (0, 1), _Vector2_7f058afa3dd186869dd0f2d889a637bb_Out_0, _Remap_736c05b9e06ff78597a5b300523c5e04_Out_3);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_dbfeaf948b34478090dd8f1a3d0e2440_Out_0 = _BaseSmoothnessRemapMin;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_d7d9704f0497d58ea30c73507241d8e4_Out_0 = _BaseSmoothnessRemapMax;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float2 _Vector2_03bee8a712eb848f9058c9ca67139ff0_Out_0 = float2(_Property_dbfeaf948b34478090dd8f1a3d0e2440_Out_0, _Property_d7d9704f0497d58ea30c73507241d8e4_Out_0);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Remap_9fa10d7f73353f8d98e7e00ad7887efd_Out_3;
            Unity_Remap_float(_Split_c8dcaee88e16428ab476271a494e0946_A_4, float2 (0, 1), _Vector2_03bee8a712eb848f9058c9ca67139ff0_Out_0, _Remap_9fa10d7f73353f8d98e7e00ad7887efd_Out_3);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Multiply_93138f23185e4d83b6825f8212653c3e_Out_2;
            Unity_Multiply_float(_SampleTexture2D_fa4ac40fc922b9869e37c06690c0f530_B_6, 2, _Multiply_93138f23185e4d83b6825f8212653c3e_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Add_53ebd006b8d6448881dfe527be4ca8e6_Out_2;
            Unity_Add_float(_Multiply_93138f23185e4d83b6825f8212653c3e_Out_2, -1, _Add_53ebd006b8d6448881dfe527be4ca8e6_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_dadcc7446e5d388e9a6730406295f93a_Out_0 = _DetailSmoothnessScale;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Multiply_1de6b43ae21981829be79a3a54ae243b_Out_2;
            Unity_Multiply_float(_Add_53ebd006b8d6448881dfe527be4ca8e6_Out_2, _Property_dadcc7446e5d388e9a6730406295f93a_Out_0, _Multiply_1de6b43ae21981829be79a3a54ae243b_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Saturate_0834275a3ed56c8fb32773dd6424fe67_Out_1;
            Unity_Saturate_float(_Multiply_1de6b43ae21981829be79a3a54ae243b_Out_2, _Saturate_0834275a3ed56c8fb32773dd6424fe67_Out_1);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Absolute_ca93b0439159da8d944e94364e98a3a5_Out_1;
            Unity_Absolute_float(_Saturate_0834275a3ed56c8fb32773dd6424fe67_Out_1, _Absolute_ca93b0439159da8d944e94364e98a3a5_Out_1);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            Bindings_BlendOverlayDetailSmoothness_06e12138dc89c0040b45a57abe520a1a _BlendOverlayDetailSmoothness_586cd13379fb3187a73a451ca1585fb7;
            float _BlendOverlayDetailSmoothness_586cd13379fb3187a73a451ca1585fb7_SmoothnessOverlay_1;
            SG_BlendOverlayDetailSmoothness_06e12138dc89c0040b45a57abe520a1a(_Remap_9fa10d7f73353f8d98e7e00ad7887efd_Out_3, _Add_53ebd006b8d6448881dfe527be4ca8e6_Out_2, _Absolute_ca93b0439159da8d944e94364e98a3a5_Out_1, _BlendOverlayDetailSmoothness_586cd13379fb3187a73a451ca1585fb7, _BlendOverlayDetailSmoothness_586cd13379fb3187a73a451ca1585fb7_SmoothnessOverlay_1);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Saturate_6a86fd5df2ee918a83675f1c42dd4511_Out_1;
            Unity_Saturate_float(_BlendOverlayDetailSmoothness_586cd13379fb3187a73a451ca1585fb7_SmoothnessOverlay_1, _Saturate_6a86fd5df2ee918a83675f1c42dd4511_Out_1);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 _Vector3_b34af5a5e4b21588a99ba5eb5358a84d_Out_0 = float3(_Multiply_1e8010b400ec9689a4d8570c8fb2dd6e_Out_2, _Remap_736c05b9e06ff78597a5b300523c5e04_Out_3, _Saturate_6a86fd5df2ee918a83675f1c42dd4511_Out_1);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_dc64ffdb5487f38c8fafcef1d518b3eb_Out_0 = _CoverMetallic;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Multiply_62c6df8b3ac33382bb38f0b594d1a4fa_Out_2;
            Unity_Multiply_float(_Split_16313c20ccdeaa86a639068877a69a2f_R_1, _Property_dc64ffdb5487f38c8fafcef1d518b3eb_Out_0, _Multiply_62c6df8b3ac33382bb38f0b594d1a4fa_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_2696a3815c73848db1c5516a77ad7e3e_Out_0 = _CoverAORemapMin;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_dc6e42b9f380d88fb5998902d1ddaa45_Out_0 = _CoverAORemapMax;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float2 _Vector2_6f054e667fb031849116087b7663e8de_Out_0 = float2(_Property_2696a3815c73848db1c5516a77ad7e3e_Out_0, _Property_dc6e42b9f380d88fb5998902d1ddaa45_Out_0);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Remap_805dc695e2ca6186842dd0c16c68fe7a_Out_3;
            Unity_Remap_float(_Split_16313c20ccdeaa86a639068877a69a2f_G_2, float2 (0, 1), _Vector2_6f054e667fb031849116087b7663e8de_Out_0, _Remap_805dc695e2ca6186842dd0c16c68fe7a_Out_3);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_05c4f672b1175a84b0d7ce44b23b4aa4_Out_0 = _CoverSmoothnessRemapMin;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_5f3529123a9ea982984b3bdc33dcb041_Out_0 = _CoverSmoothnessRemapMax;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float2 _Vector2_1eb7cc7a8699a889b2b636baa84fc4fd_Out_0 = float2(_Property_05c4f672b1175a84b0d7ce44b23b4aa4_Out_0, _Property_5f3529123a9ea982984b3bdc33dcb041_Out_0);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Remap_2e561d2a6ce223819f2665623c7c6c94_Out_3;
            Unity_Remap_float(_Split_16313c20ccdeaa86a639068877a69a2f_A_4, float2 (0, 1), _Vector2_1eb7cc7a8699a889b2b636baa84fc4fd_Out_0, _Remap_2e561d2a6ce223819f2665623c7c6c94_Out_3);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 _Vector3_9d828b596b436f898d7f64ebfd86402e_Out_0 = float3(_Multiply_62c6df8b3ac33382bb38f0b594d1a4fa_Out_2, _Remap_805dc695e2ca6186842dd0c16c68fe7a_Out_3, _Remap_2e561d2a6ce223819f2665623c7c6c94_Out_3);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 _Lerp_5a4703a1c1c9e387bdf52325fcd883e8_Out_3;
            Unity_Lerp_float3(_Vector3_b34af5a5e4b21588a99ba5eb5358a84d_Out_0, _Vector3_9d828b596b436f898d7f64ebfd86402e_Out_0, (_UseDynamicCoverTStaticMaskF_0694902516172b8fa469c5d8b8e938c6_Out_0.xxx), _Lerp_5a4703a1c1c9e387bdf52325fcd883e8_Out_3);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Split_b9b4ede5ed4eaf82a5409e98b1310654_R_1 = _Lerp_5a4703a1c1c9e387bdf52325fcd883e8_Out_3[0];
            float _Split_b9b4ede5ed4eaf82a5409e98b1310654_G_2 = _Lerp_5a4703a1c1c9e387bdf52325fcd883e8_Out_3[1];
            float _Split_b9b4ede5ed4eaf82a5409e98b1310654_B_3 = _Lerp_5a4703a1c1c9e387bdf52325fcd883e8_Out_3[2];
            float _Split_b9b4ede5ed4eaf82a5409e98b1310654_A_4 = 0;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_44a514a11d8fcc84aeab495181ebe3f0_Out_0 = _WetSmoothness;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Lerp_9c25fc1869bb8b83b41e153899e44f1a_Out_3;
            Unity_Lerp_float(_Split_b9b4ede5ed4eaf82a5409e98b1310654_B_3, _Property_44a514a11d8fcc84aeab495181ebe3f0_Out_0, _OneMinus_9b165e3f6c2fdd88a5f3a51230f8dd33_Out_1, _Lerp_9c25fc1869bb8b83b41e153899e44f1a_Out_3);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Split_31874fa1d55cb28e99a1333cf254676a_R_1 = _PlanarNM_6c8b686076db2a8c8b7d6cd91cf435f0_XZ_2[0];
            float _Split_31874fa1d55cb28e99a1333cf254676a_G_2 = _PlanarNM_6c8b686076db2a8c8b7d6cd91cf435f0_XZ_2[1];
            float _Split_31874fa1d55cb28e99a1333cf254676a_B_3 = _PlanarNM_6c8b686076db2a8c8b7d6cd91cf435f0_XZ_2[2];
            float _Split_31874fa1d55cb28e99a1333cf254676a_A_4 = _PlanarNM_6c8b686076db2a8c8b7d6cd91cf435f0_XZ_2[3];
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_881c341218ea2d81819695b0c7ddc4cb_Out_0 = _AlphaCutoff;
            #endif
            surface.BaseColor = _Lerp_538fa3f69b550a8bbe8ee20906ecc752_Out_3;
            surface.NormalTS = _Lerp_6861b6a37faf5e868527d229073a4d0f_Out_3;
            surface.Emission = float3(0, 0, 0);
            surface.Metallic = _Split_b9b4ede5ed4eaf82a5409e98b1310654_R_1;
            surface.Smoothness = _Lerp_9c25fc1869bb8b83b41e153899e44f1a_Out_3;
            surface.Occlusion = _Split_b9b4ede5ed4eaf82a5409e98b1310654_G_2;
            surface.Alpha = _Split_31874fa1d55cb28e99a1333cf254676a_A_4;
            surface.AlphaClipThreshold = _Property_881c341218ea2d81819695b0c7ddc4cb_Out_0;
            return surface;
        }

            // --------------------------------------------------
            // Build Graph Inputs

            VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.ObjectSpaceNormal =           input.normalOS;
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.ObjectSpaceTangent =          input.tangentOS.xyz;
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.ObjectSpacePosition =         input.positionOS;
        #endif


            return output;
        }
            SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        // must use interpolated tangent, bitangent and normal before they are normalized in the pixel shader.
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        float3 unnormalizedNormalWS = input.normalWS;
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        const float renormFactor = 1.0 / length(unnormalizedNormalWS);
        #endif


        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        // use bitangent on the fly like in hdrp
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        // IMPORTANT! If we ever support Flip on double sided materials ensure bitangent and tangent are NOT flipped.
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        float crossSign = (input.tangentWS.w > 0.0 ? 1.0 : -1.0) * GetOddNegativeScale();
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        float3 bitang = crossSign * cross(input.normalWS.xyz, input.tangentWS.xyz);
        #endif


        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.WorldSpaceNormal =            renormFactor*input.normalWS.xyz;      // we want a unit length Normal Vector node in shader graph
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.TangentSpaceNormal =          float3(0.0f, 0.0f, 1.0f);
        #endif


        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        // to preserve mikktspace compliance we use same scale renormFactor as was used on the normal.
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        // This is explained in section 2.2 in "surface gradient based bump mapping framework"
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.WorldSpaceTangent =           renormFactor*input.tangentWS.xyz;
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.WorldSpaceBiTangent =         renormFactor*bitang;
        #endif


        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.AbsoluteWorldSpacePosition =  GetAbsolutePositionWS(input.positionWS);
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.uv0 =                         input.texCoord0;
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.VertexColor =                 input.color;
        #endif

        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN

            return output;
        }

            // --------------------------------------------------
            // Main

            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/PBRForwardPass.hlsl"

            ENDHLSL
        }
        Pass
        {
            Name "GBuffer"
            Tags
            {
                "LightMode" = "UniversalGBuffer"
            }

            // Render State
            Cull Back
        Blend One Zero
        ZTest LEqual
        ZWrite On

            // Debug
            // <None>

            // --------------------------------------------------
            // Pass

            HLSLPROGRAM

            // Pragmas
            #pragma target 4.5
        #pragma exclude_renderers gles gles3 glcore
        #pragma multi_compile_instancing
        #pragma multi_compile_fog
        #pragma multi_compile _ DOTS_INSTANCING_ON
        #pragma vertex vert
        #pragma fragment frag

            // DotsInstancingOptions: <None>
            // HybridV1InjectedBuiltinProperties: <None>

            // Keywords
            #pragma multi_compile _ LIGHTMAP_ON
        #pragma multi_compile _ DIRLIGHTMAP_COMBINED
        #pragma multi_compile _ _MAIN_LIGHT_SHADOWS _MAIN_LIGHT_SHADOWS_CASCADE _MAIN_LIGHT_SHADOWS_SCREEN
        #pragma multi_compile _ _SHADOWS_SOFT
        #pragma multi_compile _ _MIXED_LIGHTING_SUBTRACTIVE
        #pragma multi_compile _ _GBUFFER_NORMALS_OCT
            #pragma shader_feature_local _ _USEDYNAMICCOVERTSTATICMASKF_ON

        #if defined(_USEDYNAMICCOVERTSTATICMASKF_ON)
            #define KEYWORD_PERMUTATION_0
        #else
            #define KEYWORD_PERMUTATION_1
        #endif


            // Defines
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define _AlphaClip 1
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define _NORMALMAP 1
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define _NORMAL_DROPOFF_TS 1
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define ATTRIBUTES_NEED_NORMAL
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define ATTRIBUTES_NEED_TANGENT
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define ATTRIBUTES_NEED_TEXCOORD0
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define ATTRIBUTES_NEED_TEXCOORD1
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define ATTRIBUTES_NEED_COLOR
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define VARYINGS_NEED_POSITION_WS
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define VARYINGS_NEED_NORMAL_WS
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define VARYINGS_NEED_TANGENT_WS
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define VARYINGS_NEED_TEXCOORD0
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define VARYINGS_NEED_COLOR
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define VARYINGS_NEED_VIEWDIRECTION_WS
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define VARYINGS_NEED_FOG_AND_VERTEX_LIGHT
        #endif

            #define FEATURES_GRAPH_VERTEX
            /* WARNING: $splice Could not find named fragment 'PassInstancing' */
            #define SHADERPASS SHADERPASS_GBUFFER
            /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */

            // Includes
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Shadows.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"

            // --------------------------------------------------
            // Structs and Packing

            struct Attributes
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 positionOS : POSITION;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 normalOS : NORMAL;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 tangentOS : TANGENT;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 uv0 : TEXCOORD0;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 uv1 : TEXCOORD1;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 color : COLOR;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            uint instanceID : INSTANCEID_SEMANTIC;
            #endif
            #endif
        };
        struct Varyings
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 positionCS : SV_POSITION;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 positionWS;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 normalWS;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 tangentWS;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 texCoord0;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 color;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 viewDirectionWS;
            #endif
            #if defined(LIGHTMAP_ON)
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float2 lightmapUV;
            #endif
            #endif
            #if !defined(LIGHTMAP_ON)
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 sh;
            #endif
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 fogFactorAndVertexLight;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 shadowCoord;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
            #endif
        };
        struct SurfaceDescriptionInputs
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 WorldSpaceNormal;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 TangentSpaceNormal;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 WorldSpaceTangent;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 WorldSpaceBiTangent;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 AbsoluteWorldSpacePosition;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 uv0;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 VertexColor;
            #endif
        };
        struct VertexDescriptionInputs
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 ObjectSpaceNormal;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 ObjectSpaceTangent;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 ObjectSpacePosition;
            #endif
        };
        struct PackedVaryings
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 positionCS : SV_POSITION;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 interp0 : TEXCOORD0;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 interp1 : TEXCOORD1;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 interp2 : TEXCOORD2;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 interp3 : TEXCOORD3;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 interp4 : TEXCOORD4;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 interp5 : TEXCOORD5;
            #endif
            #if defined(LIGHTMAP_ON)
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float2 interp6 : TEXCOORD6;
            #endif
            #endif
            #if !defined(LIGHTMAP_ON)
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 interp7 : TEXCOORD7;
            #endif
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 interp8 : TEXCOORD8;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 interp9 : TEXCOORD9;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
            #endif
        };

            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            output.positionCS = input.positionCS;
            output.interp0.xyz =  input.positionWS;
            output.interp1.xyz =  input.normalWS;
            output.interp2.xyzw =  input.tangentWS;
            output.interp3.xyzw =  input.texCoord0;
            output.interp4.xyzw =  input.color;
            output.interp5.xyz =  input.viewDirectionWS;
            #if defined(LIGHTMAP_ON)
            output.interp6.xy =  input.lightmapUV;
            #endif
            #if !defined(LIGHTMAP_ON)
            output.interp7.xyz =  input.sh;
            #endif
            output.interp8.xyzw =  input.fogFactorAndVertexLight;
            output.interp9.xyzw =  input.shadowCoord;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.positionWS = input.interp0.xyz;
            output.normalWS = input.interp1.xyz;
            output.tangentWS = input.interp2.xyzw;
            output.texCoord0 = input.interp3.xyzw;
            output.color = input.interp4.xyzw;
            output.viewDirectionWS = input.interp5.xyz;
            #if defined(LIGHTMAP_ON)
            output.lightmapUV = input.interp6.xy;
            #endif
            #if !defined(LIGHTMAP_ON)
            output.sh = input.interp7.xyz;
            #endif
            output.fogFactorAndVertexLight = input.interp8.xyzw;
            output.shadowCoord = input.interp9.xyzw;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        #endif

            // --------------------------------------------------
            // Graph

            // Graph Properties
            CBUFFER_START(UnityPerMaterial)
        float _AlphaCutoff;
        float4 _BaseColor;
        float4 _BaseColorMap_TexelSize;
        float _BaseUsePlanarUV;
        float4 _BaseTilingOffset;
        float4 _BaseNormalMap_TexelSize;
        float _BaseNormalScale;
        float4 _BaseMaskMap_TexelSize;
        float _BaseMetallic;
        float _BaseAORemapMin;
        float _BaseAORemapMax;
        float _BaseSmoothnessRemapMin;
        float _BaseSmoothnessRemapMax;
        float4 _CoverMaskA_TexelSize;
        float _CoverMaskPower;
        float _Cover_Amount;
        float _Cover_Amount_Grow_Speed;
        float _Cover_Max_Angle;
        float _Cover_Min_Height;
        float _Cover_Min_Height_Blending;
        float4 _CoverBaseColor;
        float4 _CoverBaseColorMap_TexelSize;
        float _CoverUsePlanarUV;
        float4 _CoverTilingOffset;
        float4 _CoverNormalMap_TexelSize;
        float _CoverNormalScale;
        float _CoverNormalBlendHardness;
        float _CoverHardness;
        float _CoverHeightMapMin;
        float _CoverHeightMapMax;
        float _CoverHeightMapOffset;
        float4 _CoverMaskMap_TexelSize;
        float _CoverMetallic;
        float _CoverAORemapMin;
        float _CoverAORemapMax;
        float _CoverSmoothnessRemapMin;
        float _CoverSmoothnessRemapMax;
        float4 _DetailMap_TexelSize;
        float4 _DetailTilingOffset;
        float _DetailAlbedoScale;
        float _DetailNormalScale;
        float _DetailSmoothnessScale;
        float4 _WetColor;
        float _WetSmoothness;
        CBUFFER_END

        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_BaseColorMap);
        SAMPLER(sampler_BaseColorMap);
        TEXTURE2D(_BaseNormalMap);
        SAMPLER(sampler_BaseNormalMap);
        TEXTURE2D(_BaseMaskMap);
        SAMPLER(sampler_BaseMaskMap);
        TEXTURE2D(_CoverMaskA);
        SAMPLER(sampler_CoverMaskA);
        TEXTURE2D(_CoverBaseColorMap);
        SAMPLER(sampler_CoverBaseColorMap);
        TEXTURE2D(_CoverNormalMap);
        SAMPLER(sampler_CoverNormalMap);
        TEXTURE2D(_CoverMaskMap);
        SAMPLER(sampler_CoverMaskMap);
        TEXTURE2D(_DetailMap);
        SAMPLER(sampler_DetailMap);

            // Graph Functions
            
        // f948cdce565a6e706cc57cb23fbf9d95
        #include "./NM_Object_VSPro_Indirect.cginc"

        void AddPragma_float(float3 A, out float3 Out){
            #pragma instancing_options renderinglayer procedural:setupVSPro
            Out = A;
        }

        struct Bindings_NMObjectVSProIndirect_0cfe1e4f145944241ab304331e53c93b
        {
        };

        void SG_NMObjectVSProIndirect_0cfe1e4f145944241ab304331e53c93b(float3 Vector3_314C8600, Bindings_NMObjectVSProIndirect_0cfe1e4f145944241ab304331e53c93b IN, out float3 ObjectSpacePosition_1)
        {
            float3 _Property_5ec158abd968858c9d31ab40df5e9e6f_Out_0 = Vector3_314C8600;
            float3 _InjectSetupCustomFunction_dec9b26544b4a788b8ecb4117dc3d24a_Out_1;
            InjectSetup_float(_Property_5ec158abd968858c9d31ab40df5e9e6f_Out_0, _InjectSetupCustomFunction_dec9b26544b4a788b8ecb4117dc3d24a_Out_1);
            float3 _AddPragmaCustomFunction_b2a053178906d0848480a1f463521a1b_Out_1;
            AddPragma_float(_InjectSetupCustomFunction_dec9b26544b4a788b8ecb4117dc3d24a_Out_1, _AddPragmaCustomFunction_b2a053178906d0848480a1f463521a1b_Out_1);
            ObjectSpacePosition_1 = _AddPragmaCustomFunction_b2a053178906d0848480a1f463521a1b_Out_1;
        }

        void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
        {
            RGBA = float4(R, G, B, A);
            RGB = float3(R, G, B);
            RG = float2(R, G);
        }

        void Unity_Divide_float(float A, float B, out float Out)
        {
            Out = A / B;
        }

        void Unity_Multiply_float(float4 A, float4 B, out float4 Out)
        {
            Out = A * B;
        }

        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }

        void Unity_Branch_float2(float Predicate, float2 True, float2 False, out float2 Out)
        {
            Out = Predicate ? True : False;
        }

        struct Bindings_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6
        {
            float3 AbsoluteWorldSpacePosition;
            half4 uv0;
        };

        void SG_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6(UnityTexture2D Texture2D_80A3D28F, float4 Vector4_2EBA7A3B, float Boolean_7ABB9909, Bindings_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6 IN, out float4 XZ_2)
        {
            UnityTexture2D _Property_3e01b4d2fc68d48ba3acbba9d5881e59_Out_0 = Texture2D_80A3D28F;
            float _Property_30834f691775a0898a45b1c868520436_Out_0 = Boolean_7ABB9909;
            float _Split_89ed63cb625cb3878c183d0b71c03400_R_1 = IN.AbsoluteWorldSpacePosition[0];
            float _Split_89ed63cb625cb3878c183d0b71c03400_G_2 = IN.AbsoluteWorldSpacePosition[1];
            float _Split_89ed63cb625cb3878c183d0b71c03400_B_3 = IN.AbsoluteWorldSpacePosition[2];
            float _Split_89ed63cb625cb3878c183d0b71c03400_A_4 = 0;
            float4 _Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4;
            float3 _Combine_cf2d04ff119ad88493f6460431765cbb_RGB_5;
            float2 _Combine_cf2d04ff119ad88493f6460431765cbb_RG_6;
            Unity_Combine_float(_Split_89ed63cb625cb3878c183d0b71c03400_R_1, _Split_89ed63cb625cb3878c183d0b71c03400_B_3, 0, 0, _Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4, _Combine_cf2d04ff119ad88493f6460431765cbb_RGB_5, _Combine_cf2d04ff119ad88493f6460431765cbb_RG_6);
            float4 _Property_8a66888ec47d0687ab1cb2f8abdc9da8_Out_0 = Vector4_2EBA7A3B;
            float _Split_2f0f52f6ef8c0e81af0da6476402bc1f_R_1 = _Property_8a66888ec47d0687ab1cb2f8abdc9da8_Out_0[0];
            float _Split_2f0f52f6ef8c0e81af0da6476402bc1f_G_2 = _Property_8a66888ec47d0687ab1cb2f8abdc9da8_Out_0[1];
            float _Split_2f0f52f6ef8c0e81af0da6476402bc1f_B_3 = _Property_8a66888ec47d0687ab1cb2f8abdc9da8_Out_0[2];
            float _Split_2f0f52f6ef8c0e81af0da6476402bc1f_A_4 = _Property_8a66888ec47d0687ab1cb2f8abdc9da8_Out_0[3];
            float _Divide_e64179199923c58289b6aa94ea6c9178_Out_2;
            Unity_Divide_float(1, _Split_2f0f52f6ef8c0e81af0da6476402bc1f_R_1, _Divide_e64179199923c58289b6aa94ea6c9178_Out_2);
            float4 _Multiply_14cec4902d0a00829e4555071a1b8ad1_Out_2;
            Unity_Multiply_float(_Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4, (_Divide_e64179199923c58289b6aa94ea6c9178_Out_2.xxxx), _Multiply_14cec4902d0a00829e4555071a1b8ad1_Out_2);
            float2 _Vector2_16c15d3bbdd14b85bd48e3a6cb318af7_Out_0 = float2(_Split_2f0f52f6ef8c0e81af0da6476402bc1f_R_1, _Split_2f0f52f6ef8c0e81af0da6476402bc1f_G_2);
            float2 _Vector2_f8d75f54e7705083bbec539a60185577_Out_0 = float2(_Split_2f0f52f6ef8c0e81af0da6476402bc1f_B_3, _Split_2f0f52f6ef8c0e81af0da6476402bc1f_A_4);
            float2 _TilingAndOffset_d91e2d25acd34686b562b7fe7e9d1d27_Out_3;
            Unity_TilingAndOffset_float(IN.uv0.xy, _Vector2_16c15d3bbdd14b85bd48e3a6cb318af7_Out_0, _Vector2_f8d75f54e7705083bbec539a60185577_Out_0, _TilingAndOffset_d91e2d25acd34686b562b7fe7e9d1d27_Out_3);
            float2 _Branch_8e5a4e8f4d52fc8aadd1f46485afc933_Out_3;
            Unity_Branch_float2(_Property_30834f691775a0898a45b1c868520436_Out_0, (_Multiply_14cec4902d0a00829e4555071a1b8ad1_Out_2.xy), _TilingAndOffset_d91e2d25acd34686b562b7fe7e9d1d27_Out_3, _Branch_8e5a4e8f4d52fc8aadd1f46485afc933_Out_3);
            float4 _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0 = SAMPLE_TEXTURE2D(_Property_3e01b4d2fc68d48ba3acbba9d5881e59_Out_0.tex, _Property_3e01b4d2fc68d48ba3acbba9d5881e59_Out_0.samplerstate, _Branch_8e5a4e8f4d52fc8aadd1f46485afc933_Out_3);
            float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_R_4 = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0.r;
            float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_G_5 = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0.g;
            float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_B_6 = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0.b;
            float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_A_7 = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0.a;
            XZ_2 = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0;
        }

        void Unity_Multiply_float(float A, float B, out float Out)
        {
            Out = A * B;
        }

        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
        }

        void Unity_Saturate_float(float In, out float Out)
        {
            Out = saturate(In);
        }

        void Unity_Absolute_float(float In, out float Out)
        {
            Out = abs(In);
        }

        void Unity_SquareRoot_float4(float4 In, out float4 Out)
        {
            Out = sqrt(In);
        }

        void Unity_Sign_float(float In, out float Out)
        {
            Out = sign(In);
        }

        void Unity_Ceiling_float(float In, out float Out)
        {
            Out = ceil(In);
        }

        void Unity_Lerp_float4(float4 A, float4 B, float4 T, out float4 Out)
        {
            Out = lerp(A, B, T);
        }

        struct Bindings_BlendOverlayBaseColor_acdb3dfca72bd6b42bbc35f4613331a2
        {
        };

        void SG_BlendOverlayBaseColor_acdb3dfca72bd6b42bbc35f4613331a2(float4 Color_9AA111D3, float Vector1_FBE622A2, float Vector1_8C15C351, Bindings_BlendOverlayBaseColor_acdb3dfca72bd6b42bbc35f4613331a2 IN, out float3 OutVector4_1)
        {
            float4 _Property_012510d774fb7f8b860f5270dca4500f_Out_0 = Color_9AA111D3;
            float4 _SquareRoot_c2c57d0223a9538aa9240890c3cacb0c_Out_1;
            Unity_SquareRoot_float4(_Property_012510d774fb7f8b860f5270dca4500f_Out_0, _SquareRoot_c2c57d0223a9538aa9240890c3cacb0c_Out_1);
            float _Property_a00e29241d12f983b30177515b367ec9_Out_0 = Vector1_FBE622A2;
            float _Sign_343a45ede7349283a681c6bd9998fd8e_Out_1;
            Unity_Sign_float(_Property_a00e29241d12f983b30177515b367ec9_Out_0, _Sign_343a45ede7349283a681c6bd9998fd8e_Out_1);
            float _Add_681019b8f5d3d68bb482d419c9fc61a9_Out_2;
            Unity_Add_float(_Sign_343a45ede7349283a681c6bd9998fd8e_Out_1, 1, _Add_681019b8f5d3d68bb482d419c9fc61a9_Out_2);
            float _Multiply_e8f4cb722712a880ac0db6c7461427f7_Out_2;
            Unity_Multiply_float(_Add_681019b8f5d3d68bb482d419c9fc61a9_Out_2, 0.5, _Multiply_e8f4cb722712a880ac0db6c7461427f7_Out_2);
            float _Ceiling_95ad15988aa9b98184875fa754feae01_Out_1;
            Unity_Ceiling_float(_Multiply_e8f4cb722712a880ac0db6c7461427f7_Out_2, _Ceiling_95ad15988aa9b98184875fa754feae01_Out_1);
            float _Property_2db1c747a05ee284a8b00076062f91a4_Out_0 = Vector1_8C15C351;
            float _Multiply_9564ecda5193bc8286d9ff771c9226cd_Out_2;
            Unity_Multiply_float(_Property_2db1c747a05ee284a8b00076062f91a4_Out_0, _Property_2db1c747a05ee284a8b00076062f91a4_Out_0, _Multiply_9564ecda5193bc8286d9ff771c9226cd_Out_2);
            float4 _Lerp_b3cdb01fc3c5b988ac9b184943bf7c01_Out_3;
            Unity_Lerp_float4(_SquareRoot_c2c57d0223a9538aa9240890c3cacb0c_Out_1, (_Ceiling_95ad15988aa9b98184875fa754feae01_Out_1.xxxx), (_Multiply_9564ecda5193bc8286d9ff771c9226cd_Out_2.xxxx), _Lerp_b3cdb01fc3c5b988ac9b184943bf7c01_Out_3);
            float4 _Multiply_39d1daff98488f8ea2cd794ad4f20926_Out_2;
            Unity_Multiply_float(_Lerp_b3cdb01fc3c5b988ac9b184943bf7c01_Out_3, _Lerp_b3cdb01fc3c5b988ac9b184943bf7c01_Out_3, _Multiply_39d1daff98488f8ea2cd794ad4f20926_Out_2);
            OutVector4_1 = (_Multiply_39d1daff98488f8ea2cd794ad4f20926_Out_2.xyz);
        }

        void Unity_Clamp_float(float In, float Min, float Max, out float Out)
        {
            Out = clamp(In, Min, Max);
        }

        void Unity_Multiply_float(float2 A, float2 B, out float2 Out)
        {
            Out = A * B;
        }

        void Unity_Add_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A + B;
        }

        void Unity_DotProduct_float2(float2 A, float2 B, out float Out)
        {
            Out = dot(A, B);
        }

        void Unity_OneMinus_float(float In, out float Out)
        {
            Out = 1 - In;
        }

        void Unity_SquareRoot_float(float In, out float Out)
        {
            Out = sqrt(In);
        }

        void Unity_Sign_float3(float3 In, out float3 Out)
        {
            Out = sign(In);
        }

        void Unity_Normalize_float3(float3 In, out float3 Out)
        {
            Out = normalize(In);
        }

        void Unity_Branch_float3(float Predicate, float3 True, float3 False, out float3 Out)
        {
            Out = Predicate ? True : False;
        }

        struct Bindings_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8
        {
            float3 WorldSpaceNormal;
            float3 WorldSpaceTangent;
            float3 WorldSpaceBiTangent;
            float3 AbsoluteWorldSpacePosition;
            half4 uv0;
        };

        void SG_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8(UnityTexture2D Texture2D_80A3D28F, float4 Vector4_82674548, float Boolean_9FF42DF6, Bindings_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8 IN, out float4 XZ_2)
        {
            float _Property_1ef12cf3201a938993fe6a7951b0e754_Out_0 = Boolean_9FF42DF6;
            UnityTexture2D _Property_3e01b4d2fc68d48ba3acbba9d5881e59_Out_0 = Texture2D_80A3D28F;
            float _Split_89ed63cb625cb3878c183d0b71c03400_R_1 = IN.AbsoluteWorldSpacePosition[0];
            float _Split_89ed63cb625cb3878c183d0b71c03400_G_2 = IN.AbsoluteWorldSpacePosition[1];
            float _Split_89ed63cb625cb3878c183d0b71c03400_B_3 = IN.AbsoluteWorldSpacePosition[2];
            float _Split_89ed63cb625cb3878c183d0b71c03400_A_4 = 0;
            float4 _Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4;
            float3 _Combine_cf2d04ff119ad88493f6460431765cbb_RGB_5;
            float2 _Combine_cf2d04ff119ad88493f6460431765cbb_RG_6;
            Unity_Combine_float(_Split_89ed63cb625cb3878c183d0b71c03400_R_1, _Split_89ed63cb625cb3878c183d0b71c03400_B_3, 0, 0, _Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4, _Combine_cf2d04ff119ad88493f6460431765cbb_RGB_5, _Combine_cf2d04ff119ad88493f6460431765cbb_RG_6);
            float4 _Property_3fa1d6f912feb481ba60f2e55e62e746_Out_0 = Vector4_82674548;
            float _Split_a2e12fa5931da084b2949343a539dfd8_R_1 = _Property_3fa1d6f912feb481ba60f2e55e62e746_Out_0[0];
            float _Split_a2e12fa5931da084b2949343a539dfd8_G_2 = _Property_3fa1d6f912feb481ba60f2e55e62e746_Out_0[1];
            float _Split_a2e12fa5931da084b2949343a539dfd8_B_3 = _Property_3fa1d6f912feb481ba60f2e55e62e746_Out_0[2];
            float _Split_a2e12fa5931da084b2949343a539dfd8_A_4 = _Property_3fa1d6f912feb481ba60f2e55e62e746_Out_0[3];
            float _Divide_c36b770dfaa0bb8f85ab27da5fd794f0_Out_2;
            Unity_Divide_float(1, _Split_a2e12fa5931da084b2949343a539dfd8_R_1, _Divide_c36b770dfaa0bb8f85ab27da5fd794f0_Out_2);
            float4 _Multiply_14cec4902d0a00829e4555071a1b8ad1_Out_2;
            Unity_Multiply_float(_Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4, (_Divide_c36b770dfaa0bb8f85ab27da5fd794f0_Out_2.xxxx), _Multiply_14cec4902d0a00829e4555071a1b8ad1_Out_2);
            float2 _Vector2_6845d21872714d889783b0cb707df3e9_Out_0 = float2(_Split_a2e12fa5931da084b2949343a539dfd8_R_1, _Split_a2e12fa5931da084b2949343a539dfd8_G_2);
            float2 _Vector2_e2e2263627c6098e96a5b5d29350ad03_Out_0 = float2(_Split_a2e12fa5931da084b2949343a539dfd8_B_3, _Split_a2e12fa5931da084b2949343a539dfd8_A_4);
            float2 _TilingAndOffset_17582d056c0b8a8dab1017d37497fe59_Out_3;
            Unity_TilingAndOffset_float(IN.uv0.xy, _Vector2_6845d21872714d889783b0cb707df3e9_Out_0, _Vector2_e2e2263627c6098e96a5b5d29350ad03_Out_0, _TilingAndOffset_17582d056c0b8a8dab1017d37497fe59_Out_3);
            float2 _Branch_1e152f3aac57448f8518bf2852c000c3_Out_3;
            Unity_Branch_float2(_Property_1ef12cf3201a938993fe6a7951b0e754_Out_0, (_Multiply_14cec4902d0a00829e4555071a1b8ad1_Out_2.xy), _TilingAndOffset_17582d056c0b8a8dab1017d37497fe59_Out_3, _Branch_1e152f3aac57448f8518bf2852c000c3_Out_3);
            float4 _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0 = SAMPLE_TEXTURE2D(_Property_3e01b4d2fc68d48ba3acbba9d5881e59_Out_0.tex, _Property_3e01b4d2fc68d48ba3acbba9d5881e59_Out_0.samplerstate, _Branch_1e152f3aac57448f8518bf2852c000c3_Out_3);
            _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0.rgb = UnpackNormal(_SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0);
            float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_R_4 = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0.r;
            float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_G_5 = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0.g;
            float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_B_6 = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0.b;
            float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_A_7 = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0.a;
            float2 _Vector2_ad6bd100e273d78fa409a30a77bfa2cc_Out_0 = float2(_SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_R_4, _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_G_5);
            float3 _Sign_3a6ebf59931cf08cb0482e0144ddac24_Out_1;
            Unity_Sign_float3(IN.WorldSpaceNormal, _Sign_3a6ebf59931cf08cb0482e0144ddac24_Out_1);
            float _Split_6299d4ddcc4c74828aea40a46fdb896e_R_1 = _Sign_3a6ebf59931cf08cb0482e0144ddac24_Out_1[0];
            float _Split_6299d4ddcc4c74828aea40a46fdb896e_G_2 = _Sign_3a6ebf59931cf08cb0482e0144ddac24_Out_1[1];
            float _Split_6299d4ddcc4c74828aea40a46fdb896e_B_3 = _Sign_3a6ebf59931cf08cb0482e0144ddac24_Out_1[2];
            float _Split_6299d4ddcc4c74828aea40a46fdb896e_A_4 = 0;
            float2 _Vector2_b76cb1842101e58b9e636d49b075c612_Out_0 = float2(_Split_6299d4ddcc4c74828aea40a46fdb896e_G_2, 1);
            float2 _Multiply_31e8db88ee20c985a9850d1a58f3282b_Out_2;
            Unity_Multiply_float(_Vector2_ad6bd100e273d78fa409a30a77bfa2cc_Out_0, _Vector2_b76cb1842101e58b9e636d49b075c612_Out_0, _Multiply_31e8db88ee20c985a9850d1a58f3282b_Out_2);
            float _Split_5ed44bf2eca0868f81eb18100f49d1fa_R_1 = IN.WorldSpaceNormal[0];
            float _Split_5ed44bf2eca0868f81eb18100f49d1fa_G_2 = IN.WorldSpaceNormal[1];
            float _Split_5ed44bf2eca0868f81eb18100f49d1fa_B_3 = IN.WorldSpaceNormal[2];
            float _Split_5ed44bf2eca0868f81eb18100f49d1fa_A_4 = 0;
            float2 _Vector2_70e5837843f28b8b9d64cada3697bd5a_Out_0 = float2(_Split_5ed44bf2eca0868f81eb18100f49d1fa_R_1, _Split_5ed44bf2eca0868f81eb18100f49d1fa_B_3);
            float2 _Add_1145b2f896593d80aa864a34e6702562_Out_2;
            Unity_Add_float2(_Multiply_31e8db88ee20c985a9850d1a58f3282b_Out_2, _Vector2_70e5837843f28b8b9d64cada3697bd5a_Out_0, _Add_1145b2f896593d80aa864a34e6702562_Out_2);
            float _Split_2bc77ca2d17bd78cb2383770ce50b179_R_1 = _Add_1145b2f896593d80aa864a34e6702562_Out_2[0];
            float _Split_2bc77ca2d17bd78cb2383770ce50b179_G_2 = _Add_1145b2f896593d80aa864a34e6702562_Out_2[1];
            float _Split_2bc77ca2d17bd78cb2383770ce50b179_B_3 = 0;
            float _Split_2bc77ca2d17bd78cb2383770ce50b179_A_4 = 0;
            float _Multiply_ab12aea87465a78eaf7fc66c2598d266_Out_2;
            Unity_Multiply_float(_SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_B_6, _Split_5ed44bf2eca0868f81eb18100f49d1fa_G_2, _Multiply_ab12aea87465a78eaf7fc66c2598d266_Out_2);
            float3 _Vector3_433840b555db308b97e9b14b6a957195_Out_0 = float3(_Split_2bc77ca2d17bd78cb2383770ce50b179_R_1, _Multiply_ab12aea87465a78eaf7fc66c2598d266_Out_2, _Split_2bc77ca2d17bd78cb2383770ce50b179_G_2);
            float3x3 Transform_c7914cc45a011c89b3f53c55afb51673_tangentTransform_World = float3x3(IN.WorldSpaceTangent, IN.WorldSpaceBiTangent, IN.WorldSpaceNormal);
            float3 _Transform_c7914cc45a011c89b3f53c55afb51673_Out_1 = TransformWorldToTangent(_Vector3_433840b555db308b97e9b14b6a957195_Out_0.xyz, Transform_c7914cc45a011c89b3f53c55afb51673_tangentTransform_World);
            float3 _Normalize_09bf8a2bd0a4d38e8b97d5c674f79b44_Out_1;
            Unity_Normalize_float3(_Transform_c7914cc45a011c89b3f53c55afb51673_Out_1, _Normalize_09bf8a2bd0a4d38e8b97d5c674f79b44_Out_1);
            float3 _Branch_9eadf909a90f2f80880f8c56ecc2a91f_Out_3;
            Unity_Branch_float3(_Property_1ef12cf3201a938993fe6a7951b0e754_Out_0, _Normalize_09bf8a2bd0a4d38e8b97d5c674f79b44_Out_1, (_SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0.xyz), _Branch_9eadf909a90f2f80880f8c56ecc2a91f_Out_3);
            XZ_2 = (float4(_Branch_9eadf909a90f2f80880f8c56ecc2a91f_Out_3, 1.0));
        }

        void Unity_NormalStrength_float(float3 In, float Strength, out float3 Out)
        {
            Out = float3(In.rg * Strength, lerp(1, In.b, saturate(Strength)));
        }

        void Unity_NormalBlend_float(float3 A, float3 B, out float3 Out)
        {
            Out = SafeNormalize(float3(A.rg + B.rg, A.b * B.b));
        }

        void Unity_Subtract_float(float A, float B, out float Out)
        {
            Out = A - B;
        }

        void Unity_Power_float(float A, float B, out float Out)
        {
            Out = pow(A, B);
        }

        void Unity_Lerp_float3(float3 A, float3 B, float3 T, out float3 Out)
        {
            Out = lerp(A, B, T);
        }

        void Unity_Remap_float(float In, float2 InMinMax, float2 OutMinMax, out float Out)
        {
            Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
        }

        void Unity_Multiply_float(float3 A, float3 B, out float3 Out)
        {
            Out = A * B;
        }

        void Unity_Lerp_float(float A, float B, float T, out float Out)
        {
            Out = lerp(A, B, T);
        }

        struct Bindings_BlendOverlayDetailSmoothness_06e12138dc89c0040b45a57abe520a1a
        {
        };

        void SG_BlendOverlayDetailSmoothness_06e12138dc89c0040b45a57abe520a1a(float Vector1_32317166, float Vector1_FBE622A2, float Vector1_8C15C351, Bindings_BlendOverlayDetailSmoothness_06e12138dc89c0040b45a57abe520a1a IN, out float SmoothnessOverlay_1)
        {
            float _Property_728cc50521e9e988ac9cbff4872d5139_Out_0 = Vector1_32317166;
            float _Property_a00e29241d12f983b30177515b367ec9_Out_0 = Vector1_FBE622A2;
            float _Sign_343a45ede7349283a681c6bd9998fd8e_Out_1;
            Unity_Sign_float(_Property_a00e29241d12f983b30177515b367ec9_Out_0, _Sign_343a45ede7349283a681c6bd9998fd8e_Out_1);
            float _Add_681019b8f5d3d68bb482d419c9fc61a9_Out_2;
            Unity_Add_float(_Sign_343a45ede7349283a681c6bd9998fd8e_Out_1, 1, _Add_681019b8f5d3d68bb482d419c9fc61a9_Out_2);
            float _Multiply_e8f4cb722712a880ac0db6c7461427f7_Out_2;
            Unity_Multiply_float(_Add_681019b8f5d3d68bb482d419c9fc61a9_Out_2, 0.5, _Multiply_e8f4cb722712a880ac0db6c7461427f7_Out_2);
            float _Ceiling_95ad15988aa9b98184875fa754feae01_Out_1;
            Unity_Ceiling_float(_Multiply_e8f4cb722712a880ac0db6c7461427f7_Out_2, _Ceiling_95ad15988aa9b98184875fa754feae01_Out_1);
            float _Property_2db1c747a05ee284a8b00076062f91a4_Out_0 = Vector1_8C15C351;
            float _Lerp_b3cdb01fc3c5b988ac9b184943bf7c01_Out_3;
            Unity_Lerp_float(_Property_728cc50521e9e988ac9cbff4872d5139_Out_0, _Ceiling_95ad15988aa9b98184875fa754feae01_Out_1, _Property_2db1c747a05ee284a8b00076062f91a4_Out_0, _Lerp_b3cdb01fc3c5b988ac9b184943bf7c01_Out_3);
            SmoothnessOverlay_1 = _Lerp_b3cdb01fc3c5b988ac9b184943bf7c01_Out_3;
        }

            // Graph Vertex
            struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };

        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            Bindings_NMObjectVSProIndirect_0cfe1e4f145944241ab304331e53c93b _NMObjectVSProIndirect_adbe93754e069e8e87df45ef6e4b343e;
            float3 _NMObjectVSProIndirect_adbe93754e069e8e87df45ef6e4b343e_ObjectSpacePosition_1;
            SG_NMObjectVSProIndirect_0cfe1e4f145944241ab304331e53c93b(IN.ObjectSpacePosition, _NMObjectVSProIndirect_adbe93754e069e8e87df45ef6e4b343e, _NMObjectVSProIndirect_adbe93754e069e8e87df45ef6e4b343e_ObjectSpacePosition_1);
            #endif
            description.Position = _NMObjectVSProIndirect_adbe93754e069e8e87df45ef6e4b343e_ObjectSpacePosition_1;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }

            // Graph Pixel
            struct SurfaceDescription
        {
            float3 BaseColor;
            float3 NormalTS;
            float3 Emission;
            float Metallic;
            float Smoothness;
            float Occlusion;
            float Alpha;
            float AlphaClipThreshold;
        };

        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            UnityTexture2D _Property_e4c53213449c7682b60df6ae54f219f0_Out_0 = UnityBuildTexture2DStructNoScale(_BaseColorMap);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 _Property_115fcc827510f38798b214d835c27637_Out_0 = _BaseTilingOffset;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_d83b8f290862b285bbe2f157190e1315_Out_0 = _BaseUsePlanarUV;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            Bindings_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6 _PlanarNM_6c8b686076db2a8c8b7d6cd91cf435f0;
            _PlanarNM_6c8b686076db2a8c8b7d6cd91cf435f0.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            _PlanarNM_6c8b686076db2a8c8b7d6cd91cf435f0.uv0 = IN.uv0;
            float4 _PlanarNM_6c8b686076db2a8c8b7d6cd91cf435f0_XZ_2;
            SG_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6(_Property_e4c53213449c7682b60df6ae54f219f0_Out_0, _Property_115fcc827510f38798b214d835c27637_Out_0, _Property_d83b8f290862b285bbe2f157190e1315_Out_0, _PlanarNM_6c8b686076db2a8c8b7d6cd91cf435f0, _PlanarNM_6c8b686076db2a8c8b7d6cd91cf435f0_XZ_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 _Property_13c79aaf332e20868551d934a2cb7112_Out_0 = _BaseColor;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 _Multiply_3d0c2fda612cfe87aa84bc17ad099a61_Out_2;
            Unity_Multiply_float(_PlanarNM_6c8b686076db2a8c8b7d6cd91cf435f0_XZ_2, _Property_13c79aaf332e20868551d934a2cb7112_Out_0, _Multiply_3d0c2fda612cfe87aa84bc17ad099a61_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            UnityTexture2D _Property_b561c414493a8f8299227a27e437f045_Out_0 = UnityBuildTexture2DStructNoScale(_DetailMap);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 _Property_70f1cc2b73af738d80b0d405e4bed8c5_Out_0 = _DetailTilingOffset;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Split_cda27505033cfc8eaf60fe914f0949b9_R_1 = _Property_70f1cc2b73af738d80b0d405e4bed8c5_Out_0[0];
            float _Split_cda27505033cfc8eaf60fe914f0949b9_G_2 = _Property_70f1cc2b73af738d80b0d405e4bed8c5_Out_0[1];
            float _Split_cda27505033cfc8eaf60fe914f0949b9_B_3 = _Property_70f1cc2b73af738d80b0d405e4bed8c5_Out_0[2];
            float _Split_cda27505033cfc8eaf60fe914f0949b9_A_4 = _Property_70f1cc2b73af738d80b0d405e4bed8c5_Out_0[3];
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float2 _Vector2_42d7e955009b6f8cb4d913530ff92840_Out_0 = float2(_Split_cda27505033cfc8eaf60fe914f0949b9_R_1, _Split_cda27505033cfc8eaf60fe914f0949b9_G_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float2 _Vector2_5452a0299d10b280aec51f7407d4d2ac_Out_0 = float2(_Split_cda27505033cfc8eaf60fe914f0949b9_B_3, _Split_cda27505033cfc8eaf60fe914f0949b9_A_4);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float2 _TilingAndOffset_e1c5b97bd253ca8f9f3d26f598e6d7fd_Out_3;
            Unity_TilingAndOffset_float(IN.uv0.xy, _Vector2_42d7e955009b6f8cb4d913530ff92840_Out_0, _Vector2_5452a0299d10b280aec51f7407d4d2ac_Out_0, _TilingAndOffset_e1c5b97bd253ca8f9f3d26f598e6d7fd_Out_3);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 _SampleTexture2D_fa4ac40fc922b9869e37c06690c0f530_RGBA_0 = SAMPLE_TEXTURE2D(_Property_b561c414493a8f8299227a27e437f045_Out_0.tex, _Property_b561c414493a8f8299227a27e437f045_Out_0.samplerstate, _TilingAndOffset_e1c5b97bd253ca8f9f3d26f598e6d7fd_Out_3);
            float _SampleTexture2D_fa4ac40fc922b9869e37c06690c0f530_R_4 = _SampleTexture2D_fa4ac40fc922b9869e37c06690c0f530_RGBA_0.r;
            float _SampleTexture2D_fa4ac40fc922b9869e37c06690c0f530_G_5 = _SampleTexture2D_fa4ac40fc922b9869e37c06690c0f530_RGBA_0.g;
            float _SampleTexture2D_fa4ac40fc922b9869e37c06690c0f530_B_6 = _SampleTexture2D_fa4ac40fc922b9869e37c06690c0f530_RGBA_0.b;
            float _SampleTexture2D_fa4ac40fc922b9869e37c06690c0f530_A_7 = _SampleTexture2D_fa4ac40fc922b9869e37c06690c0f530_RGBA_0.a;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Multiply_d0f6aeb5b3f04288b51a5ded8986b5a4_Out_2;
            Unity_Multiply_float(_SampleTexture2D_fa4ac40fc922b9869e37c06690c0f530_R_4, 2, _Multiply_d0f6aeb5b3f04288b51a5ded8986b5a4_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Add_d382719213f8618f88c54f7c3dfbd8c2_Out_2;
            Unity_Add_float(_Multiply_d0f6aeb5b3f04288b51a5ded8986b5a4_Out_2, -1, _Add_d382719213f8618f88c54f7c3dfbd8c2_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_02e7dd176dc59f8a9a62453677916b24_Out_0 = _DetailAlbedoScale;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Multiply_fd406247e3137a8b8777918477740653_Out_2;
            Unity_Multiply_float(_Add_d382719213f8618f88c54f7c3dfbd8c2_Out_2, _Property_02e7dd176dc59f8a9a62453677916b24_Out_0, _Multiply_fd406247e3137a8b8777918477740653_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Saturate_d6f590fb1b9d188e981ebb0ec4d36ba9_Out_1;
            Unity_Saturate_float(_Multiply_fd406247e3137a8b8777918477740653_Out_2, _Saturate_d6f590fb1b9d188e981ebb0ec4d36ba9_Out_1);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Absolute_dc927550b803d18ba3ff372995e6d25c_Out_1;
            Unity_Absolute_float(_Saturate_d6f590fb1b9d188e981ebb0ec4d36ba9_Out_1, _Absolute_dc927550b803d18ba3ff372995e6d25c_Out_1);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            Bindings_BlendOverlayBaseColor_acdb3dfca72bd6b42bbc35f4613331a2 _BlendOverlayBaseColor_f3cd25d5b673648eb831a3f388201f73;
            float3 _BlendOverlayBaseColor_f3cd25d5b673648eb831a3f388201f73_OutVector4_1;
            SG_BlendOverlayBaseColor_acdb3dfca72bd6b42bbc35f4613331a2(_Multiply_3d0c2fda612cfe87aa84bc17ad099a61_Out_2, _Add_d382719213f8618f88c54f7c3dfbd8c2_Out_2, _Absolute_dc927550b803d18ba3ff372995e6d25c_Out_1, _BlendOverlayBaseColor_f3cd25d5b673648eb831a3f388201f73, _BlendOverlayBaseColor_f3cd25d5b673648eb831a3f388201f73_OutVector4_1);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            UnityTexture2D _Property_f4db51ec2412c48cbcf2128b7bd8caf8_Out_0 = UnityBuildTexture2DStructNoScale(_CoverBaseColorMap);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 _Property_e35c79b8cccfbe8ca0a3c33e8d32e319_Out_0 = _CoverTilingOffset;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_e3d8b38b51331e879b1d4012d65f53e6_Out_0 = _CoverUsePlanarUV;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            Bindings_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6 _PlanarNM_c2ec737ef76d6286b8eedb44a2d24e50;
            _PlanarNM_c2ec737ef76d6286b8eedb44a2d24e50.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            _PlanarNM_c2ec737ef76d6286b8eedb44a2d24e50.uv0 = IN.uv0;
            float4 _PlanarNM_c2ec737ef76d6286b8eedb44a2d24e50_XZ_2;
            SG_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6(_Property_f4db51ec2412c48cbcf2128b7bd8caf8_Out_0, _Property_e35c79b8cccfbe8ca0a3c33e8d32e319_Out_0, _Property_e3d8b38b51331e879b1d4012d65f53e6_Out_0, _PlanarNM_c2ec737ef76d6286b8eedb44a2d24e50, _PlanarNM_c2ec737ef76d6286b8eedb44a2d24e50_XZ_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 _Property_7d3af9045f54ef8ba8629ebbbc3f4ad7_Out_0 = _CoverBaseColor;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 _Multiply_2eb83c7af5b6f58eabeec7b502517470_Out_2;
            Unity_Multiply_float(_PlanarNM_c2ec737ef76d6286b8eedb44a2d24e50_XZ_2, _Property_7d3af9045f54ef8ba8629ebbbc3f4ad7_Out_0, _Multiply_2eb83c7af5b6f58eabeec7b502517470_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            UnityTexture2D _Property_356186a26fec8686a13bc6b57fd8f3ee_Out_0 = UnityBuildTexture2DStructNoScale(_CoverMaskA);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 _UV_045cea9e82354980a778f44d92578382_Out_0 = IN.uv0;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 _SampleTexture2D_0eef6ae3dab6e185bd0f65edecd80314_RGBA_0 = SAMPLE_TEXTURE2D(_Property_356186a26fec8686a13bc6b57fd8f3ee_Out_0.tex, _Property_356186a26fec8686a13bc6b57fd8f3ee_Out_0.samplerstate, (_UV_045cea9e82354980a778f44d92578382_Out_0.xy));
            float _SampleTexture2D_0eef6ae3dab6e185bd0f65edecd80314_R_4 = _SampleTexture2D_0eef6ae3dab6e185bd0f65edecd80314_RGBA_0.r;
            float _SampleTexture2D_0eef6ae3dab6e185bd0f65edecd80314_G_5 = _SampleTexture2D_0eef6ae3dab6e185bd0f65edecd80314_RGBA_0.g;
            float _SampleTexture2D_0eef6ae3dab6e185bd0f65edecd80314_B_6 = _SampleTexture2D_0eef6ae3dab6e185bd0f65edecd80314_RGBA_0.b;
            float _SampleTexture2D_0eef6ae3dab6e185bd0f65edecd80314_A_7 = _SampleTexture2D_0eef6ae3dab6e185bd0f65edecd80314_RGBA_0.a;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_4e8240836843df81941cdf6cf2cdd638_Out_0 = _CoverMaskPower;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Multiply_8b5250e5dfc73a84a41399a13b83c0a1_Out_2;
            Unity_Multiply_float(_SampleTexture2D_0eef6ae3dab6e185bd0f65edecd80314_A_7, _Property_4e8240836843df81941cdf6cf2cdd638_Out_0, _Multiply_8b5250e5dfc73a84a41399a13b83c0a1_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Clamp_030a7c32684c258084338456eaddc77a_Out_3;
            Unity_Clamp_float(_Multiply_8b5250e5dfc73a84a41399a13b83c0a1_Out_2, 0, 1, _Clamp_030a7c32684c258084338456eaddc77a_Out_3);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Split_8ba5b67899f36b8f9dcf5c84092c0560_R_1 = IN.VertexColor[0];
            float _Split_8ba5b67899f36b8f9dcf5c84092c0560_G_2 = IN.VertexColor[1];
            float _Split_8ba5b67899f36b8f9dcf5c84092c0560_B_3 = IN.VertexColor[2];
            float _Split_8ba5b67899f36b8f9dcf5c84092c0560_A_4 = IN.VertexColor[3];
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float2 _Vector2_65060e9a9f687a89b68e32dc876be645_Out_0 = float2(_SampleTexture2D_fa4ac40fc922b9869e37c06690c0f530_A_7, _SampleTexture2D_fa4ac40fc922b9869e37c06690c0f530_G_5);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float2 _Multiply_5d4c3baed6515c8b86a289c70fca8f5d_Out_2;
            Unity_Multiply_float(_Vector2_65060e9a9f687a89b68e32dc876be645_Out_0, float2(2, 2), _Multiply_5d4c3baed6515c8b86a289c70fca8f5d_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float2 _Add_98b310e19c5fa5899c39cc45969c15ea_Out_2;
            Unity_Add_float2(_Multiply_5d4c3baed6515c8b86a289c70fca8f5d_Out_2, float2(-1, -1), _Add_98b310e19c5fa5899c39cc45969c15ea_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_08b99582093b36869beb5ea3d18e765d_Out_0 = _DetailNormalScale;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float2 _Multiply_bf0b80fdb3271784900e5b5ea4c5550f_Out_2;
            Unity_Multiply_float(_Add_98b310e19c5fa5899c39cc45969c15ea_Out_2, (_Property_08b99582093b36869beb5ea3d18e765d_Out_0.xx), _Multiply_bf0b80fdb3271784900e5b5ea4c5550f_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Split_26c1e73f8436c78ebdae5b51365a072b_R_1 = _Multiply_bf0b80fdb3271784900e5b5ea4c5550f_Out_2[0];
            float _Split_26c1e73f8436c78ebdae5b51365a072b_G_2 = _Multiply_bf0b80fdb3271784900e5b5ea4c5550f_Out_2[1];
            float _Split_26c1e73f8436c78ebdae5b51365a072b_B_3 = 0;
            float _Split_26c1e73f8436c78ebdae5b51365a072b_A_4 = 0;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _DotProduct_50aca3ce0da1ad849d7ff4a99df3a322_Out_2;
            Unity_DotProduct_float2(_Multiply_bf0b80fdb3271784900e5b5ea4c5550f_Out_2, _Multiply_bf0b80fdb3271784900e5b5ea4c5550f_Out_2, _DotProduct_50aca3ce0da1ad849d7ff4a99df3a322_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Saturate_491f2ee8417b8782aee83358b89eeb08_Out_1;
            Unity_Saturate_float(_DotProduct_50aca3ce0da1ad849d7ff4a99df3a322_Out_2, _Saturate_491f2ee8417b8782aee83358b89eeb08_Out_1);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _OneMinus_46ad3170d736808d98bf74ffa45e0414_Out_1;
            Unity_OneMinus_float(_Saturate_491f2ee8417b8782aee83358b89eeb08_Out_1, _OneMinus_46ad3170d736808d98bf74ffa45e0414_Out_1);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _SquareRoot_dfeae899ebfeae8f9257c340ca22ce38_Out_1;
            Unity_SquareRoot_float(_OneMinus_46ad3170d736808d98bf74ffa45e0414_Out_1, _SquareRoot_dfeae899ebfeae8f9257c340ca22ce38_Out_1);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 _Vector3_ed3f80ed87524e8c99f98b224af5a610_Out_0 = float3(_Split_26c1e73f8436c78ebdae5b51365a072b_R_1, _Split_26c1e73f8436c78ebdae5b51365a072b_G_2, _SquareRoot_dfeae899ebfeae8f9257c340ca22ce38_Out_1);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            UnityTexture2D _Property_2cc39234d3d334899f94126a216a50fc_Out_0 = UnityBuildTexture2DStructNoScale(_BaseNormalMap);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            Bindings_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8 _PlanarNMn_4fde70f39e45398dbb9972941e88e2bf;
            _PlanarNMn_4fde70f39e45398dbb9972941e88e2bf.WorldSpaceNormal = IN.WorldSpaceNormal;
            _PlanarNMn_4fde70f39e45398dbb9972941e88e2bf.WorldSpaceTangent = IN.WorldSpaceTangent;
            _PlanarNMn_4fde70f39e45398dbb9972941e88e2bf.WorldSpaceBiTangent = IN.WorldSpaceBiTangent;
            _PlanarNMn_4fde70f39e45398dbb9972941e88e2bf.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            _PlanarNMn_4fde70f39e45398dbb9972941e88e2bf.uv0 = IN.uv0;
            float4 _PlanarNMn_4fde70f39e45398dbb9972941e88e2bf_XZ_2;
            SG_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8(_Property_2cc39234d3d334899f94126a216a50fc_Out_0, _Property_115fcc827510f38798b214d835c27637_Out_0, _Property_d83b8f290862b285bbe2f157190e1315_Out_0, _PlanarNMn_4fde70f39e45398dbb9972941e88e2bf, _PlanarNMn_4fde70f39e45398dbb9972941e88e2bf_XZ_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_020d569f63e9a2849e23988ff74eb005_Out_0 = _BaseNormalScale;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 _NormalStrength_0c71fb166ae841839a0a12ecc5afa6fe_Out_2;
            Unity_NormalStrength_float((_PlanarNMn_4fde70f39e45398dbb9972941e88e2bf_XZ_2.xyz), _Property_020d569f63e9a2849e23988ff74eb005_Out_0, _NormalStrength_0c71fb166ae841839a0a12ecc5afa6fe_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 _NormalBlend_be36dd49bea74c8f8dd52fa3a85a9534_Out_2;
            Unity_NormalBlend_float(_Vector3_ed3f80ed87524e8c99f98b224af5a610_Out_0, _NormalStrength_0c71fb166ae841839a0a12ecc5afa6fe_Out_2, _NormalBlend_be36dd49bea74c8f8dd52fa3a85a9534_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            UnityTexture2D _Property_a383045772822c87acd099bb4cd6c478_Out_0 = UnityBuildTexture2DStructNoScale(_CoverNormalMap);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            Bindings_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8 _PlanarNMn_79abde32a0223a89907c9f09efac8db7;
            _PlanarNMn_79abde32a0223a89907c9f09efac8db7.WorldSpaceNormal = IN.WorldSpaceNormal;
            _PlanarNMn_79abde32a0223a89907c9f09efac8db7.WorldSpaceTangent = IN.WorldSpaceTangent;
            _PlanarNMn_79abde32a0223a89907c9f09efac8db7.WorldSpaceBiTangent = IN.WorldSpaceBiTangent;
            _PlanarNMn_79abde32a0223a89907c9f09efac8db7.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            _PlanarNMn_79abde32a0223a89907c9f09efac8db7.uv0 = IN.uv0;
            float4 _PlanarNMn_79abde32a0223a89907c9f09efac8db7_XZ_2;
            SG_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8(_Property_a383045772822c87acd099bb4cd6c478_Out_0, _Property_e35c79b8cccfbe8ca0a3c33e8d32e319_Out_0, _Property_e3d8b38b51331e879b1d4012d65f53e6_Out_0, _PlanarNMn_79abde32a0223a89907c9f09efac8db7, _PlanarNMn_79abde32a0223a89907c9f09efac8db7_XZ_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_c688e246111fd881820a97415e14d8a3_Out_0 = _CoverNormalBlendHardness;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 _NormalStrength_0e5e0831ba0e98878220ca6021ea52a2_Out_2;
            Unity_NormalStrength_float((_PlanarNMn_79abde32a0223a89907c9f09efac8db7_XZ_2.xyz), _Property_c688e246111fd881820a97415e14d8a3_Out_0, _NormalStrength_0e5e0831ba0e98878220ca6021ea52a2_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Split_8cadce726725318fbacd47f436a8231d_R_1 = IN.WorldSpaceNormal[0];
            float _Split_8cadce726725318fbacd47f436a8231d_G_2 = IN.WorldSpaceNormal[1];
            float _Split_8cadce726725318fbacd47f436a8231d_B_3 = IN.WorldSpaceNormal[2];
            float _Split_8cadce726725318fbacd47f436a8231d_A_4 = 0;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_ce4e5954a0b7ff8c819fa53963327595_Out_0 = _Cover_Amount;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_384059e6344fb98a85eccad78dd82f36_Out_0 = _Cover_Amount_Grow_Speed;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Subtract_70fd06876db7fa85b0cc0bce8d926dff_Out_2;
            Unity_Subtract_float(4, _Property_384059e6344fb98a85eccad78dd82f36_Out_0, _Subtract_70fd06876db7fa85b0cc0bce8d926dff_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Divide_1a3a6334c3d8bc8f8ac262c7833e15d5_Out_2;
            Unity_Divide_float(_Property_ce4e5954a0b7ff8c819fa53963327595_Out_0, _Subtract_70fd06876db7fa85b0cc0bce8d926dff_Out_2, _Divide_1a3a6334c3d8bc8f8ac262c7833e15d5_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Absolute_f218d2b85ebf288f91234faffedb5f7b_Out_1;
            Unity_Absolute_float(_Divide_1a3a6334c3d8bc8f8ac262c7833e15d5_Out_2, _Absolute_f218d2b85ebf288f91234faffedb5f7b_Out_1);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Power_a9b8d4b65c44a98e9813f61c0e2dc0a3_Out_2;
            Unity_Power_float(_Absolute_f218d2b85ebf288f91234faffedb5f7b_Out_1, _Subtract_70fd06876db7fa85b0cc0bce8d926dff_Out_2, _Power_a9b8d4b65c44a98e9813f61c0e2dc0a3_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Clamp_95d579f83746cb82be79cf6739990e0b_Out_3;
            Unity_Clamp_float(_Power_a9b8d4b65c44a98e9813f61c0e2dc0a3_Out_2, 0, 2, _Clamp_95d579f83746cb82be79cf6739990e0b_Out_3);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Multiply_02a8aa0fa6974e81aa84caba54f63896_Out_2;
            Unity_Multiply_float(_Split_8cadce726725318fbacd47f436a8231d_G_2, _Clamp_95d579f83746cb82be79cf6739990e0b_Out_3, _Multiply_02a8aa0fa6974e81aa84caba54f63896_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Saturate_ada5e8f9ebdcb38d8f5e61e8d97424b9_Out_1;
            Unity_Saturate_float(_Multiply_02a8aa0fa6974e81aa84caba54f63896_Out_2, _Saturate_ada5e8f9ebdcb38d8f5e61e8d97424b9_Out_1);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Clamp_38bac9e8ef351789b5fd4f2201f1df7b_Out_3;
            Unity_Clamp_float(_Split_8cadce726725318fbacd47f436a8231d_G_2, 0, 0.9999, _Clamp_38bac9e8ef351789b5fd4f2201f1df7b_Out_3);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_9babc76177853482826cae0163ffe988_Out_0 = _Cover_Max_Angle;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Divide_3b22550205905d8da5870f9db56e44ff_Out_2;
            Unity_Divide_float(_Property_9babc76177853482826cae0163ffe988_Out_0, 45, _Divide_3b22550205905d8da5870f9db56e44ff_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _OneMinus_99a85b6952a41288afc86da0a6ca6ea0_Out_1;
            Unity_OneMinus_float(_Divide_3b22550205905d8da5870f9db56e44ff_Out_2, _OneMinus_99a85b6952a41288afc86da0a6ca6ea0_Out_1);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Subtract_2b63f3aaee26f686971dca1d28da283c_Out_2;
            Unity_Subtract_float(_Clamp_38bac9e8ef351789b5fd4f2201f1df7b_Out_3, _OneMinus_99a85b6952a41288afc86da0a6ca6ea0_Out_1, _Subtract_2b63f3aaee26f686971dca1d28da283c_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Clamp_6bd9bb4add91fe8eb80a958a6b1a2d01_Out_3;
            Unity_Clamp_float(_Subtract_2b63f3aaee26f686971dca1d28da283c_Out_2, 0, 2, _Clamp_6bd9bb4add91fe8eb80a958a6b1a2d01_Out_3);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Divide_a09d2d461b07e98999aba746fb52a3fc_Out_2;
            Unity_Divide_float(1, _Divide_3b22550205905d8da5870f9db56e44ff_Out_2, _Divide_a09d2d461b07e98999aba746fb52a3fc_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Multiply_89a8f5a279c73b898d4ca5d075786b53_Out_2;
            Unity_Multiply_float(_Clamp_6bd9bb4add91fe8eb80a958a6b1a2d01_Out_3, _Divide_a09d2d461b07e98999aba746fb52a3fc_Out_2, _Multiply_89a8f5a279c73b898d4ca5d075786b53_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Absolute_f98ce5feb185a68784b9b35eb71ec465_Out_1;
            Unity_Absolute_float(_Multiply_89a8f5a279c73b898d4ca5d075786b53_Out_2, _Absolute_f98ce5feb185a68784b9b35eb71ec465_Out_1);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_27e768ffa9c13e8ab65d48e7712e5b66_Out_0 = _CoverHardness;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Power_b9fdc3921d5b85878a1ec4baa1975184_Out_2;
            Unity_Power_float(_Absolute_f98ce5feb185a68784b9b35eb71ec465_Out_1, _Property_27e768ffa9c13e8ab65d48e7712e5b66_Out_0, _Power_b9fdc3921d5b85878a1ec4baa1975184_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_c442c20fdade808b8e1b93cfd6625ab9_Out_0 = _Cover_Min_Height;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _OneMinus_55530ddc82048c8aa2d082334edf6a57_Out_1;
            Unity_OneMinus_float(_Property_c442c20fdade808b8e1b93cfd6625ab9_Out_0, _OneMinus_55530ddc82048c8aa2d082334edf6a57_Out_1);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Split_7e5d084c5e6bfa83a9203dac971ea31e_R_1 = IN.AbsoluteWorldSpacePosition[0];
            float _Split_7e5d084c5e6bfa83a9203dac971ea31e_G_2 = IN.AbsoluteWorldSpacePosition[1];
            float _Split_7e5d084c5e6bfa83a9203dac971ea31e_B_3 = IN.AbsoluteWorldSpacePosition[2];
            float _Split_7e5d084c5e6bfa83a9203dac971ea31e_A_4 = 0;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Add_e4067b215657d98ab6ec4e0295ddfece_Out_2;
            Unity_Add_float(_OneMinus_55530ddc82048c8aa2d082334edf6a57_Out_1, _Split_7e5d084c5e6bfa83a9203dac971ea31e_G_2, _Add_e4067b215657d98ab6ec4e0295ddfece_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Add_a4387dfc1ea3ee8da0b04f433a7c63d0_Out_2;
            Unity_Add_float(_Add_e4067b215657d98ab6ec4e0295ddfece_Out_2, 1, _Add_a4387dfc1ea3ee8da0b04f433a7c63d0_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Clamp_570e1129ecb02c8b8be79d85f19d5ae1_Out_3;
            Unity_Clamp_float(_Add_a4387dfc1ea3ee8da0b04f433a7c63d0_Out_2, 0, 1, _Clamp_570e1129ecb02c8b8be79d85f19d5ae1_Out_3);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_5da709b259ac268bb134d927bcffa4b8_Out_0 = _Cover_Min_Height_Blending;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Add_c322347d9ddbcd83ba52983e9316c387_Out_2;
            Unity_Add_float(_Add_e4067b215657d98ab6ec4e0295ddfece_Out_2, _Property_5da709b259ac268bb134d927bcffa4b8_Out_0, _Add_c322347d9ddbcd83ba52983e9316c387_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Divide_078ffa7d6c597f819511c95d33b7d90e_Out_2;
            Unity_Divide_float(_Add_c322347d9ddbcd83ba52983e9316c387_Out_2, _Add_e4067b215657d98ab6ec4e0295ddfece_Out_2, _Divide_078ffa7d6c597f819511c95d33b7d90e_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _OneMinus_b9f8edced35e7b8cab9ca581d822e31f_Out_1;
            Unity_OneMinus_float(_Divide_078ffa7d6c597f819511c95d33b7d90e_Out_2, _OneMinus_b9f8edced35e7b8cab9ca581d822e31f_Out_1);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Add_95cd1778448bfe8d9f9fa9129235f2c2_Out_2;
            Unity_Add_float(_OneMinus_b9f8edced35e7b8cab9ca581d822e31f_Out_1, -0.5, _Add_95cd1778448bfe8d9f9fa9129235f2c2_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Clamp_23e760e01b7e0780a71d88813b5828d7_Out_3;
            Unity_Clamp_float(_Add_95cd1778448bfe8d9f9fa9129235f2c2_Out_2, 0, 1, _Clamp_23e760e01b7e0780a71d88813b5828d7_Out_3);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Add_674fcef023d728848510150af810a103_Out_2;
            Unity_Add_float(_Clamp_570e1129ecb02c8b8be79d85f19d5ae1_Out_3, _Clamp_23e760e01b7e0780a71d88813b5828d7_Out_3, _Add_674fcef023d728848510150af810a103_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Clamp_5b677be9d499c082bcbe316853b0adff_Out_3;
            Unity_Clamp_float(_Add_674fcef023d728848510150af810a103_Out_2, 0, 1, _Clamp_5b677be9d499c082bcbe316853b0adff_Out_3);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Multiply_7ea7400ed65a3582b000796fb39748e9_Out_2;
            Unity_Multiply_float(_Power_b9fdc3921d5b85878a1ec4baa1975184_Out_2, _Clamp_5b677be9d499c082bcbe316853b0adff_Out_3, _Multiply_7ea7400ed65a3582b000796fb39748e9_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Multiply_4d295791f4e23186acea64f2f4de94ea_Out_2;
            Unity_Multiply_float(_Saturate_ada5e8f9ebdcb38d8f5e61e8d97424b9_Out_1, _Multiply_7ea7400ed65a3582b000796fb39748e9_Out_2, _Multiply_4d295791f4e23186acea64f2f4de94ea_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 _Lerp_21eaf65c617b2d858b3b33154d55757a_Out_3;
            Unity_Lerp_float3(_NormalBlend_be36dd49bea74c8f8dd52fa3a85a9534_Out_2, _NormalStrength_0e5e0831ba0e98878220ca6021ea52a2_Out_2, (_Multiply_4d295791f4e23186acea64f2f4de94ea_Out_2.xxx), _Lerp_21eaf65c617b2d858b3b33154d55757a_Out_3);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3x3 Transform_1e4c3a2d6240958ab6858efb88c1d06a_transposeTangent = transpose(float3x3(IN.WorldSpaceTangent, IN.WorldSpaceBiTangent, IN.WorldSpaceNormal));
            float3 _Transform_1e4c3a2d6240958ab6858efb88c1d06a_Out_1 = normalize(mul(Transform_1e4c3a2d6240958ab6858efb88c1d06a_transposeTangent, _Lerp_21eaf65c617b2d858b3b33154d55757a_Out_3.xyz).xyz);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Split_600a9d271d96798a94ab28118977defd_R_1 = _Transform_1e4c3a2d6240958ab6858efb88c1d06a_Out_1[0];
            float _Split_600a9d271d96798a94ab28118977defd_G_2 = _Transform_1e4c3a2d6240958ab6858efb88c1d06a_Out_1[1];
            float _Split_600a9d271d96798a94ab28118977defd_B_3 = _Transform_1e4c3a2d6240958ab6858efb88c1d06a_Out_1[2];
            float _Split_600a9d271d96798a94ab28118977defd_A_4 = 0;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Multiply_2e5b010626435f8492a2690396ced19d_Out_2;
            Unity_Multiply_float(_Split_600a9d271d96798a94ab28118977defd_G_2, _Clamp_95d579f83746cb82be79cf6739990e0b_Out_3, _Multiply_2e5b010626435f8492a2690396ced19d_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Multiply_5a2397e0153ddb8f9bd457d9a301dc8b_Out_2;
            Unity_Multiply_float(_Clamp_95d579f83746cb82be79cf6739990e0b_Out_3, _Property_27e768ffa9c13e8ab65d48e7712e5b66_Out_0, _Multiply_5a2397e0153ddb8f9bd457d9a301dc8b_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Multiply_3aad76eaff60dd888c3e1783ecf03943_Out_2;
            Unity_Multiply_float(_Multiply_5a2397e0153ddb8f9bd457d9a301dc8b_Out_2, _Multiply_7ea7400ed65a3582b000796fb39748e9_Out_2, _Multiply_3aad76eaff60dd888c3e1783ecf03943_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Multiply_05614e740451f18f8301586390aa5a0a_Out_2;
            Unity_Multiply_float(_Multiply_2e5b010626435f8492a2690396ced19d_Out_2, _Multiply_3aad76eaff60dd888c3e1783ecf03943_Out_2, _Multiply_05614e740451f18f8301586390aa5a0a_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            UnityTexture2D _Property_a14f2476a35d208b988233c852f919ef_Out_0 = UnityBuildTexture2DStructNoScale(_CoverMaskMap);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            Bindings_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6 _PlanarNM_6858a0e821f26a8d87846d325e9bd170;
            _PlanarNM_6858a0e821f26a8d87846d325e9bd170.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            _PlanarNM_6858a0e821f26a8d87846d325e9bd170.uv0 = IN.uv0;
            float4 _PlanarNM_6858a0e821f26a8d87846d325e9bd170_XZ_2;
            SG_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6(_Property_a14f2476a35d208b988233c852f919ef_Out_0, _Property_e35c79b8cccfbe8ca0a3c33e8d32e319_Out_0, _Property_e3d8b38b51331e879b1d4012d65f53e6_Out_0, _PlanarNM_6858a0e821f26a8d87846d325e9bd170, _PlanarNM_6858a0e821f26a8d87846d325e9bd170_XZ_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Split_16313c20ccdeaa86a639068877a69a2f_R_1 = _PlanarNM_6858a0e821f26a8d87846d325e9bd170_XZ_2[0];
            float _Split_16313c20ccdeaa86a639068877a69a2f_G_2 = _PlanarNM_6858a0e821f26a8d87846d325e9bd170_XZ_2[1];
            float _Split_16313c20ccdeaa86a639068877a69a2f_B_3 = _PlanarNM_6858a0e821f26a8d87846d325e9bd170_XZ_2[2];
            float _Split_16313c20ccdeaa86a639068877a69a2f_A_4 = _PlanarNM_6858a0e821f26a8d87846d325e9bd170_XZ_2[3];
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_673896519f419589938b37e782b90141_Out_0 = _CoverHeightMapMin;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_c35906332422438da3b19f45cbd5ac17_Out_0 = _CoverHeightMapMax;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float2 _Vector2_81cbe1e5ea789e8697223cd3bfbca76c_Out_0 = float2(_Property_673896519f419589938b37e782b90141_Out_0, _Property_c35906332422438da3b19f45cbd5ac17_Out_0);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_88ab0068f899fc8ba94efdaec5e8966b_Out_0 = _CoverHeightMapOffset;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float2 _Add_cd623e3135271489b0d45b4d7edc5f7e_Out_2;
            Unity_Add_float2(_Vector2_81cbe1e5ea789e8697223cd3bfbca76c_Out_0, (_Property_88ab0068f899fc8ba94efdaec5e8966b_Out_0.xx), _Add_cd623e3135271489b0d45b4d7edc5f7e_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Remap_9a23d5f76fa8c38dbd73f43bd6397b0b_Out_3;
            Unity_Remap_float(_Split_16313c20ccdeaa86a639068877a69a2f_B_3, float2 (0, 1), _Add_cd623e3135271489b0d45b4d7edc5f7e_Out_2, _Remap_9a23d5f76fa8c38dbd73f43bd6397b0b_Out_3);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Multiply_0093be0fd848498b89a0fa282608e715_Out_2;
            Unity_Multiply_float(_Multiply_05614e740451f18f8301586390aa5a0a_Out_2, _Remap_9a23d5f76fa8c38dbd73f43bd6397b0b_Out_3, _Multiply_0093be0fd848498b89a0fa282608e715_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Multiply_d3190f97afd0398083623ecf71a41b1a_Out_2;
            Unity_Multiply_float(_Split_8ba5b67899f36b8f9dcf5c84092c0560_G_2, _Multiply_0093be0fd848498b89a0fa282608e715_Out_2, _Multiply_d3190f97afd0398083623ecf71a41b1a_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Saturate_cbcee34e7e6e6d8091d840550ab1c74a_Out_1;
            Unity_Saturate_float(_Multiply_d3190f97afd0398083623ecf71a41b1a_Out_2, _Saturate_cbcee34e7e6e6d8091d840550ab1c74a_Out_1);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Multiply_da35b9d9e4dd8c81871a9aea42c157ee_Out_2;
            Unity_Multiply_float(_Clamp_030a7c32684c258084338456eaddc77a_Out_3, _Saturate_cbcee34e7e6e6d8091d840550ab1c74a_Out_1, _Multiply_da35b9d9e4dd8c81871a9aea42c157ee_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Clamp_c95f5515948375878df6581a36d8b203_Out_3;
            Unity_Clamp_float(_Multiply_da35b9d9e4dd8c81871a9aea42c157ee_Out_2, 0, 1, _Clamp_c95f5515948375878df6581a36d8b203_Out_3);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            #if defined(_USEDYNAMICCOVERTSTATICMASKF_ON)
            float _UseDynamicCoverTStaticMaskF_0694902516172b8fa469c5d8b8e938c6_Out_0 = _Clamp_c95f5515948375878df6581a36d8b203_Out_3;
            #else
            float _UseDynamicCoverTStaticMaskF_0694902516172b8fa469c5d8b8e938c6_Out_0 = _Clamp_030a7c32684c258084338456eaddc77a_Out_3;
            #endif
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 _Lerp_87882219e20a6d818c0de017d739125f_Out_3;
            Unity_Lerp_float3(_BlendOverlayBaseColor_f3cd25d5b673648eb831a3f388201f73_OutVector4_1, (_Multiply_2eb83c7af5b6f58eabeec7b502517470_Out_2.xyz), (_UseDynamicCoverTStaticMaskF_0694902516172b8fa469c5d8b8e938c6_Out_0.xxx), _Lerp_87882219e20a6d818c0de017d739125f_Out_3);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 _Property_4c7bd3690d9d8a838e2524f5908e09ee_Out_0 = _WetColor;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 _Multiply_77c751a5503e948d8952b403163b4eeb_Out_2;
            Unity_Multiply_float((_Property_4c7bd3690d9d8a838e2524f5908e09ee_Out_0.xyz), _Lerp_87882219e20a6d818c0de017d739125f_Out_3, _Multiply_77c751a5503e948d8952b403163b4eeb_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _OneMinus_9b165e3f6c2fdd88a5f3a51230f8dd33_Out_1;
            Unity_OneMinus_float(_Split_8ba5b67899f36b8f9dcf5c84092c0560_R_1, _OneMinus_9b165e3f6c2fdd88a5f3a51230f8dd33_Out_1);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 _Lerp_538fa3f69b550a8bbe8ee20906ecc752_Out_3;
            Unity_Lerp_float3(_Lerp_87882219e20a6d818c0de017d739125f_Out_3, _Multiply_77c751a5503e948d8952b403163b4eeb_Out_2, (_OneMinus_9b165e3f6c2fdd88a5f3a51230f8dd33_Out_1.xxx), _Lerp_538fa3f69b550a8bbe8ee20906ecc752_Out_3);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_486692dad4d34a8c8410b4771efbf96b_Out_0 = _CoverNormalScale;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 _NormalStrength_d60a055f00d779808337e9d909827806_Out_2;
            Unity_NormalStrength_float((_PlanarNMn_79abde32a0223a89907c9f09efac8db7_XZ_2.xyz), _Property_486692dad4d34a8c8410b4771efbf96b_Out_0, _NormalStrength_d60a055f00d779808337e9d909827806_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 _Lerp_6861b6a37faf5e868527d229073a4d0f_Out_3;
            Unity_Lerp_float3(_NormalBlend_be36dd49bea74c8f8dd52fa3a85a9534_Out_2, _NormalStrength_d60a055f00d779808337e9d909827806_Out_2, (_UseDynamicCoverTStaticMaskF_0694902516172b8fa469c5d8b8e938c6_Out_0.xxx), _Lerp_6861b6a37faf5e868527d229073a4d0f_Out_3);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            UnityTexture2D _Property_a1adaaa2a22b0e829756ccb08eab9146_Out_0 = UnityBuildTexture2DStructNoScale(_BaseMaskMap);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            Bindings_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6 _PlanarNM_d26fd10040332c89b94151832fa36c95;
            _PlanarNM_d26fd10040332c89b94151832fa36c95.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            _PlanarNM_d26fd10040332c89b94151832fa36c95.uv0 = IN.uv0;
            float4 _PlanarNM_d26fd10040332c89b94151832fa36c95_XZ_2;
            SG_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6(_Property_a1adaaa2a22b0e829756ccb08eab9146_Out_0, _Property_115fcc827510f38798b214d835c27637_Out_0, _Property_d83b8f290862b285bbe2f157190e1315_Out_0, _PlanarNM_d26fd10040332c89b94151832fa36c95, _PlanarNM_d26fd10040332c89b94151832fa36c95_XZ_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Split_c8dcaee88e16428ab476271a494e0946_R_1 = _PlanarNM_d26fd10040332c89b94151832fa36c95_XZ_2[0];
            float _Split_c8dcaee88e16428ab476271a494e0946_G_2 = _PlanarNM_d26fd10040332c89b94151832fa36c95_XZ_2[1];
            float _Split_c8dcaee88e16428ab476271a494e0946_B_3 = _PlanarNM_d26fd10040332c89b94151832fa36c95_XZ_2[2];
            float _Split_c8dcaee88e16428ab476271a494e0946_A_4 = _PlanarNM_d26fd10040332c89b94151832fa36c95_XZ_2[3];
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_06c41396a31ba582877d3a10387f69e6_Out_0 = _BaseMetallic;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Multiply_1e8010b400ec9689a4d8570c8fb2dd6e_Out_2;
            Unity_Multiply_float(_Split_c8dcaee88e16428ab476271a494e0946_R_1, _Property_06c41396a31ba582877d3a10387f69e6_Out_0, _Multiply_1e8010b400ec9689a4d8570c8fb2dd6e_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_2dbdbebc756fb1819344efcc68c07d00_Out_0 = _BaseAORemapMin;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_bdc878630dfca586bff66e5b4bfffe30_Out_0 = _BaseAORemapMax;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float2 _Vector2_7f058afa3dd186869dd0f2d889a637bb_Out_0 = float2(_Property_2dbdbebc756fb1819344efcc68c07d00_Out_0, _Property_bdc878630dfca586bff66e5b4bfffe30_Out_0);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Remap_736c05b9e06ff78597a5b300523c5e04_Out_3;
            Unity_Remap_float(_Split_c8dcaee88e16428ab476271a494e0946_G_2, float2 (0, 1), _Vector2_7f058afa3dd186869dd0f2d889a637bb_Out_0, _Remap_736c05b9e06ff78597a5b300523c5e04_Out_3);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_dbfeaf948b34478090dd8f1a3d0e2440_Out_0 = _BaseSmoothnessRemapMin;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_d7d9704f0497d58ea30c73507241d8e4_Out_0 = _BaseSmoothnessRemapMax;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float2 _Vector2_03bee8a712eb848f9058c9ca67139ff0_Out_0 = float2(_Property_dbfeaf948b34478090dd8f1a3d0e2440_Out_0, _Property_d7d9704f0497d58ea30c73507241d8e4_Out_0);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Remap_9fa10d7f73353f8d98e7e00ad7887efd_Out_3;
            Unity_Remap_float(_Split_c8dcaee88e16428ab476271a494e0946_A_4, float2 (0, 1), _Vector2_03bee8a712eb848f9058c9ca67139ff0_Out_0, _Remap_9fa10d7f73353f8d98e7e00ad7887efd_Out_3);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Multiply_93138f23185e4d83b6825f8212653c3e_Out_2;
            Unity_Multiply_float(_SampleTexture2D_fa4ac40fc922b9869e37c06690c0f530_B_6, 2, _Multiply_93138f23185e4d83b6825f8212653c3e_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Add_53ebd006b8d6448881dfe527be4ca8e6_Out_2;
            Unity_Add_float(_Multiply_93138f23185e4d83b6825f8212653c3e_Out_2, -1, _Add_53ebd006b8d6448881dfe527be4ca8e6_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_dadcc7446e5d388e9a6730406295f93a_Out_0 = _DetailSmoothnessScale;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Multiply_1de6b43ae21981829be79a3a54ae243b_Out_2;
            Unity_Multiply_float(_Add_53ebd006b8d6448881dfe527be4ca8e6_Out_2, _Property_dadcc7446e5d388e9a6730406295f93a_Out_0, _Multiply_1de6b43ae21981829be79a3a54ae243b_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Saturate_0834275a3ed56c8fb32773dd6424fe67_Out_1;
            Unity_Saturate_float(_Multiply_1de6b43ae21981829be79a3a54ae243b_Out_2, _Saturate_0834275a3ed56c8fb32773dd6424fe67_Out_1);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Absolute_ca93b0439159da8d944e94364e98a3a5_Out_1;
            Unity_Absolute_float(_Saturate_0834275a3ed56c8fb32773dd6424fe67_Out_1, _Absolute_ca93b0439159da8d944e94364e98a3a5_Out_1);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            Bindings_BlendOverlayDetailSmoothness_06e12138dc89c0040b45a57abe520a1a _BlendOverlayDetailSmoothness_586cd13379fb3187a73a451ca1585fb7;
            float _BlendOverlayDetailSmoothness_586cd13379fb3187a73a451ca1585fb7_SmoothnessOverlay_1;
            SG_BlendOverlayDetailSmoothness_06e12138dc89c0040b45a57abe520a1a(_Remap_9fa10d7f73353f8d98e7e00ad7887efd_Out_3, _Add_53ebd006b8d6448881dfe527be4ca8e6_Out_2, _Absolute_ca93b0439159da8d944e94364e98a3a5_Out_1, _BlendOverlayDetailSmoothness_586cd13379fb3187a73a451ca1585fb7, _BlendOverlayDetailSmoothness_586cd13379fb3187a73a451ca1585fb7_SmoothnessOverlay_1);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Saturate_6a86fd5df2ee918a83675f1c42dd4511_Out_1;
            Unity_Saturate_float(_BlendOverlayDetailSmoothness_586cd13379fb3187a73a451ca1585fb7_SmoothnessOverlay_1, _Saturate_6a86fd5df2ee918a83675f1c42dd4511_Out_1);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 _Vector3_b34af5a5e4b21588a99ba5eb5358a84d_Out_0 = float3(_Multiply_1e8010b400ec9689a4d8570c8fb2dd6e_Out_2, _Remap_736c05b9e06ff78597a5b300523c5e04_Out_3, _Saturate_6a86fd5df2ee918a83675f1c42dd4511_Out_1);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_dc64ffdb5487f38c8fafcef1d518b3eb_Out_0 = _CoverMetallic;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Multiply_62c6df8b3ac33382bb38f0b594d1a4fa_Out_2;
            Unity_Multiply_float(_Split_16313c20ccdeaa86a639068877a69a2f_R_1, _Property_dc64ffdb5487f38c8fafcef1d518b3eb_Out_0, _Multiply_62c6df8b3ac33382bb38f0b594d1a4fa_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_2696a3815c73848db1c5516a77ad7e3e_Out_0 = _CoverAORemapMin;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_dc6e42b9f380d88fb5998902d1ddaa45_Out_0 = _CoverAORemapMax;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float2 _Vector2_6f054e667fb031849116087b7663e8de_Out_0 = float2(_Property_2696a3815c73848db1c5516a77ad7e3e_Out_0, _Property_dc6e42b9f380d88fb5998902d1ddaa45_Out_0);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Remap_805dc695e2ca6186842dd0c16c68fe7a_Out_3;
            Unity_Remap_float(_Split_16313c20ccdeaa86a639068877a69a2f_G_2, float2 (0, 1), _Vector2_6f054e667fb031849116087b7663e8de_Out_0, _Remap_805dc695e2ca6186842dd0c16c68fe7a_Out_3);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_05c4f672b1175a84b0d7ce44b23b4aa4_Out_0 = _CoverSmoothnessRemapMin;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_5f3529123a9ea982984b3bdc33dcb041_Out_0 = _CoverSmoothnessRemapMax;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float2 _Vector2_1eb7cc7a8699a889b2b636baa84fc4fd_Out_0 = float2(_Property_05c4f672b1175a84b0d7ce44b23b4aa4_Out_0, _Property_5f3529123a9ea982984b3bdc33dcb041_Out_0);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Remap_2e561d2a6ce223819f2665623c7c6c94_Out_3;
            Unity_Remap_float(_Split_16313c20ccdeaa86a639068877a69a2f_A_4, float2 (0, 1), _Vector2_1eb7cc7a8699a889b2b636baa84fc4fd_Out_0, _Remap_2e561d2a6ce223819f2665623c7c6c94_Out_3);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 _Vector3_9d828b596b436f898d7f64ebfd86402e_Out_0 = float3(_Multiply_62c6df8b3ac33382bb38f0b594d1a4fa_Out_2, _Remap_805dc695e2ca6186842dd0c16c68fe7a_Out_3, _Remap_2e561d2a6ce223819f2665623c7c6c94_Out_3);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 _Lerp_5a4703a1c1c9e387bdf52325fcd883e8_Out_3;
            Unity_Lerp_float3(_Vector3_b34af5a5e4b21588a99ba5eb5358a84d_Out_0, _Vector3_9d828b596b436f898d7f64ebfd86402e_Out_0, (_UseDynamicCoverTStaticMaskF_0694902516172b8fa469c5d8b8e938c6_Out_0.xxx), _Lerp_5a4703a1c1c9e387bdf52325fcd883e8_Out_3);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Split_b9b4ede5ed4eaf82a5409e98b1310654_R_1 = _Lerp_5a4703a1c1c9e387bdf52325fcd883e8_Out_3[0];
            float _Split_b9b4ede5ed4eaf82a5409e98b1310654_G_2 = _Lerp_5a4703a1c1c9e387bdf52325fcd883e8_Out_3[1];
            float _Split_b9b4ede5ed4eaf82a5409e98b1310654_B_3 = _Lerp_5a4703a1c1c9e387bdf52325fcd883e8_Out_3[2];
            float _Split_b9b4ede5ed4eaf82a5409e98b1310654_A_4 = 0;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_44a514a11d8fcc84aeab495181ebe3f0_Out_0 = _WetSmoothness;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Lerp_9c25fc1869bb8b83b41e153899e44f1a_Out_3;
            Unity_Lerp_float(_Split_b9b4ede5ed4eaf82a5409e98b1310654_B_3, _Property_44a514a11d8fcc84aeab495181ebe3f0_Out_0, _OneMinus_9b165e3f6c2fdd88a5f3a51230f8dd33_Out_1, _Lerp_9c25fc1869bb8b83b41e153899e44f1a_Out_3);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Split_31874fa1d55cb28e99a1333cf254676a_R_1 = _PlanarNM_6c8b686076db2a8c8b7d6cd91cf435f0_XZ_2[0];
            float _Split_31874fa1d55cb28e99a1333cf254676a_G_2 = _PlanarNM_6c8b686076db2a8c8b7d6cd91cf435f0_XZ_2[1];
            float _Split_31874fa1d55cb28e99a1333cf254676a_B_3 = _PlanarNM_6c8b686076db2a8c8b7d6cd91cf435f0_XZ_2[2];
            float _Split_31874fa1d55cb28e99a1333cf254676a_A_4 = _PlanarNM_6c8b686076db2a8c8b7d6cd91cf435f0_XZ_2[3];
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_881c341218ea2d81819695b0c7ddc4cb_Out_0 = _AlphaCutoff;
            #endif
            surface.BaseColor = _Lerp_538fa3f69b550a8bbe8ee20906ecc752_Out_3;
            surface.NormalTS = _Lerp_6861b6a37faf5e868527d229073a4d0f_Out_3;
            surface.Emission = float3(0, 0, 0);
            surface.Metallic = _Split_b9b4ede5ed4eaf82a5409e98b1310654_R_1;
            surface.Smoothness = _Lerp_9c25fc1869bb8b83b41e153899e44f1a_Out_3;
            surface.Occlusion = _Split_b9b4ede5ed4eaf82a5409e98b1310654_G_2;
            surface.Alpha = _Split_31874fa1d55cb28e99a1333cf254676a_A_4;
            surface.AlphaClipThreshold = _Property_881c341218ea2d81819695b0c7ddc4cb_Out_0;
            return surface;
        }

            // --------------------------------------------------
            // Build Graph Inputs

            VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.ObjectSpaceNormal =           input.normalOS;
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.ObjectSpaceTangent =          input.tangentOS.xyz;
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.ObjectSpacePosition =         input.positionOS;
        #endif


            return output;
        }
            SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        // must use interpolated tangent, bitangent and normal before they are normalized in the pixel shader.
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        float3 unnormalizedNormalWS = input.normalWS;
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        const float renormFactor = 1.0 / length(unnormalizedNormalWS);
        #endif


        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        // use bitangent on the fly like in hdrp
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        // IMPORTANT! If we ever support Flip on double sided materials ensure bitangent and tangent are NOT flipped.
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        float crossSign = (input.tangentWS.w > 0.0 ? 1.0 : -1.0) * GetOddNegativeScale();
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        float3 bitang = crossSign * cross(input.normalWS.xyz, input.tangentWS.xyz);
        #endif


        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.WorldSpaceNormal =            renormFactor*input.normalWS.xyz;      // we want a unit length Normal Vector node in shader graph
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.TangentSpaceNormal =          float3(0.0f, 0.0f, 1.0f);
        #endif


        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        // to preserve mikktspace compliance we use same scale renormFactor as was used on the normal.
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        // This is explained in section 2.2 in "surface gradient based bump mapping framework"
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.WorldSpaceTangent =           renormFactor*input.tangentWS.xyz;
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.WorldSpaceBiTangent =         renormFactor*bitang;
        #endif


        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.AbsoluteWorldSpacePosition =  GetAbsolutePositionWS(input.positionWS);
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.uv0 =                         input.texCoord0;
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.VertexColor =                 input.color;
        #endif

        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN

            return output;
        }

            // --------------------------------------------------
            // Main

            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/UnityGBuffer.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/PBRGBufferPass.hlsl"

            ENDHLSL
        }
        Pass
        {
            Name "ShadowCaster"
            Tags
            {
                "LightMode" = "ShadowCaster"
            }

            // Render State
            Cull Back
        Blend One Zero
        ZTest LEqual
        ZWrite On
        ColorMask 0

            // Debug
            // <None>

            // --------------------------------------------------
            // Pass

            HLSLPROGRAM

            // Pragmas
            #pragma target 4.5
        #pragma exclude_renderers gles gles3 glcore
        #pragma multi_compile_instancing
        #pragma multi_compile _ DOTS_INSTANCING_ON
        #pragma vertex vert
        #pragma fragment frag

            // DotsInstancingOptions: <None>
            // HybridV1InjectedBuiltinProperties: <None>

            // Keywords
            #pragma multi_compile _ _CASTING_PUNCTUAL_LIGHT_SHADOW
            #pragma shader_feature_local _ _USEDYNAMICCOVERTSTATICMASKF_ON

        #if defined(_USEDYNAMICCOVERTSTATICMASKF_ON)
            #define KEYWORD_PERMUTATION_0
        #else
            #define KEYWORD_PERMUTATION_1
        #endif


            // Defines
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define _AlphaClip 1
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define _NORMALMAP 1
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define _NORMAL_DROPOFF_TS 1
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define ATTRIBUTES_NEED_NORMAL
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define ATTRIBUTES_NEED_TANGENT
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define ATTRIBUTES_NEED_TEXCOORD0
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define VARYINGS_NEED_POSITION_WS
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define VARYINGS_NEED_TEXCOORD0
        #endif

            #define FEATURES_GRAPH_VERTEX
            /* WARNING: $splice Could not find named fragment 'PassInstancing' */
            #define SHADERPASS SHADERPASS_SHADOWCASTER
            /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */

            // Includes
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"

            // --------------------------------------------------
            // Structs and Packing

            struct Attributes
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 positionOS : POSITION;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 normalOS : NORMAL;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 tangentOS : TANGENT;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 uv0 : TEXCOORD0;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            uint instanceID : INSTANCEID_SEMANTIC;
            #endif
            #endif
        };
        struct Varyings
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 positionCS : SV_POSITION;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 positionWS;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 texCoord0;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
            #endif
        };
        struct SurfaceDescriptionInputs
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 AbsoluteWorldSpacePosition;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 uv0;
            #endif
        };
        struct VertexDescriptionInputs
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 ObjectSpaceNormal;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 ObjectSpaceTangent;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 ObjectSpacePosition;
            #endif
        };
        struct PackedVaryings
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 positionCS : SV_POSITION;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 interp0 : TEXCOORD0;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 interp1 : TEXCOORD1;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
            #endif
        };

            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            output.positionCS = input.positionCS;
            output.interp0.xyz =  input.positionWS;
            output.interp1.xyzw =  input.texCoord0;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.positionWS = input.interp0.xyz;
            output.texCoord0 = input.interp1.xyzw;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        #endif

            // --------------------------------------------------
            // Graph

            // Graph Properties
            CBUFFER_START(UnityPerMaterial)
        float _AlphaCutoff;
        float4 _BaseColor;
        float4 _BaseColorMap_TexelSize;
        float _BaseUsePlanarUV;
        float4 _BaseTilingOffset;
        float4 _BaseNormalMap_TexelSize;
        float _BaseNormalScale;
        float4 _BaseMaskMap_TexelSize;
        float _BaseMetallic;
        float _BaseAORemapMin;
        float _BaseAORemapMax;
        float _BaseSmoothnessRemapMin;
        float _BaseSmoothnessRemapMax;
        float4 _CoverMaskA_TexelSize;
        float _CoverMaskPower;
        float _Cover_Amount;
        float _Cover_Amount_Grow_Speed;
        float _Cover_Max_Angle;
        float _Cover_Min_Height;
        float _Cover_Min_Height_Blending;
        float4 _CoverBaseColor;
        float4 _CoverBaseColorMap_TexelSize;
        float _CoverUsePlanarUV;
        float4 _CoverTilingOffset;
        float4 _CoverNormalMap_TexelSize;
        float _CoverNormalScale;
        float _CoverNormalBlendHardness;
        float _CoverHardness;
        float _CoverHeightMapMin;
        float _CoverHeightMapMax;
        float _CoverHeightMapOffset;
        float4 _CoverMaskMap_TexelSize;
        float _CoverMetallic;
        float _CoverAORemapMin;
        float _CoverAORemapMax;
        float _CoverSmoothnessRemapMin;
        float _CoverSmoothnessRemapMax;
        float4 _DetailMap_TexelSize;
        float4 _DetailTilingOffset;
        float _DetailAlbedoScale;
        float _DetailNormalScale;
        float _DetailSmoothnessScale;
        float4 _WetColor;
        float _WetSmoothness;
        CBUFFER_END

        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_BaseColorMap);
        SAMPLER(sampler_BaseColorMap);
        TEXTURE2D(_BaseNormalMap);
        SAMPLER(sampler_BaseNormalMap);
        TEXTURE2D(_BaseMaskMap);
        SAMPLER(sampler_BaseMaskMap);
        TEXTURE2D(_CoverMaskA);
        SAMPLER(sampler_CoverMaskA);
        TEXTURE2D(_CoverBaseColorMap);
        SAMPLER(sampler_CoverBaseColorMap);
        TEXTURE2D(_CoverNormalMap);
        SAMPLER(sampler_CoverNormalMap);
        TEXTURE2D(_CoverMaskMap);
        SAMPLER(sampler_CoverMaskMap);
        TEXTURE2D(_DetailMap);
        SAMPLER(sampler_DetailMap);

            // Graph Functions
            
        // f948cdce565a6e706cc57cb23fbf9d95
        #include "./NM_Object_VSPro_Indirect.cginc"

        void AddPragma_float(float3 A, out float3 Out){
            #pragma instancing_options renderinglayer procedural:setupVSPro
            Out = A;
        }

        struct Bindings_NMObjectVSProIndirect_0cfe1e4f145944241ab304331e53c93b
        {
        };

        void SG_NMObjectVSProIndirect_0cfe1e4f145944241ab304331e53c93b(float3 Vector3_314C8600, Bindings_NMObjectVSProIndirect_0cfe1e4f145944241ab304331e53c93b IN, out float3 ObjectSpacePosition_1)
        {
            float3 _Property_5ec158abd968858c9d31ab40df5e9e6f_Out_0 = Vector3_314C8600;
            float3 _InjectSetupCustomFunction_dec9b26544b4a788b8ecb4117dc3d24a_Out_1;
            InjectSetup_float(_Property_5ec158abd968858c9d31ab40df5e9e6f_Out_0, _InjectSetupCustomFunction_dec9b26544b4a788b8ecb4117dc3d24a_Out_1);
            float3 _AddPragmaCustomFunction_b2a053178906d0848480a1f463521a1b_Out_1;
            AddPragma_float(_InjectSetupCustomFunction_dec9b26544b4a788b8ecb4117dc3d24a_Out_1, _AddPragmaCustomFunction_b2a053178906d0848480a1f463521a1b_Out_1);
            ObjectSpacePosition_1 = _AddPragmaCustomFunction_b2a053178906d0848480a1f463521a1b_Out_1;
        }

        void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
        {
            RGBA = float4(R, G, B, A);
            RGB = float3(R, G, B);
            RG = float2(R, G);
        }

        void Unity_Divide_float(float A, float B, out float Out)
        {
            Out = A / B;
        }

        void Unity_Multiply_float(float4 A, float4 B, out float4 Out)
        {
            Out = A * B;
        }

        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }

        void Unity_Branch_float2(float Predicate, float2 True, float2 False, out float2 Out)
        {
            Out = Predicate ? True : False;
        }

        struct Bindings_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6
        {
            float3 AbsoluteWorldSpacePosition;
            half4 uv0;
        };

        void SG_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6(UnityTexture2D Texture2D_80A3D28F, float4 Vector4_2EBA7A3B, float Boolean_7ABB9909, Bindings_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6 IN, out float4 XZ_2)
        {
            UnityTexture2D _Property_3e01b4d2fc68d48ba3acbba9d5881e59_Out_0 = Texture2D_80A3D28F;
            float _Property_30834f691775a0898a45b1c868520436_Out_0 = Boolean_7ABB9909;
            float _Split_89ed63cb625cb3878c183d0b71c03400_R_1 = IN.AbsoluteWorldSpacePosition[0];
            float _Split_89ed63cb625cb3878c183d0b71c03400_G_2 = IN.AbsoluteWorldSpacePosition[1];
            float _Split_89ed63cb625cb3878c183d0b71c03400_B_3 = IN.AbsoluteWorldSpacePosition[2];
            float _Split_89ed63cb625cb3878c183d0b71c03400_A_4 = 0;
            float4 _Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4;
            float3 _Combine_cf2d04ff119ad88493f6460431765cbb_RGB_5;
            float2 _Combine_cf2d04ff119ad88493f6460431765cbb_RG_6;
            Unity_Combine_float(_Split_89ed63cb625cb3878c183d0b71c03400_R_1, _Split_89ed63cb625cb3878c183d0b71c03400_B_3, 0, 0, _Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4, _Combine_cf2d04ff119ad88493f6460431765cbb_RGB_5, _Combine_cf2d04ff119ad88493f6460431765cbb_RG_6);
            float4 _Property_8a66888ec47d0687ab1cb2f8abdc9da8_Out_0 = Vector4_2EBA7A3B;
            float _Split_2f0f52f6ef8c0e81af0da6476402bc1f_R_1 = _Property_8a66888ec47d0687ab1cb2f8abdc9da8_Out_0[0];
            float _Split_2f0f52f6ef8c0e81af0da6476402bc1f_G_2 = _Property_8a66888ec47d0687ab1cb2f8abdc9da8_Out_0[1];
            float _Split_2f0f52f6ef8c0e81af0da6476402bc1f_B_3 = _Property_8a66888ec47d0687ab1cb2f8abdc9da8_Out_0[2];
            float _Split_2f0f52f6ef8c0e81af0da6476402bc1f_A_4 = _Property_8a66888ec47d0687ab1cb2f8abdc9da8_Out_0[3];
            float _Divide_e64179199923c58289b6aa94ea6c9178_Out_2;
            Unity_Divide_float(1, _Split_2f0f52f6ef8c0e81af0da6476402bc1f_R_1, _Divide_e64179199923c58289b6aa94ea6c9178_Out_2);
            float4 _Multiply_14cec4902d0a00829e4555071a1b8ad1_Out_2;
            Unity_Multiply_float(_Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4, (_Divide_e64179199923c58289b6aa94ea6c9178_Out_2.xxxx), _Multiply_14cec4902d0a00829e4555071a1b8ad1_Out_2);
            float2 _Vector2_16c15d3bbdd14b85bd48e3a6cb318af7_Out_0 = float2(_Split_2f0f52f6ef8c0e81af0da6476402bc1f_R_1, _Split_2f0f52f6ef8c0e81af0da6476402bc1f_G_2);
            float2 _Vector2_f8d75f54e7705083bbec539a60185577_Out_0 = float2(_Split_2f0f52f6ef8c0e81af0da6476402bc1f_B_3, _Split_2f0f52f6ef8c0e81af0da6476402bc1f_A_4);
            float2 _TilingAndOffset_d91e2d25acd34686b562b7fe7e9d1d27_Out_3;
            Unity_TilingAndOffset_float(IN.uv0.xy, _Vector2_16c15d3bbdd14b85bd48e3a6cb318af7_Out_0, _Vector2_f8d75f54e7705083bbec539a60185577_Out_0, _TilingAndOffset_d91e2d25acd34686b562b7fe7e9d1d27_Out_3);
            float2 _Branch_8e5a4e8f4d52fc8aadd1f46485afc933_Out_3;
            Unity_Branch_float2(_Property_30834f691775a0898a45b1c868520436_Out_0, (_Multiply_14cec4902d0a00829e4555071a1b8ad1_Out_2.xy), _TilingAndOffset_d91e2d25acd34686b562b7fe7e9d1d27_Out_3, _Branch_8e5a4e8f4d52fc8aadd1f46485afc933_Out_3);
            float4 _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0 = SAMPLE_TEXTURE2D(_Property_3e01b4d2fc68d48ba3acbba9d5881e59_Out_0.tex, _Property_3e01b4d2fc68d48ba3acbba9d5881e59_Out_0.samplerstate, _Branch_8e5a4e8f4d52fc8aadd1f46485afc933_Out_3);
            float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_R_4 = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0.r;
            float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_G_5 = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0.g;
            float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_B_6 = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0.b;
            float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_A_7 = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0.a;
            XZ_2 = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0;
        }

            // Graph Vertex
            struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };

        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            Bindings_NMObjectVSProIndirect_0cfe1e4f145944241ab304331e53c93b _NMObjectVSProIndirect_adbe93754e069e8e87df45ef6e4b343e;
            float3 _NMObjectVSProIndirect_adbe93754e069e8e87df45ef6e4b343e_ObjectSpacePosition_1;
            SG_NMObjectVSProIndirect_0cfe1e4f145944241ab304331e53c93b(IN.ObjectSpacePosition, _NMObjectVSProIndirect_adbe93754e069e8e87df45ef6e4b343e, _NMObjectVSProIndirect_adbe93754e069e8e87df45ef6e4b343e_ObjectSpacePosition_1);
            #endif
            description.Position = _NMObjectVSProIndirect_adbe93754e069e8e87df45ef6e4b343e_ObjectSpacePosition_1;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }

            // Graph Pixel
            struct SurfaceDescription
        {
            float Alpha;
            float AlphaClipThreshold;
        };

        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            UnityTexture2D _Property_e4c53213449c7682b60df6ae54f219f0_Out_0 = UnityBuildTexture2DStructNoScale(_BaseColorMap);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 _Property_115fcc827510f38798b214d835c27637_Out_0 = _BaseTilingOffset;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_d83b8f290862b285bbe2f157190e1315_Out_0 = _BaseUsePlanarUV;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            Bindings_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6 _PlanarNM_6c8b686076db2a8c8b7d6cd91cf435f0;
            _PlanarNM_6c8b686076db2a8c8b7d6cd91cf435f0.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            _PlanarNM_6c8b686076db2a8c8b7d6cd91cf435f0.uv0 = IN.uv0;
            float4 _PlanarNM_6c8b686076db2a8c8b7d6cd91cf435f0_XZ_2;
            SG_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6(_Property_e4c53213449c7682b60df6ae54f219f0_Out_0, _Property_115fcc827510f38798b214d835c27637_Out_0, _Property_d83b8f290862b285bbe2f157190e1315_Out_0, _PlanarNM_6c8b686076db2a8c8b7d6cd91cf435f0, _PlanarNM_6c8b686076db2a8c8b7d6cd91cf435f0_XZ_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Split_31874fa1d55cb28e99a1333cf254676a_R_1 = _PlanarNM_6c8b686076db2a8c8b7d6cd91cf435f0_XZ_2[0];
            float _Split_31874fa1d55cb28e99a1333cf254676a_G_2 = _PlanarNM_6c8b686076db2a8c8b7d6cd91cf435f0_XZ_2[1];
            float _Split_31874fa1d55cb28e99a1333cf254676a_B_3 = _PlanarNM_6c8b686076db2a8c8b7d6cd91cf435f0_XZ_2[2];
            float _Split_31874fa1d55cb28e99a1333cf254676a_A_4 = _PlanarNM_6c8b686076db2a8c8b7d6cd91cf435f0_XZ_2[3];
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_881c341218ea2d81819695b0c7ddc4cb_Out_0 = _AlphaCutoff;
            #endif
            surface.Alpha = _Split_31874fa1d55cb28e99a1333cf254676a_A_4;
            surface.AlphaClipThreshold = _Property_881c341218ea2d81819695b0c7ddc4cb_Out_0;
            return surface;
        }

            // --------------------------------------------------
            // Build Graph Inputs

            VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.ObjectSpaceNormal =           input.normalOS;
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.ObjectSpaceTangent =          input.tangentOS.xyz;
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.ObjectSpacePosition =         input.positionOS;
        #endif


            return output;
        }
            SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);





        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.AbsoluteWorldSpacePosition =  GetAbsolutePositionWS(input.positionWS);
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.uv0 =                         input.texCoord0;
        #endif

        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN

            return output;
        }

            // --------------------------------------------------
            // Main

            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShadowCasterPass.hlsl"

            ENDHLSL
        }
        Pass
        {
            Name "DepthOnly"
            Tags
            {
                "LightMode" = "DepthOnly"
            }

            // Render State
            Cull Back
        Blend One Zero
        ZTest LEqual
        ZWrite On
        ColorMask 0

            // Debug
            // <None>

            // --------------------------------------------------
            // Pass

            HLSLPROGRAM

            // Pragmas
            #pragma target 4.5
        #pragma exclude_renderers gles gles3 glcore
        #pragma multi_compile_instancing
        #pragma multi_compile _ DOTS_INSTANCING_ON
        #pragma vertex vert
        #pragma fragment frag

            // DotsInstancingOptions: <None>
            // HybridV1InjectedBuiltinProperties: <None>

            // Keywords
            // PassKeywords: <None>
            #pragma shader_feature_local _ _USEDYNAMICCOVERTSTATICMASKF_ON

        #if defined(_USEDYNAMICCOVERTSTATICMASKF_ON)
            #define KEYWORD_PERMUTATION_0
        #else
            #define KEYWORD_PERMUTATION_1
        #endif


            // Defines
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define _AlphaClip 1
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define _NORMALMAP 1
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define _NORMAL_DROPOFF_TS 1
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define ATTRIBUTES_NEED_NORMAL
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define ATTRIBUTES_NEED_TANGENT
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define ATTRIBUTES_NEED_TEXCOORD0
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define VARYINGS_NEED_POSITION_WS
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define VARYINGS_NEED_TEXCOORD0
        #endif

            #define FEATURES_GRAPH_VERTEX
            /* WARNING: $splice Could not find named fragment 'PassInstancing' */
            #define SHADERPASS SHADERPASS_DEPTHONLY
            /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */

            // Includes
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"

            // --------------------------------------------------
            // Structs and Packing

            struct Attributes
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 positionOS : POSITION;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 normalOS : NORMAL;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 tangentOS : TANGENT;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 uv0 : TEXCOORD0;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            uint instanceID : INSTANCEID_SEMANTIC;
            #endif
            #endif
        };
        struct Varyings
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 positionCS : SV_POSITION;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 positionWS;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 texCoord0;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
            #endif
        };
        struct SurfaceDescriptionInputs
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 AbsoluteWorldSpacePosition;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 uv0;
            #endif
        };
        struct VertexDescriptionInputs
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 ObjectSpaceNormal;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 ObjectSpaceTangent;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 ObjectSpacePosition;
            #endif
        };
        struct PackedVaryings
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 positionCS : SV_POSITION;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 interp0 : TEXCOORD0;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 interp1 : TEXCOORD1;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
            #endif
        };

            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            output.positionCS = input.positionCS;
            output.interp0.xyz =  input.positionWS;
            output.interp1.xyzw =  input.texCoord0;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.positionWS = input.interp0.xyz;
            output.texCoord0 = input.interp1.xyzw;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        #endif

            // --------------------------------------------------
            // Graph

            // Graph Properties
            CBUFFER_START(UnityPerMaterial)
        float _AlphaCutoff;
        float4 _BaseColor;
        float4 _BaseColorMap_TexelSize;
        float _BaseUsePlanarUV;
        float4 _BaseTilingOffset;
        float4 _BaseNormalMap_TexelSize;
        float _BaseNormalScale;
        float4 _BaseMaskMap_TexelSize;
        float _BaseMetallic;
        float _BaseAORemapMin;
        float _BaseAORemapMax;
        float _BaseSmoothnessRemapMin;
        float _BaseSmoothnessRemapMax;
        float4 _CoverMaskA_TexelSize;
        float _CoverMaskPower;
        float _Cover_Amount;
        float _Cover_Amount_Grow_Speed;
        float _Cover_Max_Angle;
        float _Cover_Min_Height;
        float _Cover_Min_Height_Blending;
        float4 _CoverBaseColor;
        float4 _CoverBaseColorMap_TexelSize;
        float _CoverUsePlanarUV;
        float4 _CoverTilingOffset;
        float4 _CoverNormalMap_TexelSize;
        float _CoverNormalScale;
        float _CoverNormalBlendHardness;
        float _CoverHardness;
        float _CoverHeightMapMin;
        float _CoverHeightMapMax;
        float _CoverHeightMapOffset;
        float4 _CoverMaskMap_TexelSize;
        float _CoverMetallic;
        float _CoverAORemapMin;
        float _CoverAORemapMax;
        float _CoverSmoothnessRemapMin;
        float _CoverSmoothnessRemapMax;
        float4 _DetailMap_TexelSize;
        float4 _DetailTilingOffset;
        float _DetailAlbedoScale;
        float _DetailNormalScale;
        float _DetailSmoothnessScale;
        float4 _WetColor;
        float _WetSmoothness;
        CBUFFER_END

        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_BaseColorMap);
        SAMPLER(sampler_BaseColorMap);
        TEXTURE2D(_BaseNormalMap);
        SAMPLER(sampler_BaseNormalMap);
        TEXTURE2D(_BaseMaskMap);
        SAMPLER(sampler_BaseMaskMap);
        TEXTURE2D(_CoverMaskA);
        SAMPLER(sampler_CoverMaskA);
        TEXTURE2D(_CoverBaseColorMap);
        SAMPLER(sampler_CoverBaseColorMap);
        TEXTURE2D(_CoverNormalMap);
        SAMPLER(sampler_CoverNormalMap);
        TEXTURE2D(_CoverMaskMap);
        SAMPLER(sampler_CoverMaskMap);
        TEXTURE2D(_DetailMap);
        SAMPLER(sampler_DetailMap);

            // Graph Functions
            
        // f948cdce565a6e706cc57cb23fbf9d95
        #include "./NM_Object_VSPro_Indirect.cginc"

        void AddPragma_float(float3 A, out float3 Out){
            #pragma instancing_options renderinglayer procedural:setupVSPro
            Out = A;
        }

        struct Bindings_NMObjectVSProIndirect_0cfe1e4f145944241ab304331e53c93b
        {
        };

        void SG_NMObjectVSProIndirect_0cfe1e4f145944241ab304331e53c93b(float3 Vector3_314C8600, Bindings_NMObjectVSProIndirect_0cfe1e4f145944241ab304331e53c93b IN, out float3 ObjectSpacePosition_1)
        {
            float3 _Property_5ec158abd968858c9d31ab40df5e9e6f_Out_0 = Vector3_314C8600;
            float3 _InjectSetupCustomFunction_dec9b26544b4a788b8ecb4117dc3d24a_Out_1;
            InjectSetup_float(_Property_5ec158abd968858c9d31ab40df5e9e6f_Out_0, _InjectSetupCustomFunction_dec9b26544b4a788b8ecb4117dc3d24a_Out_1);
            float3 _AddPragmaCustomFunction_b2a053178906d0848480a1f463521a1b_Out_1;
            AddPragma_float(_InjectSetupCustomFunction_dec9b26544b4a788b8ecb4117dc3d24a_Out_1, _AddPragmaCustomFunction_b2a053178906d0848480a1f463521a1b_Out_1);
            ObjectSpacePosition_1 = _AddPragmaCustomFunction_b2a053178906d0848480a1f463521a1b_Out_1;
        }

        void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
        {
            RGBA = float4(R, G, B, A);
            RGB = float3(R, G, B);
            RG = float2(R, G);
        }

        void Unity_Divide_float(float A, float B, out float Out)
        {
            Out = A / B;
        }

        void Unity_Multiply_float(float4 A, float4 B, out float4 Out)
        {
            Out = A * B;
        }

        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }

        void Unity_Branch_float2(float Predicate, float2 True, float2 False, out float2 Out)
        {
            Out = Predicate ? True : False;
        }

        struct Bindings_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6
        {
            float3 AbsoluteWorldSpacePosition;
            half4 uv0;
        };

        void SG_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6(UnityTexture2D Texture2D_80A3D28F, float4 Vector4_2EBA7A3B, float Boolean_7ABB9909, Bindings_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6 IN, out float4 XZ_2)
        {
            UnityTexture2D _Property_3e01b4d2fc68d48ba3acbba9d5881e59_Out_0 = Texture2D_80A3D28F;
            float _Property_30834f691775a0898a45b1c868520436_Out_0 = Boolean_7ABB9909;
            float _Split_89ed63cb625cb3878c183d0b71c03400_R_1 = IN.AbsoluteWorldSpacePosition[0];
            float _Split_89ed63cb625cb3878c183d0b71c03400_G_2 = IN.AbsoluteWorldSpacePosition[1];
            float _Split_89ed63cb625cb3878c183d0b71c03400_B_3 = IN.AbsoluteWorldSpacePosition[2];
            float _Split_89ed63cb625cb3878c183d0b71c03400_A_4 = 0;
            float4 _Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4;
            float3 _Combine_cf2d04ff119ad88493f6460431765cbb_RGB_5;
            float2 _Combine_cf2d04ff119ad88493f6460431765cbb_RG_6;
            Unity_Combine_float(_Split_89ed63cb625cb3878c183d0b71c03400_R_1, _Split_89ed63cb625cb3878c183d0b71c03400_B_3, 0, 0, _Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4, _Combine_cf2d04ff119ad88493f6460431765cbb_RGB_5, _Combine_cf2d04ff119ad88493f6460431765cbb_RG_6);
            float4 _Property_8a66888ec47d0687ab1cb2f8abdc9da8_Out_0 = Vector4_2EBA7A3B;
            float _Split_2f0f52f6ef8c0e81af0da6476402bc1f_R_1 = _Property_8a66888ec47d0687ab1cb2f8abdc9da8_Out_0[0];
            float _Split_2f0f52f6ef8c0e81af0da6476402bc1f_G_2 = _Property_8a66888ec47d0687ab1cb2f8abdc9da8_Out_0[1];
            float _Split_2f0f52f6ef8c0e81af0da6476402bc1f_B_3 = _Property_8a66888ec47d0687ab1cb2f8abdc9da8_Out_0[2];
            float _Split_2f0f52f6ef8c0e81af0da6476402bc1f_A_4 = _Property_8a66888ec47d0687ab1cb2f8abdc9da8_Out_0[3];
            float _Divide_e64179199923c58289b6aa94ea6c9178_Out_2;
            Unity_Divide_float(1, _Split_2f0f52f6ef8c0e81af0da6476402bc1f_R_1, _Divide_e64179199923c58289b6aa94ea6c9178_Out_2);
            float4 _Multiply_14cec4902d0a00829e4555071a1b8ad1_Out_2;
            Unity_Multiply_float(_Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4, (_Divide_e64179199923c58289b6aa94ea6c9178_Out_2.xxxx), _Multiply_14cec4902d0a00829e4555071a1b8ad1_Out_2);
            float2 _Vector2_16c15d3bbdd14b85bd48e3a6cb318af7_Out_0 = float2(_Split_2f0f52f6ef8c0e81af0da6476402bc1f_R_1, _Split_2f0f52f6ef8c0e81af0da6476402bc1f_G_2);
            float2 _Vector2_f8d75f54e7705083bbec539a60185577_Out_0 = float2(_Split_2f0f52f6ef8c0e81af0da6476402bc1f_B_3, _Split_2f0f52f6ef8c0e81af0da6476402bc1f_A_4);
            float2 _TilingAndOffset_d91e2d25acd34686b562b7fe7e9d1d27_Out_3;
            Unity_TilingAndOffset_float(IN.uv0.xy, _Vector2_16c15d3bbdd14b85bd48e3a6cb318af7_Out_0, _Vector2_f8d75f54e7705083bbec539a60185577_Out_0, _TilingAndOffset_d91e2d25acd34686b562b7fe7e9d1d27_Out_3);
            float2 _Branch_8e5a4e8f4d52fc8aadd1f46485afc933_Out_3;
            Unity_Branch_float2(_Property_30834f691775a0898a45b1c868520436_Out_0, (_Multiply_14cec4902d0a00829e4555071a1b8ad1_Out_2.xy), _TilingAndOffset_d91e2d25acd34686b562b7fe7e9d1d27_Out_3, _Branch_8e5a4e8f4d52fc8aadd1f46485afc933_Out_3);
            float4 _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0 = SAMPLE_TEXTURE2D(_Property_3e01b4d2fc68d48ba3acbba9d5881e59_Out_0.tex, _Property_3e01b4d2fc68d48ba3acbba9d5881e59_Out_0.samplerstate, _Branch_8e5a4e8f4d52fc8aadd1f46485afc933_Out_3);
            float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_R_4 = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0.r;
            float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_G_5 = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0.g;
            float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_B_6 = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0.b;
            float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_A_7 = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0.a;
            XZ_2 = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0;
        }

            // Graph Vertex
            struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };

        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            Bindings_NMObjectVSProIndirect_0cfe1e4f145944241ab304331e53c93b _NMObjectVSProIndirect_adbe93754e069e8e87df45ef6e4b343e;
            float3 _NMObjectVSProIndirect_adbe93754e069e8e87df45ef6e4b343e_ObjectSpacePosition_1;
            SG_NMObjectVSProIndirect_0cfe1e4f145944241ab304331e53c93b(IN.ObjectSpacePosition, _NMObjectVSProIndirect_adbe93754e069e8e87df45ef6e4b343e, _NMObjectVSProIndirect_adbe93754e069e8e87df45ef6e4b343e_ObjectSpacePosition_1);
            #endif
            description.Position = _NMObjectVSProIndirect_adbe93754e069e8e87df45ef6e4b343e_ObjectSpacePosition_1;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }

            // Graph Pixel
            struct SurfaceDescription
        {
            float Alpha;
            float AlphaClipThreshold;
        };

        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            UnityTexture2D _Property_e4c53213449c7682b60df6ae54f219f0_Out_0 = UnityBuildTexture2DStructNoScale(_BaseColorMap);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 _Property_115fcc827510f38798b214d835c27637_Out_0 = _BaseTilingOffset;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_d83b8f290862b285bbe2f157190e1315_Out_0 = _BaseUsePlanarUV;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            Bindings_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6 _PlanarNM_6c8b686076db2a8c8b7d6cd91cf435f0;
            _PlanarNM_6c8b686076db2a8c8b7d6cd91cf435f0.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            _PlanarNM_6c8b686076db2a8c8b7d6cd91cf435f0.uv0 = IN.uv0;
            float4 _PlanarNM_6c8b686076db2a8c8b7d6cd91cf435f0_XZ_2;
            SG_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6(_Property_e4c53213449c7682b60df6ae54f219f0_Out_0, _Property_115fcc827510f38798b214d835c27637_Out_0, _Property_d83b8f290862b285bbe2f157190e1315_Out_0, _PlanarNM_6c8b686076db2a8c8b7d6cd91cf435f0, _PlanarNM_6c8b686076db2a8c8b7d6cd91cf435f0_XZ_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Split_31874fa1d55cb28e99a1333cf254676a_R_1 = _PlanarNM_6c8b686076db2a8c8b7d6cd91cf435f0_XZ_2[0];
            float _Split_31874fa1d55cb28e99a1333cf254676a_G_2 = _PlanarNM_6c8b686076db2a8c8b7d6cd91cf435f0_XZ_2[1];
            float _Split_31874fa1d55cb28e99a1333cf254676a_B_3 = _PlanarNM_6c8b686076db2a8c8b7d6cd91cf435f0_XZ_2[2];
            float _Split_31874fa1d55cb28e99a1333cf254676a_A_4 = _PlanarNM_6c8b686076db2a8c8b7d6cd91cf435f0_XZ_2[3];
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_881c341218ea2d81819695b0c7ddc4cb_Out_0 = _AlphaCutoff;
            #endif
            surface.Alpha = _Split_31874fa1d55cb28e99a1333cf254676a_A_4;
            surface.AlphaClipThreshold = _Property_881c341218ea2d81819695b0c7ddc4cb_Out_0;
            return surface;
        }

            // --------------------------------------------------
            // Build Graph Inputs

            VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.ObjectSpaceNormal =           input.normalOS;
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.ObjectSpaceTangent =          input.tangentOS.xyz;
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.ObjectSpacePosition =         input.positionOS;
        #endif


            return output;
        }
            SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);





        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.AbsoluteWorldSpacePosition =  GetAbsolutePositionWS(input.positionWS);
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.uv0 =                         input.texCoord0;
        #endif

        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN

            return output;
        }

            // --------------------------------------------------
            // Main

            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/DepthOnlyPass.hlsl"

            ENDHLSL
        }
        Pass
        {
            Name "DepthNormals"
            Tags
            {
                "LightMode" = "DepthNormals"
            }

            // Render State
            Cull Back
        Blend One Zero
        ZTest LEqual
        ZWrite On

            // Debug
            // <None>

            // --------------------------------------------------
            // Pass

            HLSLPROGRAM

            // Pragmas
            #pragma target 4.5
        #pragma exclude_renderers gles gles3 glcore
        #pragma multi_compile_instancing
        #pragma multi_compile _ DOTS_INSTANCING_ON
        #pragma vertex vert
        #pragma fragment frag

            // DotsInstancingOptions: <None>
            // HybridV1InjectedBuiltinProperties: <None>

            // Keywords
            // PassKeywords: <None>
            #pragma shader_feature_local _ _USEDYNAMICCOVERTSTATICMASKF_ON

        #if defined(_USEDYNAMICCOVERTSTATICMASKF_ON)
            #define KEYWORD_PERMUTATION_0
        #else
            #define KEYWORD_PERMUTATION_1
        #endif


            // Defines
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define _AlphaClip 1
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define _NORMALMAP 1
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define _NORMAL_DROPOFF_TS 1
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define ATTRIBUTES_NEED_NORMAL
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define ATTRIBUTES_NEED_TANGENT
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define ATTRIBUTES_NEED_TEXCOORD0
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define ATTRIBUTES_NEED_TEXCOORD1
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define ATTRIBUTES_NEED_COLOR
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define VARYINGS_NEED_POSITION_WS
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define VARYINGS_NEED_NORMAL_WS
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define VARYINGS_NEED_TANGENT_WS
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define VARYINGS_NEED_TEXCOORD0
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define VARYINGS_NEED_COLOR
        #endif

            #define FEATURES_GRAPH_VERTEX
            /* WARNING: $splice Could not find named fragment 'PassInstancing' */
            #define SHADERPASS SHADERPASS_DEPTHNORMALSONLY
            /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */

            // Includes
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"

            // --------------------------------------------------
            // Structs and Packing

            struct Attributes
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 positionOS : POSITION;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 normalOS : NORMAL;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 tangentOS : TANGENT;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 uv0 : TEXCOORD0;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 uv1 : TEXCOORD1;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 color : COLOR;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            uint instanceID : INSTANCEID_SEMANTIC;
            #endif
            #endif
        };
        struct Varyings
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 positionCS : SV_POSITION;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 positionWS;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 normalWS;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 tangentWS;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 texCoord0;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 color;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
            #endif
        };
        struct SurfaceDescriptionInputs
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 WorldSpaceNormal;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 TangentSpaceNormal;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 WorldSpaceTangent;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 WorldSpaceBiTangent;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 AbsoluteWorldSpacePosition;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 uv0;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 VertexColor;
            #endif
        };
        struct VertexDescriptionInputs
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 ObjectSpaceNormal;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 ObjectSpaceTangent;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 ObjectSpacePosition;
            #endif
        };
        struct PackedVaryings
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 positionCS : SV_POSITION;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 interp0 : TEXCOORD0;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 interp1 : TEXCOORD1;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 interp2 : TEXCOORD2;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 interp3 : TEXCOORD3;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 interp4 : TEXCOORD4;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
            #endif
        };

            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            output.positionCS = input.positionCS;
            output.interp0.xyz =  input.positionWS;
            output.interp1.xyz =  input.normalWS;
            output.interp2.xyzw =  input.tangentWS;
            output.interp3.xyzw =  input.texCoord0;
            output.interp4.xyzw =  input.color;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.positionWS = input.interp0.xyz;
            output.normalWS = input.interp1.xyz;
            output.tangentWS = input.interp2.xyzw;
            output.texCoord0 = input.interp3.xyzw;
            output.color = input.interp4.xyzw;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        #endif

            // --------------------------------------------------
            // Graph

            // Graph Properties
            CBUFFER_START(UnityPerMaterial)
        float _AlphaCutoff;
        float4 _BaseColor;
        float4 _BaseColorMap_TexelSize;
        float _BaseUsePlanarUV;
        float4 _BaseTilingOffset;
        float4 _BaseNormalMap_TexelSize;
        float _BaseNormalScale;
        float4 _BaseMaskMap_TexelSize;
        float _BaseMetallic;
        float _BaseAORemapMin;
        float _BaseAORemapMax;
        float _BaseSmoothnessRemapMin;
        float _BaseSmoothnessRemapMax;
        float4 _CoverMaskA_TexelSize;
        float _CoverMaskPower;
        float _Cover_Amount;
        float _Cover_Amount_Grow_Speed;
        float _Cover_Max_Angle;
        float _Cover_Min_Height;
        float _Cover_Min_Height_Blending;
        float4 _CoverBaseColor;
        float4 _CoverBaseColorMap_TexelSize;
        float _CoverUsePlanarUV;
        float4 _CoverTilingOffset;
        float4 _CoverNormalMap_TexelSize;
        float _CoverNormalScale;
        float _CoverNormalBlendHardness;
        float _CoverHardness;
        float _CoverHeightMapMin;
        float _CoverHeightMapMax;
        float _CoverHeightMapOffset;
        float4 _CoverMaskMap_TexelSize;
        float _CoverMetallic;
        float _CoverAORemapMin;
        float _CoverAORemapMax;
        float _CoverSmoothnessRemapMin;
        float _CoverSmoothnessRemapMax;
        float4 _DetailMap_TexelSize;
        float4 _DetailTilingOffset;
        float _DetailAlbedoScale;
        float _DetailNormalScale;
        float _DetailSmoothnessScale;
        float4 _WetColor;
        float _WetSmoothness;
        CBUFFER_END

        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_BaseColorMap);
        SAMPLER(sampler_BaseColorMap);
        TEXTURE2D(_BaseNormalMap);
        SAMPLER(sampler_BaseNormalMap);
        TEXTURE2D(_BaseMaskMap);
        SAMPLER(sampler_BaseMaskMap);
        TEXTURE2D(_CoverMaskA);
        SAMPLER(sampler_CoverMaskA);
        TEXTURE2D(_CoverBaseColorMap);
        SAMPLER(sampler_CoverBaseColorMap);
        TEXTURE2D(_CoverNormalMap);
        SAMPLER(sampler_CoverNormalMap);
        TEXTURE2D(_CoverMaskMap);
        SAMPLER(sampler_CoverMaskMap);
        TEXTURE2D(_DetailMap);
        SAMPLER(sampler_DetailMap);

            // Graph Functions
            
        // f948cdce565a6e706cc57cb23fbf9d95
        #include "./NM_Object_VSPro_Indirect.cginc"

        void AddPragma_float(float3 A, out float3 Out){
            #pragma instancing_options renderinglayer procedural:setupVSPro
            Out = A;
        }

        struct Bindings_NMObjectVSProIndirect_0cfe1e4f145944241ab304331e53c93b
        {
        };

        void SG_NMObjectVSProIndirect_0cfe1e4f145944241ab304331e53c93b(float3 Vector3_314C8600, Bindings_NMObjectVSProIndirect_0cfe1e4f145944241ab304331e53c93b IN, out float3 ObjectSpacePosition_1)
        {
            float3 _Property_5ec158abd968858c9d31ab40df5e9e6f_Out_0 = Vector3_314C8600;
            float3 _InjectSetupCustomFunction_dec9b26544b4a788b8ecb4117dc3d24a_Out_1;
            InjectSetup_float(_Property_5ec158abd968858c9d31ab40df5e9e6f_Out_0, _InjectSetupCustomFunction_dec9b26544b4a788b8ecb4117dc3d24a_Out_1);
            float3 _AddPragmaCustomFunction_b2a053178906d0848480a1f463521a1b_Out_1;
            AddPragma_float(_InjectSetupCustomFunction_dec9b26544b4a788b8ecb4117dc3d24a_Out_1, _AddPragmaCustomFunction_b2a053178906d0848480a1f463521a1b_Out_1);
            ObjectSpacePosition_1 = _AddPragmaCustomFunction_b2a053178906d0848480a1f463521a1b_Out_1;
        }

        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }

        void Unity_Multiply_float(float2 A, float2 B, out float2 Out)
        {
            Out = A * B;
        }

        void Unity_Add_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A + B;
        }

        void Unity_DotProduct_float2(float2 A, float2 B, out float Out)
        {
            Out = dot(A, B);
        }

        void Unity_Saturate_float(float In, out float Out)
        {
            Out = saturate(In);
        }

        void Unity_OneMinus_float(float In, out float Out)
        {
            Out = 1 - In;
        }

        void Unity_SquareRoot_float(float In, out float Out)
        {
            Out = sqrt(In);
        }

        void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
        {
            RGBA = float4(R, G, B, A);
            RGB = float3(R, G, B);
            RG = float2(R, G);
        }

        void Unity_Divide_float(float A, float B, out float Out)
        {
            Out = A / B;
        }

        void Unity_Multiply_float(float4 A, float4 B, out float4 Out)
        {
            Out = A * B;
        }

        void Unity_Branch_float2(float Predicate, float2 True, float2 False, out float2 Out)
        {
            Out = Predicate ? True : False;
        }

        void Unity_Sign_float3(float3 In, out float3 Out)
        {
            Out = sign(In);
        }

        void Unity_Multiply_float(float A, float B, out float Out)
        {
            Out = A * B;
        }

        void Unity_Normalize_float3(float3 In, out float3 Out)
        {
            Out = normalize(In);
        }

        void Unity_Branch_float3(float Predicate, float3 True, float3 False, out float3 Out)
        {
            Out = Predicate ? True : False;
        }

        struct Bindings_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8
        {
            float3 WorldSpaceNormal;
            float3 WorldSpaceTangent;
            float3 WorldSpaceBiTangent;
            float3 AbsoluteWorldSpacePosition;
            half4 uv0;
        };

        void SG_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8(UnityTexture2D Texture2D_80A3D28F, float4 Vector4_82674548, float Boolean_9FF42DF6, Bindings_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8 IN, out float4 XZ_2)
        {
            float _Property_1ef12cf3201a938993fe6a7951b0e754_Out_0 = Boolean_9FF42DF6;
            UnityTexture2D _Property_3e01b4d2fc68d48ba3acbba9d5881e59_Out_0 = Texture2D_80A3D28F;
            float _Split_89ed63cb625cb3878c183d0b71c03400_R_1 = IN.AbsoluteWorldSpacePosition[0];
            float _Split_89ed63cb625cb3878c183d0b71c03400_G_2 = IN.AbsoluteWorldSpacePosition[1];
            float _Split_89ed63cb625cb3878c183d0b71c03400_B_3 = IN.AbsoluteWorldSpacePosition[2];
            float _Split_89ed63cb625cb3878c183d0b71c03400_A_4 = 0;
            float4 _Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4;
            float3 _Combine_cf2d04ff119ad88493f6460431765cbb_RGB_5;
            float2 _Combine_cf2d04ff119ad88493f6460431765cbb_RG_6;
            Unity_Combine_float(_Split_89ed63cb625cb3878c183d0b71c03400_R_1, _Split_89ed63cb625cb3878c183d0b71c03400_B_3, 0, 0, _Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4, _Combine_cf2d04ff119ad88493f6460431765cbb_RGB_5, _Combine_cf2d04ff119ad88493f6460431765cbb_RG_6);
            float4 _Property_3fa1d6f912feb481ba60f2e55e62e746_Out_0 = Vector4_82674548;
            float _Split_a2e12fa5931da084b2949343a539dfd8_R_1 = _Property_3fa1d6f912feb481ba60f2e55e62e746_Out_0[0];
            float _Split_a2e12fa5931da084b2949343a539dfd8_G_2 = _Property_3fa1d6f912feb481ba60f2e55e62e746_Out_0[1];
            float _Split_a2e12fa5931da084b2949343a539dfd8_B_3 = _Property_3fa1d6f912feb481ba60f2e55e62e746_Out_0[2];
            float _Split_a2e12fa5931da084b2949343a539dfd8_A_4 = _Property_3fa1d6f912feb481ba60f2e55e62e746_Out_0[3];
            float _Divide_c36b770dfaa0bb8f85ab27da5fd794f0_Out_2;
            Unity_Divide_float(1, _Split_a2e12fa5931da084b2949343a539dfd8_R_1, _Divide_c36b770dfaa0bb8f85ab27da5fd794f0_Out_2);
            float4 _Multiply_14cec4902d0a00829e4555071a1b8ad1_Out_2;
            Unity_Multiply_float(_Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4, (_Divide_c36b770dfaa0bb8f85ab27da5fd794f0_Out_2.xxxx), _Multiply_14cec4902d0a00829e4555071a1b8ad1_Out_2);
            float2 _Vector2_6845d21872714d889783b0cb707df3e9_Out_0 = float2(_Split_a2e12fa5931da084b2949343a539dfd8_R_1, _Split_a2e12fa5931da084b2949343a539dfd8_G_2);
            float2 _Vector2_e2e2263627c6098e96a5b5d29350ad03_Out_0 = float2(_Split_a2e12fa5931da084b2949343a539dfd8_B_3, _Split_a2e12fa5931da084b2949343a539dfd8_A_4);
            float2 _TilingAndOffset_17582d056c0b8a8dab1017d37497fe59_Out_3;
            Unity_TilingAndOffset_float(IN.uv0.xy, _Vector2_6845d21872714d889783b0cb707df3e9_Out_0, _Vector2_e2e2263627c6098e96a5b5d29350ad03_Out_0, _TilingAndOffset_17582d056c0b8a8dab1017d37497fe59_Out_3);
            float2 _Branch_1e152f3aac57448f8518bf2852c000c3_Out_3;
            Unity_Branch_float2(_Property_1ef12cf3201a938993fe6a7951b0e754_Out_0, (_Multiply_14cec4902d0a00829e4555071a1b8ad1_Out_2.xy), _TilingAndOffset_17582d056c0b8a8dab1017d37497fe59_Out_3, _Branch_1e152f3aac57448f8518bf2852c000c3_Out_3);
            float4 _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0 = SAMPLE_TEXTURE2D(_Property_3e01b4d2fc68d48ba3acbba9d5881e59_Out_0.tex, _Property_3e01b4d2fc68d48ba3acbba9d5881e59_Out_0.samplerstate, _Branch_1e152f3aac57448f8518bf2852c000c3_Out_3);
            _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0.rgb = UnpackNormal(_SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0);
            float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_R_4 = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0.r;
            float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_G_5 = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0.g;
            float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_B_6 = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0.b;
            float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_A_7 = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0.a;
            float2 _Vector2_ad6bd100e273d78fa409a30a77bfa2cc_Out_0 = float2(_SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_R_4, _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_G_5);
            float3 _Sign_3a6ebf59931cf08cb0482e0144ddac24_Out_1;
            Unity_Sign_float3(IN.WorldSpaceNormal, _Sign_3a6ebf59931cf08cb0482e0144ddac24_Out_1);
            float _Split_6299d4ddcc4c74828aea40a46fdb896e_R_1 = _Sign_3a6ebf59931cf08cb0482e0144ddac24_Out_1[0];
            float _Split_6299d4ddcc4c74828aea40a46fdb896e_G_2 = _Sign_3a6ebf59931cf08cb0482e0144ddac24_Out_1[1];
            float _Split_6299d4ddcc4c74828aea40a46fdb896e_B_3 = _Sign_3a6ebf59931cf08cb0482e0144ddac24_Out_1[2];
            float _Split_6299d4ddcc4c74828aea40a46fdb896e_A_4 = 0;
            float2 _Vector2_b76cb1842101e58b9e636d49b075c612_Out_0 = float2(_Split_6299d4ddcc4c74828aea40a46fdb896e_G_2, 1);
            float2 _Multiply_31e8db88ee20c985a9850d1a58f3282b_Out_2;
            Unity_Multiply_float(_Vector2_ad6bd100e273d78fa409a30a77bfa2cc_Out_0, _Vector2_b76cb1842101e58b9e636d49b075c612_Out_0, _Multiply_31e8db88ee20c985a9850d1a58f3282b_Out_2);
            float _Split_5ed44bf2eca0868f81eb18100f49d1fa_R_1 = IN.WorldSpaceNormal[0];
            float _Split_5ed44bf2eca0868f81eb18100f49d1fa_G_2 = IN.WorldSpaceNormal[1];
            float _Split_5ed44bf2eca0868f81eb18100f49d1fa_B_3 = IN.WorldSpaceNormal[2];
            float _Split_5ed44bf2eca0868f81eb18100f49d1fa_A_4 = 0;
            float2 _Vector2_70e5837843f28b8b9d64cada3697bd5a_Out_0 = float2(_Split_5ed44bf2eca0868f81eb18100f49d1fa_R_1, _Split_5ed44bf2eca0868f81eb18100f49d1fa_B_3);
            float2 _Add_1145b2f896593d80aa864a34e6702562_Out_2;
            Unity_Add_float2(_Multiply_31e8db88ee20c985a9850d1a58f3282b_Out_2, _Vector2_70e5837843f28b8b9d64cada3697bd5a_Out_0, _Add_1145b2f896593d80aa864a34e6702562_Out_2);
            float _Split_2bc77ca2d17bd78cb2383770ce50b179_R_1 = _Add_1145b2f896593d80aa864a34e6702562_Out_2[0];
            float _Split_2bc77ca2d17bd78cb2383770ce50b179_G_2 = _Add_1145b2f896593d80aa864a34e6702562_Out_2[1];
            float _Split_2bc77ca2d17bd78cb2383770ce50b179_B_3 = 0;
            float _Split_2bc77ca2d17bd78cb2383770ce50b179_A_4 = 0;
            float _Multiply_ab12aea87465a78eaf7fc66c2598d266_Out_2;
            Unity_Multiply_float(_SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_B_6, _Split_5ed44bf2eca0868f81eb18100f49d1fa_G_2, _Multiply_ab12aea87465a78eaf7fc66c2598d266_Out_2);
            float3 _Vector3_433840b555db308b97e9b14b6a957195_Out_0 = float3(_Split_2bc77ca2d17bd78cb2383770ce50b179_R_1, _Multiply_ab12aea87465a78eaf7fc66c2598d266_Out_2, _Split_2bc77ca2d17bd78cb2383770ce50b179_G_2);
            float3x3 Transform_c7914cc45a011c89b3f53c55afb51673_tangentTransform_World = float3x3(IN.WorldSpaceTangent, IN.WorldSpaceBiTangent, IN.WorldSpaceNormal);
            float3 _Transform_c7914cc45a011c89b3f53c55afb51673_Out_1 = TransformWorldToTangent(_Vector3_433840b555db308b97e9b14b6a957195_Out_0.xyz, Transform_c7914cc45a011c89b3f53c55afb51673_tangentTransform_World);
            float3 _Normalize_09bf8a2bd0a4d38e8b97d5c674f79b44_Out_1;
            Unity_Normalize_float3(_Transform_c7914cc45a011c89b3f53c55afb51673_Out_1, _Normalize_09bf8a2bd0a4d38e8b97d5c674f79b44_Out_1);
            float3 _Branch_9eadf909a90f2f80880f8c56ecc2a91f_Out_3;
            Unity_Branch_float3(_Property_1ef12cf3201a938993fe6a7951b0e754_Out_0, _Normalize_09bf8a2bd0a4d38e8b97d5c674f79b44_Out_1, (_SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0.xyz), _Branch_9eadf909a90f2f80880f8c56ecc2a91f_Out_3);
            XZ_2 = (float4(_Branch_9eadf909a90f2f80880f8c56ecc2a91f_Out_3, 1.0));
        }

        void Unity_NormalStrength_float(float3 In, float Strength, out float3 Out)
        {
            Out = float3(In.rg * Strength, lerp(1, In.b, saturate(Strength)));
        }

        void Unity_NormalBlend_float(float3 A, float3 B, out float3 Out)
        {
            Out = SafeNormalize(float3(A.rg + B.rg, A.b * B.b));
        }

        void Unity_Clamp_float(float In, float Min, float Max, out float Out)
        {
            Out = clamp(In, Min, Max);
        }

        void Unity_Subtract_float(float A, float B, out float Out)
        {
            Out = A - B;
        }

        void Unity_Absolute_float(float In, out float Out)
        {
            Out = abs(In);
        }

        void Unity_Power_float(float A, float B, out float Out)
        {
            Out = pow(A, B);
        }

        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
        }

        void Unity_Lerp_float3(float3 A, float3 B, float3 T, out float3 Out)
        {
            Out = lerp(A, B, T);
        }

        struct Bindings_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6
        {
            float3 AbsoluteWorldSpacePosition;
            half4 uv0;
        };

        void SG_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6(UnityTexture2D Texture2D_80A3D28F, float4 Vector4_2EBA7A3B, float Boolean_7ABB9909, Bindings_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6 IN, out float4 XZ_2)
        {
            UnityTexture2D _Property_3e01b4d2fc68d48ba3acbba9d5881e59_Out_0 = Texture2D_80A3D28F;
            float _Property_30834f691775a0898a45b1c868520436_Out_0 = Boolean_7ABB9909;
            float _Split_89ed63cb625cb3878c183d0b71c03400_R_1 = IN.AbsoluteWorldSpacePosition[0];
            float _Split_89ed63cb625cb3878c183d0b71c03400_G_2 = IN.AbsoluteWorldSpacePosition[1];
            float _Split_89ed63cb625cb3878c183d0b71c03400_B_3 = IN.AbsoluteWorldSpacePosition[2];
            float _Split_89ed63cb625cb3878c183d0b71c03400_A_4 = 0;
            float4 _Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4;
            float3 _Combine_cf2d04ff119ad88493f6460431765cbb_RGB_5;
            float2 _Combine_cf2d04ff119ad88493f6460431765cbb_RG_6;
            Unity_Combine_float(_Split_89ed63cb625cb3878c183d0b71c03400_R_1, _Split_89ed63cb625cb3878c183d0b71c03400_B_3, 0, 0, _Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4, _Combine_cf2d04ff119ad88493f6460431765cbb_RGB_5, _Combine_cf2d04ff119ad88493f6460431765cbb_RG_6);
            float4 _Property_8a66888ec47d0687ab1cb2f8abdc9da8_Out_0 = Vector4_2EBA7A3B;
            float _Split_2f0f52f6ef8c0e81af0da6476402bc1f_R_1 = _Property_8a66888ec47d0687ab1cb2f8abdc9da8_Out_0[0];
            float _Split_2f0f52f6ef8c0e81af0da6476402bc1f_G_2 = _Property_8a66888ec47d0687ab1cb2f8abdc9da8_Out_0[1];
            float _Split_2f0f52f6ef8c0e81af0da6476402bc1f_B_3 = _Property_8a66888ec47d0687ab1cb2f8abdc9da8_Out_0[2];
            float _Split_2f0f52f6ef8c0e81af0da6476402bc1f_A_4 = _Property_8a66888ec47d0687ab1cb2f8abdc9da8_Out_0[3];
            float _Divide_e64179199923c58289b6aa94ea6c9178_Out_2;
            Unity_Divide_float(1, _Split_2f0f52f6ef8c0e81af0da6476402bc1f_R_1, _Divide_e64179199923c58289b6aa94ea6c9178_Out_2);
            float4 _Multiply_14cec4902d0a00829e4555071a1b8ad1_Out_2;
            Unity_Multiply_float(_Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4, (_Divide_e64179199923c58289b6aa94ea6c9178_Out_2.xxxx), _Multiply_14cec4902d0a00829e4555071a1b8ad1_Out_2);
            float2 _Vector2_16c15d3bbdd14b85bd48e3a6cb318af7_Out_0 = float2(_Split_2f0f52f6ef8c0e81af0da6476402bc1f_R_1, _Split_2f0f52f6ef8c0e81af0da6476402bc1f_G_2);
            float2 _Vector2_f8d75f54e7705083bbec539a60185577_Out_0 = float2(_Split_2f0f52f6ef8c0e81af0da6476402bc1f_B_3, _Split_2f0f52f6ef8c0e81af0da6476402bc1f_A_4);
            float2 _TilingAndOffset_d91e2d25acd34686b562b7fe7e9d1d27_Out_3;
            Unity_TilingAndOffset_float(IN.uv0.xy, _Vector2_16c15d3bbdd14b85bd48e3a6cb318af7_Out_0, _Vector2_f8d75f54e7705083bbec539a60185577_Out_0, _TilingAndOffset_d91e2d25acd34686b562b7fe7e9d1d27_Out_3);
            float2 _Branch_8e5a4e8f4d52fc8aadd1f46485afc933_Out_3;
            Unity_Branch_float2(_Property_30834f691775a0898a45b1c868520436_Out_0, (_Multiply_14cec4902d0a00829e4555071a1b8ad1_Out_2.xy), _TilingAndOffset_d91e2d25acd34686b562b7fe7e9d1d27_Out_3, _Branch_8e5a4e8f4d52fc8aadd1f46485afc933_Out_3);
            float4 _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0 = SAMPLE_TEXTURE2D(_Property_3e01b4d2fc68d48ba3acbba9d5881e59_Out_0.tex, _Property_3e01b4d2fc68d48ba3acbba9d5881e59_Out_0.samplerstate, _Branch_8e5a4e8f4d52fc8aadd1f46485afc933_Out_3);
            float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_R_4 = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0.r;
            float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_G_5 = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0.g;
            float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_B_6 = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0.b;
            float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_A_7 = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0.a;
            XZ_2 = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0;
        }

        void Unity_Remap_float(float In, float2 InMinMax, float2 OutMinMax, out float Out)
        {
            Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
        }

            // Graph Vertex
            struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };

        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            Bindings_NMObjectVSProIndirect_0cfe1e4f145944241ab304331e53c93b _NMObjectVSProIndirect_adbe93754e069e8e87df45ef6e4b343e;
            float3 _NMObjectVSProIndirect_adbe93754e069e8e87df45ef6e4b343e_ObjectSpacePosition_1;
            SG_NMObjectVSProIndirect_0cfe1e4f145944241ab304331e53c93b(IN.ObjectSpacePosition, _NMObjectVSProIndirect_adbe93754e069e8e87df45ef6e4b343e, _NMObjectVSProIndirect_adbe93754e069e8e87df45ef6e4b343e_ObjectSpacePosition_1);
            #endif
            description.Position = _NMObjectVSProIndirect_adbe93754e069e8e87df45ef6e4b343e_ObjectSpacePosition_1;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }

            // Graph Pixel
            struct SurfaceDescription
        {
            float3 NormalTS;
            float Alpha;
            float AlphaClipThreshold;
        };

        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            UnityTexture2D _Property_b561c414493a8f8299227a27e437f045_Out_0 = UnityBuildTexture2DStructNoScale(_DetailMap);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 _Property_70f1cc2b73af738d80b0d405e4bed8c5_Out_0 = _DetailTilingOffset;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Split_cda27505033cfc8eaf60fe914f0949b9_R_1 = _Property_70f1cc2b73af738d80b0d405e4bed8c5_Out_0[0];
            float _Split_cda27505033cfc8eaf60fe914f0949b9_G_2 = _Property_70f1cc2b73af738d80b0d405e4bed8c5_Out_0[1];
            float _Split_cda27505033cfc8eaf60fe914f0949b9_B_3 = _Property_70f1cc2b73af738d80b0d405e4bed8c5_Out_0[2];
            float _Split_cda27505033cfc8eaf60fe914f0949b9_A_4 = _Property_70f1cc2b73af738d80b0d405e4bed8c5_Out_0[3];
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float2 _Vector2_42d7e955009b6f8cb4d913530ff92840_Out_0 = float2(_Split_cda27505033cfc8eaf60fe914f0949b9_R_1, _Split_cda27505033cfc8eaf60fe914f0949b9_G_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float2 _Vector2_5452a0299d10b280aec51f7407d4d2ac_Out_0 = float2(_Split_cda27505033cfc8eaf60fe914f0949b9_B_3, _Split_cda27505033cfc8eaf60fe914f0949b9_A_4);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float2 _TilingAndOffset_e1c5b97bd253ca8f9f3d26f598e6d7fd_Out_3;
            Unity_TilingAndOffset_float(IN.uv0.xy, _Vector2_42d7e955009b6f8cb4d913530ff92840_Out_0, _Vector2_5452a0299d10b280aec51f7407d4d2ac_Out_0, _TilingAndOffset_e1c5b97bd253ca8f9f3d26f598e6d7fd_Out_3);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 _SampleTexture2D_fa4ac40fc922b9869e37c06690c0f530_RGBA_0 = SAMPLE_TEXTURE2D(_Property_b561c414493a8f8299227a27e437f045_Out_0.tex, _Property_b561c414493a8f8299227a27e437f045_Out_0.samplerstate, _TilingAndOffset_e1c5b97bd253ca8f9f3d26f598e6d7fd_Out_3);
            float _SampleTexture2D_fa4ac40fc922b9869e37c06690c0f530_R_4 = _SampleTexture2D_fa4ac40fc922b9869e37c06690c0f530_RGBA_0.r;
            float _SampleTexture2D_fa4ac40fc922b9869e37c06690c0f530_G_5 = _SampleTexture2D_fa4ac40fc922b9869e37c06690c0f530_RGBA_0.g;
            float _SampleTexture2D_fa4ac40fc922b9869e37c06690c0f530_B_6 = _SampleTexture2D_fa4ac40fc922b9869e37c06690c0f530_RGBA_0.b;
            float _SampleTexture2D_fa4ac40fc922b9869e37c06690c0f530_A_7 = _SampleTexture2D_fa4ac40fc922b9869e37c06690c0f530_RGBA_0.a;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float2 _Vector2_65060e9a9f687a89b68e32dc876be645_Out_0 = float2(_SampleTexture2D_fa4ac40fc922b9869e37c06690c0f530_A_7, _SampleTexture2D_fa4ac40fc922b9869e37c06690c0f530_G_5);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float2 _Multiply_5d4c3baed6515c8b86a289c70fca8f5d_Out_2;
            Unity_Multiply_float(_Vector2_65060e9a9f687a89b68e32dc876be645_Out_0, float2(2, 2), _Multiply_5d4c3baed6515c8b86a289c70fca8f5d_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float2 _Add_98b310e19c5fa5899c39cc45969c15ea_Out_2;
            Unity_Add_float2(_Multiply_5d4c3baed6515c8b86a289c70fca8f5d_Out_2, float2(-1, -1), _Add_98b310e19c5fa5899c39cc45969c15ea_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_08b99582093b36869beb5ea3d18e765d_Out_0 = _DetailNormalScale;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float2 _Multiply_bf0b80fdb3271784900e5b5ea4c5550f_Out_2;
            Unity_Multiply_float(_Add_98b310e19c5fa5899c39cc45969c15ea_Out_2, (_Property_08b99582093b36869beb5ea3d18e765d_Out_0.xx), _Multiply_bf0b80fdb3271784900e5b5ea4c5550f_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Split_26c1e73f8436c78ebdae5b51365a072b_R_1 = _Multiply_bf0b80fdb3271784900e5b5ea4c5550f_Out_2[0];
            float _Split_26c1e73f8436c78ebdae5b51365a072b_G_2 = _Multiply_bf0b80fdb3271784900e5b5ea4c5550f_Out_2[1];
            float _Split_26c1e73f8436c78ebdae5b51365a072b_B_3 = 0;
            float _Split_26c1e73f8436c78ebdae5b51365a072b_A_4 = 0;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _DotProduct_50aca3ce0da1ad849d7ff4a99df3a322_Out_2;
            Unity_DotProduct_float2(_Multiply_bf0b80fdb3271784900e5b5ea4c5550f_Out_2, _Multiply_bf0b80fdb3271784900e5b5ea4c5550f_Out_2, _DotProduct_50aca3ce0da1ad849d7ff4a99df3a322_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Saturate_491f2ee8417b8782aee83358b89eeb08_Out_1;
            Unity_Saturate_float(_DotProduct_50aca3ce0da1ad849d7ff4a99df3a322_Out_2, _Saturate_491f2ee8417b8782aee83358b89eeb08_Out_1);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _OneMinus_46ad3170d736808d98bf74ffa45e0414_Out_1;
            Unity_OneMinus_float(_Saturate_491f2ee8417b8782aee83358b89eeb08_Out_1, _OneMinus_46ad3170d736808d98bf74ffa45e0414_Out_1);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _SquareRoot_dfeae899ebfeae8f9257c340ca22ce38_Out_1;
            Unity_SquareRoot_float(_OneMinus_46ad3170d736808d98bf74ffa45e0414_Out_1, _SquareRoot_dfeae899ebfeae8f9257c340ca22ce38_Out_1);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 _Vector3_ed3f80ed87524e8c99f98b224af5a610_Out_0 = float3(_Split_26c1e73f8436c78ebdae5b51365a072b_R_1, _Split_26c1e73f8436c78ebdae5b51365a072b_G_2, _SquareRoot_dfeae899ebfeae8f9257c340ca22ce38_Out_1);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            UnityTexture2D _Property_2cc39234d3d334899f94126a216a50fc_Out_0 = UnityBuildTexture2DStructNoScale(_BaseNormalMap);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 _Property_115fcc827510f38798b214d835c27637_Out_0 = _BaseTilingOffset;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_d83b8f290862b285bbe2f157190e1315_Out_0 = _BaseUsePlanarUV;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            Bindings_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8 _PlanarNMn_4fde70f39e45398dbb9972941e88e2bf;
            _PlanarNMn_4fde70f39e45398dbb9972941e88e2bf.WorldSpaceNormal = IN.WorldSpaceNormal;
            _PlanarNMn_4fde70f39e45398dbb9972941e88e2bf.WorldSpaceTangent = IN.WorldSpaceTangent;
            _PlanarNMn_4fde70f39e45398dbb9972941e88e2bf.WorldSpaceBiTangent = IN.WorldSpaceBiTangent;
            _PlanarNMn_4fde70f39e45398dbb9972941e88e2bf.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            _PlanarNMn_4fde70f39e45398dbb9972941e88e2bf.uv0 = IN.uv0;
            float4 _PlanarNMn_4fde70f39e45398dbb9972941e88e2bf_XZ_2;
            SG_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8(_Property_2cc39234d3d334899f94126a216a50fc_Out_0, _Property_115fcc827510f38798b214d835c27637_Out_0, _Property_d83b8f290862b285bbe2f157190e1315_Out_0, _PlanarNMn_4fde70f39e45398dbb9972941e88e2bf, _PlanarNMn_4fde70f39e45398dbb9972941e88e2bf_XZ_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_020d569f63e9a2849e23988ff74eb005_Out_0 = _BaseNormalScale;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 _NormalStrength_0c71fb166ae841839a0a12ecc5afa6fe_Out_2;
            Unity_NormalStrength_float((_PlanarNMn_4fde70f39e45398dbb9972941e88e2bf_XZ_2.xyz), _Property_020d569f63e9a2849e23988ff74eb005_Out_0, _NormalStrength_0c71fb166ae841839a0a12ecc5afa6fe_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 _NormalBlend_be36dd49bea74c8f8dd52fa3a85a9534_Out_2;
            Unity_NormalBlend_float(_Vector3_ed3f80ed87524e8c99f98b224af5a610_Out_0, _NormalStrength_0c71fb166ae841839a0a12ecc5afa6fe_Out_2, _NormalBlend_be36dd49bea74c8f8dd52fa3a85a9534_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            UnityTexture2D _Property_a383045772822c87acd099bb4cd6c478_Out_0 = UnityBuildTexture2DStructNoScale(_CoverNormalMap);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 _Property_e35c79b8cccfbe8ca0a3c33e8d32e319_Out_0 = _CoverTilingOffset;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_e3d8b38b51331e879b1d4012d65f53e6_Out_0 = _CoverUsePlanarUV;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            Bindings_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8 _PlanarNMn_79abde32a0223a89907c9f09efac8db7;
            _PlanarNMn_79abde32a0223a89907c9f09efac8db7.WorldSpaceNormal = IN.WorldSpaceNormal;
            _PlanarNMn_79abde32a0223a89907c9f09efac8db7.WorldSpaceTangent = IN.WorldSpaceTangent;
            _PlanarNMn_79abde32a0223a89907c9f09efac8db7.WorldSpaceBiTangent = IN.WorldSpaceBiTangent;
            _PlanarNMn_79abde32a0223a89907c9f09efac8db7.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            _PlanarNMn_79abde32a0223a89907c9f09efac8db7.uv0 = IN.uv0;
            float4 _PlanarNMn_79abde32a0223a89907c9f09efac8db7_XZ_2;
            SG_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8(_Property_a383045772822c87acd099bb4cd6c478_Out_0, _Property_e35c79b8cccfbe8ca0a3c33e8d32e319_Out_0, _Property_e3d8b38b51331e879b1d4012d65f53e6_Out_0, _PlanarNMn_79abde32a0223a89907c9f09efac8db7, _PlanarNMn_79abde32a0223a89907c9f09efac8db7_XZ_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_486692dad4d34a8c8410b4771efbf96b_Out_0 = _CoverNormalScale;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 _NormalStrength_d60a055f00d779808337e9d909827806_Out_2;
            Unity_NormalStrength_float((_PlanarNMn_79abde32a0223a89907c9f09efac8db7_XZ_2.xyz), _Property_486692dad4d34a8c8410b4771efbf96b_Out_0, _NormalStrength_d60a055f00d779808337e9d909827806_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            UnityTexture2D _Property_356186a26fec8686a13bc6b57fd8f3ee_Out_0 = UnityBuildTexture2DStructNoScale(_CoverMaskA);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 _UV_045cea9e82354980a778f44d92578382_Out_0 = IN.uv0;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 _SampleTexture2D_0eef6ae3dab6e185bd0f65edecd80314_RGBA_0 = SAMPLE_TEXTURE2D(_Property_356186a26fec8686a13bc6b57fd8f3ee_Out_0.tex, _Property_356186a26fec8686a13bc6b57fd8f3ee_Out_0.samplerstate, (_UV_045cea9e82354980a778f44d92578382_Out_0.xy));
            float _SampleTexture2D_0eef6ae3dab6e185bd0f65edecd80314_R_4 = _SampleTexture2D_0eef6ae3dab6e185bd0f65edecd80314_RGBA_0.r;
            float _SampleTexture2D_0eef6ae3dab6e185bd0f65edecd80314_G_5 = _SampleTexture2D_0eef6ae3dab6e185bd0f65edecd80314_RGBA_0.g;
            float _SampleTexture2D_0eef6ae3dab6e185bd0f65edecd80314_B_6 = _SampleTexture2D_0eef6ae3dab6e185bd0f65edecd80314_RGBA_0.b;
            float _SampleTexture2D_0eef6ae3dab6e185bd0f65edecd80314_A_7 = _SampleTexture2D_0eef6ae3dab6e185bd0f65edecd80314_RGBA_0.a;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_4e8240836843df81941cdf6cf2cdd638_Out_0 = _CoverMaskPower;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Multiply_8b5250e5dfc73a84a41399a13b83c0a1_Out_2;
            Unity_Multiply_float(_SampleTexture2D_0eef6ae3dab6e185bd0f65edecd80314_A_7, _Property_4e8240836843df81941cdf6cf2cdd638_Out_0, _Multiply_8b5250e5dfc73a84a41399a13b83c0a1_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Clamp_030a7c32684c258084338456eaddc77a_Out_3;
            Unity_Clamp_float(_Multiply_8b5250e5dfc73a84a41399a13b83c0a1_Out_2, 0, 1, _Clamp_030a7c32684c258084338456eaddc77a_Out_3);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Split_8ba5b67899f36b8f9dcf5c84092c0560_R_1 = IN.VertexColor[0];
            float _Split_8ba5b67899f36b8f9dcf5c84092c0560_G_2 = IN.VertexColor[1];
            float _Split_8ba5b67899f36b8f9dcf5c84092c0560_B_3 = IN.VertexColor[2];
            float _Split_8ba5b67899f36b8f9dcf5c84092c0560_A_4 = IN.VertexColor[3];
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_c688e246111fd881820a97415e14d8a3_Out_0 = _CoverNormalBlendHardness;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 _NormalStrength_0e5e0831ba0e98878220ca6021ea52a2_Out_2;
            Unity_NormalStrength_float((_PlanarNMn_79abde32a0223a89907c9f09efac8db7_XZ_2.xyz), _Property_c688e246111fd881820a97415e14d8a3_Out_0, _NormalStrength_0e5e0831ba0e98878220ca6021ea52a2_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Split_8cadce726725318fbacd47f436a8231d_R_1 = IN.WorldSpaceNormal[0];
            float _Split_8cadce726725318fbacd47f436a8231d_G_2 = IN.WorldSpaceNormal[1];
            float _Split_8cadce726725318fbacd47f436a8231d_B_3 = IN.WorldSpaceNormal[2];
            float _Split_8cadce726725318fbacd47f436a8231d_A_4 = 0;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_ce4e5954a0b7ff8c819fa53963327595_Out_0 = _Cover_Amount;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_384059e6344fb98a85eccad78dd82f36_Out_0 = _Cover_Amount_Grow_Speed;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Subtract_70fd06876db7fa85b0cc0bce8d926dff_Out_2;
            Unity_Subtract_float(4, _Property_384059e6344fb98a85eccad78dd82f36_Out_0, _Subtract_70fd06876db7fa85b0cc0bce8d926dff_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Divide_1a3a6334c3d8bc8f8ac262c7833e15d5_Out_2;
            Unity_Divide_float(_Property_ce4e5954a0b7ff8c819fa53963327595_Out_0, _Subtract_70fd06876db7fa85b0cc0bce8d926dff_Out_2, _Divide_1a3a6334c3d8bc8f8ac262c7833e15d5_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Absolute_f218d2b85ebf288f91234faffedb5f7b_Out_1;
            Unity_Absolute_float(_Divide_1a3a6334c3d8bc8f8ac262c7833e15d5_Out_2, _Absolute_f218d2b85ebf288f91234faffedb5f7b_Out_1);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Power_a9b8d4b65c44a98e9813f61c0e2dc0a3_Out_2;
            Unity_Power_float(_Absolute_f218d2b85ebf288f91234faffedb5f7b_Out_1, _Subtract_70fd06876db7fa85b0cc0bce8d926dff_Out_2, _Power_a9b8d4b65c44a98e9813f61c0e2dc0a3_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Clamp_95d579f83746cb82be79cf6739990e0b_Out_3;
            Unity_Clamp_float(_Power_a9b8d4b65c44a98e9813f61c0e2dc0a3_Out_2, 0, 2, _Clamp_95d579f83746cb82be79cf6739990e0b_Out_3);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Multiply_02a8aa0fa6974e81aa84caba54f63896_Out_2;
            Unity_Multiply_float(_Split_8cadce726725318fbacd47f436a8231d_G_2, _Clamp_95d579f83746cb82be79cf6739990e0b_Out_3, _Multiply_02a8aa0fa6974e81aa84caba54f63896_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Saturate_ada5e8f9ebdcb38d8f5e61e8d97424b9_Out_1;
            Unity_Saturate_float(_Multiply_02a8aa0fa6974e81aa84caba54f63896_Out_2, _Saturate_ada5e8f9ebdcb38d8f5e61e8d97424b9_Out_1);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Clamp_38bac9e8ef351789b5fd4f2201f1df7b_Out_3;
            Unity_Clamp_float(_Split_8cadce726725318fbacd47f436a8231d_G_2, 0, 0.9999, _Clamp_38bac9e8ef351789b5fd4f2201f1df7b_Out_3);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_9babc76177853482826cae0163ffe988_Out_0 = _Cover_Max_Angle;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Divide_3b22550205905d8da5870f9db56e44ff_Out_2;
            Unity_Divide_float(_Property_9babc76177853482826cae0163ffe988_Out_0, 45, _Divide_3b22550205905d8da5870f9db56e44ff_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _OneMinus_99a85b6952a41288afc86da0a6ca6ea0_Out_1;
            Unity_OneMinus_float(_Divide_3b22550205905d8da5870f9db56e44ff_Out_2, _OneMinus_99a85b6952a41288afc86da0a6ca6ea0_Out_1);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Subtract_2b63f3aaee26f686971dca1d28da283c_Out_2;
            Unity_Subtract_float(_Clamp_38bac9e8ef351789b5fd4f2201f1df7b_Out_3, _OneMinus_99a85b6952a41288afc86da0a6ca6ea0_Out_1, _Subtract_2b63f3aaee26f686971dca1d28da283c_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Clamp_6bd9bb4add91fe8eb80a958a6b1a2d01_Out_3;
            Unity_Clamp_float(_Subtract_2b63f3aaee26f686971dca1d28da283c_Out_2, 0, 2, _Clamp_6bd9bb4add91fe8eb80a958a6b1a2d01_Out_3);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Divide_a09d2d461b07e98999aba746fb52a3fc_Out_2;
            Unity_Divide_float(1, _Divide_3b22550205905d8da5870f9db56e44ff_Out_2, _Divide_a09d2d461b07e98999aba746fb52a3fc_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Multiply_89a8f5a279c73b898d4ca5d075786b53_Out_2;
            Unity_Multiply_float(_Clamp_6bd9bb4add91fe8eb80a958a6b1a2d01_Out_3, _Divide_a09d2d461b07e98999aba746fb52a3fc_Out_2, _Multiply_89a8f5a279c73b898d4ca5d075786b53_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Absolute_f98ce5feb185a68784b9b35eb71ec465_Out_1;
            Unity_Absolute_float(_Multiply_89a8f5a279c73b898d4ca5d075786b53_Out_2, _Absolute_f98ce5feb185a68784b9b35eb71ec465_Out_1);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_27e768ffa9c13e8ab65d48e7712e5b66_Out_0 = _CoverHardness;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Power_b9fdc3921d5b85878a1ec4baa1975184_Out_2;
            Unity_Power_float(_Absolute_f98ce5feb185a68784b9b35eb71ec465_Out_1, _Property_27e768ffa9c13e8ab65d48e7712e5b66_Out_0, _Power_b9fdc3921d5b85878a1ec4baa1975184_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_c442c20fdade808b8e1b93cfd6625ab9_Out_0 = _Cover_Min_Height;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _OneMinus_55530ddc82048c8aa2d082334edf6a57_Out_1;
            Unity_OneMinus_float(_Property_c442c20fdade808b8e1b93cfd6625ab9_Out_0, _OneMinus_55530ddc82048c8aa2d082334edf6a57_Out_1);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Split_7e5d084c5e6bfa83a9203dac971ea31e_R_1 = IN.AbsoluteWorldSpacePosition[0];
            float _Split_7e5d084c5e6bfa83a9203dac971ea31e_G_2 = IN.AbsoluteWorldSpacePosition[1];
            float _Split_7e5d084c5e6bfa83a9203dac971ea31e_B_3 = IN.AbsoluteWorldSpacePosition[2];
            float _Split_7e5d084c5e6bfa83a9203dac971ea31e_A_4 = 0;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Add_e4067b215657d98ab6ec4e0295ddfece_Out_2;
            Unity_Add_float(_OneMinus_55530ddc82048c8aa2d082334edf6a57_Out_1, _Split_7e5d084c5e6bfa83a9203dac971ea31e_G_2, _Add_e4067b215657d98ab6ec4e0295ddfece_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Add_a4387dfc1ea3ee8da0b04f433a7c63d0_Out_2;
            Unity_Add_float(_Add_e4067b215657d98ab6ec4e0295ddfece_Out_2, 1, _Add_a4387dfc1ea3ee8da0b04f433a7c63d0_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Clamp_570e1129ecb02c8b8be79d85f19d5ae1_Out_3;
            Unity_Clamp_float(_Add_a4387dfc1ea3ee8da0b04f433a7c63d0_Out_2, 0, 1, _Clamp_570e1129ecb02c8b8be79d85f19d5ae1_Out_3);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_5da709b259ac268bb134d927bcffa4b8_Out_0 = _Cover_Min_Height_Blending;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Add_c322347d9ddbcd83ba52983e9316c387_Out_2;
            Unity_Add_float(_Add_e4067b215657d98ab6ec4e0295ddfece_Out_2, _Property_5da709b259ac268bb134d927bcffa4b8_Out_0, _Add_c322347d9ddbcd83ba52983e9316c387_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Divide_078ffa7d6c597f819511c95d33b7d90e_Out_2;
            Unity_Divide_float(_Add_c322347d9ddbcd83ba52983e9316c387_Out_2, _Add_e4067b215657d98ab6ec4e0295ddfece_Out_2, _Divide_078ffa7d6c597f819511c95d33b7d90e_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _OneMinus_b9f8edced35e7b8cab9ca581d822e31f_Out_1;
            Unity_OneMinus_float(_Divide_078ffa7d6c597f819511c95d33b7d90e_Out_2, _OneMinus_b9f8edced35e7b8cab9ca581d822e31f_Out_1);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Add_95cd1778448bfe8d9f9fa9129235f2c2_Out_2;
            Unity_Add_float(_OneMinus_b9f8edced35e7b8cab9ca581d822e31f_Out_1, -0.5, _Add_95cd1778448bfe8d9f9fa9129235f2c2_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Clamp_23e760e01b7e0780a71d88813b5828d7_Out_3;
            Unity_Clamp_float(_Add_95cd1778448bfe8d9f9fa9129235f2c2_Out_2, 0, 1, _Clamp_23e760e01b7e0780a71d88813b5828d7_Out_3);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Add_674fcef023d728848510150af810a103_Out_2;
            Unity_Add_float(_Clamp_570e1129ecb02c8b8be79d85f19d5ae1_Out_3, _Clamp_23e760e01b7e0780a71d88813b5828d7_Out_3, _Add_674fcef023d728848510150af810a103_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Clamp_5b677be9d499c082bcbe316853b0adff_Out_3;
            Unity_Clamp_float(_Add_674fcef023d728848510150af810a103_Out_2, 0, 1, _Clamp_5b677be9d499c082bcbe316853b0adff_Out_3);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Multiply_7ea7400ed65a3582b000796fb39748e9_Out_2;
            Unity_Multiply_float(_Power_b9fdc3921d5b85878a1ec4baa1975184_Out_2, _Clamp_5b677be9d499c082bcbe316853b0adff_Out_3, _Multiply_7ea7400ed65a3582b000796fb39748e9_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Multiply_4d295791f4e23186acea64f2f4de94ea_Out_2;
            Unity_Multiply_float(_Saturate_ada5e8f9ebdcb38d8f5e61e8d97424b9_Out_1, _Multiply_7ea7400ed65a3582b000796fb39748e9_Out_2, _Multiply_4d295791f4e23186acea64f2f4de94ea_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 _Lerp_21eaf65c617b2d858b3b33154d55757a_Out_3;
            Unity_Lerp_float3(_NormalBlend_be36dd49bea74c8f8dd52fa3a85a9534_Out_2, _NormalStrength_0e5e0831ba0e98878220ca6021ea52a2_Out_2, (_Multiply_4d295791f4e23186acea64f2f4de94ea_Out_2.xxx), _Lerp_21eaf65c617b2d858b3b33154d55757a_Out_3);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3x3 Transform_1e4c3a2d6240958ab6858efb88c1d06a_transposeTangent = transpose(float3x3(IN.WorldSpaceTangent, IN.WorldSpaceBiTangent, IN.WorldSpaceNormal));
            float3 _Transform_1e4c3a2d6240958ab6858efb88c1d06a_Out_1 = normalize(mul(Transform_1e4c3a2d6240958ab6858efb88c1d06a_transposeTangent, _Lerp_21eaf65c617b2d858b3b33154d55757a_Out_3.xyz).xyz);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Split_600a9d271d96798a94ab28118977defd_R_1 = _Transform_1e4c3a2d6240958ab6858efb88c1d06a_Out_1[0];
            float _Split_600a9d271d96798a94ab28118977defd_G_2 = _Transform_1e4c3a2d6240958ab6858efb88c1d06a_Out_1[1];
            float _Split_600a9d271d96798a94ab28118977defd_B_3 = _Transform_1e4c3a2d6240958ab6858efb88c1d06a_Out_1[2];
            float _Split_600a9d271d96798a94ab28118977defd_A_4 = 0;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Multiply_2e5b010626435f8492a2690396ced19d_Out_2;
            Unity_Multiply_float(_Split_600a9d271d96798a94ab28118977defd_G_2, _Clamp_95d579f83746cb82be79cf6739990e0b_Out_3, _Multiply_2e5b010626435f8492a2690396ced19d_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Multiply_5a2397e0153ddb8f9bd457d9a301dc8b_Out_2;
            Unity_Multiply_float(_Clamp_95d579f83746cb82be79cf6739990e0b_Out_3, _Property_27e768ffa9c13e8ab65d48e7712e5b66_Out_0, _Multiply_5a2397e0153ddb8f9bd457d9a301dc8b_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Multiply_3aad76eaff60dd888c3e1783ecf03943_Out_2;
            Unity_Multiply_float(_Multiply_5a2397e0153ddb8f9bd457d9a301dc8b_Out_2, _Multiply_7ea7400ed65a3582b000796fb39748e9_Out_2, _Multiply_3aad76eaff60dd888c3e1783ecf03943_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Multiply_05614e740451f18f8301586390aa5a0a_Out_2;
            Unity_Multiply_float(_Multiply_2e5b010626435f8492a2690396ced19d_Out_2, _Multiply_3aad76eaff60dd888c3e1783ecf03943_Out_2, _Multiply_05614e740451f18f8301586390aa5a0a_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            UnityTexture2D _Property_a14f2476a35d208b988233c852f919ef_Out_0 = UnityBuildTexture2DStructNoScale(_CoverMaskMap);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            Bindings_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6 _PlanarNM_6858a0e821f26a8d87846d325e9bd170;
            _PlanarNM_6858a0e821f26a8d87846d325e9bd170.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            _PlanarNM_6858a0e821f26a8d87846d325e9bd170.uv0 = IN.uv0;
            float4 _PlanarNM_6858a0e821f26a8d87846d325e9bd170_XZ_2;
            SG_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6(_Property_a14f2476a35d208b988233c852f919ef_Out_0, _Property_e35c79b8cccfbe8ca0a3c33e8d32e319_Out_0, _Property_e3d8b38b51331e879b1d4012d65f53e6_Out_0, _PlanarNM_6858a0e821f26a8d87846d325e9bd170, _PlanarNM_6858a0e821f26a8d87846d325e9bd170_XZ_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Split_16313c20ccdeaa86a639068877a69a2f_R_1 = _PlanarNM_6858a0e821f26a8d87846d325e9bd170_XZ_2[0];
            float _Split_16313c20ccdeaa86a639068877a69a2f_G_2 = _PlanarNM_6858a0e821f26a8d87846d325e9bd170_XZ_2[1];
            float _Split_16313c20ccdeaa86a639068877a69a2f_B_3 = _PlanarNM_6858a0e821f26a8d87846d325e9bd170_XZ_2[2];
            float _Split_16313c20ccdeaa86a639068877a69a2f_A_4 = _PlanarNM_6858a0e821f26a8d87846d325e9bd170_XZ_2[3];
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_673896519f419589938b37e782b90141_Out_0 = _CoverHeightMapMin;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_c35906332422438da3b19f45cbd5ac17_Out_0 = _CoverHeightMapMax;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float2 _Vector2_81cbe1e5ea789e8697223cd3bfbca76c_Out_0 = float2(_Property_673896519f419589938b37e782b90141_Out_0, _Property_c35906332422438da3b19f45cbd5ac17_Out_0);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_88ab0068f899fc8ba94efdaec5e8966b_Out_0 = _CoverHeightMapOffset;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float2 _Add_cd623e3135271489b0d45b4d7edc5f7e_Out_2;
            Unity_Add_float2(_Vector2_81cbe1e5ea789e8697223cd3bfbca76c_Out_0, (_Property_88ab0068f899fc8ba94efdaec5e8966b_Out_0.xx), _Add_cd623e3135271489b0d45b4d7edc5f7e_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Remap_9a23d5f76fa8c38dbd73f43bd6397b0b_Out_3;
            Unity_Remap_float(_Split_16313c20ccdeaa86a639068877a69a2f_B_3, float2 (0, 1), _Add_cd623e3135271489b0d45b4d7edc5f7e_Out_2, _Remap_9a23d5f76fa8c38dbd73f43bd6397b0b_Out_3);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Multiply_0093be0fd848498b89a0fa282608e715_Out_2;
            Unity_Multiply_float(_Multiply_05614e740451f18f8301586390aa5a0a_Out_2, _Remap_9a23d5f76fa8c38dbd73f43bd6397b0b_Out_3, _Multiply_0093be0fd848498b89a0fa282608e715_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Multiply_d3190f97afd0398083623ecf71a41b1a_Out_2;
            Unity_Multiply_float(_Split_8ba5b67899f36b8f9dcf5c84092c0560_G_2, _Multiply_0093be0fd848498b89a0fa282608e715_Out_2, _Multiply_d3190f97afd0398083623ecf71a41b1a_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Saturate_cbcee34e7e6e6d8091d840550ab1c74a_Out_1;
            Unity_Saturate_float(_Multiply_d3190f97afd0398083623ecf71a41b1a_Out_2, _Saturate_cbcee34e7e6e6d8091d840550ab1c74a_Out_1);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Multiply_da35b9d9e4dd8c81871a9aea42c157ee_Out_2;
            Unity_Multiply_float(_Clamp_030a7c32684c258084338456eaddc77a_Out_3, _Saturate_cbcee34e7e6e6d8091d840550ab1c74a_Out_1, _Multiply_da35b9d9e4dd8c81871a9aea42c157ee_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Clamp_c95f5515948375878df6581a36d8b203_Out_3;
            Unity_Clamp_float(_Multiply_da35b9d9e4dd8c81871a9aea42c157ee_Out_2, 0, 1, _Clamp_c95f5515948375878df6581a36d8b203_Out_3);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            #if defined(_USEDYNAMICCOVERTSTATICMASKF_ON)
            float _UseDynamicCoverTStaticMaskF_0694902516172b8fa469c5d8b8e938c6_Out_0 = _Clamp_c95f5515948375878df6581a36d8b203_Out_3;
            #else
            float _UseDynamicCoverTStaticMaskF_0694902516172b8fa469c5d8b8e938c6_Out_0 = _Clamp_030a7c32684c258084338456eaddc77a_Out_3;
            #endif
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 _Lerp_6861b6a37faf5e868527d229073a4d0f_Out_3;
            Unity_Lerp_float3(_NormalBlend_be36dd49bea74c8f8dd52fa3a85a9534_Out_2, _NormalStrength_d60a055f00d779808337e9d909827806_Out_2, (_UseDynamicCoverTStaticMaskF_0694902516172b8fa469c5d8b8e938c6_Out_0.xxx), _Lerp_6861b6a37faf5e868527d229073a4d0f_Out_3);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            UnityTexture2D _Property_e4c53213449c7682b60df6ae54f219f0_Out_0 = UnityBuildTexture2DStructNoScale(_BaseColorMap);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            Bindings_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6 _PlanarNM_6c8b686076db2a8c8b7d6cd91cf435f0;
            _PlanarNM_6c8b686076db2a8c8b7d6cd91cf435f0.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            _PlanarNM_6c8b686076db2a8c8b7d6cd91cf435f0.uv0 = IN.uv0;
            float4 _PlanarNM_6c8b686076db2a8c8b7d6cd91cf435f0_XZ_2;
            SG_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6(_Property_e4c53213449c7682b60df6ae54f219f0_Out_0, _Property_115fcc827510f38798b214d835c27637_Out_0, _Property_d83b8f290862b285bbe2f157190e1315_Out_0, _PlanarNM_6c8b686076db2a8c8b7d6cd91cf435f0, _PlanarNM_6c8b686076db2a8c8b7d6cd91cf435f0_XZ_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Split_31874fa1d55cb28e99a1333cf254676a_R_1 = _PlanarNM_6c8b686076db2a8c8b7d6cd91cf435f0_XZ_2[0];
            float _Split_31874fa1d55cb28e99a1333cf254676a_G_2 = _PlanarNM_6c8b686076db2a8c8b7d6cd91cf435f0_XZ_2[1];
            float _Split_31874fa1d55cb28e99a1333cf254676a_B_3 = _PlanarNM_6c8b686076db2a8c8b7d6cd91cf435f0_XZ_2[2];
            float _Split_31874fa1d55cb28e99a1333cf254676a_A_4 = _PlanarNM_6c8b686076db2a8c8b7d6cd91cf435f0_XZ_2[3];
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_881c341218ea2d81819695b0c7ddc4cb_Out_0 = _AlphaCutoff;
            #endif
            surface.NormalTS = _Lerp_6861b6a37faf5e868527d229073a4d0f_Out_3;
            surface.Alpha = _Split_31874fa1d55cb28e99a1333cf254676a_A_4;
            surface.AlphaClipThreshold = _Property_881c341218ea2d81819695b0c7ddc4cb_Out_0;
            return surface;
        }

            // --------------------------------------------------
            // Build Graph Inputs

            VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.ObjectSpaceNormal =           input.normalOS;
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.ObjectSpaceTangent =          input.tangentOS.xyz;
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.ObjectSpacePosition =         input.positionOS;
        #endif


            return output;
        }
            SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        // must use interpolated tangent, bitangent and normal before they are normalized in the pixel shader.
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        float3 unnormalizedNormalWS = input.normalWS;
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        const float renormFactor = 1.0 / length(unnormalizedNormalWS);
        #endif


        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        // use bitangent on the fly like in hdrp
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        // IMPORTANT! If we ever support Flip on double sided materials ensure bitangent and tangent are NOT flipped.
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        float crossSign = (input.tangentWS.w > 0.0 ? 1.0 : -1.0) * GetOddNegativeScale();
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        float3 bitang = crossSign * cross(input.normalWS.xyz, input.tangentWS.xyz);
        #endif


        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.WorldSpaceNormal =            renormFactor*input.normalWS.xyz;      // we want a unit length Normal Vector node in shader graph
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.TangentSpaceNormal =          float3(0.0f, 0.0f, 1.0f);
        #endif


        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        // to preserve mikktspace compliance we use same scale renormFactor as was used on the normal.
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        // This is explained in section 2.2 in "surface gradient based bump mapping framework"
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.WorldSpaceTangent =           renormFactor*input.tangentWS.xyz;
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.WorldSpaceBiTangent =         renormFactor*bitang;
        #endif


        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.AbsoluteWorldSpacePosition =  GetAbsolutePositionWS(input.positionWS);
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.uv0 =                         input.texCoord0;
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.VertexColor =                 input.color;
        #endif

        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN

            return output;
        }

            // --------------------------------------------------
            // Main

            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/DepthNormalsOnlyPass.hlsl"

            ENDHLSL
        }
        Pass
        {
            Name "Meta"
            Tags
            {
                "LightMode" = "Meta"
            }

            // Render State
            Cull Off

            // Debug
            // <None>

            // --------------------------------------------------
            // Pass

            HLSLPROGRAM

            // Pragmas
            #pragma target 4.5
        #pragma exclude_renderers gles gles3 glcore
        #pragma vertex vert
        #pragma fragment frag

            // DotsInstancingOptions: <None>
            // HybridV1InjectedBuiltinProperties: <None>

            // Keywords
            #pragma shader_feature _ _SMOOTHNESS_TEXTURE_ALBEDO_CHANNEL_A
            #pragma shader_feature_local _ _USEDYNAMICCOVERTSTATICMASKF_ON

        #if defined(_USEDYNAMICCOVERTSTATICMASKF_ON)
            #define KEYWORD_PERMUTATION_0
        #else
            #define KEYWORD_PERMUTATION_1
        #endif


            // Defines
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define _AlphaClip 1
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define _NORMALMAP 1
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define _NORMAL_DROPOFF_TS 1
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define ATTRIBUTES_NEED_NORMAL
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define ATTRIBUTES_NEED_TANGENT
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define ATTRIBUTES_NEED_TEXCOORD0
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define ATTRIBUTES_NEED_TEXCOORD1
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define ATTRIBUTES_NEED_TEXCOORD2
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define ATTRIBUTES_NEED_COLOR
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define VARYINGS_NEED_POSITION_WS
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define VARYINGS_NEED_NORMAL_WS
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define VARYINGS_NEED_TANGENT_WS
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define VARYINGS_NEED_TEXCOORD0
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define VARYINGS_NEED_COLOR
        #endif

            #define FEATURES_GRAPH_VERTEX
            /* WARNING: $splice Could not find named fragment 'PassInstancing' */
            #define SHADERPASS SHADERPASS_META
            /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */

            // Includes
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/MetaInput.hlsl"

            // --------------------------------------------------
            // Structs and Packing

            struct Attributes
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 positionOS : POSITION;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 normalOS : NORMAL;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 tangentOS : TANGENT;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 uv0 : TEXCOORD0;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 uv1 : TEXCOORD1;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 uv2 : TEXCOORD2;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 color : COLOR;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            uint instanceID : INSTANCEID_SEMANTIC;
            #endif
            #endif
        };
        struct Varyings
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 positionCS : SV_POSITION;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 positionWS;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 normalWS;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 tangentWS;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 texCoord0;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 color;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
            #endif
        };
        struct SurfaceDescriptionInputs
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 WorldSpaceNormal;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 WorldSpaceTangent;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 WorldSpaceBiTangent;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 AbsoluteWorldSpacePosition;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 uv0;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 VertexColor;
            #endif
        };
        struct VertexDescriptionInputs
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 ObjectSpaceNormal;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 ObjectSpaceTangent;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 ObjectSpacePosition;
            #endif
        };
        struct PackedVaryings
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 positionCS : SV_POSITION;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 interp0 : TEXCOORD0;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 interp1 : TEXCOORD1;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 interp2 : TEXCOORD2;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 interp3 : TEXCOORD3;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 interp4 : TEXCOORD4;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
            #endif
        };

            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            output.positionCS = input.positionCS;
            output.interp0.xyz =  input.positionWS;
            output.interp1.xyz =  input.normalWS;
            output.interp2.xyzw =  input.tangentWS;
            output.interp3.xyzw =  input.texCoord0;
            output.interp4.xyzw =  input.color;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.positionWS = input.interp0.xyz;
            output.normalWS = input.interp1.xyz;
            output.tangentWS = input.interp2.xyzw;
            output.texCoord0 = input.interp3.xyzw;
            output.color = input.interp4.xyzw;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        #endif

            // --------------------------------------------------
            // Graph

            // Graph Properties
            CBUFFER_START(UnityPerMaterial)
        float _AlphaCutoff;
        float4 _BaseColor;
        float4 _BaseColorMap_TexelSize;
        float _BaseUsePlanarUV;
        float4 _BaseTilingOffset;
        float4 _BaseNormalMap_TexelSize;
        float _BaseNormalScale;
        float4 _BaseMaskMap_TexelSize;
        float _BaseMetallic;
        float _BaseAORemapMin;
        float _BaseAORemapMax;
        float _BaseSmoothnessRemapMin;
        float _BaseSmoothnessRemapMax;
        float4 _CoverMaskA_TexelSize;
        float _CoverMaskPower;
        float _Cover_Amount;
        float _Cover_Amount_Grow_Speed;
        float _Cover_Max_Angle;
        float _Cover_Min_Height;
        float _Cover_Min_Height_Blending;
        float4 _CoverBaseColor;
        float4 _CoverBaseColorMap_TexelSize;
        float _CoverUsePlanarUV;
        float4 _CoverTilingOffset;
        float4 _CoverNormalMap_TexelSize;
        float _CoverNormalScale;
        float _CoverNormalBlendHardness;
        float _CoverHardness;
        float _CoverHeightMapMin;
        float _CoverHeightMapMax;
        float _CoverHeightMapOffset;
        float4 _CoverMaskMap_TexelSize;
        float _CoverMetallic;
        float _CoverAORemapMin;
        float _CoverAORemapMax;
        float _CoverSmoothnessRemapMin;
        float _CoverSmoothnessRemapMax;
        float4 _DetailMap_TexelSize;
        float4 _DetailTilingOffset;
        float _DetailAlbedoScale;
        float _DetailNormalScale;
        float _DetailSmoothnessScale;
        float4 _WetColor;
        float _WetSmoothness;
        CBUFFER_END

        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_BaseColorMap);
        SAMPLER(sampler_BaseColorMap);
        TEXTURE2D(_BaseNormalMap);
        SAMPLER(sampler_BaseNormalMap);
        TEXTURE2D(_BaseMaskMap);
        SAMPLER(sampler_BaseMaskMap);
        TEXTURE2D(_CoverMaskA);
        SAMPLER(sampler_CoverMaskA);
        TEXTURE2D(_CoverBaseColorMap);
        SAMPLER(sampler_CoverBaseColorMap);
        TEXTURE2D(_CoverNormalMap);
        SAMPLER(sampler_CoverNormalMap);
        TEXTURE2D(_CoverMaskMap);
        SAMPLER(sampler_CoverMaskMap);
        TEXTURE2D(_DetailMap);
        SAMPLER(sampler_DetailMap);

            // Graph Functions
            
        // f948cdce565a6e706cc57cb23fbf9d95
        #include "./NM_Object_VSPro_Indirect.cginc"

        void AddPragma_float(float3 A, out float3 Out){
            #pragma instancing_options renderinglayer procedural:setupVSPro
            Out = A;
        }

        struct Bindings_NMObjectVSProIndirect_0cfe1e4f145944241ab304331e53c93b
        {
        };

        void SG_NMObjectVSProIndirect_0cfe1e4f145944241ab304331e53c93b(float3 Vector3_314C8600, Bindings_NMObjectVSProIndirect_0cfe1e4f145944241ab304331e53c93b IN, out float3 ObjectSpacePosition_1)
        {
            float3 _Property_5ec158abd968858c9d31ab40df5e9e6f_Out_0 = Vector3_314C8600;
            float3 _InjectSetupCustomFunction_dec9b26544b4a788b8ecb4117dc3d24a_Out_1;
            InjectSetup_float(_Property_5ec158abd968858c9d31ab40df5e9e6f_Out_0, _InjectSetupCustomFunction_dec9b26544b4a788b8ecb4117dc3d24a_Out_1);
            float3 _AddPragmaCustomFunction_b2a053178906d0848480a1f463521a1b_Out_1;
            AddPragma_float(_InjectSetupCustomFunction_dec9b26544b4a788b8ecb4117dc3d24a_Out_1, _AddPragmaCustomFunction_b2a053178906d0848480a1f463521a1b_Out_1);
            ObjectSpacePosition_1 = _AddPragmaCustomFunction_b2a053178906d0848480a1f463521a1b_Out_1;
        }

        void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
        {
            RGBA = float4(R, G, B, A);
            RGB = float3(R, G, B);
            RG = float2(R, G);
        }

        void Unity_Divide_float(float A, float B, out float Out)
        {
            Out = A / B;
        }

        void Unity_Multiply_float(float4 A, float4 B, out float4 Out)
        {
            Out = A * B;
        }

        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }

        void Unity_Branch_float2(float Predicate, float2 True, float2 False, out float2 Out)
        {
            Out = Predicate ? True : False;
        }

        struct Bindings_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6
        {
            float3 AbsoluteWorldSpacePosition;
            half4 uv0;
        };

        void SG_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6(UnityTexture2D Texture2D_80A3D28F, float4 Vector4_2EBA7A3B, float Boolean_7ABB9909, Bindings_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6 IN, out float4 XZ_2)
        {
            UnityTexture2D _Property_3e01b4d2fc68d48ba3acbba9d5881e59_Out_0 = Texture2D_80A3D28F;
            float _Property_30834f691775a0898a45b1c868520436_Out_0 = Boolean_7ABB9909;
            float _Split_89ed63cb625cb3878c183d0b71c03400_R_1 = IN.AbsoluteWorldSpacePosition[0];
            float _Split_89ed63cb625cb3878c183d0b71c03400_G_2 = IN.AbsoluteWorldSpacePosition[1];
            float _Split_89ed63cb625cb3878c183d0b71c03400_B_3 = IN.AbsoluteWorldSpacePosition[2];
            float _Split_89ed63cb625cb3878c183d0b71c03400_A_4 = 0;
            float4 _Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4;
            float3 _Combine_cf2d04ff119ad88493f6460431765cbb_RGB_5;
            float2 _Combine_cf2d04ff119ad88493f6460431765cbb_RG_6;
            Unity_Combine_float(_Split_89ed63cb625cb3878c183d0b71c03400_R_1, _Split_89ed63cb625cb3878c183d0b71c03400_B_3, 0, 0, _Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4, _Combine_cf2d04ff119ad88493f6460431765cbb_RGB_5, _Combine_cf2d04ff119ad88493f6460431765cbb_RG_6);
            float4 _Property_8a66888ec47d0687ab1cb2f8abdc9da8_Out_0 = Vector4_2EBA7A3B;
            float _Split_2f0f52f6ef8c0e81af0da6476402bc1f_R_1 = _Property_8a66888ec47d0687ab1cb2f8abdc9da8_Out_0[0];
            float _Split_2f0f52f6ef8c0e81af0da6476402bc1f_G_2 = _Property_8a66888ec47d0687ab1cb2f8abdc9da8_Out_0[1];
            float _Split_2f0f52f6ef8c0e81af0da6476402bc1f_B_3 = _Property_8a66888ec47d0687ab1cb2f8abdc9da8_Out_0[2];
            float _Split_2f0f52f6ef8c0e81af0da6476402bc1f_A_4 = _Property_8a66888ec47d0687ab1cb2f8abdc9da8_Out_0[3];
            float _Divide_e64179199923c58289b6aa94ea6c9178_Out_2;
            Unity_Divide_float(1, _Split_2f0f52f6ef8c0e81af0da6476402bc1f_R_1, _Divide_e64179199923c58289b6aa94ea6c9178_Out_2);
            float4 _Multiply_14cec4902d0a00829e4555071a1b8ad1_Out_2;
            Unity_Multiply_float(_Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4, (_Divide_e64179199923c58289b6aa94ea6c9178_Out_2.xxxx), _Multiply_14cec4902d0a00829e4555071a1b8ad1_Out_2);
            float2 _Vector2_16c15d3bbdd14b85bd48e3a6cb318af7_Out_0 = float2(_Split_2f0f52f6ef8c0e81af0da6476402bc1f_R_1, _Split_2f0f52f6ef8c0e81af0da6476402bc1f_G_2);
            float2 _Vector2_f8d75f54e7705083bbec539a60185577_Out_0 = float2(_Split_2f0f52f6ef8c0e81af0da6476402bc1f_B_3, _Split_2f0f52f6ef8c0e81af0da6476402bc1f_A_4);
            float2 _TilingAndOffset_d91e2d25acd34686b562b7fe7e9d1d27_Out_3;
            Unity_TilingAndOffset_float(IN.uv0.xy, _Vector2_16c15d3bbdd14b85bd48e3a6cb318af7_Out_0, _Vector2_f8d75f54e7705083bbec539a60185577_Out_0, _TilingAndOffset_d91e2d25acd34686b562b7fe7e9d1d27_Out_3);
            float2 _Branch_8e5a4e8f4d52fc8aadd1f46485afc933_Out_3;
            Unity_Branch_float2(_Property_30834f691775a0898a45b1c868520436_Out_0, (_Multiply_14cec4902d0a00829e4555071a1b8ad1_Out_2.xy), _TilingAndOffset_d91e2d25acd34686b562b7fe7e9d1d27_Out_3, _Branch_8e5a4e8f4d52fc8aadd1f46485afc933_Out_3);
            float4 _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0 = SAMPLE_TEXTURE2D(_Property_3e01b4d2fc68d48ba3acbba9d5881e59_Out_0.tex, _Property_3e01b4d2fc68d48ba3acbba9d5881e59_Out_0.samplerstate, _Branch_8e5a4e8f4d52fc8aadd1f46485afc933_Out_3);
            float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_R_4 = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0.r;
            float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_G_5 = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0.g;
            float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_B_6 = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0.b;
            float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_A_7 = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0.a;
            XZ_2 = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0;
        }

        void Unity_Multiply_float(float A, float B, out float Out)
        {
            Out = A * B;
        }

        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
        }

        void Unity_Saturate_float(float In, out float Out)
        {
            Out = saturate(In);
        }

        void Unity_Absolute_float(float In, out float Out)
        {
            Out = abs(In);
        }

        void Unity_SquareRoot_float4(float4 In, out float4 Out)
        {
            Out = sqrt(In);
        }

        void Unity_Sign_float(float In, out float Out)
        {
            Out = sign(In);
        }

        void Unity_Ceiling_float(float In, out float Out)
        {
            Out = ceil(In);
        }

        void Unity_Lerp_float4(float4 A, float4 B, float4 T, out float4 Out)
        {
            Out = lerp(A, B, T);
        }

        struct Bindings_BlendOverlayBaseColor_acdb3dfca72bd6b42bbc35f4613331a2
        {
        };

        void SG_BlendOverlayBaseColor_acdb3dfca72bd6b42bbc35f4613331a2(float4 Color_9AA111D3, float Vector1_FBE622A2, float Vector1_8C15C351, Bindings_BlendOverlayBaseColor_acdb3dfca72bd6b42bbc35f4613331a2 IN, out float3 OutVector4_1)
        {
            float4 _Property_012510d774fb7f8b860f5270dca4500f_Out_0 = Color_9AA111D3;
            float4 _SquareRoot_c2c57d0223a9538aa9240890c3cacb0c_Out_1;
            Unity_SquareRoot_float4(_Property_012510d774fb7f8b860f5270dca4500f_Out_0, _SquareRoot_c2c57d0223a9538aa9240890c3cacb0c_Out_1);
            float _Property_a00e29241d12f983b30177515b367ec9_Out_0 = Vector1_FBE622A2;
            float _Sign_343a45ede7349283a681c6bd9998fd8e_Out_1;
            Unity_Sign_float(_Property_a00e29241d12f983b30177515b367ec9_Out_0, _Sign_343a45ede7349283a681c6bd9998fd8e_Out_1);
            float _Add_681019b8f5d3d68bb482d419c9fc61a9_Out_2;
            Unity_Add_float(_Sign_343a45ede7349283a681c6bd9998fd8e_Out_1, 1, _Add_681019b8f5d3d68bb482d419c9fc61a9_Out_2);
            float _Multiply_e8f4cb722712a880ac0db6c7461427f7_Out_2;
            Unity_Multiply_float(_Add_681019b8f5d3d68bb482d419c9fc61a9_Out_2, 0.5, _Multiply_e8f4cb722712a880ac0db6c7461427f7_Out_2);
            float _Ceiling_95ad15988aa9b98184875fa754feae01_Out_1;
            Unity_Ceiling_float(_Multiply_e8f4cb722712a880ac0db6c7461427f7_Out_2, _Ceiling_95ad15988aa9b98184875fa754feae01_Out_1);
            float _Property_2db1c747a05ee284a8b00076062f91a4_Out_0 = Vector1_8C15C351;
            float _Multiply_9564ecda5193bc8286d9ff771c9226cd_Out_2;
            Unity_Multiply_float(_Property_2db1c747a05ee284a8b00076062f91a4_Out_0, _Property_2db1c747a05ee284a8b00076062f91a4_Out_0, _Multiply_9564ecda5193bc8286d9ff771c9226cd_Out_2);
            float4 _Lerp_b3cdb01fc3c5b988ac9b184943bf7c01_Out_3;
            Unity_Lerp_float4(_SquareRoot_c2c57d0223a9538aa9240890c3cacb0c_Out_1, (_Ceiling_95ad15988aa9b98184875fa754feae01_Out_1.xxxx), (_Multiply_9564ecda5193bc8286d9ff771c9226cd_Out_2.xxxx), _Lerp_b3cdb01fc3c5b988ac9b184943bf7c01_Out_3);
            float4 _Multiply_39d1daff98488f8ea2cd794ad4f20926_Out_2;
            Unity_Multiply_float(_Lerp_b3cdb01fc3c5b988ac9b184943bf7c01_Out_3, _Lerp_b3cdb01fc3c5b988ac9b184943bf7c01_Out_3, _Multiply_39d1daff98488f8ea2cd794ad4f20926_Out_2);
            OutVector4_1 = (_Multiply_39d1daff98488f8ea2cd794ad4f20926_Out_2.xyz);
        }

        void Unity_Clamp_float(float In, float Min, float Max, out float Out)
        {
            Out = clamp(In, Min, Max);
        }

        void Unity_Multiply_float(float2 A, float2 B, out float2 Out)
        {
            Out = A * B;
        }

        void Unity_Add_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A + B;
        }

        void Unity_DotProduct_float2(float2 A, float2 B, out float Out)
        {
            Out = dot(A, B);
        }

        void Unity_OneMinus_float(float In, out float Out)
        {
            Out = 1 - In;
        }

        void Unity_SquareRoot_float(float In, out float Out)
        {
            Out = sqrt(In);
        }

        void Unity_Sign_float3(float3 In, out float3 Out)
        {
            Out = sign(In);
        }

        void Unity_Normalize_float3(float3 In, out float3 Out)
        {
            Out = normalize(In);
        }

        void Unity_Branch_float3(float Predicate, float3 True, float3 False, out float3 Out)
        {
            Out = Predicate ? True : False;
        }

        struct Bindings_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8
        {
            float3 WorldSpaceNormal;
            float3 WorldSpaceTangent;
            float3 WorldSpaceBiTangent;
            float3 AbsoluteWorldSpacePosition;
            half4 uv0;
        };

        void SG_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8(UnityTexture2D Texture2D_80A3D28F, float4 Vector4_82674548, float Boolean_9FF42DF6, Bindings_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8 IN, out float4 XZ_2)
        {
            float _Property_1ef12cf3201a938993fe6a7951b0e754_Out_0 = Boolean_9FF42DF6;
            UnityTexture2D _Property_3e01b4d2fc68d48ba3acbba9d5881e59_Out_0 = Texture2D_80A3D28F;
            float _Split_89ed63cb625cb3878c183d0b71c03400_R_1 = IN.AbsoluteWorldSpacePosition[0];
            float _Split_89ed63cb625cb3878c183d0b71c03400_G_2 = IN.AbsoluteWorldSpacePosition[1];
            float _Split_89ed63cb625cb3878c183d0b71c03400_B_3 = IN.AbsoluteWorldSpacePosition[2];
            float _Split_89ed63cb625cb3878c183d0b71c03400_A_4 = 0;
            float4 _Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4;
            float3 _Combine_cf2d04ff119ad88493f6460431765cbb_RGB_5;
            float2 _Combine_cf2d04ff119ad88493f6460431765cbb_RG_6;
            Unity_Combine_float(_Split_89ed63cb625cb3878c183d0b71c03400_R_1, _Split_89ed63cb625cb3878c183d0b71c03400_B_3, 0, 0, _Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4, _Combine_cf2d04ff119ad88493f6460431765cbb_RGB_5, _Combine_cf2d04ff119ad88493f6460431765cbb_RG_6);
            float4 _Property_3fa1d6f912feb481ba60f2e55e62e746_Out_0 = Vector4_82674548;
            float _Split_a2e12fa5931da084b2949343a539dfd8_R_1 = _Property_3fa1d6f912feb481ba60f2e55e62e746_Out_0[0];
            float _Split_a2e12fa5931da084b2949343a539dfd8_G_2 = _Property_3fa1d6f912feb481ba60f2e55e62e746_Out_0[1];
            float _Split_a2e12fa5931da084b2949343a539dfd8_B_3 = _Property_3fa1d6f912feb481ba60f2e55e62e746_Out_0[2];
            float _Split_a2e12fa5931da084b2949343a539dfd8_A_4 = _Property_3fa1d6f912feb481ba60f2e55e62e746_Out_0[3];
            float _Divide_c36b770dfaa0bb8f85ab27da5fd794f0_Out_2;
            Unity_Divide_float(1, _Split_a2e12fa5931da084b2949343a539dfd8_R_1, _Divide_c36b770dfaa0bb8f85ab27da5fd794f0_Out_2);
            float4 _Multiply_14cec4902d0a00829e4555071a1b8ad1_Out_2;
            Unity_Multiply_float(_Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4, (_Divide_c36b770dfaa0bb8f85ab27da5fd794f0_Out_2.xxxx), _Multiply_14cec4902d0a00829e4555071a1b8ad1_Out_2);
            float2 _Vector2_6845d21872714d889783b0cb707df3e9_Out_0 = float2(_Split_a2e12fa5931da084b2949343a539dfd8_R_1, _Split_a2e12fa5931da084b2949343a539dfd8_G_2);
            float2 _Vector2_e2e2263627c6098e96a5b5d29350ad03_Out_0 = float2(_Split_a2e12fa5931da084b2949343a539dfd8_B_3, _Split_a2e12fa5931da084b2949343a539dfd8_A_4);
            float2 _TilingAndOffset_17582d056c0b8a8dab1017d37497fe59_Out_3;
            Unity_TilingAndOffset_float(IN.uv0.xy, _Vector2_6845d21872714d889783b0cb707df3e9_Out_0, _Vector2_e2e2263627c6098e96a5b5d29350ad03_Out_0, _TilingAndOffset_17582d056c0b8a8dab1017d37497fe59_Out_3);
            float2 _Branch_1e152f3aac57448f8518bf2852c000c3_Out_3;
            Unity_Branch_float2(_Property_1ef12cf3201a938993fe6a7951b0e754_Out_0, (_Multiply_14cec4902d0a00829e4555071a1b8ad1_Out_2.xy), _TilingAndOffset_17582d056c0b8a8dab1017d37497fe59_Out_3, _Branch_1e152f3aac57448f8518bf2852c000c3_Out_3);
            float4 _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0 = SAMPLE_TEXTURE2D(_Property_3e01b4d2fc68d48ba3acbba9d5881e59_Out_0.tex, _Property_3e01b4d2fc68d48ba3acbba9d5881e59_Out_0.samplerstate, _Branch_1e152f3aac57448f8518bf2852c000c3_Out_3);
            _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0.rgb = UnpackNormal(_SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0);
            float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_R_4 = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0.r;
            float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_G_5 = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0.g;
            float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_B_6 = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0.b;
            float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_A_7 = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0.a;
            float2 _Vector2_ad6bd100e273d78fa409a30a77bfa2cc_Out_0 = float2(_SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_R_4, _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_G_5);
            float3 _Sign_3a6ebf59931cf08cb0482e0144ddac24_Out_1;
            Unity_Sign_float3(IN.WorldSpaceNormal, _Sign_3a6ebf59931cf08cb0482e0144ddac24_Out_1);
            float _Split_6299d4ddcc4c74828aea40a46fdb896e_R_1 = _Sign_3a6ebf59931cf08cb0482e0144ddac24_Out_1[0];
            float _Split_6299d4ddcc4c74828aea40a46fdb896e_G_2 = _Sign_3a6ebf59931cf08cb0482e0144ddac24_Out_1[1];
            float _Split_6299d4ddcc4c74828aea40a46fdb896e_B_3 = _Sign_3a6ebf59931cf08cb0482e0144ddac24_Out_1[2];
            float _Split_6299d4ddcc4c74828aea40a46fdb896e_A_4 = 0;
            float2 _Vector2_b76cb1842101e58b9e636d49b075c612_Out_0 = float2(_Split_6299d4ddcc4c74828aea40a46fdb896e_G_2, 1);
            float2 _Multiply_31e8db88ee20c985a9850d1a58f3282b_Out_2;
            Unity_Multiply_float(_Vector2_ad6bd100e273d78fa409a30a77bfa2cc_Out_0, _Vector2_b76cb1842101e58b9e636d49b075c612_Out_0, _Multiply_31e8db88ee20c985a9850d1a58f3282b_Out_2);
            float _Split_5ed44bf2eca0868f81eb18100f49d1fa_R_1 = IN.WorldSpaceNormal[0];
            float _Split_5ed44bf2eca0868f81eb18100f49d1fa_G_2 = IN.WorldSpaceNormal[1];
            float _Split_5ed44bf2eca0868f81eb18100f49d1fa_B_3 = IN.WorldSpaceNormal[2];
            float _Split_5ed44bf2eca0868f81eb18100f49d1fa_A_4 = 0;
            float2 _Vector2_70e5837843f28b8b9d64cada3697bd5a_Out_0 = float2(_Split_5ed44bf2eca0868f81eb18100f49d1fa_R_1, _Split_5ed44bf2eca0868f81eb18100f49d1fa_B_3);
            float2 _Add_1145b2f896593d80aa864a34e6702562_Out_2;
            Unity_Add_float2(_Multiply_31e8db88ee20c985a9850d1a58f3282b_Out_2, _Vector2_70e5837843f28b8b9d64cada3697bd5a_Out_0, _Add_1145b2f896593d80aa864a34e6702562_Out_2);
            float _Split_2bc77ca2d17bd78cb2383770ce50b179_R_1 = _Add_1145b2f896593d80aa864a34e6702562_Out_2[0];
            float _Split_2bc77ca2d17bd78cb2383770ce50b179_G_2 = _Add_1145b2f896593d80aa864a34e6702562_Out_2[1];
            float _Split_2bc77ca2d17bd78cb2383770ce50b179_B_3 = 0;
            float _Split_2bc77ca2d17bd78cb2383770ce50b179_A_4 = 0;
            float _Multiply_ab12aea87465a78eaf7fc66c2598d266_Out_2;
            Unity_Multiply_float(_SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_B_6, _Split_5ed44bf2eca0868f81eb18100f49d1fa_G_2, _Multiply_ab12aea87465a78eaf7fc66c2598d266_Out_2);
            float3 _Vector3_433840b555db308b97e9b14b6a957195_Out_0 = float3(_Split_2bc77ca2d17bd78cb2383770ce50b179_R_1, _Multiply_ab12aea87465a78eaf7fc66c2598d266_Out_2, _Split_2bc77ca2d17bd78cb2383770ce50b179_G_2);
            float3x3 Transform_c7914cc45a011c89b3f53c55afb51673_tangentTransform_World = float3x3(IN.WorldSpaceTangent, IN.WorldSpaceBiTangent, IN.WorldSpaceNormal);
            float3 _Transform_c7914cc45a011c89b3f53c55afb51673_Out_1 = TransformWorldToTangent(_Vector3_433840b555db308b97e9b14b6a957195_Out_0.xyz, Transform_c7914cc45a011c89b3f53c55afb51673_tangentTransform_World);
            float3 _Normalize_09bf8a2bd0a4d38e8b97d5c674f79b44_Out_1;
            Unity_Normalize_float3(_Transform_c7914cc45a011c89b3f53c55afb51673_Out_1, _Normalize_09bf8a2bd0a4d38e8b97d5c674f79b44_Out_1);
            float3 _Branch_9eadf909a90f2f80880f8c56ecc2a91f_Out_3;
            Unity_Branch_float3(_Property_1ef12cf3201a938993fe6a7951b0e754_Out_0, _Normalize_09bf8a2bd0a4d38e8b97d5c674f79b44_Out_1, (_SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0.xyz), _Branch_9eadf909a90f2f80880f8c56ecc2a91f_Out_3);
            XZ_2 = (float4(_Branch_9eadf909a90f2f80880f8c56ecc2a91f_Out_3, 1.0));
        }

        void Unity_NormalStrength_float(float3 In, float Strength, out float3 Out)
        {
            Out = float3(In.rg * Strength, lerp(1, In.b, saturate(Strength)));
        }

        void Unity_NormalBlend_float(float3 A, float3 B, out float3 Out)
        {
            Out = SafeNormalize(float3(A.rg + B.rg, A.b * B.b));
        }

        void Unity_Subtract_float(float A, float B, out float Out)
        {
            Out = A - B;
        }

        void Unity_Power_float(float A, float B, out float Out)
        {
            Out = pow(A, B);
        }

        void Unity_Lerp_float3(float3 A, float3 B, float3 T, out float3 Out)
        {
            Out = lerp(A, B, T);
        }

        void Unity_Remap_float(float In, float2 InMinMax, float2 OutMinMax, out float Out)
        {
            Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
        }

        void Unity_Multiply_float(float3 A, float3 B, out float3 Out)
        {
            Out = A * B;
        }

            // Graph Vertex
            struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };

        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            Bindings_NMObjectVSProIndirect_0cfe1e4f145944241ab304331e53c93b _NMObjectVSProIndirect_adbe93754e069e8e87df45ef6e4b343e;
            float3 _NMObjectVSProIndirect_adbe93754e069e8e87df45ef6e4b343e_ObjectSpacePosition_1;
            SG_NMObjectVSProIndirect_0cfe1e4f145944241ab304331e53c93b(IN.ObjectSpacePosition, _NMObjectVSProIndirect_adbe93754e069e8e87df45ef6e4b343e, _NMObjectVSProIndirect_adbe93754e069e8e87df45ef6e4b343e_ObjectSpacePosition_1);
            #endif
            description.Position = _NMObjectVSProIndirect_adbe93754e069e8e87df45ef6e4b343e_ObjectSpacePosition_1;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }

            // Graph Pixel
            struct SurfaceDescription
        {
            float3 BaseColor;
            float3 Emission;
            float Alpha;
            float AlphaClipThreshold;
        };

        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            UnityTexture2D _Property_e4c53213449c7682b60df6ae54f219f0_Out_0 = UnityBuildTexture2DStructNoScale(_BaseColorMap);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 _Property_115fcc827510f38798b214d835c27637_Out_0 = _BaseTilingOffset;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_d83b8f290862b285bbe2f157190e1315_Out_0 = _BaseUsePlanarUV;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            Bindings_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6 _PlanarNM_6c8b686076db2a8c8b7d6cd91cf435f0;
            _PlanarNM_6c8b686076db2a8c8b7d6cd91cf435f0.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            _PlanarNM_6c8b686076db2a8c8b7d6cd91cf435f0.uv0 = IN.uv0;
            float4 _PlanarNM_6c8b686076db2a8c8b7d6cd91cf435f0_XZ_2;
            SG_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6(_Property_e4c53213449c7682b60df6ae54f219f0_Out_0, _Property_115fcc827510f38798b214d835c27637_Out_0, _Property_d83b8f290862b285bbe2f157190e1315_Out_0, _PlanarNM_6c8b686076db2a8c8b7d6cd91cf435f0, _PlanarNM_6c8b686076db2a8c8b7d6cd91cf435f0_XZ_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 _Property_13c79aaf332e20868551d934a2cb7112_Out_0 = _BaseColor;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 _Multiply_3d0c2fda612cfe87aa84bc17ad099a61_Out_2;
            Unity_Multiply_float(_PlanarNM_6c8b686076db2a8c8b7d6cd91cf435f0_XZ_2, _Property_13c79aaf332e20868551d934a2cb7112_Out_0, _Multiply_3d0c2fda612cfe87aa84bc17ad099a61_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            UnityTexture2D _Property_b561c414493a8f8299227a27e437f045_Out_0 = UnityBuildTexture2DStructNoScale(_DetailMap);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 _Property_70f1cc2b73af738d80b0d405e4bed8c5_Out_0 = _DetailTilingOffset;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Split_cda27505033cfc8eaf60fe914f0949b9_R_1 = _Property_70f1cc2b73af738d80b0d405e4bed8c5_Out_0[0];
            float _Split_cda27505033cfc8eaf60fe914f0949b9_G_2 = _Property_70f1cc2b73af738d80b0d405e4bed8c5_Out_0[1];
            float _Split_cda27505033cfc8eaf60fe914f0949b9_B_3 = _Property_70f1cc2b73af738d80b0d405e4bed8c5_Out_0[2];
            float _Split_cda27505033cfc8eaf60fe914f0949b9_A_4 = _Property_70f1cc2b73af738d80b0d405e4bed8c5_Out_0[3];
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float2 _Vector2_42d7e955009b6f8cb4d913530ff92840_Out_0 = float2(_Split_cda27505033cfc8eaf60fe914f0949b9_R_1, _Split_cda27505033cfc8eaf60fe914f0949b9_G_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float2 _Vector2_5452a0299d10b280aec51f7407d4d2ac_Out_0 = float2(_Split_cda27505033cfc8eaf60fe914f0949b9_B_3, _Split_cda27505033cfc8eaf60fe914f0949b9_A_4);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float2 _TilingAndOffset_e1c5b97bd253ca8f9f3d26f598e6d7fd_Out_3;
            Unity_TilingAndOffset_float(IN.uv0.xy, _Vector2_42d7e955009b6f8cb4d913530ff92840_Out_0, _Vector2_5452a0299d10b280aec51f7407d4d2ac_Out_0, _TilingAndOffset_e1c5b97bd253ca8f9f3d26f598e6d7fd_Out_3);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 _SampleTexture2D_fa4ac40fc922b9869e37c06690c0f530_RGBA_0 = SAMPLE_TEXTURE2D(_Property_b561c414493a8f8299227a27e437f045_Out_0.tex, _Property_b561c414493a8f8299227a27e437f045_Out_0.samplerstate, _TilingAndOffset_e1c5b97bd253ca8f9f3d26f598e6d7fd_Out_3);
            float _SampleTexture2D_fa4ac40fc922b9869e37c06690c0f530_R_4 = _SampleTexture2D_fa4ac40fc922b9869e37c06690c0f530_RGBA_0.r;
            float _SampleTexture2D_fa4ac40fc922b9869e37c06690c0f530_G_5 = _SampleTexture2D_fa4ac40fc922b9869e37c06690c0f530_RGBA_0.g;
            float _SampleTexture2D_fa4ac40fc922b9869e37c06690c0f530_B_6 = _SampleTexture2D_fa4ac40fc922b9869e37c06690c0f530_RGBA_0.b;
            float _SampleTexture2D_fa4ac40fc922b9869e37c06690c0f530_A_7 = _SampleTexture2D_fa4ac40fc922b9869e37c06690c0f530_RGBA_0.a;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Multiply_d0f6aeb5b3f04288b51a5ded8986b5a4_Out_2;
            Unity_Multiply_float(_SampleTexture2D_fa4ac40fc922b9869e37c06690c0f530_R_4, 2, _Multiply_d0f6aeb5b3f04288b51a5ded8986b5a4_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Add_d382719213f8618f88c54f7c3dfbd8c2_Out_2;
            Unity_Add_float(_Multiply_d0f6aeb5b3f04288b51a5ded8986b5a4_Out_2, -1, _Add_d382719213f8618f88c54f7c3dfbd8c2_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_02e7dd176dc59f8a9a62453677916b24_Out_0 = _DetailAlbedoScale;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Multiply_fd406247e3137a8b8777918477740653_Out_2;
            Unity_Multiply_float(_Add_d382719213f8618f88c54f7c3dfbd8c2_Out_2, _Property_02e7dd176dc59f8a9a62453677916b24_Out_0, _Multiply_fd406247e3137a8b8777918477740653_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Saturate_d6f590fb1b9d188e981ebb0ec4d36ba9_Out_1;
            Unity_Saturate_float(_Multiply_fd406247e3137a8b8777918477740653_Out_2, _Saturate_d6f590fb1b9d188e981ebb0ec4d36ba9_Out_1);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Absolute_dc927550b803d18ba3ff372995e6d25c_Out_1;
            Unity_Absolute_float(_Saturate_d6f590fb1b9d188e981ebb0ec4d36ba9_Out_1, _Absolute_dc927550b803d18ba3ff372995e6d25c_Out_1);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            Bindings_BlendOverlayBaseColor_acdb3dfca72bd6b42bbc35f4613331a2 _BlendOverlayBaseColor_f3cd25d5b673648eb831a3f388201f73;
            float3 _BlendOverlayBaseColor_f3cd25d5b673648eb831a3f388201f73_OutVector4_1;
            SG_BlendOverlayBaseColor_acdb3dfca72bd6b42bbc35f4613331a2(_Multiply_3d0c2fda612cfe87aa84bc17ad099a61_Out_2, _Add_d382719213f8618f88c54f7c3dfbd8c2_Out_2, _Absolute_dc927550b803d18ba3ff372995e6d25c_Out_1, _BlendOverlayBaseColor_f3cd25d5b673648eb831a3f388201f73, _BlendOverlayBaseColor_f3cd25d5b673648eb831a3f388201f73_OutVector4_1);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            UnityTexture2D _Property_f4db51ec2412c48cbcf2128b7bd8caf8_Out_0 = UnityBuildTexture2DStructNoScale(_CoverBaseColorMap);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 _Property_e35c79b8cccfbe8ca0a3c33e8d32e319_Out_0 = _CoverTilingOffset;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_e3d8b38b51331e879b1d4012d65f53e6_Out_0 = _CoverUsePlanarUV;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            Bindings_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6 _PlanarNM_c2ec737ef76d6286b8eedb44a2d24e50;
            _PlanarNM_c2ec737ef76d6286b8eedb44a2d24e50.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            _PlanarNM_c2ec737ef76d6286b8eedb44a2d24e50.uv0 = IN.uv0;
            float4 _PlanarNM_c2ec737ef76d6286b8eedb44a2d24e50_XZ_2;
            SG_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6(_Property_f4db51ec2412c48cbcf2128b7bd8caf8_Out_0, _Property_e35c79b8cccfbe8ca0a3c33e8d32e319_Out_0, _Property_e3d8b38b51331e879b1d4012d65f53e6_Out_0, _PlanarNM_c2ec737ef76d6286b8eedb44a2d24e50, _PlanarNM_c2ec737ef76d6286b8eedb44a2d24e50_XZ_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 _Property_7d3af9045f54ef8ba8629ebbbc3f4ad7_Out_0 = _CoverBaseColor;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 _Multiply_2eb83c7af5b6f58eabeec7b502517470_Out_2;
            Unity_Multiply_float(_PlanarNM_c2ec737ef76d6286b8eedb44a2d24e50_XZ_2, _Property_7d3af9045f54ef8ba8629ebbbc3f4ad7_Out_0, _Multiply_2eb83c7af5b6f58eabeec7b502517470_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            UnityTexture2D _Property_356186a26fec8686a13bc6b57fd8f3ee_Out_0 = UnityBuildTexture2DStructNoScale(_CoverMaskA);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 _UV_045cea9e82354980a778f44d92578382_Out_0 = IN.uv0;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 _SampleTexture2D_0eef6ae3dab6e185bd0f65edecd80314_RGBA_0 = SAMPLE_TEXTURE2D(_Property_356186a26fec8686a13bc6b57fd8f3ee_Out_0.tex, _Property_356186a26fec8686a13bc6b57fd8f3ee_Out_0.samplerstate, (_UV_045cea9e82354980a778f44d92578382_Out_0.xy));
            float _SampleTexture2D_0eef6ae3dab6e185bd0f65edecd80314_R_4 = _SampleTexture2D_0eef6ae3dab6e185bd0f65edecd80314_RGBA_0.r;
            float _SampleTexture2D_0eef6ae3dab6e185bd0f65edecd80314_G_5 = _SampleTexture2D_0eef6ae3dab6e185bd0f65edecd80314_RGBA_0.g;
            float _SampleTexture2D_0eef6ae3dab6e185bd0f65edecd80314_B_6 = _SampleTexture2D_0eef6ae3dab6e185bd0f65edecd80314_RGBA_0.b;
            float _SampleTexture2D_0eef6ae3dab6e185bd0f65edecd80314_A_7 = _SampleTexture2D_0eef6ae3dab6e185bd0f65edecd80314_RGBA_0.a;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_4e8240836843df81941cdf6cf2cdd638_Out_0 = _CoverMaskPower;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Multiply_8b5250e5dfc73a84a41399a13b83c0a1_Out_2;
            Unity_Multiply_float(_SampleTexture2D_0eef6ae3dab6e185bd0f65edecd80314_A_7, _Property_4e8240836843df81941cdf6cf2cdd638_Out_0, _Multiply_8b5250e5dfc73a84a41399a13b83c0a1_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Clamp_030a7c32684c258084338456eaddc77a_Out_3;
            Unity_Clamp_float(_Multiply_8b5250e5dfc73a84a41399a13b83c0a1_Out_2, 0, 1, _Clamp_030a7c32684c258084338456eaddc77a_Out_3);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Split_8ba5b67899f36b8f9dcf5c84092c0560_R_1 = IN.VertexColor[0];
            float _Split_8ba5b67899f36b8f9dcf5c84092c0560_G_2 = IN.VertexColor[1];
            float _Split_8ba5b67899f36b8f9dcf5c84092c0560_B_3 = IN.VertexColor[2];
            float _Split_8ba5b67899f36b8f9dcf5c84092c0560_A_4 = IN.VertexColor[3];
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float2 _Vector2_65060e9a9f687a89b68e32dc876be645_Out_0 = float2(_SampleTexture2D_fa4ac40fc922b9869e37c06690c0f530_A_7, _SampleTexture2D_fa4ac40fc922b9869e37c06690c0f530_G_5);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float2 _Multiply_5d4c3baed6515c8b86a289c70fca8f5d_Out_2;
            Unity_Multiply_float(_Vector2_65060e9a9f687a89b68e32dc876be645_Out_0, float2(2, 2), _Multiply_5d4c3baed6515c8b86a289c70fca8f5d_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float2 _Add_98b310e19c5fa5899c39cc45969c15ea_Out_2;
            Unity_Add_float2(_Multiply_5d4c3baed6515c8b86a289c70fca8f5d_Out_2, float2(-1, -1), _Add_98b310e19c5fa5899c39cc45969c15ea_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_08b99582093b36869beb5ea3d18e765d_Out_0 = _DetailNormalScale;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float2 _Multiply_bf0b80fdb3271784900e5b5ea4c5550f_Out_2;
            Unity_Multiply_float(_Add_98b310e19c5fa5899c39cc45969c15ea_Out_2, (_Property_08b99582093b36869beb5ea3d18e765d_Out_0.xx), _Multiply_bf0b80fdb3271784900e5b5ea4c5550f_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Split_26c1e73f8436c78ebdae5b51365a072b_R_1 = _Multiply_bf0b80fdb3271784900e5b5ea4c5550f_Out_2[0];
            float _Split_26c1e73f8436c78ebdae5b51365a072b_G_2 = _Multiply_bf0b80fdb3271784900e5b5ea4c5550f_Out_2[1];
            float _Split_26c1e73f8436c78ebdae5b51365a072b_B_3 = 0;
            float _Split_26c1e73f8436c78ebdae5b51365a072b_A_4 = 0;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _DotProduct_50aca3ce0da1ad849d7ff4a99df3a322_Out_2;
            Unity_DotProduct_float2(_Multiply_bf0b80fdb3271784900e5b5ea4c5550f_Out_2, _Multiply_bf0b80fdb3271784900e5b5ea4c5550f_Out_2, _DotProduct_50aca3ce0da1ad849d7ff4a99df3a322_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Saturate_491f2ee8417b8782aee83358b89eeb08_Out_1;
            Unity_Saturate_float(_DotProduct_50aca3ce0da1ad849d7ff4a99df3a322_Out_2, _Saturate_491f2ee8417b8782aee83358b89eeb08_Out_1);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _OneMinus_46ad3170d736808d98bf74ffa45e0414_Out_1;
            Unity_OneMinus_float(_Saturate_491f2ee8417b8782aee83358b89eeb08_Out_1, _OneMinus_46ad3170d736808d98bf74ffa45e0414_Out_1);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _SquareRoot_dfeae899ebfeae8f9257c340ca22ce38_Out_1;
            Unity_SquareRoot_float(_OneMinus_46ad3170d736808d98bf74ffa45e0414_Out_1, _SquareRoot_dfeae899ebfeae8f9257c340ca22ce38_Out_1);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 _Vector3_ed3f80ed87524e8c99f98b224af5a610_Out_0 = float3(_Split_26c1e73f8436c78ebdae5b51365a072b_R_1, _Split_26c1e73f8436c78ebdae5b51365a072b_G_2, _SquareRoot_dfeae899ebfeae8f9257c340ca22ce38_Out_1);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            UnityTexture2D _Property_2cc39234d3d334899f94126a216a50fc_Out_0 = UnityBuildTexture2DStructNoScale(_BaseNormalMap);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            Bindings_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8 _PlanarNMn_4fde70f39e45398dbb9972941e88e2bf;
            _PlanarNMn_4fde70f39e45398dbb9972941e88e2bf.WorldSpaceNormal = IN.WorldSpaceNormal;
            _PlanarNMn_4fde70f39e45398dbb9972941e88e2bf.WorldSpaceTangent = IN.WorldSpaceTangent;
            _PlanarNMn_4fde70f39e45398dbb9972941e88e2bf.WorldSpaceBiTangent = IN.WorldSpaceBiTangent;
            _PlanarNMn_4fde70f39e45398dbb9972941e88e2bf.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            _PlanarNMn_4fde70f39e45398dbb9972941e88e2bf.uv0 = IN.uv0;
            float4 _PlanarNMn_4fde70f39e45398dbb9972941e88e2bf_XZ_2;
            SG_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8(_Property_2cc39234d3d334899f94126a216a50fc_Out_0, _Property_115fcc827510f38798b214d835c27637_Out_0, _Property_d83b8f290862b285bbe2f157190e1315_Out_0, _PlanarNMn_4fde70f39e45398dbb9972941e88e2bf, _PlanarNMn_4fde70f39e45398dbb9972941e88e2bf_XZ_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_020d569f63e9a2849e23988ff74eb005_Out_0 = _BaseNormalScale;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 _NormalStrength_0c71fb166ae841839a0a12ecc5afa6fe_Out_2;
            Unity_NormalStrength_float((_PlanarNMn_4fde70f39e45398dbb9972941e88e2bf_XZ_2.xyz), _Property_020d569f63e9a2849e23988ff74eb005_Out_0, _NormalStrength_0c71fb166ae841839a0a12ecc5afa6fe_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 _NormalBlend_be36dd49bea74c8f8dd52fa3a85a9534_Out_2;
            Unity_NormalBlend_float(_Vector3_ed3f80ed87524e8c99f98b224af5a610_Out_0, _NormalStrength_0c71fb166ae841839a0a12ecc5afa6fe_Out_2, _NormalBlend_be36dd49bea74c8f8dd52fa3a85a9534_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            UnityTexture2D _Property_a383045772822c87acd099bb4cd6c478_Out_0 = UnityBuildTexture2DStructNoScale(_CoverNormalMap);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            Bindings_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8 _PlanarNMn_79abde32a0223a89907c9f09efac8db7;
            _PlanarNMn_79abde32a0223a89907c9f09efac8db7.WorldSpaceNormal = IN.WorldSpaceNormal;
            _PlanarNMn_79abde32a0223a89907c9f09efac8db7.WorldSpaceTangent = IN.WorldSpaceTangent;
            _PlanarNMn_79abde32a0223a89907c9f09efac8db7.WorldSpaceBiTangent = IN.WorldSpaceBiTangent;
            _PlanarNMn_79abde32a0223a89907c9f09efac8db7.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            _PlanarNMn_79abde32a0223a89907c9f09efac8db7.uv0 = IN.uv0;
            float4 _PlanarNMn_79abde32a0223a89907c9f09efac8db7_XZ_2;
            SG_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8(_Property_a383045772822c87acd099bb4cd6c478_Out_0, _Property_e35c79b8cccfbe8ca0a3c33e8d32e319_Out_0, _Property_e3d8b38b51331e879b1d4012d65f53e6_Out_0, _PlanarNMn_79abde32a0223a89907c9f09efac8db7, _PlanarNMn_79abde32a0223a89907c9f09efac8db7_XZ_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_c688e246111fd881820a97415e14d8a3_Out_0 = _CoverNormalBlendHardness;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 _NormalStrength_0e5e0831ba0e98878220ca6021ea52a2_Out_2;
            Unity_NormalStrength_float((_PlanarNMn_79abde32a0223a89907c9f09efac8db7_XZ_2.xyz), _Property_c688e246111fd881820a97415e14d8a3_Out_0, _NormalStrength_0e5e0831ba0e98878220ca6021ea52a2_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Split_8cadce726725318fbacd47f436a8231d_R_1 = IN.WorldSpaceNormal[0];
            float _Split_8cadce726725318fbacd47f436a8231d_G_2 = IN.WorldSpaceNormal[1];
            float _Split_8cadce726725318fbacd47f436a8231d_B_3 = IN.WorldSpaceNormal[2];
            float _Split_8cadce726725318fbacd47f436a8231d_A_4 = 0;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_ce4e5954a0b7ff8c819fa53963327595_Out_0 = _Cover_Amount;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_384059e6344fb98a85eccad78dd82f36_Out_0 = _Cover_Amount_Grow_Speed;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Subtract_70fd06876db7fa85b0cc0bce8d926dff_Out_2;
            Unity_Subtract_float(4, _Property_384059e6344fb98a85eccad78dd82f36_Out_0, _Subtract_70fd06876db7fa85b0cc0bce8d926dff_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Divide_1a3a6334c3d8bc8f8ac262c7833e15d5_Out_2;
            Unity_Divide_float(_Property_ce4e5954a0b7ff8c819fa53963327595_Out_0, _Subtract_70fd06876db7fa85b0cc0bce8d926dff_Out_2, _Divide_1a3a6334c3d8bc8f8ac262c7833e15d5_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Absolute_f218d2b85ebf288f91234faffedb5f7b_Out_1;
            Unity_Absolute_float(_Divide_1a3a6334c3d8bc8f8ac262c7833e15d5_Out_2, _Absolute_f218d2b85ebf288f91234faffedb5f7b_Out_1);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Power_a9b8d4b65c44a98e9813f61c0e2dc0a3_Out_2;
            Unity_Power_float(_Absolute_f218d2b85ebf288f91234faffedb5f7b_Out_1, _Subtract_70fd06876db7fa85b0cc0bce8d926dff_Out_2, _Power_a9b8d4b65c44a98e9813f61c0e2dc0a3_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Clamp_95d579f83746cb82be79cf6739990e0b_Out_3;
            Unity_Clamp_float(_Power_a9b8d4b65c44a98e9813f61c0e2dc0a3_Out_2, 0, 2, _Clamp_95d579f83746cb82be79cf6739990e0b_Out_3);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Multiply_02a8aa0fa6974e81aa84caba54f63896_Out_2;
            Unity_Multiply_float(_Split_8cadce726725318fbacd47f436a8231d_G_2, _Clamp_95d579f83746cb82be79cf6739990e0b_Out_3, _Multiply_02a8aa0fa6974e81aa84caba54f63896_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Saturate_ada5e8f9ebdcb38d8f5e61e8d97424b9_Out_1;
            Unity_Saturate_float(_Multiply_02a8aa0fa6974e81aa84caba54f63896_Out_2, _Saturate_ada5e8f9ebdcb38d8f5e61e8d97424b9_Out_1);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Clamp_38bac9e8ef351789b5fd4f2201f1df7b_Out_3;
            Unity_Clamp_float(_Split_8cadce726725318fbacd47f436a8231d_G_2, 0, 0.9999, _Clamp_38bac9e8ef351789b5fd4f2201f1df7b_Out_3);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_9babc76177853482826cae0163ffe988_Out_0 = _Cover_Max_Angle;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Divide_3b22550205905d8da5870f9db56e44ff_Out_2;
            Unity_Divide_float(_Property_9babc76177853482826cae0163ffe988_Out_0, 45, _Divide_3b22550205905d8da5870f9db56e44ff_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _OneMinus_99a85b6952a41288afc86da0a6ca6ea0_Out_1;
            Unity_OneMinus_float(_Divide_3b22550205905d8da5870f9db56e44ff_Out_2, _OneMinus_99a85b6952a41288afc86da0a6ca6ea0_Out_1);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Subtract_2b63f3aaee26f686971dca1d28da283c_Out_2;
            Unity_Subtract_float(_Clamp_38bac9e8ef351789b5fd4f2201f1df7b_Out_3, _OneMinus_99a85b6952a41288afc86da0a6ca6ea0_Out_1, _Subtract_2b63f3aaee26f686971dca1d28da283c_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Clamp_6bd9bb4add91fe8eb80a958a6b1a2d01_Out_3;
            Unity_Clamp_float(_Subtract_2b63f3aaee26f686971dca1d28da283c_Out_2, 0, 2, _Clamp_6bd9bb4add91fe8eb80a958a6b1a2d01_Out_3);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Divide_a09d2d461b07e98999aba746fb52a3fc_Out_2;
            Unity_Divide_float(1, _Divide_3b22550205905d8da5870f9db56e44ff_Out_2, _Divide_a09d2d461b07e98999aba746fb52a3fc_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Multiply_89a8f5a279c73b898d4ca5d075786b53_Out_2;
            Unity_Multiply_float(_Clamp_6bd9bb4add91fe8eb80a958a6b1a2d01_Out_3, _Divide_a09d2d461b07e98999aba746fb52a3fc_Out_2, _Multiply_89a8f5a279c73b898d4ca5d075786b53_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Absolute_f98ce5feb185a68784b9b35eb71ec465_Out_1;
            Unity_Absolute_float(_Multiply_89a8f5a279c73b898d4ca5d075786b53_Out_2, _Absolute_f98ce5feb185a68784b9b35eb71ec465_Out_1);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_27e768ffa9c13e8ab65d48e7712e5b66_Out_0 = _CoverHardness;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Power_b9fdc3921d5b85878a1ec4baa1975184_Out_2;
            Unity_Power_float(_Absolute_f98ce5feb185a68784b9b35eb71ec465_Out_1, _Property_27e768ffa9c13e8ab65d48e7712e5b66_Out_0, _Power_b9fdc3921d5b85878a1ec4baa1975184_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_c442c20fdade808b8e1b93cfd6625ab9_Out_0 = _Cover_Min_Height;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _OneMinus_55530ddc82048c8aa2d082334edf6a57_Out_1;
            Unity_OneMinus_float(_Property_c442c20fdade808b8e1b93cfd6625ab9_Out_0, _OneMinus_55530ddc82048c8aa2d082334edf6a57_Out_1);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Split_7e5d084c5e6bfa83a9203dac971ea31e_R_1 = IN.AbsoluteWorldSpacePosition[0];
            float _Split_7e5d084c5e6bfa83a9203dac971ea31e_G_2 = IN.AbsoluteWorldSpacePosition[1];
            float _Split_7e5d084c5e6bfa83a9203dac971ea31e_B_3 = IN.AbsoluteWorldSpacePosition[2];
            float _Split_7e5d084c5e6bfa83a9203dac971ea31e_A_4 = 0;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Add_e4067b215657d98ab6ec4e0295ddfece_Out_2;
            Unity_Add_float(_OneMinus_55530ddc82048c8aa2d082334edf6a57_Out_1, _Split_7e5d084c5e6bfa83a9203dac971ea31e_G_2, _Add_e4067b215657d98ab6ec4e0295ddfece_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Add_a4387dfc1ea3ee8da0b04f433a7c63d0_Out_2;
            Unity_Add_float(_Add_e4067b215657d98ab6ec4e0295ddfece_Out_2, 1, _Add_a4387dfc1ea3ee8da0b04f433a7c63d0_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Clamp_570e1129ecb02c8b8be79d85f19d5ae1_Out_3;
            Unity_Clamp_float(_Add_a4387dfc1ea3ee8da0b04f433a7c63d0_Out_2, 0, 1, _Clamp_570e1129ecb02c8b8be79d85f19d5ae1_Out_3);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_5da709b259ac268bb134d927bcffa4b8_Out_0 = _Cover_Min_Height_Blending;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Add_c322347d9ddbcd83ba52983e9316c387_Out_2;
            Unity_Add_float(_Add_e4067b215657d98ab6ec4e0295ddfece_Out_2, _Property_5da709b259ac268bb134d927bcffa4b8_Out_0, _Add_c322347d9ddbcd83ba52983e9316c387_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Divide_078ffa7d6c597f819511c95d33b7d90e_Out_2;
            Unity_Divide_float(_Add_c322347d9ddbcd83ba52983e9316c387_Out_2, _Add_e4067b215657d98ab6ec4e0295ddfece_Out_2, _Divide_078ffa7d6c597f819511c95d33b7d90e_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _OneMinus_b9f8edced35e7b8cab9ca581d822e31f_Out_1;
            Unity_OneMinus_float(_Divide_078ffa7d6c597f819511c95d33b7d90e_Out_2, _OneMinus_b9f8edced35e7b8cab9ca581d822e31f_Out_1);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Add_95cd1778448bfe8d9f9fa9129235f2c2_Out_2;
            Unity_Add_float(_OneMinus_b9f8edced35e7b8cab9ca581d822e31f_Out_1, -0.5, _Add_95cd1778448bfe8d9f9fa9129235f2c2_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Clamp_23e760e01b7e0780a71d88813b5828d7_Out_3;
            Unity_Clamp_float(_Add_95cd1778448bfe8d9f9fa9129235f2c2_Out_2, 0, 1, _Clamp_23e760e01b7e0780a71d88813b5828d7_Out_3);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Add_674fcef023d728848510150af810a103_Out_2;
            Unity_Add_float(_Clamp_570e1129ecb02c8b8be79d85f19d5ae1_Out_3, _Clamp_23e760e01b7e0780a71d88813b5828d7_Out_3, _Add_674fcef023d728848510150af810a103_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Clamp_5b677be9d499c082bcbe316853b0adff_Out_3;
            Unity_Clamp_float(_Add_674fcef023d728848510150af810a103_Out_2, 0, 1, _Clamp_5b677be9d499c082bcbe316853b0adff_Out_3);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Multiply_7ea7400ed65a3582b000796fb39748e9_Out_2;
            Unity_Multiply_float(_Power_b9fdc3921d5b85878a1ec4baa1975184_Out_2, _Clamp_5b677be9d499c082bcbe316853b0adff_Out_3, _Multiply_7ea7400ed65a3582b000796fb39748e9_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Multiply_4d295791f4e23186acea64f2f4de94ea_Out_2;
            Unity_Multiply_float(_Saturate_ada5e8f9ebdcb38d8f5e61e8d97424b9_Out_1, _Multiply_7ea7400ed65a3582b000796fb39748e9_Out_2, _Multiply_4d295791f4e23186acea64f2f4de94ea_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 _Lerp_21eaf65c617b2d858b3b33154d55757a_Out_3;
            Unity_Lerp_float3(_NormalBlend_be36dd49bea74c8f8dd52fa3a85a9534_Out_2, _NormalStrength_0e5e0831ba0e98878220ca6021ea52a2_Out_2, (_Multiply_4d295791f4e23186acea64f2f4de94ea_Out_2.xxx), _Lerp_21eaf65c617b2d858b3b33154d55757a_Out_3);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3x3 Transform_1e4c3a2d6240958ab6858efb88c1d06a_transposeTangent = transpose(float3x3(IN.WorldSpaceTangent, IN.WorldSpaceBiTangent, IN.WorldSpaceNormal));
            float3 _Transform_1e4c3a2d6240958ab6858efb88c1d06a_Out_1 = normalize(mul(Transform_1e4c3a2d6240958ab6858efb88c1d06a_transposeTangent, _Lerp_21eaf65c617b2d858b3b33154d55757a_Out_3.xyz).xyz);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Split_600a9d271d96798a94ab28118977defd_R_1 = _Transform_1e4c3a2d6240958ab6858efb88c1d06a_Out_1[0];
            float _Split_600a9d271d96798a94ab28118977defd_G_2 = _Transform_1e4c3a2d6240958ab6858efb88c1d06a_Out_1[1];
            float _Split_600a9d271d96798a94ab28118977defd_B_3 = _Transform_1e4c3a2d6240958ab6858efb88c1d06a_Out_1[2];
            float _Split_600a9d271d96798a94ab28118977defd_A_4 = 0;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Multiply_2e5b010626435f8492a2690396ced19d_Out_2;
            Unity_Multiply_float(_Split_600a9d271d96798a94ab28118977defd_G_2, _Clamp_95d579f83746cb82be79cf6739990e0b_Out_3, _Multiply_2e5b010626435f8492a2690396ced19d_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Multiply_5a2397e0153ddb8f9bd457d9a301dc8b_Out_2;
            Unity_Multiply_float(_Clamp_95d579f83746cb82be79cf6739990e0b_Out_3, _Property_27e768ffa9c13e8ab65d48e7712e5b66_Out_0, _Multiply_5a2397e0153ddb8f9bd457d9a301dc8b_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Multiply_3aad76eaff60dd888c3e1783ecf03943_Out_2;
            Unity_Multiply_float(_Multiply_5a2397e0153ddb8f9bd457d9a301dc8b_Out_2, _Multiply_7ea7400ed65a3582b000796fb39748e9_Out_2, _Multiply_3aad76eaff60dd888c3e1783ecf03943_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Multiply_05614e740451f18f8301586390aa5a0a_Out_2;
            Unity_Multiply_float(_Multiply_2e5b010626435f8492a2690396ced19d_Out_2, _Multiply_3aad76eaff60dd888c3e1783ecf03943_Out_2, _Multiply_05614e740451f18f8301586390aa5a0a_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            UnityTexture2D _Property_a14f2476a35d208b988233c852f919ef_Out_0 = UnityBuildTexture2DStructNoScale(_CoverMaskMap);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            Bindings_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6 _PlanarNM_6858a0e821f26a8d87846d325e9bd170;
            _PlanarNM_6858a0e821f26a8d87846d325e9bd170.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            _PlanarNM_6858a0e821f26a8d87846d325e9bd170.uv0 = IN.uv0;
            float4 _PlanarNM_6858a0e821f26a8d87846d325e9bd170_XZ_2;
            SG_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6(_Property_a14f2476a35d208b988233c852f919ef_Out_0, _Property_e35c79b8cccfbe8ca0a3c33e8d32e319_Out_0, _Property_e3d8b38b51331e879b1d4012d65f53e6_Out_0, _PlanarNM_6858a0e821f26a8d87846d325e9bd170, _PlanarNM_6858a0e821f26a8d87846d325e9bd170_XZ_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Split_16313c20ccdeaa86a639068877a69a2f_R_1 = _PlanarNM_6858a0e821f26a8d87846d325e9bd170_XZ_2[0];
            float _Split_16313c20ccdeaa86a639068877a69a2f_G_2 = _PlanarNM_6858a0e821f26a8d87846d325e9bd170_XZ_2[1];
            float _Split_16313c20ccdeaa86a639068877a69a2f_B_3 = _PlanarNM_6858a0e821f26a8d87846d325e9bd170_XZ_2[2];
            float _Split_16313c20ccdeaa86a639068877a69a2f_A_4 = _PlanarNM_6858a0e821f26a8d87846d325e9bd170_XZ_2[3];
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_673896519f419589938b37e782b90141_Out_0 = _CoverHeightMapMin;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_c35906332422438da3b19f45cbd5ac17_Out_0 = _CoverHeightMapMax;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float2 _Vector2_81cbe1e5ea789e8697223cd3bfbca76c_Out_0 = float2(_Property_673896519f419589938b37e782b90141_Out_0, _Property_c35906332422438da3b19f45cbd5ac17_Out_0);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_88ab0068f899fc8ba94efdaec5e8966b_Out_0 = _CoverHeightMapOffset;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float2 _Add_cd623e3135271489b0d45b4d7edc5f7e_Out_2;
            Unity_Add_float2(_Vector2_81cbe1e5ea789e8697223cd3bfbca76c_Out_0, (_Property_88ab0068f899fc8ba94efdaec5e8966b_Out_0.xx), _Add_cd623e3135271489b0d45b4d7edc5f7e_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Remap_9a23d5f76fa8c38dbd73f43bd6397b0b_Out_3;
            Unity_Remap_float(_Split_16313c20ccdeaa86a639068877a69a2f_B_3, float2 (0, 1), _Add_cd623e3135271489b0d45b4d7edc5f7e_Out_2, _Remap_9a23d5f76fa8c38dbd73f43bd6397b0b_Out_3);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Multiply_0093be0fd848498b89a0fa282608e715_Out_2;
            Unity_Multiply_float(_Multiply_05614e740451f18f8301586390aa5a0a_Out_2, _Remap_9a23d5f76fa8c38dbd73f43bd6397b0b_Out_3, _Multiply_0093be0fd848498b89a0fa282608e715_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Multiply_d3190f97afd0398083623ecf71a41b1a_Out_2;
            Unity_Multiply_float(_Split_8ba5b67899f36b8f9dcf5c84092c0560_G_2, _Multiply_0093be0fd848498b89a0fa282608e715_Out_2, _Multiply_d3190f97afd0398083623ecf71a41b1a_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Saturate_cbcee34e7e6e6d8091d840550ab1c74a_Out_1;
            Unity_Saturate_float(_Multiply_d3190f97afd0398083623ecf71a41b1a_Out_2, _Saturate_cbcee34e7e6e6d8091d840550ab1c74a_Out_1);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Multiply_da35b9d9e4dd8c81871a9aea42c157ee_Out_2;
            Unity_Multiply_float(_Clamp_030a7c32684c258084338456eaddc77a_Out_3, _Saturate_cbcee34e7e6e6d8091d840550ab1c74a_Out_1, _Multiply_da35b9d9e4dd8c81871a9aea42c157ee_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Clamp_c95f5515948375878df6581a36d8b203_Out_3;
            Unity_Clamp_float(_Multiply_da35b9d9e4dd8c81871a9aea42c157ee_Out_2, 0, 1, _Clamp_c95f5515948375878df6581a36d8b203_Out_3);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            #if defined(_USEDYNAMICCOVERTSTATICMASKF_ON)
            float _UseDynamicCoverTStaticMaskF_0694902516172b8fa469c5d8b8e938c6_Out_0 = _Clamp_c95f5515948375878df6581a36d8b203_Out_3;
            #else
            float _UseDynamicCoverTStaticMaskF_0694902516172b8fa469c5d8b8e938c6_Out_0 = _Clamp_030a7c32684c258084338456eaddc77a_Out_3;
            #endif
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 _Lerp_87882219e20a6d818c0de017d739125f_Out_3;
            Unity_Lerp_float3(_BlendOverlayBaseColor_f3cd25d5b673648eb831a3f388201f73_OutVector4_1, (_Multiply_2eb83c7af5b6f58eabeec7b502517470_Out_2.xyz), (_UseDynamicCoverTStaticMaskF_0694902516172b8fa469c5d8b8e938c6_Out_0.xxx), _Lerp_87882219e20a6d818c0de017d739125f_Out_3);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 _Property_4c7bd3690d9d8a838e2524f5908e09ee_Out_0 = _WetColor;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 _Multiply_77c751a5503e948d8952b403163b4eeb_Out_2;
            Unity_Multiply_float((_Property_4c7bd3690d9d8a838e2524f5908e09ee_Out_0.xyz), _Lerp_87882219e20a6d818c0de017d739125f_Out_3, _Multiply_77c751a5503e948d8952b403163b4eeb_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _OneMinus_9b165e3f6c2fdd88a5f3a51230f8dd33_Out_1;
            Unity_OneMinus_float(_Split_8ba5b67899f36b8f9dcf5c84092c0560_R_1, _OneMinus_9b165e3f6c2fdd88a5f3a51230f8dd33_Out_1);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 _Lerp_538fa3f69b550a8bbe8ee20906ecc752_Out_3;
            Unity_Lerp_float3(_Lerp_87882219e20a6d818c0de017d739125f_Out_3, _Multiply_77c751a5503e948d8952b403163b4eeb_Out_2, (_OneMinus_9b165e3f6c2fdd88a5f3a51230f8dd33_Out_1.xxx), _Lerp_538fa3f69b550a8bbe8ee20906ecc752_Out_3);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Split_31874fa1d55cb28e99a1333cf254676a_R_1 = _PlanarNM_6c8b686076db2a8c8b7d6cd91cf435f0_XZ_2[0];
            float _Split_31874fa1d55cb28e99a1333cf254676a_G_2 = _PlanarNM_6c8b686076db2a8c8b7d6cd91cf435f0_XZ_2[1];
            float _Split_31874fa1d55cb28e99a1333cf254676a_B_3 = _PlanarNM_6c8b686076db2a8c8b7d6cd91cf435f0_XZ_2[2];
            float _Split_31874fa1d55cb28e99a1333cf254676a_A_4 = _PlanarNM_6c8b686076db2a8c8b7d6cd91cf435f0_XZ_2[3];
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_881c341218ea2d81819695b0c7ddc4cb_Out_0 = _AlphaCutoff;
            #endif
            surface.BaseColor = _Lerp_538fa3f69b550a8bbe8ee20906ecc752_Out_3;
            surface.Emission = float3(0, 0, 0);
            surface.Alpha = _Split_31874fa1d55cb28e99a1333cf254676a_A_4;
            surface.AlphaClipThreshold = _Property_881c341218ea2d81819695b0c7ddc4cb_Out_0;
            return surface;
        }

            // --------------------------------------------------
            // Build Graph Inputs

            VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.ObjectSpaceNormal =           input.normalOS;
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.ObjectSpaceTangent =          input.tangentOS.xyz;
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.ObjectSpacePosition =         input.positionOS;
        #endif


            return output;
        }
            SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        // must use interpolated tangent, bitangent and normal before they are normalized in the pixel shader.
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        float3 unnormalizedNormalWS = input.normalWS;
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        const float renormFactor = 1.0 / length(unnormalizedNormalWS);
        #endif


        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        // use bitangent on the fly like in hdrp
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        // IMPORTANT! If we ever support Flip on double sided materials ensure bitangent and tangent are NOT flipped.
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        float crossSign = (input.tangentWS.w > 0.0 ? 1.0 : -1.0) * GetOddNegativeScale();
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        float3 bitang = crossSign * cross(input.normalWS.xyz, input.tangentWS.xyz);
        #endif


        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.WorldSpaceNormal =            renormFactor*input.normalWS.xyz;      // we want a unit length Normal Vector node in shader graph
        #endif


        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        // to preserve mikktspace compliance we use same scale renormFactor as was used on the normal.
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        // This is explained in section 2.2 in "surface gradient based bump mapping framework"
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.WorldSpaceTangent =           renormFactor*input.tangentWS.xyz;
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.WorldSpaceBiTangent =         renormFactor*bitang;
        #endif


        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.AbsoluteWorldSpacePosition =  GetAbsolutePositionWS(input.positionWS);
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.uv0 =                         input.texCoord0;
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.VertexColor =                 input.color;
        #endif

        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN

            return output;
        }

            // --------------------------------------------------
            // Main

            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/LightingMetaPass.hlsl"

            ENDHLSL
        }
        Pass
        {
            // Name: <None>
            Tags
            {
                "LightMode" = "Universal2D"
            }

            // Render State
            Cull Back
        Blend One Zero
        ZTest LEqual
        ZWrite On

            // Debug
            // <None>

            // --------------------------------------------------
            // Pass

            HLSLPROGRAM

            // Pragmas
            #pragma target 4.5
        #pragma exclude_renderers gles gles3 glcore
        #pragma vertex vert
        #pragma fragment frag

            // DotsInstancingOptions: <None>
            // HybridV1InjectedBuiltinProperties: <None>

            // Keywords
            // PassKeywords: <None>
            #pragma shader_feature_local _ _USEDYNAMICCOVERTSTATICMASKF_ON

        #if defined(_USEDYNAMICCOVERTSTATICMASKF_ON)
            #define KEYWORD_PERMUTATION_0
        #else
            #define KEYWORD_PERMUTATION_1
        #endif


            // Defines
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define _AlphaClip 1
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define _NORMALMAP 1
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define _NORMAL_DROPOFF_TS 1
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define ATTRIBUTES_NEED_NORMAL
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define ATTRIBUTES_NEED_TANGENT
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define ATTRIBUTES_NEED_TEXCOORD0
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define ATTRIBUTES_NEED_COLOR
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define VARYINGS_NEED_POSITION_WS
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define VARYINGS_NEED_NORMAL_WS
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define VARYINGS_NEED_TANGENT_WS
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define VARYINGS_NEED_TEXCOORD0
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define VARYINGS_NEED_COLOR
        #endif

            #define FEATURES_GRAPH_VERTEX
            /* WARNING: $splice Could not find named fragment 'PassInstancing' */
            #define SHADERPASS SHADERPASS_2D
            /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */

            // Includes
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"

            // --------------------------------------------------
            // Structs and Packing

            struct Attributes
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 positionOS : POSITION;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 normalOS : NORMAL;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 tangentOS : TANGENT;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 uv0 : TEXCOORD0;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 color : COLOR;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            uint instanceID : INSTANCEID_SEMANTIC;
            #endif
            #endif
        };
        struct Varyings
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 positionCS : SV_POSITION;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 positionWS;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 normalWS;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 tangentWS;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 texCoord0;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 color;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
            #endif
        };
        struct SurfaceDescriptionInputs
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 WorldSpaceNormal;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 WorldSpaceTangent;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 WorldSpaceBiTangent;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 AbsoluteWorldSpacePosition;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 uv0;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 VertexColor;
            #endif
        };
        struct VertexDescriptionInputs
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 ObjectSpaceNormal;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 ObjectSpaceTangent;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 ObjectSpacePosition;
            #endif
        };
        struct PackedVaryings
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 positionCS : SV_POSITION;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 interp0 : TEXCOORD0;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 interp1 : TEXCOORD1;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 interp2 : TEXCOORD2;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 interp3 : TEXCOORD3;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 interp4 : TEXCOORD4;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
            #endif
        };

            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            output.positionCS = input.positionCS;
            output.interp0.xyz =  input.positionWS;
            output.interp1.xyz =  input.normalWS;
            output.interp2.xyzw =  input.tangentWS;
            output.interp3.xyzw =  input.texCoord0;
            output.interp4.xyzw =  input.color;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.positionWS = input.interp0.xyz;
            output.normalWS = input.interp1.xyz;
            output.tangentWS = input.interp2.xyzw;
            output.texCoord0 = input.interp3.xyzw;
            output.color = input.interp4.xyzw;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        #endif

            // --------------------------------------------------
            // Graph

            // Graph Properties
            CBUFFER_START(UnityPerMaterial)
        float _AlphaCutoff;
        float4 _BaseColor;
        float4 _BaseColorMap_TexelSize;
        float _BaseUsePlanarUV;
        float4 _BaseTilingOffset;
        float4 _BaseNormalMap_TexelSize;
        float _BaseNormalScale;
        float4 _BaseMaskMap_TexelSize;
        float _BaseMetallic;
        float _BaseAORemapMin;
        float _BaseAORemapMax;
        float _BaseSmoothnessRemapMin;
        float _BaseSmoothnessRemapMax;
        float4 _CoverMaskA_TexelSize;
        float _CoverMaskPower;
        float _Cover_Amount;
        float _Cover_Amount_Grow_Speed;
        float _Cover_Max_Angle;
        float _Cover_Min_Height;
        float _Cover_Min_Height_Blending;
        float4 _CoverBaseColor;
        float4 _CoverBaseColorMap_TexelSize;
        float _CoverUsePlanarUV;
        float4 _CoverTilingOffset;
        float4 _CoverNormalMap_TexelSize;
        float _CoverNormalScale;
        float _CoverNormalBlendHardness;
        float _CoverHardness;
        float _CoverHeightMapMin;
        float _CoverHeightMapMax;
        float _CoverHeightMapOffset;
        float4 _CoverMaskMap_TexelSize;
        float _CoverMetallic;
        float _CoverAORemapMin;
        float _CoverAORemapMax;
        float _CoverSmoothnessRemapMin;
        float _CoverSmoothnessRemapMax;
        float4 _DetailMap_TexelSize;
        float4 _DetailTilingOffset;
        float _DetailAlbedoScale;
        float _DetailNormalScale;
        float _DetailSmoothnessScale;
        float4 _WetColor;
        float _WetSmoothness;
        CBUFFER_END

        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_BaseColorMap);
        SAMPLER(sampler_BaseColorMap);
        TEXTURE2D(_BaseNormalMap);
        SAMPLER(sampler_BaseNormalMap);
        TEXTURE2D(_BaseMaskMap);
        SAMPLER(sampler_BaseMaskMap);
        TEXTURE2D(_CoverMaskA);
        SAMPLER(sampler_CoverMaskA);
        TEXTURE2D(_CoverBaseColorMap);
        SAMPLER(sampler_CoverBaseColorMap);
        TEXTURE2D(_CoverNormalMap);
        SAMPLER(sampler_CoverNormalMap);
        TEXTURE2D(_CoverMaskMap);
        SAMPLER(sampler_CoverMaskMap);
        TEXTURE2D(_DetailMap);
        SAMPLER(sampler_DetailMap);

            // Graph Functions
            
        // f948cdce565a6e706cc57cb23fbf9d95
        #include "./NM_Object_VSPro_Indirect.cginc"

        void AddPragma_float(float3 A, out float3 Out){
            #pragma instancing_options renderinglayer procedural:setupVSPro
            Out = A;
        }

        struct Bindings_NMObjectVSProIndirect_0cfe1e4f145944241ab304331e53c93b
        {
        };

        void SG_NMObjectVSProIndirect_0cfe1e4f145944241ab304331e53c93b(float3 Vector3_314C8600, Bindings_NMObjectVSProIndirect_0cfe1e4f145944241ab304331e53c93b IN, out float3 ObjectSpacePosition_1)
        {
            float3 _Property_5ec158abd968858c9d31ab40df5e9e6f_Out_0 = Vector3_314C8600;
            float3 _InjectSetupCustomFunction_dec9b26544b4a788b8ecb4117dc3d24a_Out_1;
            InjectSetup_float(_Property_5ec158abd968858c9d31ab40df5e9e6f_Out_0, _InjectSetupCustomFunction_dec9b26544b4a788b8ecb4117dc3d24a_Out_1);
            float3 _AddPragmaCustomFunction_b2a053178906d0848480a1f463521a1b_Out_1;
            AddPragma_float(_InjectSetupCustomFunction_dec9b26544b4a788b8ecb4117dc3d24a_Out_1, _AddPragmaCustomFunction_b2a053178906d0848480a1f463521a1b_Out_1);
            ObjectSpacePosition_1 = _AddPragmaCustomFunction_b2a053178906d0848480a1f463521a1b_Out_1;
        }

        void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
        {
            RGBA = float4(R, G, B, A);
            RGB = float3(R, G, B);
            RG = float2(R, G);
        }

        void Unity_Divide_float(float A, float B, out float Out)
        {
            Out = A / B;
        }

        void Unity_Multiply_float(float4 A, float4 B, out float4 Out)
        {
            Out = A * B;
        }

        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }

        void Unity_Branch_float2(float Predicate, float2 True, float2 False, out float2 Out)
        {
            Out = Predicate ? True : False;
        }

        struct Bindings_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6
        {
            float3 AbsoluteWorldSpacePosition;
            half4 uv0;
        };

        void SG_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6(UnityTexture2D Texture2D_80A3D28F, float4 Vector4_2EBA7A3B, float Boolean_7ABB9909, Bindings_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6 IN, out float4 XZ_2)
        {
            UnityTexture2D _Property_3e01b4d2fc68d48ba3acbba9d5881e59_Out_0 = Texture2D_80A3D28F;
            float _Property_30834f691775a0898a45b1c868520436_Out_0 = Boolean_7ABB9909;
            float _Split_89ed63cb625cb3878c183d0b71c03400_R_1 = IN.AbsoluteWorldSpacePosition[0];
            float _Split_89ed63cb625cb3878c183d0b71c03400_G_2 = IN.AbsoluteWorldSpacePosition[1];
            float _Split_89ed63cb625cb3878c183d0b71c03400_B_3 = IN.AbsoluteWorldSpacePosition[2];
            float _Split_89ed63cb625cb3878c183d0b71c03400_A_4 = 0;
            float4 _Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4;
            float3 _Combine_cf2d04ff119ad88493f6460431765cbb_RGB_5;
            float2 _Combine_cf2d04ff119ad88493f6460431765cbb_RG_6;
            Unity_Combine_float(_Split_89ed63cb625cb3878c183d0b71c03400_R_1, _Split_89ed63cb625cb3878c183d0b71c03400_B_3, 0, 0, _Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4, _Combine_cf2d04ff119ad88493f6460431765cbb_RGB_5, _Combine_cf2d04ff119ad88493f6460431765cbb_RG_6);
            float4 _Property_8a66888ec47d0687ab1cb2f8abdc9da8_Out_0 = Vector4_2EBA7A3B;
            float _Split_2f0f52f6ef8c0e81af0da6476402bc1f_R_1 = _Property_8a66888ec47d0687ab1cb2f8abdc9da8_Out_0[0];
            float _Split_2f0f52f6ef8c0e81af0da6476402bc1f_G_2 = _Property_8a66888ec47d0687ab1cb2f8abdc9da8_Out_0[1];
            float _Split_2f0f52f6ef8c0e81af0da6476402bc1f_B_3 = _Property_8a66888ec47d0687ab1cb2f8abdc9da8_Out_0[2];
            float _Split_2f0f52f6ef8c0e81af0da6476402bc1f_A_4 = _Property_8a66888ec47d0687ab1cb2f8abdc9da8_Out_0[3];
            float _Divide_e64179199923c58289b6aa94ea6c9178_Out_2;
            Unity_Divide_float(1, _Split_2f0f52f6ef8c0e81af0da6476402bc1f_R_1, _Divide_e64179199923c58289b6aa94ea6c9178_Out_2);
            float4 _Multiply_14cec4902d0a00829e4555071a1b8ad1_Out_2;
            Unity_Multiply_float(_Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4, (_Divide_e64179199923c58289b6aa94ea6c9178_Out_2.xxxx), _Multiply_14cec4902d0a00829e4555071a1b8ad1_Out_2);
            float2 _Vector2_16c15d3bbdd14b85bd48e3a6cb318af7_Out_0 = float2(_Split_2f0f52f6ef8c0e81af0da6476402bc1f_R_1, _Split_2f0f52f6ef8c0e81af0da6476402bc1f_G_2);
            float2 _Vector2_f8d75f54e7705083bbec539a60185577_Out_0 = float2(_Split_2f0f52f6ef8c0e81af0da6476402bc1f_B_3, _Split_2f0f52f6ef8c0e81af0da6476402bc1f_A_4);
            float2 _TilingAndOffset_d91e2d25acd34686b562b7fe7e9d1d27_Out_3;
            Unity_TilingAndOffset_float(IN.uv0.xy, _Vector2_16c15d3bbdd14b85bd48e3a6cb318af7_Out_0, _Vector2_f8d75f54e7705083bbec539a60185577_Out_0, _TilingAndOffset_d91e2d25acd34686b562b7fe7e9d1d27_Out_3);
            float2 _Branch_8e5a4e8f4d52fc8aadd1f46485afc933_Out_3;
            Unity_Branch_float2(_Property_30834f691775a0898a45b1c868520436_Out_0, (_Multiply_14cec4902d0a00829e4555071a1b8ad1_Out_2.xy), _TilingAndOffset_d91e2d25acd34686b562b7fe7e9d1d27_Out_3, _Branch_8e5a4e8f4d52fc8aadd1f46485afc933_Out_3);
            float4 _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0 = SAMPLE_TEXTURE2D(_Property_3e01b4d2fc68d48ba3acbba9d5881e59_Out_0.tex, _Property_3e01b4d2fc68d48ba3acbba9d5881e59_Out_0.samplerstate, _Branch_8e5a4e8f4d52fc8aadd1f46485afc933_Out_3);
            float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_R_4 = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0.r;
            float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_G_5 = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0.g;
            float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_B_6 = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0.b;
            float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_A_7 = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0.a;
            XZ_2 = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0;
        }

        void Unity_Multiply_float(float A, float B, out float Out)
        {
            Out = A * B;
        }

        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
        }

        void Unity_Saturate_float(float In, out float Out)
        {
            Out = saturate(In);
        }

        void Unity_Absolute_float(float In, out float Out)
        {
            Out = abs(In);
        }

        void Unity_SquareRoot_float4(float4 In, out float4 Out)
        {
            Out = sqrt(In);
        }

        void Unity_Sign_float(float In, out float Out)
        {
            Out = sign(In);
        }

        void Unity_Ceiling_float(float In, out float Out)
        {
            Out = ceil(In);
        }

        void Unity_Lerp_float4(float4 A, float4 B, float4 T, out float4 Out)
        {
            Out = lerp(A, B, T);
        }

        struct Bindings_BlendOverlayBaseColor_acdb3dfca72bd6b42bbc35f4613331a2
        {
        };

        void SG_BlendOverlayBaseColor_acdb3dfca72bd6b42bbc35f4613331a2(float4 Color_9AA111D3, float Vector1_FBE622A2, float Vector1_8C15C351, Bindings_BlendOverlayBaseColor_acdb3dfca72bd6b42bbc35f4613331a2 IN, out float3 OutVector4_1)
        {
            float4 _Property_012510d774fb7f8b860f5270dca4500f_Out_0 = Color_9AA111D3;
            float4 _SquareRoot_c2c57d0223a9538aa9240890c3cacb0c_Out_1;
            Unity_SquareRoot_float4(_Property_012510d774fb7f8b860f5270dca4500f_Out_0, _SquareRoot_c2c57d0223a9538aa9240890c3cacb0c_Out_1);
            float _Property_a00e29241d12f983b30177515b367ec9_Out_0 = Vector1_FBE622A2;
            float _Sign_343a45ede7349283a681c6bd9998fd8e_Out_1;
            Unity_Sign_float(_Property_a00e29241d12f983b30177515b367ec9_Out_0, _Sign_343a45ede7349283a681c6bd9998fd8e_Out_1);
            float _Add_681019b8f5d3d68bb482d419c9fc61a9_Out_2;
            Unity_Add_float(_Sign_343a45ede7349283a681c6bd9998fd8e_Out_1, 1, _Add_681019b8f5d3d68bb482d419c9fc61a9_Out_2);
            float _Multiply_e8f4cb722712a880ac0db6c7461427f7_Out_2;
            Unity_Multiply_float(_Add_681019b8f5d3d68bb482d419c9fc61a9_Out_2, 0.5, _Multiply_e8f4cb722712a880ac0db6c7461427f7_Out_2);
            float _Ceiling_95ad15988aa9b98184875fa754feae01_Out_1;
            Unity_Ceiling_float(_Multiply_e8f4cb722712a880ac0db6c7461427f7_Out_2, _Ceiling_95ad15988aa9b98184875fa754feae01_Out_1);
            float _Property_2db1c747a05ee284a8b00076062f91a4_Out_0 = Vector1_8C15C351;
            float _Multiply_9564ecda5193bc8286d9ff771c9226cd_Out_2;
            Unity_Multiply_float(_Property_2db1c747a05ee284a8b00076062f91a4_Out_0, _Property_2db1c747a05ee284a8b00076062f91a4_Out_0, _Multiply_9564ecda5193bc8286d9ff771c9226cd_Out_2);
            float4 _Lerp_b3cdb01fc3c5b988ac9b184943bf7c01_Out_3;
            Unity_Lerp_float4(_SquareRoot_c2c57d0223a9538aa9240890c3cacb0c_Out_1, (_Ceiling_95ad15988aa9b98184875fa754feae01_Out_1.xxxx), (_Multiply_9564ecda5193bc8286d9ff771c9226cd_Out_2.xxxx), _Lerp_b3cdb01fc3c5b988ac9b184943bf7c01_Out_3);
            float4 _Multiply_39d1daff98488f8ea2cd794ad4f20926_Out_2;
            Unity_Multiply_float(_Lerp_b3cdb01fc3c5b988ac9b184943bf7c01_Out_3, _Lerp_b3cdb01fc3c5b988ac9b184943bf7c01_Out_3, _Multiply_39d1daff98488f8ea2cd794ad4f20926_Out_2);
            OutVector4_1 = (_Multiply_39d1daff98488f8ea2cd794ad4f20926_Out_2.xyz);
        }

        void Unity_Clamp_float(float In, float Min, float Max, out float Out)
        {
            Out = clamp(In, Min, Max);
        }

        void Unity_Multiply_float(float2 A, float2 B, out float2 Out)
        {
            Out = A * B;
        }

        void Unity_Add_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A + B;
        }

        void Unity_DotProduct_float2(float2 A, float2 B, out float Out)
        {
            Out = dot(A, B);
        }

        void Unity_OneMinus_float(float In, out float Out)
        {
            Out = 1 - In;
        }

        void Unity_SquareRoot_float(float In, out float Out)
        {
            Out = sqrt(In);
        }

        void Unity_Sign_float3(float3 In, out float3 Out)
        {
            Out = sign(In);
        }

        void Unity_Normalize_float3(float3 In, out float3 Out)
        {
            Out = normalize(In);
        }

        void Unity_Branch_float3(float Predicate, float3 True, float3 False, out float3 Out)
        {
            Out = Predicate ? True : False;
        }

        struct Bindings_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8
        {
            float3 WorldSpaceNormal;
            float3 WorldSpaceTangent;
            float3 WorldSpaceBiTangent;
            float3 AbsoluteWorldSpacePosition;
            half4 uv0;
        };

        void SG_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8(UnityTexture2D Texture2D_80A3D28F, float4 Vector4_82674548, float Boolean_9FF42DF6, Bindings_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8 IN, out float4 XZ_2)
        {
            float _Property_1ef12cf3201a938993fe6a7951b0e754_Out_0 = Boolean_9FF42DF6;
            UnityTexture2D _Property_3e01b4d2fc68d48ba3acbba9d5881e59_Out_0 = Texture2D_80A3D28F;
            float _Split_89ed63cb625cb3878c183d0b71c03400_R_1 = IN.AbsoluteWorldSpacePosition[0];
            float _Split_89ed63cb625cb3878c183d0b71c03400_G_2 = IN.AbsoluteWorldSpacePosition[1];
            float _Split_89ed63cb625cb3878c183d0b71c03400_B_3 = IN.AbsoluteWorldSpacePosition[2];
            float _Split_89ed63cb625cb3878c183d0b71c03400_A_4 = 0;
            float4 _Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4;
            float3 _Combine_cf2d04ff119ad88493f6460431765cbb_RGB_5;
            float2 _Combine_cf2d04ff119ad88493f6460431765cbb_RG_6;
            Unity_Combine_float(_Split_89ed63cb625cb3878c183d0b71c03400_R_1, _Split_89ed63cb625cb3878c183d0b71c03400_B_3, 0, 0, _Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4, _Combine_cf2d04ff119ad88493f6460431765cbb_RGB_5, _Combine_cf2d04ff119ad88493f6460431765cbb_RG_6);
            float4 _Property_3fa1d6f912feb481ba60f2e55e62e746_Out_0 = Vector4_82674548;
            float _Split_a2e12fa5931da084b2949343a539dfd8_R_1 = _Property_3fa1d6f912feb481ba60f2e55e62e746_Out_0[0];
            float _Split_a2e12fa5931da084b2949343a539dfd8_G_2 = _Property_3fa1d6f912feb481ba60f2e55e62e746_Out_0[1];
            float _Split_a2e12fa5931da084b2949343a539dfd8_B_3 = _Property_3fa1d6f912feb481ba60f2e55e62e746_Out_0[2];
            float _Split_a2e12fa5931da084b2949343a539dfd8_A_4 = _Property_3fa1d6f912feb481ba60f2e55e62e746_Out_0[3];
            float _Divide_c36b770dfaa0bb8f85ab27da5fd794f0_Out_2;
            Unity_Divide_float(1, _Split_a2e12fa5931da084b2949343a539dfd8_R_1, _Divide_c36b770dfaa0bb8f85ab27da5fd794f0_Out_2);
            float4 _Multiply_14cec4902d0a00829e4555071a1b8ad1_Out_2;
            Unity_Multiply_float(_Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4, (_Divide_c36b770dfaa0bb8f85ab27da5fd794f0_Out_2.xxxx), _Multiply_14cec4902d0a00829e4555071a1b8ad1_Out_2);
            float2 _Vector2_6845d21872714d889783b0cb707df3e9_Out_0 = float2(_Split_a2e12fa5931da084b2949343a539dfd8_R_1, _Split_a2e12fa5931da084b2949343a539dfd8_G_2);
            float2 _Vector2_e2e2263627c6098e96a5b5d29350ad03_Out_0 = float2(_Split_a2e12fa5931da084b2949343a539dfd8_B_3, _Split_a2e12fa5931da084b2949343a539dfd8_A_4);
            float2 _TilingAndOffset_17582d056c0b8a8dab1017d37497fe59_Out_3;
            Unity_TilingAndOffset_float(IN.uv0.xy, _Vector2_6845d21872714d889783b0cb707df3e9_Out_0, _Vector2_e2e2263627c6098e96a5b5d29350ad03_Out_0, _TilingAndOffset_17582d056c0b8a8dab1017d37497fe59_Out_3);
            float2 _Branch_1e152f3aac57448f8518bf2852c000c3_Out_3;
            Unity_Branch_float2(_Property_1ef12cf3201a938993fe6a7951b0e754_Out_0, (_Multiply_14cec4902d0a00829e4555071a1b8ad1_Out_2.xy), _TilingAndOffset_17582d056c0b8a8dab1017d37497fe59_Out_3, _Branch_1e152f3aac57448f8518bf2852c000c3_Out_3);
            float4 _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0 = SAMPLE_TEXTURE2D(_Property_3e01b4d2fc68d48ba3acbba9d5881e59_Out_0.tex, _Property_3e01b4d2fc68d48ba3acbba9d5881e59_Out_0.samplerstate, _Branch_1e152f3aac57448f8518bf2852c000c3_Out_3);
            _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0.rgb = UnpackNormal(_SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0);
            float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_R_4 = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0.r;
            float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_G_5 = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0.g;
            float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_B_6 = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0.b;
            float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_A_7 = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0.a;
            float2 _Vector2_ad6bd100e273d78fa409a30a77bfa2cc_Out_0 = float2(_SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_R_4, _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_G_5);
            float3 _Sign_3a6ebf59931cf08cb0482e0144ddac24_Out_1;
            Unity_Sign_float3(IN.WorldSpaceNormal, _Sign_3a6ebf59931cf08cb0482e0144ddac24_Out_1);
            float _Split_6299d4ddcc4c74828aea40a46fdb896e_R_1 = _Sign_3a6ebf59931cf08cb0482e0144ddac24_Out_1[0];
            float _Split_6299d4ddcc4c74828aea40a46fdb896e_G_2 = _Sign_3a6ebf59931cf08cb0482e0144ddac24_Out_1[1];
            float _Split_6299d4ddcc4c74828aea40a46fdb896e_B_3 = _Sign_3a6ebf59931cf08cb0482e0144ddac24_Out_1[2];
            float _Split_6299d4ddcc4c74828aea40a46fdb896e_A_4 = 0;
            float2 _Vector2_b76cb1842101e58b9e636d49b075c612_Out_0 = float2(_Split_6299d4ddcc4c74828aea40a46fdb896e_G_2, 1);
            float2 _Multiply_31e8db88ee20c985a9850d1a58f3282b_Out_2;
            Unity_Multiply_float(_Vector2_ad6bd100e273d78fa409a30a77bfa2cc_Out_0, _Vector2_b76cb1842101e58b9e636d49b075c612_Out_0, _Multiply_31e8db88ee20c985a9850d1a58f3282b_Out_2);
            float _Split_5ed44bf2eca0868f81eb18100f49d1fa_R_1 = IN.WorldSpaceNormal[0];
            float _Split_5ed44bf2eca0868f81eb18100f49d1fa_G_2 = IN.WorldSpaceNormal[1];
            float _Split_5ed44bf2eca0868f81eb18100f49d1fa_B_3 = IN.WorldSpaceNormal[2];
            float _Split_5ed44bf2eca0868f81eb18100f49d1fa_A_4 = 0;
            float2 _Vector2_70e5837843f28b8b9d64cada3697bd5a_Out_0 = float2(_Split_5ed44bf2eca0868f81eb18100f49d1fa_R_1, _Split_5ed44bf2eca0868f81eb18100f49d1fa_B_3);
            float2 _Add_1145b2f896593d80aa864a34e6702562_Out_2;
            Unity_Add_float2(_Multiply_31e8db88ee20c985a9850d1a58f3282b_Out_2, _Vector2_70e5837843f28b8b9d64cada3697bd5a_Out_0, _Add_1145b2f896593d80aa864a34e6702562_Out_2);
            float _Split_2bc77ca2d17bd78cb2383770ce50b179_R_1 = _Add_1145b2f896593d80aa864a34e6702562_Out_2[0];
            float _Split_2bc77ca2d17bd78cb2383770ce50b179_G_2 = _Add_1145b2f896593d80aa864a34e6702562_Out_2[1];
            float _Split_2bc77ca2d17bd78cb2383770ce50b179_B_3 = 0;
            float _Split_2bc77ca2d17bd78cb2383770ce50b179_A_4 = 0;
            float _Multiply_ab12aea87465a78eaf7fc66c2598d266_Out_2;
            Unity_Multiply_float(_SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_B_6, _Split_5ed44bf2eca0868f81eb18100f49d1fa_G_2, _Multiply_ab12aea87465a78eaf7fc66c2598d266_Out_2);
            float3 _Vector3_433840b555db308b97e9b14b6a957195_Out_0 = float3(_Split_2bc77ca2d17bd78cb2383770ce50b179_R_1, _Multiply_ab12aea87465a78eaf7fc66c2598d266_Out_2, _Split_2bc77ca2d17bd78cb2383770ce50b179_G_2);
            float3x3 Transform_c7914cc45a011c89b3f53c55afb51673_tangentTransform_World = float3x3(IN.WorldSpaceTangent, IN.WorldSpaceBiTangent, IN.WorldSpaceNormal);
            float3 _Transform_c7914cc45a011c89b3f53c55afb51673_Out_1 = TransformWorldToTangent(_Vector3_433840b555db308b97e9b14b6a957195_Out_0.xyz, Transform_c7914cc45a011c89b3f53c55afb51673_tangentTransform_World);
            float3 _Normalize_09bf8a2bd0a4d38e8b97d5c674f79b44_Out_1;
            Unity_Normalize_float3(_Transform_c7914cc45a011c89b3f53c55afb51673_Out_1, _Normalize_09bf8a2bd0a4d38e8b97d5c674f79b44_Out_1);
            float3 _Branch_9eadf909a90f2f80880f8c56ecc2a91f_Out_3;
            Unity_Branch_float3(_Property_1ef12cf3201a938993fe6a7951b0e754_Out_0, _Normalize_09bf8a2bd0a4d38e8b97d5c674f79b44_Out_1, (_SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0.xyz), _Branch_9eadf909a90f2f80880f8c56ecc2a91f_Out_3);
            XZ_2 = (float4(_Branch_9eadf909a90f2f80880f8c56ecc2a91f_Out_3, 1.0));
        }

        void Unity_NormalStrength_float(float3 In, float Strength, out float3 Out)
        {
            Out = float3(In.rg * Strength, lerp(1, In.b, saturate(Strength)));
        }

        void Unity_NormalBlend_float(float3 A, float3 B, out float3 Out)
        {
            Out = SafeNormalize(float3(A.rg + B.rg, A.b * B.b));
        }

        void Unity_Subtract_float(float A, float B, out float Out)
        {
            Out = A - B;
        }

        void Unity_Power_float(float A, float B, out float Out)
        {
            Out = pow(A, B);
        }

        void Unity_Lerp_float3(float3 A, float3 B, float3 T, out float3 Out)
        {
            Out = lerp(A, B, T);
        }

        void Unity_Remap_float(float In, float2 InMinMax, float2 OutMinMax, out float Out)
        {
            Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
        }

        void Unity_Multiply_float(float3 A, float3 B, out float3 Out)
        {
            Out = A * B;
        }

            // Graph Vertex
            struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };

        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            Bindings_NMObjectVSProIndirect_0cfe1e4f145944241ab304331e53c93b _NMObjectVSProIndirect_adbe93754e069e8e87df45ef6e4b343e;
            float3 _NMObjectVSProIndirect_adbe93754e069e8e87df45ef6e4b343e_ObjectSpacePosition_1;
            SG_NMObjectVSProIndirect_0cfe1e4f145944241ab304331e53c93b(IN.ObjectSpacePosition, _NMObjectVSProIndirect_adbe93754e069e8e87df45ef6e4b343e, _NMObjectVSProIndirect_adbe93754e069e8e87df45ef6e4b343e_ObjectSpacePosition_1);
            #endif
            description.Position = _NMObjectVSProIndirect_adbe93754e069e8e87df45ef6e4b343e_ObjectSpacePosition_1;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }

            // Graph Pixel
            struct SurfaceDescription
        {
            float3 BaseColor;
            float Alpha;
            float AlphaClipThreshold;
        };

        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            UnityTexture2D _Property_e4c53213449c7682b60df6ae54f219f0_Out_0 = UnityBuildTexture2DStructNoScale(_BaseColorMap);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 _Property_115fcc827510f38798b214d835c27637_Out_0 = _BaseTilingOffset;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_d83b8f290862b285bbe2f157190e1315_Out_0 = _BaseUsePlanarUV;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            Bindings_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6 _PlanarNM_6c8b686076db2a8c8b7d6cd91cf435f0;
            _PlanarNM_6c8b686076db2a8c8b7d6cd91cf435f0.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            _PlanarNM_6c8b686076db2a8c8b7d6cd91cf435f0.uv0 = IN.uv0;
            float4 _PlanarNM_6c8b686076db2a8c8b7d6cd91cf435f0_XZ_2;
            SG_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6(_Property_e4c53213449c7682b60df6ae54f219f0_Out_0, _Property_115fcc827510f38798b214d835c27637_Out_0, _Property_d83b8f290862b285bbe2f157190e1315_Out_0, _PlanarNM_6c8b686076db2a8c8b7d6cd91cf435f0, _PlanarNM_6c8b686076db2a8c8b7d6cd91cf435f0_XZ_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 _Property_13c79aaf332e20868551d934a2cb7112_Out_0 = _BaseColor;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 _Multiply_3d0c2fda612cfe87aa84bc17ad099a61_Out_2;
            Unity_Multiply_float(_PlanarNM_6c8b686076db2a8c8b7d6cd91cf435f0_XZ_2, _Property_13c79aaf332e20868551d934a2cb7112_Out_0, _Multiply_3d0c2fda612cfe87aa84bc17ad099a61_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            UnityTexture2D _Property_b561c414493a8f8299227a27e437f045_Out_0 = UnityBuildTexture2DStructNoScale(_DetailMap);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 _Property_70f1cc2b73af738d80b0d405e4bed8c5_Out_0 = _DetailTilingOffset;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Split_cda27505033cfc8eaf60fe914f0949b9_R_1 = _Property_70f1cc2b73af738d80b0d405e4bed8c5_Out_0[0];
            float _Split_cda27505033cfc8eaf60fe914f0949b9_G_2 = _Property_70f1cc2b73af738d80b0d405e4bed8c5_Out_0[1];
            float _Split_cda27505033cfc8eaf60fe914f0949b9_B_3 = _Property_70f1cc2b73af738d80b0d405e4bed8c5_Out_0[2];
            float _Split_cda27505033cfc8eaf60fe914f0949b9_A_4 = _Property_70f1cc2b73af738d80b0d405e4bed8c5_Out_0[3];
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float2 _Vector2_42d7e955009b6f8cb4d913530ff92840_Out_0 = float2(_Split_cda27505033cfc8eaf60fe914f0949b9_R_1, _Split_cda27505033cfc8eaf60fe914f0949b9_G_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float2 _Vector2_5452a0299d10b280aec51f7407d4d2ac_Out_0 = float2(_Split_cda27505033cfc8eaf60fe914f0949b9_B_3, _Split_cda27505033cfc8eaf60fe914f0949b9_A_4);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float2 _TilingAndOffset_e1c5b97bd253ca8f9f3d26f598e6d7fd_Out_3;
            Unity_TilingAndOffset_float(IN.uv0.xy, _Vector2_42d7e955009b6f8cb4d913530ff92840_Out_0, _Vector2_5452a0299d10b280aec51f7407d4d2ac_Out_0, _TilingAndOffset_e1c5b97bd253ca8f9f3d26f598e6d7fd_Out_3);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 _SampleTexture2D_fa4ac40fc922b9869e37c06690c0f530_RGBA_0 = SAMPLE_TEXTURE2D(_Property_b561c414493a8f8299227a27e437f045_Out_0.tex, _Property_b561c414493a8f8299227a27e437f045_Out_0.samplerstate, _TilingAndOffset_e1c5b97bd253ca8f9f3d26f598e6d7fd_Out_3);
            float _SampleTexture2D_fa4ac40fc922b9869e37c06690c0f530_R_4 = _SampleTexture2D_fa4ac40fc922b9869e37c06690c0f530_RGBA_0.r;
            float _SampleTexture2D_fa4ac40fc922b9869e37c06690c0f530_G_5 = _SampleTexture2D_fa4ac40fc922b9869e37c06690c0f530_RGBA_0.g;
            float _SampleTexture2D_fa4ac40fc922b9869e37c06690c0f530_B_6 = _SampleTexture2D_fa4ac40fc922b9869e37c06690c0f530_RGBA_0.b;
            float _SampleTexture2D_fa4ac40fc922b9869e37c06690c0f530_A_7 = _SampleTexture2D_fa4ac40fc922b9869e37c06690c0f530_RGBA_0.a;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Multiply_d0f6aeb5b3f04288b51a5ded8986b5a4_Out_2;
            Unity_Multiply_float(_SampleTexture2D_fa4ac40fc922b9869e37c06690c0f530_R_4, 2, _Multiply_d0f6aeb5b3f04288b51a5ded8986b5a4_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Add_d382719213f8618f88c54f7c3dfbd8c2_Out_2;
            Unity_Add_float(_Multiply_d0f6aeb5b3f04288b51a5ded8986b5a4_Out_2, -1, _Add_d382719213f8618f88c54f7c3dfbd8c2_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_02e7dd176dc59f8a9a62453677916b24_Out_0 = _DetailAlbedoScale;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Multiply_fd406247e3137a8b8777918477740653_Out_2;
            Unity_Multiply_float(_Add_d382719213f8618f88c54f7c3dfbd8c2_Out_2, _Property_02e7dd176dc59f8a9a62453677916b24_Out_0, _Multiply_fd406247e3137a8b8777918477740653_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Saturate_d6f590fb1b9d188e981ebb0ec4d36ba9_Out_1;
            Unity_Saturate_float(_Multiply_fd406247e3137a8b8777918477740653_Out_2, _Saturate_d6f590fb1b9d188e981ebb0ec4d36ba9_Out_1);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Absolute_dc927550b803d18ba3ff372995e6d25c_Out_1;
            Unity_Absolute_float(_Saturate_d6f590fb1b9d188e981ebb0ec4d36ba9_Out_1, _Absolute_dc927550b803d18ba3ff372995e6d25c_Out_1);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            Bindings_BlendOverlayBaseColor_acdb3dfca72bd6b42bbc35f4613331a2 _BlendOverlayBaseColor_f3cd25d5b673648eb831a3f388201f73;
            float3 _BlendOverlayBaseColor_f3cd25d5b673648eb831a3f388201f73_OutVector4_1;
            SG_BlendOverlayBaseColor_acdb3dfca72bd6b42bbc35f4613331a2(_Multiply_3d0c2fda612cfe87aa84bc17ad099a61_Out_2, _Add_d382719213f8618f88c54f7c3dfbd8c2_Out_2, _Absolute_dc927550b803d18ba3ff372995e6d25c_Out_1, _BlendOverlayBaseColor_f3cd25d5b673648eb831a3f388201f73, _BlendOverlayBaseColor_f3cd25d5b673648eb831a3f388201f73_OutVector4_1);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            UnityTexture2D _Property_f4db51ec2412c48cbcf2128b7bd8caf8_Out_0 = UnityBuildTexture2DStructNoScale(_CoverBaseColorMap);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 _Property_e35c79b8cccfbe8ca0a3c33e8d32e319_Out_0 = _CoverTilingOffset;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_e3d8b38b51331e879b1d4012d65f53e6_Out_0 = _CoverUsePlanarUV;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            Bindings_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6 _PlanarNM_c2ec737ef76d6286b8eedb44a2d24e50;
            _PlanarNM_c2ec737ef76d6286b8eedb44a2d24e50.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            _PlanarNM_c2ec737ef76d6286b8eedb44a2d24e50.uv0 = IN.uv0;
            float4 _PlanarNM_c2ec737ef76d6286b8eedb44a2d24e50_XZ_2;
            SG_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6(_Property_f4db51ec2412c48cbcf2128b7bd8caf8_Out_0, _Property_e35c79b8cccfbe8ca0a3c33e8d32e319_Out_0, _Property_e3d8b38b51331e879b1d4012d65f53e6_Out_0, _PlanarNM_c2ec737ef76d6286b8eedb44a2d24e50, _PlanarNM_c2ec737ef76d6286b8eedb44a2d24e50_XZ_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 _Property_7d3af9045f54ef8ba8629ebbbc3f4ad7_Out_0 = _CoverBaseColor;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 _Multiply_2eb83c7af5b6f58eabeec7b502517470_Out_2;
            Unity_Multiply_float(_PlanarNM_c2ec737ef76d6286b8eedb44a2d24e50_XZ_2, _Property_7d3af9045f54ef8ba8629ebbbc3f4ad7_Out_0, _Multiply_2eb83c7af5b6f58eabeec7b502517470_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            UnityTexture2D _Property_356186a26fec8686a13bc6b57fd8f3ee_Out_0 = UnityBuildTexture2DStructNoScale(_CoverMaskA);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 _UV_045cea9e82354980a778f44d92578382_Out_0 = IN.uv0;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 _SampleTexture2D_0eef6ae3dab6e185bd0f65edecd80314_RGBA_0 = SAMPLE_TEXTURE2D(_Property_356186a26fec8686a13bc6b57fd8f3ee_Out_0.tex, _Property_356186a26fec8686a13bc6b57fd8f3ee_Out_0.samplerstate, (_UV_045cea9e82354980a778f44d92578382_Out_0.xy));
            float _SampleTexture2D_0eef6ae3dab6e185bd0f65edecd80314_R_4 = _SampleTexture2D_0eef6ae3dab6e185bd0f65edecd80314_RGBA_0.r;
            float _SampleTexture2D_0eef6ae3dab6e185bd0f65edecd80314_G_5 = _SampleTexture2D_0eef6ae3dab6e185bd0f65edecd80314_RGBA_0.g;
            float _SampleTexture2D_0eef6ae3dab6e185bd0f65edecd80314_B_6 = _SampleTexture2D_0eef6ae3dab6e185bd0f65edecd80314_RGBA_0.b;
            float _SampleTexture2D_0eef6ae3dab6e185bd0f65edecd80314_A_7 = _SampleTexture2D_0eef6ae3dab6e185bd0f65edecd80314_RGBA_0.a;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_4e8240836843df81941cdf6cf2cdd638_Out_0 = _CoverMaskPower;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Multiply_8b5250e5dfc73a84a41399a13b83c0a1_Out_2;
            Unity_Multiply_float(_SampleTexture2D_0eef6ae3dab6e185bd0f65edecd80314_A_7, _Property_4e8240836843df81941cdf6cf2cdd638_Out_0, _Multiply_8b5250e5dfc73a84a41399a13b83c0a1_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Clamp_030a7c32684c258084338456eaddc77a_Out_3;
            Unity_Clamp_float(_Multiply_8b5250e5dfc73a84a41399a13b83c0a1_Out_2, 0, 1, _Clamp_030a7c32684c258084338456eaddc77a_Out_3);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Split_8ba5b67899f36b8f9dcf5c84092c0560_R_1 = IN.VertexColor[0];
            float _Split_8ba5b67899f36b8f9dcf5c84092c0560_G_2 = IN.VertexColor[1];
            float _Split_8ba5b67899f36b8f9dcf5c84092c0560_B_3 = IN.VertexColor[2];
            float _Split_8ba5b67899f36b8f9dcf5c84092c0560_A_4 = IN.VertexColor[3];
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float2 _Vector2_65060e9a9f687a89b68e32dc876be645_Out_0 = float2(_SampleTexture2D_fa4ac40fc922b9869e37c06690c0f530_A_7, _SampleTexture2D_fa4ac40fc922b9869e37c06690c0f530_G_5);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float2 _Multiply_5d4c3baed6515c8b86a289c70fca8f5d_Out_2;
            Unity_Multiply_float(_Vector2_65060e9a9f687a89b68e32dc876be645_Out_0, float2(2, 2), _Multiply_5d4c3baed6515c8b86a289c70fca8f5d_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float2 _Add_98b310e19c5fa5899c39cc45969c15ea_Out_2;
            Unity_Add_float2(_Multiply_5d4c3baed6515c8b86a289c70fca8f5d_Out_2, float2(-1, -1), _Add_98b310e19c5fa5899c39cc45969c15ea_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_08b99582093b36869beb5ea3d18e765d_Out_0 = _DetailNormalScale;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float2 _Multiply_bf0b80fdb3271784900e5b5ea4c5550f_Out_2;
            Unity_Multiply_float(_Add_98b310e19c5fa5899c39cc45969c15ea_Out_2, (_Property_08b99582093b36869beb5ea3d18e765d_Out_0.xx), _Multiply_bf0b80fdb3271784900e5b5ea4c5550f_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Split_26c1e73f8436c78ebdae5b51365a072b_R_1 = _Multiply_bf0b80fdb3271784900e5b5ea4c5550f_Out_2[0];
            float _Split_26c1e73f8436c78ebdae5b51365a072b_G_2 = _Multiply_bf0b80fdb3271784900e5b5ea4c5550f_Out_2[1];
            float _Split_26c1e73f8436c78ebdae5b51365a072b_B_3 = 0;
            float _Split_26c1e73f8436c78ebdae5b51365a072b_A_4 = 0;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _DotProduct_50aca3ce0da1ad849d7ff4a99df3a322_Out_2;
            Unity_DotProduct_float2(_Multiply_bf0b80fdb3271784900e5b5ea4c5550f_Out_2, _Multiply_bf0b80fdb3271784900e5b5ea4c5550f_Out_2, _DotProduct_50aca3ce0da1ad849d7ff4a99df3a322_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Saturate_491f2ee8417b8782aee83358b89eeb08_Out_1;
            Unity_Saturate_float(_DotProduct_50aca3ce0da1ad849d7ff4a99df3a322_Out_2, _Saturate_491f2ee8417b8782aee83358b89eeb08_Out_1);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _OneMinus_46ad3170d736808d98bf74ffa45e0414_Out_1;
            Unity_OneMinus_float(_Saturate_491f2ee8417b8782aee83358b89eeb08_Out_1, _OneMinus_46ad3170d736808d98bf74ffa45e0414_Out_1);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _SquareRoot_dfeae899ebfeae8f9257c340ca22ce38_Out_1;
            Unity_SquareRoot_float(_OneMinus_46ad3170d736808d98bf74ffa45e0414_Out_1, _SquareRoot_dfeae899ebfeae8f9257c340ca22ce38_Out_1);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 _Vector3_ed3f80ed87524e8c99f98b224af5a610_Out_0 = float3(_Split_26c1e73f8436c78ebdae5b51365a072b_R_1, _Split_26c1e73f8436c78ebdae5b51365a072b_G_2, _SquareRoot_dfeae899ebfeae8f9257c340ca22ce38_Out_1);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            UnityTexture2D _Property_2cc39234d3d334899f94126a216a50fc_Out_0 = UnityBuildTexture2DStructNoScale(_BaseNormalMap);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            Bindings_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8 _PlanarNMn_4fde70f39e45398dbb9972941e88e2bf;
            _PlanarNMn_4fde70f39e45398dbb9972941e88e2bf.WorldSpaceNormal = IN.WorldSpaceNormal;
            _PlanarNMn_4fde70f39e45398dbb9972941e88e2bf.WorldSpaceTangent = IN.WorldSpaceTangent;
            _PlanarNMn_4fde70f39e45398dbb9972941e88e2bf.WorldSpaceBiTangent = IN.WorldSpaceBiTangent;
            _PlanarNMn_4fde70f39e45398dbb9972941e88e2bf.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            _PlanarNMn_4fde70f39e45398dbb9972941e88e2bf.uv0 = IN.uv0;
            float4 _PlanarNMn_4fde70f39e45398dbb9972941e88e2bf_XZ_2;
            SG_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8(_Property_2cc39234d3d334899f94126a216a50fc_Out_0, _Property_115fcc827510f38798b214d835c27637_Out_0, _Property_d83b8f290862b285bbe2f157190e1315_Out_0, _PlanarNMn_4fde70f39e45398dbb9972941e88e2bf, _PlanarNMn_4fde70f39e45398dbb9972941e88e2bf_XZ_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_020d569f63e9a2849e23988ff74eb005_Out_0 = _BaseNormalScale;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 _NormalStrength_0c71fb166ae841839a0a12ecc5afa6fe_Out_2;
            Unity_NormalStrength_float((_PlanarNMn_4fde70f39e45398dbb9972941e88e2bf_XZ_2.xyz), _Property_020d569f63e9a2849e23988ff74eb005_Out_0, _NormalStrength_0c71fb166ae841839a0a12ecc5afa6fe_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 _NormalBlend_be36dd49bea74c8f8dd52fa3a85a9534_Out_2;
            Unity_NormalBlend_float(_Vector3_ed3f80ed87524e8c99f98b224af5a610_Out_0, _NormalStrength_0c71fb166ae841839a0a12ecc5afa6fe_Out_2, _NormalBlend_be36dd49bea74c8f8dd52fa3a85a9534_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            UnityTexture2D _Property_a383045772822c87acd099bb4cd6c478_Out_0 = UnityBuildTexture2DStructNoScale(_CoverNormalMap);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            Bindings_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8 _PlanarNMn_79abde32a0223a89907c9f09efac8db7;
            _PlanarNMn_79abde32a0223a89907c9f09efac8db7.WorldSpaceNormal = IN.WorldSpaceNormal;
            _PlanarNMn_79abde32a0223a89907c9f09efac8db7.WorldSpaceTangent = IN.WorldSpaceTangent;
            _PlanarNMn_79abde32a0223a89907c9f09efac8db7.WorldSpaceBiTangent = IN.WorldSpaceBiTangent;
            _PlanarNMn_79abde32a0223a89907c9f09efac8db7.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            _PlanarNMn_79abde32a0223a89907c9f09efac8db7.uv0 = IN.uv0;
            float4 _PlanarNMn_79abde32a0223a89907c9f09efac8db7_XZ_2;
            SG_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8(_Property_a383045772822c87acd099bb4cd6c478_Out_0, _Property_e35c79b8cccfbe8ca0a3c33e8d32e319_Out_0, _Property_e3d8b38b51331e879b1d4012d65f53e6_Out_0, _PlanarNMn_79abde32a0223a89907c9f09efac8db7, _PlanarNMn_79abde32a0223a89907c9f09efac8db7_XZ_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_c688e246111fd881820a97415e14d8a3_Out_0 = _CoverNormalBlendHardness;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 _NormalStrength_0e5e0831ba0e98878220ca6021ea52a2_Out_2;
            Unity_NormalStrength_float((_PlanarNMn_79abde32a0223a89907c9f09efac8db7_XZ_2.xyz), _Property_c688e246111fd881820a97415e14d8a3_Out_0, _NormalStrength_0e5e0831ba0e98878220ca6021ea52a2_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Split_8cadce726725318fbacd47f436a8231d_R_1 = IN.WorldSpaceNormal[0];
            float _Split_8cadce726725318fbacd47f436a8231d_G_2 = IN.WorldSpaceNormal[1];
            float _Split_8cadce726725318fbacd47f436a8231d_B_3 = IN.WorldSpaceNormal[2];
            float _Split_8cadce726725318fbacd47f436a8231d_A_4 = 0;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_ce4e5954a0b7ff8c819fa53963327595_Out_0 = _Cover_Amount;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_384059e6344fb98a85eccad78dd82f36_Out_0 = _Cover_Amount_Grow_Speed;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Subtract_70fd06876db7fa85b0cc0bce8d926dff_Out_2;
            Unity_Subtract_float(4, _Property_384059e6344fb98a85eccad78dd82f36_Out_0, _Subtract_70fd06876db7fa85b0cc0bce8d926dff_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Divide_1a3a6334c3d8bc8f8ac262c7833e15d5_Out_2;
            Unity_Divide_float(_Property_ce4e5954a0b7ff8c819fa53963327595_Out_0, _Subtract_70fd06876db7fa85b0cc0bce8d926dff_Out_2, _Divide_1a3a6334c3d8bc8f8ac262c7833e15d5_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Absolute_f218d2b85ebf288f91234faffedb5f7b_Out_1;
            Unity_Absolute_float(_Divide_1a3a6334c3d8bc8f8ac262c7833e15d5_Out_2, _Absolute_f218d2b85ebf288f91234faffedb5f7b_Out_1);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Power_a9b8d4b65c44a98e9813f61c0e2dc0a3_Out_2;
            Unity_Power_float(_Absolute_f218d2b85ebf288f91234faffedb5f7b_Out_1, _Subtract_70fd06876db7fa85b0cc0bce8d926dff_Out_2, _Power_a9b8d4b65c44a98e9813f61c0e2dc0a3_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Clamp_95d579f83746cb82be79cf6739990e0b_Out_3;
            Unity_Clamp_float(_Power_a9b8d4b65c44a98e9813f61c0e2dc0a3_Out_2, 0, 2, _Clamp_95d579f83746cb82be79cf6739990e0b_Out_3);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Multiply_02a8aa0fa6974e81aa84caba54f63896_Out_2;
            Unity_Multiply_float(_Split_8cadce726725318fbacd47f436a8231d_G_2, _Clamp_95d579f83746cb82be79cf6739990e0b_Out_3, _Multiply_02a8aa0fa6974e81aa84caba54f63896_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Saturate_ada5e8f9ebdcb38d8f5e61e8d97424b9_Out_1;
            Unity_Saturate_float(_Multiply_02a8aa0fa6974e81aa84caba54f63896_Out_2, _Saturate_ada5e8f9ebdcb38d8f5e61e8d97424b9_Out_1);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Clamp_38bac9e8ef351789b5fd4f2201f1df7b_Out_3;
            Unity_Clamp_float(_Split_8cadce726725318fbacd47f436a8231d_G_2, 0, 0.9999, _Clamp_38bac9e8ef351789b5fd4f2201f1df7b_Out_3);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_9babc76177853482826cae0163ffe988_Out_0 = _Cover_Max_Angle;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Divide_3b22550205905d8da5870f9db56e44ff_Out_2;
            Unity_Divide_float(_Property_9babc76177853482826cae0163ffe988_Out_0, 45, _Divide_3b22550205905d8da5870f9db56e44ff_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _OneMinus_99a85b6952a41288afc86da0a6ca6ea0_Out_1;
            Unity_OneMinus_float(_Divide_3b22550205905d8da5870f9db56e44ff_Out_2, _OneMinus_99a85b6952a41288afc86da0a6ca6ea0_Out_1);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Subtract_2b63f3aaee26f686971dca1d28da283c_Out_2;
            Unity_Subtract_float(_Clamp_38bac9e8ef351789b5fd4f2201f1df7b_Out_3, _OneMinus_99a85b6952a41288afc86da0a6ca6ea0_Out_1, _Subtract_2b63f3aaee26f686971dca1d28da283c_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Clamp_6bd9bb4add91fe8eb80a958a6b1a2d01_Out_3;
            Unity_Clamp_float(_Subtract_2b63f3aaee26f686971dca1d28da283c_Out_2, 0, 2, _Clamp_6bd9bb4add91fe8eb80a958a6b1a2d01_Out_3);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Divide_a09d2d461b07e98999aba746fb52a3fc_Out_2;
            Unity_Divide_float(1, _Divide_3b22550205905d8da5870f9db56e44ff_Out_2, _Divide_a09d2d461b07e98999aba746fb52a3fc_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Multiply_89a8f5a279c73b898d4ca5d075786b53_Out_2;
            Unity_Multiply_float(_Clamp_6bd9bb4add91fe8eb80a958a6b1a2d01_Out_3, _Divide_a09d2d461b07e98999aba746fb52a3fc_Out_2, _Multiply_89a8f5a279c73b898d4ca5d075786b53_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Absolute_f98ce5feb185a68784b9b35eb71ec465_Out_1;
            Unity_Absolute_float(_Multiply_89a8f5a279c73b898d4ca5d075786b53_Out_2, _Absolute_f98ce5feb185a68784b9b35eb71ec465_Out_1);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_27e768ffa9c13e8ab65d48e7712e5b66_Out_0 = _CoverHardness;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Power_b9fdc3921d5b85878a1ec4baa1975184_Out_2;
            Unity_Power_float(_Absolute_f98ce5feb185a68784b9b35eb71ec465_Out_1, _Property_27e768ffa9c13e8ab65d48e7712e5b66_Out_0, _Power_b9fdc3921d5b85878a1ec4baa1975184_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_c442c20fdade808b8e1b93cfd6625ab9_Out_0 = _Cover_Min_Height;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _OneMinus_55530ddc82048c8aa2d082334edf6a57_Out_1;
            Unity_OneMinus_float(_Property_c442c20fdade808b8e1b93cfd6625ab9_Out_0, _OneMinus_55530ddc82048c8aa2d082334edf6a57_Out_1);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Split_7e5d084c5e6bfa83a9203dac971ea31e_R_1 = IN.AbsoluteWorldSpacePosition[0];
            float _Split_7e5d084c5e6bfa83a9203dac971ea31e_G_2 = IN.AbsoluteWorldSpacePosition[1];
            float _Split_7e5d084c5e6bfa83a9203dac971ea31e_B_3 = IN.AbsoluteWorldSpacePosition[2];
            float _Split_7e5d084c5e6bfa83a9203dac971ea31e_A_4 = 0;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Add_e4067b215657d98ab6ec4e0295ddfece_Out_2;
            Unity_Add_float(_OneMinus_55530ddc82048c8aa2d082334edf6a57_Out_1, _Split_7e5d084c5e6bfa83a9203dac971ea31e_G_2, _Add_e4067b215657d98ab6ec4e0295ddfece_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Add_a4387dfc1ea3ee8da0b04f433a7c63d0_Out_2;
            Unity_Add_float(_Add_e4067b215657d98ab6ec4e0295ddfece_Out_2, 1, _Add_a4387dfc1ea3ee8da0b04f433a7c63d0_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Clamp_570e1129ecb02c8b8be79d85f19d5ae1_Out_3;
            Unity_Clamp_float(_Add_a4387dfc1ea3ee8da0b04f433a7c63d0_Out_2, 0, 1, _Clamp_570e1129ecb02c8b8be79d85f19d5ae1_Out_3);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_5da709b259ac268bb134d927bcffa4b8_Out_0 = _Cover_Min_Height_Blending;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Add_c322347d9ddbcd83ba52983e9316c387_Out_2;
            Unity_Add_float(_Add_e4067b215657d98ab6ec4e0295ddfece_Out_2, _Property_5da709b259ac268bb134d927bcffa4b8_Out_0, _Add_c322347d9ddbcd83ba52983e9316c387_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Divide_078ffa7d6c597f819511c95d33b7d90e_Out_2;
            Unity_Divide_float(_Add_c322347d9ddbcd83ba52983e9316c387_Out_2, _Add_e4067b215657d98ab6ec4e0295ddfece_Out_2, _Divide_078ffa7d6c597f819511c95d33b7d90e_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _OneMinus_b9f8edced35e7b8cab9ca581d822e31f_Out_1;
            Unity_OneMinus_float(_Divide_078ffa7d6c597f819511c95d33b7d90e_Out_2, _OneMinus_b9f8edced35e7b8cab9ca581d822e31f_Out_1);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Add_95cd1778448bfe8d9f9fa9129235f2c2_Out_2;
            Unity_Add_float(_OneMinus_b9f8edced35e7b8cab9ca581d822e31f_Out_1, -0.5, _Add_95cd1778448bfe8d9f9fa9129235f2c2_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Clamp_23e760e01b7e0780a71d88813b5828d7_Out_3;
            Unity_Clamp_float(_Add_95cd1778448bfe8d9f9fa9129235f2c2_Out_2, 0, 1, _Clamp_23e760e01b7e0780a71d88813b5828d7_Out_3);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Add_674fcef023d728848510150af810a103_Out_2;
            Unity_Add_float(_Clamp_570e1129ecb02c8b8be79d85f19d5ae1_Out_3, _Clamp_23e760e01b7e0780a71d88813b5828d7_Out_3, _Add_674fcef023d728848510150af810a103_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Clamp_5b677be9d499c082bcbe316853b0adff_Out_3;
            Unity_Clamp_float(_Add_674fcef023d728848510150af810a103_Out_2, 0, 1, _Clamp_5b677be9d499c082bcbe316853b0adff_Out_3);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Multiply_7ea7400ed65a3582b000796fb39748e9_Out_2;
            Unity_Multiply_float(_Power_b9fdc3921d5b85878a1ec4baa1975184_Out_2, _Clamp_5b677be9d499c082bcbe316853b0adff_Out_3, _Multiply_7ea7400ed65a3582b000796fb39748e9_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Multiply_4d295791f4e23186acea64f2f4de94ea_Out_2;
            Unity_Multiply_float(_Saturate_ada5e8f9ebdcb38d8f5e61e8d97424b9_Out_1, _Multiply_7ea7400ed65a3582b000796fb39748e9_Out_2, _Multiply_4d295791f4e23186acea64f2f4de94ea_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 _Lerp_21eaf65c617b2d858b3b33154d55757a_Out_3;
            Unity_Lerp_float3(_NormalBlend_be36dd49bea74c8f8dd52fa3a85a9534_Out_2, _NormalStrength_0e5e0831ba0e98878220ca6021ea52a2_Out_2, (_Multiply_4d295791f4e23186acea64f2f4de94ea_Out_2.xxx), _Lerp_21eaf65c617b2d858b3b33154d55757a_Out_3);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3x3 Transform_1e4c3a2d6240958ab6858efb88c1d06a_transposeTangent = transpose(float3x3(IN.WorldSpaceTangent, IN.WorldSpaceBiTangent, IN.WorldSpaceNormal));
            float3 _Transform_1e4c3a2d6240958ab6858efb88c1d06a_Out_1 = normalize(mul(Transform_1e4c3a2d6240958ab6858efb88c1d06a_transposeTangent, _Lerp_21eaf65c617b2d858b3b33154d55757a_Out_3.xyz).xyz);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Split_600a9d271d96798a94ab28118977defd_R_1 = _Transform_1e4c3a2d6240958ab6858efb88c1d06a_Out_1[0];
            float _Split_600a9d271d96798a94ab28118977defd_G_2 = _Transform_1e4c3a2d6240958ab6858efb88c1d06a_Out_1[1];
            float _Split_600a9d271d96798a94ab28118977defd_B_3 = _Transform_1e4c3a2d6240958ab6858efb88c1d06a_Out_1[2];
            float _Split_600a9d271d96798a94ab28118977defd_A_4 = 0;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Multiply_2e5b010626435f8492a2690396ced19d_Out_2;
            Unity_Multiply_float(_Split_600a9d271d96798a94ab28118977defd_G_2, _Clamp_95d579f83746cb82be79cf6739990e0b_Out_3, _Multiply_2e5b010626435f8492a2690396ced19d_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Multiply_5a2397e0153ddb8f9bd457d9a301dc8b_Out_2;
            Unity_Multiply_float(_Clamp_95d579f83746cb82be79cf6739990e0b_Out_3, _Property_27e768ffa9c13e8ab65d48e7712e5b66_Out_0, _Multiply_5a2397e0153ddb8f9bd457d9a301dc8b_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Multiply_3aad76eaff60dd888c3e1783ecf03943_Out_2;
            Unity_Multiply_float(_Multiply_5a2397e0153ddb8f9bd457d9a301dc8b_Out_2, _Multiply_7ea7400ed65a3582b000796fb39748e9_Out_2, _Multiply_3aad76eaff60dd888c3e1783ecf03943_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Multiply_05614e740451f18f8301586390aa5a0a_Out_2;
            Unity_Multiply_float(_Multiply_2e5b010626435f8492a2690396ced19d_Out_2, _Multiply_3aad76eaff60dd888c3e1783ecf03943_Out_2, _Multiply_05614e740451f18f8301586390aa5a0a_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            UnityTexture2D _Property_a14f2476a35d208b988233c852f919ef_Out_0 = UnityBuildTexture2DStructNoScale(_CoverMaskMap);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            Bindings_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6 _PlanarNM_6858a0e821f26a8d87846d325e9bd170;
            _PlanarNM_6858a0e821f26a8d87846d325e9bd170.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            _PlanarNM_6858a0e821f26a8d87846d325e9bd170.uv0 = IN.uv0;
            float4 _PlanarNM_6858a0e821f26a8d87846d325e9bd170_XZ_2;
            SG_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6(_Property_a14f2476a35d208b988233c852f919ef_Out_0, _Property_e35c79b8cccfbe8ca0a3c33e8d32e319_Out_0, _Property_e3d8b38b51331e879b1d4012d65f53e6_Out_0, _PlanarNM_6858a0e821f26a8d87846d325e9bd170, _PlanarNM_6858a0e821f26a8d87846d325e9bd170_XZ_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Split_16313c20ccdeaa86a639068877a69a2f_R_1 = _PlanarNM_6858a0e821f26a8d87846d325e9bd170_XZ_2[0];
            float _Split_16313c20ccdeaa86a639068877a69a2f_G_2 = _PlanarNM_6858a0e821f26a8d87846d325e9bd170_XZ_2[1];
            float _Split_16313c20ccdeaa86a639068877a69a2f_B_3 = _PlanarNM_6858a0e821f26a8d87846d325e9bd170_XZ_2[2];
            float _Split_16313c20ccdeaa86a639068877a69a2f_A_4 = _PlanarNM_6858a0e821f26a8d87846d325e9bd170_XZ_2[3];
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_673896519f419589938b37e782b90141_Out_0 = _CoverHeightMapMin;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_c35906332422438da3b19f45cbd5ac17_Out_0 = _CoverHeightMapMax;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float2 _Vector2_81cbe1e5ea789e8697223cd3bfbca76c_Out_0 = float2(_Property_673896519f419589938b37e782b90141_Out_0, _Property_c35906332422438da3b19f45cbd5ac17_Out_0);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_88ab0068f899fc8ba94efdaec5e8966b_Out_0 = _CoverHeightMapOffset;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float2 _Add_cd623e3135271489b0d45b4d7edc5f7e_Out_2;
            Unity_Add_float2(_Vector2_81cbe1e5ea789e8697223cd3bfbca76c_Out_0, (_Property_88ab0068f899fc8ba94efdaec5e8966b_Out_0.xx), _Add_cd623e3135271489b0d45b4d7edc5f7e_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Remap_9a23d5f76fa8c38dbd73f43bd6397b0b_Out_3;
            Unity_Remap_float(_Split_16313c20ccdeaa86a639068877a69a2f_B_3, float2 (0, 1), _Add_cd623e3135271489b0d45b4d7edc5f7e_Out_2, _Remap_9a23d5f76fa8c38dbd73f43bd6397b0b_Out_3);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Multiply_0093be0fd848498b89a0fa282608e715_Out_2;
            Unity_Multiply_float(_Multiply_05614e740451f18f8301586390aa5a0a_Out_2, _Remap_9a23d5f76fa8c38dbd73f43bd6397b0b_Out_3, _Multiply_0093be0fd848498b89a0fa282608e715_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Multiply_d3190f97afd0398083623ecf71a41b1a_Out_2;
            Unity_Multiply_float(_Split_8ba5b67899f36b8f9dcf5c84092c0560_G_2, _Multiply_0093be0fd848498b89a0fa282608e715_Out_2, _Multiply_d3190f97afd0398083623ecf71a41b1a_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Saturate_cbcee34e7e6e6d8091d840550ab1c74a_Out_1;
            Unity_Saturate_float(_Multiply_d3190f97afd0398083623ecf71a41b1a_Out_2, _Saturate_cbcee34e7e6e6d8091d840550ab1c74a_Out_1);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Multiply_da35b9d9e4dd8c81871a9aea42c157ee_Out_2;
            Unity_Multiply_float(_Clamp_030a7c32684c258084338456eaddc77a_Out_3, _Saturate_cbcee34e7e6e6d8091d840550ab1c74a_Out_1, _Multiply_da35b9d9e4dd8c81871a9aea42c157ee_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Clamp_c95f5515948375878df6581a36d8b203_Out_3;
            Unity_Clamp_float(_Multiply_da35b9d9e4dd8c81871a9aea42c157ee_Out_2, 0, 1, _Clamp_c95f5515948375878df6581a36d8b203_Out_3);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            #if defined(_USEDYNAMICCOVERTSTATICMASKF_ON)
            float _UseDynamicCoverTStaticMaskF_0694902516172b8fa469c5d8b8e938c6_Out_0 = _Clamp_c95f5515948375878df6581a36d8b203_Out_3;
            #else
            float _UseDynamicCoverTStaticMaskF_0694902516172b8fa469c5d8b8e938c6_Out_0 = _Clamp_030a7c32684c258084338456eaddc77a_Out_3;
            #endif
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 _Lerp_87882219e20a6d818c0de017d739125f_Out_3;
            Unity_Lerp_float3(_BlendOverlayBaseColor_f3cd25d5b673648eb831a3f388201f73_OutVector4_1, (_Multiply_2eb83c7af5b6f58eabeec7b502517470_Out_2.xyz), (_UseDynamicCoverTStaticMaskF_0694902516172b8fa469c5d8b8e938c6_Out_0.xxx), _Lerp_87882219e20a6d818c0de017d739125f_Out_3);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 _Property_4c7bd3690d9d8a838e2524f5908e09ee_Out_0 = _WetColor;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 _Multiply_77c751a5503e948d8952b403163b4eeb_Out_2;
            Unity_Multiply_float((_Property_4c7bd3690d9d8a838e2524f5908e09ee_Out_0.xyz), _Lerp_87882219e20a6d818c0de017d739125f_Out_3, _Multiply_77c751a5503e948d8952b403163b4eeb_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _OneMinus_9b165e3f6c2fdd88a5f3a51230f8dd33_Out_1;
            Unity_OneMinus_float(_Split_8ba5b67899f36b8f9dcf5c84092c0560_R_1, _OneMinus_9b165e3f6c2fdd88a5f3a51230f8dd33_Out_1);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 _Lerp_538fa3f69b550a8bbe8ee20906ecc752_Out_3;
            Unity_Lerp_float3(_Lerp_87882219e20a6d818c0de017d739125f_Out_3, _Multiply_77c751a5503e948d8952b403163b4eeb_Out_2, (_OneMinus_9b165e3f6c2fdd88a5f3a51230f8dd33_Out_1.xxx), _Lerp_538fa3f69b550a8bbe8ee20906ecc752_Out_3);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Split_31874fa1d55cb28e99a1333cf254676a_R_1 = _PlanarNM_6c8b686076db2a8c8b7d6cd91cf435f0_XZ_2[0];
            float _Split_31874fa1d55cb28e99a1333cf254676a_G_2 = _PlanarNM_6c8b686076db2a8c8b7d6cd91cf435f0_XZ_2[1];
            float _Split_31874fa1d55cb28e99a1333cf254676a_B_3 = _PlanarNM_6c8b686076db2a8c8b7d6cd91cf435f0_XZ_2[2];
            float _Split_31874fa1d55cb28e99a1333cf254676a_A_4 = _PlanarNM_6c8b686076db2a8c8b7d6cd91cf435f0_XZ_2[3];
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_881c341218ea2d81819695b0c7ddc4cb_Out_0 = _AlphaCutoff;
            #endif
            surface.BaseColor = _Lerp_538fa3f69b550a8bbe8ee20906ecc752_Out_3;
            surface.Alpha = _Split_31874fa1d55cb28e99a1333cf254676a_A_4;
            surface.AlphaClipThreshold = _Property_881c341218ea2d81819695b0c7ddc4cb_Out_0;
            return surface;
        }

            // --------------------------------------------------
            // Build Graph Inputs

            VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.ObjectSpaceNormal =           input.normalOS;
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.ObjectSpaceTangent =          input.tangentOS.xyz;
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.ObjectSpacePosition =         input.positionOS;
        #endif


            return output;
        }
            SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        // must use interpolated tangent, bitangent and normal before they are normalized in the pixel shader.
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        float3 unnormalizedNormalWS = input.normalWS;
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        const float renormFactor = 1.0 / length(unnormalizedNormalWS);
        #endif


        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        // use bitangent on the fly like in hdrp
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        // IMPORTANT! If we ever support Flip on double sided materials ensure bitangent and tangent are NOT flipped.
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        float crossSign = (input.tangentWS.w > 0.0 ? 1.0 : -1.0) * GetOddNegativeScale();
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        float3 bitang = crossSign * cross(input.normalWS.xyz, input.tangentWS.xyz);
        #endif


        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.WorldSpaceNormal =            renormFactor*input.normalWS.xyz;      // we want a unit length Normal Vector node in shader graph
        #endif


        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        // to preserve mikktspace compliance we use same scale renormFactor as was used on the normal.
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        // This is explained in section 2.2 in "surface gradient based bump mapping framework"
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.WorldSpaceTangent =           renormFactor*input.tangentWS.xyz;
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.WorldSpaceBiTangent =         renormFactor*bitang;
        #endif


        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.AbsoluteWorldSpacePosition =  GetAbsolutePositionWS(input.positionWS);
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.uv0 =                         input.texCoord0;
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.VertexColor =                 input.color;
        #endif

        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN

            return output;
        }

            // --------------------------------------------------
            // Main

            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/PBR2DPass.hlsl"

            ENDHLSL
        }
    }
    SubShader
    {
        Tags
        {
            "RenderPipeline"="UniversalPipeline"
            "RenderType"="Opaque"
            "UniversalMaterialType" = "Lit"
            "Queue"="AlphaTest"
        }
        Pass
        {
            Name "Universal Forward"
            Tags
            {
                "LightMode" = "UniversalForward"
            }

            // Render State
            Cull Back
        Blend One Zero
        ZTest LEqual
        ZWrite On

            // Debug
            // <None>

            // --------------------------------------------------
            // Pass

            HLSLPROGRAM

            // Pragmas
            #pragma target 2.0
        #pragma only_renderers gles gles3 glcore
        #pragma multi_compile_instancing
        #pragma multi_compile_fog
        #pragma vertex vert
        #pragma fragment frag

            // DotsInstancingOptions: <None>
            // HybridV1InjectedBuiltinProperties: <None>

            // Keywords
            #pragma multi_compile _ _SCREEN_SPACE_OCCLUSION
        #pragma multi_compile _ LIGHTMAP_ON
        #pragma multi_compile _ DIRLIGHTMAP_COMBINED
        #pragma multi_compile _ _MAIN_LIGHT_SHADOWS _MAIN_LIGHT_SHADOWS_CASCADE _MAIN_LIGHT_SHADOWS_SCREEN
        #pragma multi_compile _ADDITIONAL_LIGHTS_VERTEX _ADDITIONAL_LIGHTS _ADDITIONAL_OFF
        #pragma multi_compile _ _ADDITIONAL_LIGHT_SHADOWS
        #pragma multi_compile _ _SHADOWS_SOFT
        #pragma multi_compile _ LIGHTMAP_SHADOW_MIXING
        #pragma multi_compile _ SHADOWS_SHADOWMASK
            #pragma shader_feature_local _ _USEDYNAMICCOVERTSTATICMASKF_ON

        #if defined(_USEDYNAMICCOVERTSTATICMASKF_ON)
            #define KEYWORD_PERMUTATION_0
        #else
            #define KEYWORD_PERMUTATION_1
        #endif


            // Defines
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define _AlphaClip 1
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define _NORMALMAP 1
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define _NORMAL_DROPOFF_TS 1
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define ATTRIBUTES_NEED_NORMAL
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define ATTRIBUTES_NEED_TANGENT
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define ATTRIBUTES_NEED_TEXCOORD0
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define ATTRIBUTES_NEED_TEXCOORD1
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define ATTRIBUTES_NEED_COLOR
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define VARYINGS_NEED_POSITION_WS
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define VARYINGS_NEED_NORMAL_WS
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define VARYINGS_NEED_TANGENT_WS
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define VARYINGS_NEED_TEXCOORD0
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define VARYINGS_NEED_COLOR
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define VARYINGS_NEED_VIEWDIRECTION_WS
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define VARYINGS_NEED_FOG_AND_VERTEX_LIGHT
        #endif

            #define FEATURES_GRAPH_VERTEX
            /* WARNING: $splice Could not find named fragment 'PassInstancing' */
            #define SHADERPASS SHADERPASS_FORWARD
            /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */

            // Includes
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Shadows.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"

            // --------------------------------------------------
            // Structs and Packing

            struct Attributes
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 positionOS : POSITION;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 normalOS : NORMAL;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 tangentOS : TANGENT;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 uv0 : TEXCOORD0;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 uv1 : TEXCOORD1;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 color : COLOR;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            uint instanceID : INSTANCEID_SEMANTIC;
            #endif
            #endif
        };
        struct Varyings
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 positionCS : SV_POSITION;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 positionWS;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 normalWS;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 tangentWS;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 texCoord0;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 color;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 viewDirectionWS;
            #endif
            #if defined(LIGHTMAP_ON)
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float2 lightmapUV;
            #endif
            #endif
            #if !defined(LIGHTMAP_ON)
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 sh;
            #endif
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 fogFactorAndVertexLight;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 shadowCoord;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
            #endif
        };
        struct SurfaceDescriptionInputs
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 WorldSpaceNormal;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 TangentSpaceNormal;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 WorldSpaceTangent;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 WorldSpaceBiTangent;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 AbsoluteWorldSpacePosition;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 uv0;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 VertexColor;
            #endif
        };
        struct VertexDescriptionInputs
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 ObjectSpaceNormal;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 ObjectSpaceTangent;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 ObjectSpacePosition;
            #endif
        };
        struct PackedVaryings
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 positionCS : SV_POSITION;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 interp0 : TEXCOORD0;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 interp1 : TEXCOORD1;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 interp2 : TEXCOORD2;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 interp3 : TEXCOORD3;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 interp4 : TEXCOORD4;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 interp5 : TEXCOORD5;
            #endif
            #if defined(LIGHTMAP_ON)
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float2 interp6 : TEXCOORD6;
            #endif
            #endif
            #if !defined(LIGHTMAP_ON)
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 interp7 : TEXCOORD7;
            #endif
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 interp8 : TEXCOORD8;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 interp9 : TEXCOORD9;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
            #endif
        };

            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            output.positionCS = input.positionCS;
            output.interp0.xyz =  input.positionWS;
            output.interp1.xyz =  input.normalWS;
            output.interp2.xyzw =  input.tangentWS;
            output.interp3.xyzw =  input.texCoord0;
            output.interp4.xyzw =  input.color;
            output.interp5.xyz =  input.viewDirectionWS;
            #if defined(LIGHTMAP_ON)
            output.interp6.xy =  input.lightmapUV;
            #endif
            #if !defined(LIGHTMAP_ON)
            output.interp7.xyz =  input.sh;
            #endif
            output.interp8.xyzw =  input.fogFactorAndVertexLight;
            output.interp9.xyzw =  input.shadowCoord;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.positionWS = input.interp0.xyz;
            output.normalWS = input.interp1.xyz;
            output.tangentWS = input.interp2.xyzw;
            output.texCoord0 = input.interp3.xyzw;
            output.color = input.interp4.xyzw;
            output.viewDirectionWS = input.interp5.xyz;
            #if defined(LIGHTMAP_ON)
            output.lightmapUV = input.interp6.xy;
            #endif
            #if !defined(LIGHTMAP_ON)
            output.sh = input.interp7.xyz;
            #endif
            output.fogFactorAndVertexLight = input.interp8.xyzw;
            output.shadowCoord = input.interp9.xyzw;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        #endif

            // --------------------------------------------------
            // Graph

            // Graph Properties
            CBUFFER_START(UnityPerMaterial)
        float _AlphaCutoff;
        float4 _BaseColor;
        float4 _BaseColorMap_TexelSize;
        float _BaseUsePlanarUV;
        float4 _BaseTilingOffset;
        float4 _BaseNormalMap_TexelSize;
        float _BaseNormalScale;
        float4 _BaseMaskMap_TexelSize;
        float _BaseMetallic;
        float _BaseAORemapMin;
        float _BaseAORemapMax;
        float _BaseSmoothnessRemapMin;
        float _BaseSmoothnessRemapMax;
        float4 _CoverMaskA_TexelSize;
        float _CoverMaskPower;
        float _Cover_Amount;
        float _Cover_Amount_Grow_Speed;
        float _Cover_Max_Angle;
        float _Cover_Min_Height;
        float _Cover_Min_Height_Blending;
        float4 _CoverBaseColor;
        float4 _CoverBaseColorMap_TexelSize;
        float _CoverUsePlanarUV;
        float4 _CoverTilingOffset;
        float4 _CoverNormalMap_TexelSize;
        float _CoverNormalScale;
        float _CoverNormalBlendHardness;
        float _CoverHardness;
        float _CoverHeightMapMin;
        float _CoverHeightMapMax;
        float _CoverHeightMapOffset;
        float4 _CoverMaskMap_TexelSize;
        float _CoverMetallic;
        float _CoverAORemapMin;
        float _CoverAORemapMax;
        float _CoverSmoothnessRemapMin;
        float _CoverSmoothnessRemapMax;
        float4 _DetailMap_TexelSize;
        float4 _DetailTilingOffset;
        float _DetailAlbedoScale;
        float _DetailNormalScale;
        float _DetailSmoothnessScale;
        float4 _WetColor;
        float _WetSmoothness;
        CBUFFER_END

        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_BaseColorMap);
        SAMPLER(sampler_BaseColorMap);
        TEXTURE2D(_BaseNormalMap);
        SAMPLER(sampler_BaseNormalMap);
        TEXTURE2D(_BaseMaskMap);
        SAMPLER(sampler_BaseMaskMap);
        TEXTURE2D(_CoverMaskA);
        SAMPLER(sampler_CoverMaskA);
        TEXTURE2D(_CoverBaseColorMap);
        SAMPLER(sampler_CoverBaseColorMap);
        TEXTURE2D(_CoverNormalMap);
        SAMPLER(sampler_CoverNormalMap);
        TEXTURE2D(_CoverMaskMap);
        SAMPLER(sampler_CoverMaskMap);
        TEXTURE2D(_DetailMap);
        SAMPLER(sampler_DetailMap);

            // Graph Functions
            
        // f948cdce565a6e706cc57cb23fbf9d95
        #include "./NM_Object_VSPro_Indirect.cginc"

        void AddPragma_float(float3 A, out float3 Out){
            #pragma instancing_options renderinglayer procedural:setupVSPro
            Out = A;
        }

        struct Bindings_NMObjectVSProIndirect_0cfe1e4f145944241ab304331e53c93b
        {
        };

        void SG_NMObjectVSProIndirect_0cfe1e4f145944241ab304331e53c93b(float3 Vector3_314C8600, Bindings_NMObjectVSProIndirect_0cfe1e4f145944241ab304331e53c93b IN, out float3 ObjectSpacePosition_1)
        {
            float3 _Property_5ec158abd968858c9d31ab40df5e9e6f_Out_0 = Vector3_314C8600;
            float3 _InjectSetupCustomFunction_dec9b26544b4a788b8ecb4117dc3d24a_Out_1;
            InjectSetup_float(_Property_5ec158abd968858c9d31ab40df5e9e6f_Out_0, _InjectSetupCustomFunction_dec9b26544b4a788b8ecb4117dc3d24a_Out_1);
            float3 _AddPragmaCustomFunction_b2a053178906d0848480a1f463521a1b_Out_1;
            AddPragma_float(_InjectSetupCustomFunction_dec9b26544b4a788b8ecb4117dc3d24a_Out_1, _AddPragmaCustomFunction_b2a053178906d0848480a1f463521a1b_Out_1);
            ObjectSpacePosition_1 = _AddPragmaCustomFunction_b2a053178906d0848480a1f463521a1b_Out_1;
        }

        void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
        {
            RGBA = float4(R, G, B, A);
            RGB = float3(R, G, B);
            RG = float2(R, G);
        }

        void Unity_Divide_float(float A, float B, out float Out)
        {
            Out = A / B;
        }

        void Unity_Multiply_float(float4 A, float4 B, out float4 Out)
        {
            Out = A * B;
        }

        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }

        void Unity_Branch_float2(float Predicate, float2 True, float2 False, out float2 Out)
        {
            Out = Predicate ? True : False;
        }

        struct Bindings_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6
        {
            float3 AbsoluteWorldSpacePosition;
            half4 uv0;
        };

        void SG_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6(UnityTexture2D Texture2D_80A3D28F, float4 Vector4_2EBA7A3B, float Boolean_7ABB9909, Bindings_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6 IN, out float4 XZ_2)
        {
            UnityTexture2D _Property_3e01b4d2fc68d48ba3acbba9d5881e59_Out_0 = Texture2D_80A3D28F;
            float _Property_30834f691775a0898a45b1c868520436_Out_0 = Boolean_7ABB9909;
            float _Split_89ed63cb625cb3878c183d0b71c03400_R_1 = IN.AbsoluteWorldSpacePosition[0];
            float _Split_89ed63cb625cb3878c183d0b71c03400_G_2 = IN.AbsoluteWorldSpacePosition[1];
            float _Split_89ed63cb625cb3878c183d0b71c03400_B_3 = IN.AbsoluteWorldSpacePosition[2];
            float _Split_89ed63cb625cb3878c183d0b71c03400_A_4 = 0;
            float4 _Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4;
            float3 _Combine_cf2d04ff119ad88493f6460431765cbb_RGB_5;
            float2 _Combine_cf2d04ff119ad88493f6460431765cbb_RG_6;
            Unity_Combine_float(_Split_89ed63cb625cb3878c183d0b71c03400_R_1, _Split_89ed63cb625cb3878c183d0b71c03400_B_3, 0, 0, _Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4, _Combine_cf2d04ff119ad88493f6460431765cbb_RGB_5, _Combine_cf2d04ff119ad88493f6460431765cbb_RG_6);
            float4 _Property_8a66888ec47d0687ab1cb2f8abdc9da8_Out_0 = Vector4_2EBA7A3B;
            float _Split_2f0f52f6ef8c0e81af0da6476402bc1f_R_1 = _Property_8a66888ec47d0687ab1cb2f8abdc9da8_Out_0[0];
            float _Split_2f0f52f6ef8c0e81af0da6476402bc1f_G_2 = _Property_8a66888ec47d0687ab1cb2f8abdc9da8_Out_0[1];
            float _Split_2f0f52f6ef8c0e81af0da6476402bc1f_B_3 = _Property_8a66888ec47d0687ab1cb2f8abdc9da8_Out_0[2];
            float _Split_2f0f52f6ef8c0e81af0da6476402bc1f_A_4 = _Property_8a66888ec47d0687ab1cb2f8abdc9da8_Out_0[3];
            float _Divide_e64179199923c58289b6aa94ea6c9178_Out_2;
            Unity_Divide_float(1, _Split_2f0f52f6ef8c0e81af0da6476402bc1f_R_1, _Divide_e64179199923c58289b6aa94ea6c9178_Out_2);
            float4 _Multiply_14cec4902d0a00829e4555071a1b8ad1_Out_2;
            Unity_Multiply_float(_Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4, (_Divide_e64179199923c58289b6aa94ea6c9178_Out_2.xxxx), _Multiply_14cec4902d0a00829e4555071a1b8ad1_Out_2);
            float2 _Vector2_16c15d3bbdd14b85bd48e3a6cb318af7_Out_0 = float2(_Split_2f0f52f6ef8c0e81af0da6476402bc1f_R_1, _Split_2f0f52f6ef8c0e81af0da6476402bc1f_G_2);
            float2 _Vector2_f8d75f54e7705083bbec539a60185577_Out_0 = float2(_Split_2f0f52f6ef8c0e81af0da6476402bc1f_B_3, _Split_2f0f52f6ef8c0e81af0da6476402bc1f_A_4);
            float2 _TilingAndOffset_d91e2d25acd34686b562b7fe7e9d1d27_Out_3;
            Unity_TilingAndOffset_float(IN.uv0.xy, _Vector2_16c15d3bbdd14b85bd48e3a6cb318af7_Out_0, _Vector2_f8d75f54e7705083bbec539a60185577_Out_0, _TilingAndOffset_d91e2d25acd34686b562b7fe7e9d1d27_Out_3);
            float2 _Branch_8e5a4e8f4d52fc8aadd1f46485afc933_Out_3;
            Unity_Branch_float2(_Property_30834f691775a0898a45b1c868520436_Out_0, (_Multiply_14cec4902d0a00829e4555071a1b8ad1_Out_2.xy), _TilingAndOffset_d91e2d25acd34686b562b7fe7e9d1d27_Out_3, _Branch_8e5a4e8f4d52fc8aadd1f46485afc933_Out_3);
            float4 _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0 = SAMPLE_TEXTURE2D(_Property_3e01b4d2fc68d48ba3acbba9d5881e59_Out_0.tex, _Property_3e01b4d2fc68d48ba3acbba9d5881e59_Out_0.samplerstate, _Branch_8e5a4e8f4d52fc8aadd1f46485afc933_Out_3);
            float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_R_4 = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0.r;
            float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_G_5 = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0.g;
            float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_B_6 = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0.b;
            float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_A_7 = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0.a;
            XZ_2 = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0;
        }

        void Unity_Multiply_float(float A, float B, out float Out)
        {
            Out = A * B;
        }

        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
        }

        void Unity_Saturate_float(float In, out float Out)
        {
            Out = saturate(In);
        }

        void Unity_Absolute_float(float In, out float Out)
        {
            Out = abs(In);
        }

        void Unity_SquareRoot_float4(float4 In, out float4 Out)
        {
            Out = sqrt(In);
        }

        void Unity_Sign_float(float In, out float Out)
        {
            Out = sign(In);
        }

        void Unity_Ceiling_float(float In, out float Out)
        {
            Out = ceil(In);
        }

        void Unity_Lerp_float4(float4 A, float4 B, float4 T, out float4 Out)
        {
            Out = lerp(A, B, T);
        }

        struct Bindings_BlendOverlayBaseColor_acdb3dfca72bd6b42bbc35f4613331a2
        {
        };

        void SG_BlendOverlayBaseColor_acdb3dfca72bd6b42bbc35f4613331a2(float4 Color_9AA111D3, float Vector1_FBE622A2, float Vector1_8C15C351, Bindings_BlendOverlayBaseColor_acdb3dfca72bd6b42bbc35f4613331a2 IN, out float3 OutVector4_1)
        {
            float4 _Property_012510d774fb7f8b860f5270dca4500f_Out_0 = Color_9AA111D3;
            float4 _SquareRoot_c2c57d0223a9538aa9240890c3cacb0c_Out_1;
            Unity_SquareRoot_float4(_Property_012510d774fb7f8b860f5270dca4500f_Out_0, _SquareRoot_c2c57d0223a9538aa9240890c3cacb0c_Out_1);
            float _Property_a00e29241d12f983b30177515b367ec9_Out_0 = Vector1_FBE622A2;
            float _Sign_343a45ede7349283a681c6bd9998fd8e_Out_1;
            Unity_Sign_float(_Property_a00e29241d12f983b30177515b367ec9_Out_0, _Sign_343a45ede7349283a681c6bd9998fd8e_Out_1);
            float _Add_681019b8f5d3d68bb482d419c9fc61a9_Out_2;
            Unity_Add_float(_Sign_343a45ede7349283a681c6bd9998fd8e_Out_1, 1, _Add_681019b8f5d3d68bb482d419c9fc61a9_Out_2);
            float _Multiply_e8f4cb722712a880ac0db6c7461427f7_Out_2;
            Unity_Multiply_float(_Add_681019b8f5d3d68bb482d419c9fc61a9_Out_2, 0.5, _Multiply_e8f4cb722712a880ac0db6c7461427f7_Out_2);
            float _Ceiling_95ad15988aa9b98184875fa754feae01_Out_1;
            Unity_Ceiling_float(_Multiply_e8f4cb722712a880ac0db6c7461427f7_Out_2, _Ceiling_95ad15988aa9b98184875fa754feae01_Out_1);
            float _Property_2db1c747a05ee284a8b00076062f91a4_Out_0 = Vector1_8C15C351;
            float _Multiply_9564ecda5193bc8286d9ff771c9226cd_Out_2;
            Unity_Multiply_float(_Property_2db1c747a05ee284a8b00076062f91a4_Out_0, _Property_2db1c747a05ee284a8b00076062f91a4_Out_0, _Multiply_9564ecda5193bc8286d9ff771c9226cd_Out_2);
            float4 _Lerp_b3cdb01fc3c5b988ac9b184943bf7c01_Out_3;
            Unity_Lerp_float4(_SquareRoot_c2c57d0223a9538aa9240890c3cacb0c_Out_1, (_Ceiling_95ad15988aa9b98184875fa754feae01_Out_1.xxxx), (_Multiply_9564ecda5193bc8286d9ff771c9226cd_Out_2.xxxx), _Lerp_b3cdb01fc3c5b988ac9b184943bf7c01_Out_3);
            float4 _Multiply_39d1daff98488f8ea2cd794ad4f20926_Out_2;
            Unity_Multiply_float(_Lerp_b3cdb01fc3c5b988ac9b184943bf7c01_Out_3, _Lerp_b3cdb01fc3c5b988ac9b184943bf7c01_Out_3, _Multiply_39d1daff98488f8ea2cd794ad4f20926_Out_2);
            OutVector4_1 = (_Multiply_39d1daff98488f8ea2cd794ad4f20926_Out_2.xyz);
        }

        void Unity_Clamp_float(float In, float Min, float Max, out float Out)
        {
            Out = clamp(In, Min, Max);
        }

        void Unity_Multiply_float(float2 A, float2 B, out float2 Out)
        {
            Out = A * B;
        }

        void Unity_Add_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A + B;
        }

        void Unity_DotProduct_float2(float2 A, float2 B, out float Out)
        {
            Out = dot(A, B);
        }

        void Unity_OneMinus_float(float In, out float Out)
        {
            Out = 1 - In;
        }

        void Unity_SquareRoot_float(float In, out float Out)
        {
            Out = sqrt(In);
        }

        void Unity_Sign_float3(float3 In, out float3 Out)
        {
            Out = sign(In);
        }

        void Unity_Normalize_float3(float3 In, out float3 Out)
        {
            Out = normalize(In);
        }

        void Unity_Branch_float3(float Predicate, float3 True, float3 False, out float3 Out)
        {
            Out = Predicate ? True : False;
        }

        struct Bindings_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8
        {
            float3 WorldSpaceNormal;
            float3 WorldSpaceTangent;
            float3 WorldSpaceBiTangent;
            float3 AbsoluteWorldSpacePosition;
            half4 uv0;
        };

        void SG_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8(UnityTexture2D Texture2D_80A3D28F, float4 Vector4_82674548, float Boolean_9FF42DF6, Bindings_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8 IN, out float4 XZ_2)
        {
            float _Property_1ef12cf3201a938993fe6a7951b0e754_Out_0 = Boolean_9FF42DF6;
            UnityTexture2D _Property_3e01b4d2fc68d48ba3acbba9d5881e59_Out_0 = Texture2D_80A3D28F;
            float _Split_89ed63cb625cb3878c183d0b71c03400_R_1 = IN.AbsoluteWorldSpacePosition[0];
            float _Split_89ed63cb625cb3878c183d0b71c03400_G_2 = IN.AbsoluteWorldSpacePosition[1];
            float _Split_89ed63cb625cb3878c183d0b71c03400_B_3 = IN.AbsoluteWorldSpacePosition[2];
            float _Split_89ed63cb625cb3878c183d0b71c03400_A_4 = 0;
            float4 _Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4;
            float3 _Combine_cf2d04ff119ad88493f6460431765cbb_RGB_5;
            float2 _Combine_cf2d04ff119ad88493f6460431765cbb_RG_6;
            Unity_Combine_float(_Split_89ed63cb625cb3878c183d0b71c03400_R_1, _Split_89ed63cb625cb3878c183d0b71c03400_B_3, 0, 0, _Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4, _Combine_cf2d04ff119ad88493f6460431765cbb_RGB_5, _Combine_cf2d04ff119ad88493f6460431765cbb_RG_6);
            float4 _Property_3fa1d6f912feb481ba60f2e55e62e746_Out_0 = Vector4_82674548;
            float _Split_a2e12fa5931da084b2949343a539dfd8_R_1 = _Property_3fa1d6f912feb481ba60f2e55e62e746_Out_0[0];
            float _Split_a2e12fa5931da084b2949343a539dfd8_G_2 = _Property_3fa1d6f912feb481ba60f2e55e62e746_Out_0[1];
            float _Split_a2e12fa5931da084b2949343a539dfd8_B_3 = _Property_3fa1d6f912feb481ba60f2e55e62e746_Out_0[2];
            float _Split_a2e12fa5931da084b2949343a539dfd8_A_4 = _Property_3fa1d6f912feb481ba60f2e55e62e746_Out_0[3];
            float _Divide_c36b770dfaa0bb8f85ab27da5fd794f0_Out_2;
            Unity_Divide_float(1, _Split_a2e12fa5931da084b2949343a539dfd8_R_1, _Divide_c36b770dfaa0bb8f85ab27da5fd794f0_Out_2);
            float4 _Multiply_14cec4902d0a00829e4555071a1b8ad1_Out_2;
            Unity_Multiply_float(_Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4, (_Divide_c36b770dfaa0bb8f85ab27da5fd794f0_Out_2.xxxx), _Multiply_14cec4902d0a00829e4555071a1b8ad1_Out_2);
            float2 _Vector2_6845d21872714d889783b0cb707df3e9_Out_0 = float2(_Split_a2e12fa5931da084b2949343a539dfd8_R_1, _Split_a2e12fa5931da084b2949343a539dfd8_G_2);
            float2 _Vector2_e2e2263627c6098e96a5b5d29350ad03_Out_0 = float2(_Split_a2e12fa5931da084b2949343a539dfd8_B_3, _Split_a2e12fa5931da084b2949343a539dfd8_A_4);
            float2 _TilingAndOffset_17582d056c0b8a8dab1017d37497fe59_Out_3;
            Unity_TilingAndOffset_float(IN.uv0.xy, _Vector2_6845d21872714d889783b0cb707df3e9_Out_0, _Vector2_e2e2263627c6098e96a5b5d29350ad03_Out_0, _TilingAndOffset_17582d056c0b8a8dab1017d37497fe59_Out_3);
            float2 _Branch_1e152f3aac57448f8518bf2852c000c3_Out_3;
            Unity_Branch_float2(_Property_1ef12cf3201a938993fe6a7951b0e754_Out_0, (_Multiply_14cec4902d0a00829e4555071a1b8ad1_Out_2.xy), _TilingAndOffset_17582d056c0b8a8dab1017d37497fe59_Out_3, _Branch_1e152f3aac57448f8518bf2852c000c3_Out_3);
            float4 _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0 = SAMPLE_TEXTURE2D(_Property_3e01b4d2fc68d48ba3acbba9d5881e59_Out_0.tex, _Property_3e01b4d2fc68d48ba3acbba9d5881e59_Out_0.samplerstate, _Branch_1e152f3aac57448f8518bf2852c000c3_Out_3);
            _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0.rgb = UnpackNormal(_SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0);
            float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_R_4 = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0.r;
            float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_G_5 = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0.g;
            float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_B_6 = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0.b;
            float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_A_7 = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0.a;
            float2 _Vector2_ad6bd100e273d78fa409a30a77bfa2cc_Out_0 = float2(_SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_R_4, _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_G_5);
            float3 _Sign_3a6ebf59931cf08cb0482e0144ddac24_Out_1;
            Unity_Sign_float3(IN.WorldSpaceNormal, _Sign_3a6ebf59931cf08cb0482e0144ddac24_Out_1);
            float _Split_6299d4ddcc4c74828aea40a46fdb896e_R_1 = _Sign_3a6ebf59931cf08cb0482e0144ddac24_Out_1[0];
            float _Split_6299d4ddcc4c74828aea40a46fdb896e_G_2 = _Sign_3a6ebf59931cf08cb0482e0144ddac24_Out_1[1];
            float _Split_6299d4ddcc4c74828aea40a46fdb896e_B_3 = _Sign_3a6ebf59931cf08cb0482e0144ddac24_Out_1[2];
            float _Split_6299d4ddcc4c74828aea40a46fdb896e_A_4 = 0;
            float2 _Vector2_b76cb1842101e58b9e636d49b075c612_Out_0 = float2(_Split_6299d4ddcc4c74828aea40a46fdb896e_G_2, 1);
            float2 _Multiply_31e8db88ee20c985a9850d1a58f3282b_Out_2;
            Unity_Multiply_float(_Vector2_ad6bd100e273d78fa409a30a77bfa2cc_Out_0, _Vector2_b76cb1842101e58b9e636d49b075c612_Out_0, _Multiply_31e8db88ee20c985a9850d1a58f3282b_Out_2);
            float _Split_5ed44bf2eca0868f81eb18100f49d1fa_R_1 = IN.WorldSpaceNormal[0];
            float _Split_5ed44bf2eca0868f81eb18100f49d1fa_G_2 = IN.WorldSpaceNormal[1];
            float _Split_5ed44bf2eca0868f81eb18100f49d1fa_B_3 = IN.WorldSpaceNormal[2];
            float _Split_5ed44bf2eca0868f81eb18100f49d1fa_A_4 = 0;
            float2 _Vector2_70e5837843f28b8b9d64cada3697bd5a_Out_0 = float2(_Split_5ed44bf2eca0868f81eb18100f49d1fa_R_1, _Split_5ed44bf2eca0868f81eb18100f49d1fa_B_3);
            float2 _Add_1145b2f896593d80aa864a34e6702562_Out_2;
            Unity_Add_float2(_Multiply_31e8db88ee20c985a9850d1a58f3282b_Out_2, _Vector2_70e5837843f28b8b9d64cada3697bd5a_Out_0, _Add_1145b2f896593d80aa864a34e6702562_Out_2);
            float _Split_2bc77ca2d17bd78cb2383770ce50b179_R_1 = _Add_1145b2f896593d80aa864a34e6702562_Out_2[0];
            float _Split_2bc77ca2d17bd78cb2383770ce50b179_G_2 = _Add_1145b2f896593d80aa864a34e6702562_Out_2[1];
            float _Split_2bc77ca2d17bd78cb2383770ce50b179_B_3 = 0;
            float _Split_2bc77ca2d17bd78cb2383770ce50b179_A_4 = 0;
            float _Multiply_ab12aea87465a78eaf7fc66c2598d266_Out_2;
            Unity_Multiply_float(_SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_B_6, _Split_5ed44bf2eca0868f81eb18100f49d1fa_G_2, _Multiply_ab12aea87465a78eaf7fc66c2598d266_Out_2);
            float3 _Vector3_433840b555db308b97e9b14b6a957195_Out_0 = float3(_Split_2bc77ca2d17bd78cb2383770ce50b179_R_1, _Multiply_ab12aea87465a78eaf7fc66c2598d266_Out_2, _Split_2bc77ca2d17bd78cb2383770ce50b179_G_2);
            float3x3 Transform_c7914cc45a011c89b3f53c55afb51673_tangentTransform_World = float3x3(IN.WorldSpaceTangent, IN.WorldSpaceBiTangent, IN.WorldSpaceNormal);
            float3 _Transform_c7914cc45a011c89b3f53c55afb51673_Out_1 = TransformWorldToTangent(_Vector3_433840b555db308b97e9b14b6a957195_Out_0.xyz, Transform_c7914cc45a011c89b3f53c55afb51673_tangentTransform_World);
            float3 _Normalize_09bf8a2bd0a4d38e8b97d5c674f79b44_Out_1;
            Unity_Normalize_float3(_Transform_c7914cc45a011c89b3f53c55afb51673_Out_1, _Normalize_09bf8a2bd0a4d38e8b97d5c674f79b44_Out_1);
            float3 _Branch_9eadf909a90f2f80880f8c56ecc2a91f_Out_3;
            Unity_Branch_float3(_Property_1ef12cf3201a938993fe6a7951b0e754_Out_0, _Normalize_09bf8a2bd0a4d38e8b97d5c674f79b44_Out_1, (_SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0.xyz), _Branch_9eadf909a90f2f80880f8c56ecc2a91f_Out_3);
            XZ_2 = (float4(_Branch_9eadf909a90f2f80880f8c56ecc2a91f_Out_3, 1.0));
        }

        void Unity_NormalStrength_float(float3 In, float Strength, out float3 Out)
        {
            Out = float3(In.rg * Strength, lerp(1, In.b, saturate(Strength)));
        }

        void Unity_NormalBlend_float(float3 A, float3 B, out float3 Out)
        {
            Out = SafeNormalize(float3(A.rg + B.rg, A.b * B.b));
        }

        void Unity_Subtract_float(float A, float B, out float Out)
        {
            Out = A - B;
        }

        void Unity_Power_float(float A, float B, out float Out)
        {
            Out = pow(A, B);
        }

        void Unity_Lerp_float3(float3 A, float3 B, float3 T, out float3 Out)
        {
            Out = lerp(A, B, T);
        }

        void Unity_Remap_float(float In, float2 InMinMax, float2 OutMinMax, out float Out)
        {
            Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
        }

        void Unity_Multiply_float(float3 A, float3 B, out float3 Out)
        {
            Out = A * B;
        }

        void Unity_Lerp_float(float A, float B, float T, out float Out)
        {
            Out = lerp(A, B, T);
        }

        struct Bindings_BlendOverlayDetailSmoothness_06e12138dc89c0040b45a57abe520a1a
        {
        };

        void SG_BlendOverlayDetailSmoothness_06e12138dc89c0040b45a57abe520a1a(float Vector1_32317166, float Vector1_FBE622A2, float Vector1_8C15C351, Bindings_BlendOverlayDetailSmoothness_06e12138dc89c0040b45a57abe520a1a IN, out float SmoothnessOverlay_1)
        {
            float _Property_728cc50521e9e988ac9cbff4872d5139_Out_0 = Vector1_32317166;
            float _Property_a00e29241d12f983b30177515b367ec9_Out_0 = Vector1_FBE622A2;
            float _Sign_343a45ede7349283a681c6bd9998fd8e_Out_1;
            Unity_Sign_float(_Property_a00e29241d12f983b30177515b367ec9_Out_0, _Sign_343a45ede7349283a681c6bd9998fd8e_Out_1);
            float _Add_681019b8f5d3d68bb482d419c9fc61a9_Out_2;
            Unity_Add_float(_Sign_343a45ede7349283a681c6bd9998fd8e_Out_1, 1, _Add_681019b8f5d3d68bb482d419c9fc61a9_Out_2);
            float _Multiply_e8f4cb722712a880ac0db6c7461427f7_Out_2;
            Unity_Multiply_float(_Add_681019b8f5d3d68bb482d419c9fc61a9_Out_2, 0.5, _Multiply_e8f4cb722712a880ac0db6c7461427f7_Out_2);
            float _Ceiling_95ad15988aa9b98184875fa754feae01_Out_1;
            Unity_Ceiling_float(_Multiply_e8f4cb722712a880ac0db6c7461427f7_Out_2, _Ceiling_95ad15988aa9b98184875fa754feae01_Out_1);
            float _Property_2db1c747a05ee284a8b00076062f91a4_Out_0 = Vector1_8C15C351;
            float _Lerp_b3cdb01fc3c5b988ac9b184943bf7c01_Out_3;
            Unity_Lerp_float(_Property_728cc50521e9e988ac9cbff4872d5139_Out_0, _Ceiling_95ad15988aa9b98184875fa754feae01_Out_1, _Property_2db1c747a05ee284a8b00076062f91a4_Out_0, _Lerp_b3cdb01fc3c5b988ac9b184943bf7c01_Out_3);
            SmoothnessOverlay_1 = _Lerp_b3cdb01fc3c5b988ac9b184943bf7c01_Out_3;
        }

            // Graph Vertex
            struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };

        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            Bindings_NMObjectVSProIndirect_0cfe1e4f145944241ab304331e53c93b _NMObjectVSProIndirect_adbe93754e069e8e87df45ef6e4b343e;
            float3 _NMObjectVSProIndirect_adbe93754e069e8e87df45ef6e4b343e_ObjectSpacePosition_1;
            SG_NMObjectVSProIndirect_0cfe1e4f145944241ab304331e53c93b(IN.ObjectSpacePosition, _NMObjectVSProIndirect_adbe93754e069e8e87df45ef6e4b343e, _NMObjectVSProIndirect_adbe93754e069e8e87df45ef6e4b343e_ObjectSpacePosition_1);
            #endif
            description.Position = _NMObjectVSProIndirect_adbe93754e069e8e87df45ef6e4b343e_ObjectSpacePosition_1;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }

            // Graph Pixel
            struct SurfaceDescription
        {
            float3 BaseColor;
            float3 NormalTS;
            float3 Emission;
            float Metallic;
            float Smoothness;
            float Occlusion;
            float Alpha;
            float AlphaClipThreshold;
        };

        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            UnityTexture2D _Property_e4c53213449c7682b60df6ae54f219f0_Out_0 = UnityBuildTexture2DStructNoScale(_BaseColorMap);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 _Property_115fcc827510f38798b214d835c27637_Out_0 = _BaseTilingOffset;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_d83b8f290862b285bbe2f157190e1315_Out_0 = _BaseUsePlanarUV;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            Bindings_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6 _PlanarNM_6c8b686076db2a8c8b7d6cd91cf435f0;
            _PlanarNM_6c8b686076db2a8c8b7d6cd91cf435f0.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            _PlanarNM_6c8b686076db2a8c8b7d6cd91cf435f0.uv0 = IN.uv0;
            float4 _PlanarNM_6c8b686076db2a8c8b7d6cd91cf435f0_XZ_2;
            SG_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6(_Property_e4c53213449c7682b60df6ae54f219f0_Out_0, _Property_115fcc827510f38798b214d835c27637_Out_0, _Property_d83b8f290862b285bbe2f157190e1315_Out_0, _PlanarNM_6c8b686076db2a8c8b7d6cd91cf435f0, _PlanarNM_6c8b686076db2a8c8b7d6cd91cf435f0_XZ_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 _Property_13c79aaf332e20868551d934a2cb7112_Out_0 = _BaseColor;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 _Multiply_3d0c2fda612cfe87aa84bc17ad099a61_Out_2;
            Unity_Multiply_float(_PlanarNM_6c8b686076db2a8c8b7d6cd91cf435f0_XZ_2, _Property_13c79aaf332e20868551d934a2cb7112_Out_0, _Multiply_3d0c2fda612cfe87aa84bc17ad099a61_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            UnityTexture2D _Property_b561c414493a8f8299227a27e437f045_Out_0 = UnityBuildTexture2DStructNoScale(_DetailMap);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 _Property_70f1cc2b73af738d80b0d405e4bed8c5_Out_0 = _DetailTilingOffset;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Split_cda27505033cfc8eaf60fe914f0949b9_R_1 = _Property_70f1cc2b73af738d80b0d405e4bed8c5_Out_0[0];
            float _Split_cda27505033cfc8eaf60fe914f0949b9_G_2 = _Property_70f1cc2b73af738d80b0d405e4bed8c5_Out_0[1];
            float _Split_cda27505033cfc8eaf60fe914f0949b9_B_3 = _Property_70f1cc2b73af738d80b0d405e4bed8c5_Out_0[2];
            float _Split_cda27505033cfc8eaf60fe914f0949b9_A_4 = _Property_70f1cc2b73af738d80b0d405e4bed8c5_Out_0[3];
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float2 _Vector2_42d7e955009b6f8cb4d913530ff92840_Out_0 = float2(_Split_cda27505033cfc8eaf60fe914f0949b9_R_1, _Split_cda27505033cfc8eaf60fe914f0949b9_G_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float2 _Vector2_5452a0299d10b280aec51f7407d4d2ac_Out_0 = float2(_Split_cda27505033cfc8eaf60fe914f0949b9_B_3, _Split_cda27505033cfc8eaf60fe914f0949b9_A_4);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float2 _TilingAndOffset_e1c5b97bd253ca8f9f3d26f598e6d7fd_Out_3;
            Unity_TilingAndOffset_float(IN.uv0.xy, _Vector2_42d7e955009b6f8cb4d913530ff92840_Out_0, _Vector2_5452a0299d10b280aec51f7407d4d2ac_Out_0, _TilingAndOffset_e1c5b97bd253ca8f9f3d26f598e6d7fd_Out_3);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 _SampleTexture2D_fa4ac40fc922b9869e37c06690c0f530_RGBA_0 = SAMPLE_TEXTURE2D(_Property_b561c414493a8f8299227a27e437f045_Out_0.tex, _Property_b561c414493a8f8299227a27e437f045_Out_0.samplerstate, _TilingAndOffset_e1c5b97bd253ca8f9f3d26f598e6d7fd_Out_3);
            float _SampleTexture2D_fa4ac40fc922b9869e37c06690c0f530_R_4 = _SampleTexture2D_fa4ac40fc922b9869e37c06690c0f530_RGBA_0.r;
            float _SampleTexture2D_fa4ac40fc922b9869e37c06690c0f530_G_5 = _SampleTexture2D_fa4ac40fc922b9869e37c06690c0f530_RGBA_0.g;
            float _SampleTexture2D_fa4ac40fc922b9869e37c06690c0f530_B_6 = _SampleTexture2D_fa4ac40fc922b9869e37c06690c0f530_RGBA_0.b;
            float _SampleTexture2D_fa4ac40fc922b9869e37c06690c0f530_A_7 = _SampleTexture2D_fa4ac40fc922b9869e37c06690c0f530_RGBA_0.a;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Multiply_d0f6aeb5b3f04288b51a5ded8986b5a4_Out_2;
            Unity_Multiply_float(_SampleTexture2D_fa4ac40fc922b9869e37c06690c0f530_R_4, 2, _Multiply_d0f6aeb5b3f04288b51a5ded8986b5a4_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Add_d382719213f8618f88c54f7c3dfbd8c2_Out_2;
            Unity_Add_float(_Multiply_d0f6aeb5b3f04288b51a5ded8986b5a4_Out_2, -1, _Add_d382719213f8618f88c54f7c3dfbd8c2_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_02e7dd176dc59f8a9a62453677916b24_Out_0 = _DetailAlbedoScale;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Multiply_fd406247e3137a8b8777918477740653_Out_2;
            Unity_Multiply_float(_Add_d382719213f8618f88c54f7c3dfbd8c2_Out_2, _Property_02e7dd176dc59f8a9a62453677916b24_Out_0, _Multiply_fd406247e3137a8b8777918477740653_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Saturate_d6f590fb1b9d188e981ebb0ec4d36ba9_Out_1;
            Unity_Saturate_float(_Multiply_fd406247e3137a8b8777918477740653_Out_2, _Saturate_d6f590fb1b9d188e981ebb0ec4d36ba9_Out_1);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Absolute_dc927550b803d18ba3ff372995e6d25c_Out_1;
            Unity_Absolute_float(_Saturate_d6f590fb1b9d188e981ebb0ec4d36ba9_Out_1, _Absolute_dc927550b803d18ba3ff372995e6d25c_Out_1);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            Bindings_BlendOverlayBaseColor_acdb3dfca72bd6b42bbc35f4613331a2 _BlendOverlayBaseColor_f3cd25d5b673648eb831a3f388201f73;
            float3 _BlendOverlayBaseColor_f3cd25d5b673648eb831a3f388201f73_OutVector4_1;
            SG_BlendOverlayBaseColor_acdb3dfca72bd6b42bbc35f4613331a2(_Multiply_3d0c2fda612cfe87aa84bc17ad099a61_Out_2, _Add_d382719213f8618f88c54f7c3dfbd8c2_Out_2, _Absolute_dc927550b803d18ba3ff372995e6d25c_Out_1, _BlendOverlayBaseColor_f3cd25d5b673648eb831a3f388201f73, _BlendOverlayBaseColor_f3cd25d5b673648eb831a3f388201f73_OutVector4_1);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            UnityTexture2D _Property_f4db51ec2412c48cbcf2128b7bd8caf8_Out_0 = UnityBuildTexture2DStructNoScale(_CoverBaseColorMap);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 _Property_e35c79b8cccfbe8ca0a3c33e8d32e319_Out_0 = _CoverTilingOffset;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_e3d8b38b51331e879b1d4012d65f53e6_Out_0 = _CoverUsePlanarUV;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            Bindings_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6 _PlanarNM_c2ec737ef76d6286b8eedb44a2d24e50;
            _PlanarNM_c2ec737ef76d6286b8eedb44a2d24e50.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            _PlanarNM_c2ec737ef76d6286b8eedb44a2d24e50.uv0 = IN.uv0;
            float4 _PlanarNM_c2ec737ef76d6286b8eedb44a2d24e50_XZ_2;
            SG_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6(_Property_f4db51ec2412c48cbcf2128b7bd8caf8_Out_0, _Property_e35c79b8cccfbe8ca0a3c33e8d32e319_Out_0, _Property_e3d8b38b51331e879b1d4012d65f53e6_Out_0, _PlanarNM_c2ec737ef76d6286b8eedb44a2d24e50, _PlanarNM_c2ec737ef76d6286b8eedb44a2d24e50_XZ_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 _Property_7d3af9045f54ef8ba8629ebbbc3f4ad7_Out_0 = _CoverBaseColor;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 _Multiply_2eb83c7af5b6f58eabeec7b502517470_Out_2;
            Unity_Multiply_float(_PlanarNM_c2ec737ef76d6286b8eedb44a2d24e50_XZ_2, _Property_7d3af9045f54ef8ba8629ebbbc3f4ad7_Out_0, _Multiply_2eb83c7af5b6f58eabeec7b502517470_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            UnityTexture2D _Property_356186a26fec8686a13bc6b57fd8f3ee_Out_0 = UnityBuildTexture2DStructNoScale(_CoverMaskA);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 _UV_045cea9e82354980a778f44d92578382_Out_0 = IN.uv0;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 _SampleTexture2D_0eef6ae3dab6e185bd0f65edecd80314_RGBA_0 = SAMPLE_TEXTURE2D(_Property_356186a26fec8686a13bc6b57fd8f3ee_Out_0.tex, _Property_356186a26fec8686a13bc6b57fd8f3ee_Out_0.samplerstate, (_UV_045cea9e82354980a778f44d92578382_Out_0.xy));
            float _SampleTexture2D_0eef6ae3dab6e185bd0f65edecd80314_R_4 = _SampleTexture2D_0eef6ae3dab6e185bd0f65edecd80314_RGBA_0.r;
            float _SampleTexture2D_0eef6ae3dab6e185bd0f65edecd80314_G_5 = _SampleTexture2D_0eef6ae3dab6e185bd0f65edecd80314_RGBA_0.g;
            float _SampleTexture2D_0eef6ae3dab6e185bd0f65edecd80314_B_6 = _SampleTexture2D_0eef6ae3dab6e185bd0f65edecd80314_RGBA_0.b;
            float _SampleTexture2D_0eef6ae3dab6e185bd0f65edecd80314_A_7 = _SampleTexture2D_0eef6ae3dab6e185bd0f65edecd80314_RGBA_0.a;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_4e8240836843df81941cdf6cf2cdd638_Out_0 = _CoverMaskPower;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Multiply_8b5250e5dfc73a84a41399a13b83c0a1_Out_2;
            Unity_Multiply_float(_SampleTexture2D_0eef6ae3dab6e185bd0f65edecd80314_A_7, _Property_4e8240836843df81941cdf6cf2cdd638_Out_0, _Multiply_8b5250e5dfc73a84a41399a13b83c0a1_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Clamp_030a7c32684c258084338456eaddc77a_Out_3;
            Unity_Clamp_float(_Multiply_8b5250e5dfc73a84a41399a13b83c0a1_Out_2, 0, 1, _Clamp_030a7c32684c258084338456eaddc77a_Out_3);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Split_8ba5b67899f36b8f9dcf5c84092c0560_R_1 = IN.VertexColor[0];
            float _Split_8ba5b67899f36b8f9dcf5c84092c0560_G_2 = IN.VertexColor[1];
            float _Split_8ba5b67899f36b8f9dcf5c84092c0560_B_3 = IN.VertexColor[2];
            float _Split_8ba5b67899f36b8f9dcf5c84092c0560_A_4 = IN.VertexColor[3];
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float2 _Vector2_65060e9a9f687a89b68e32dc876be645_Out_0 = float2(_SampleTexture2D_fa4ac40fc922b9869e37c06690c0f530_A_7, _SampleTexture2D_fa4ac40fc922b9869e37c06690c0f530_G_5);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float2 _Multiply_5d4c3baed6515c8b86a289c70fca8f5d_Out_2;
            Unity_Multiply_float(_Vector2_65060e9a9f687a89b68e32dc876be645_Out_0, float2(2, 2), _Multiply_5d4c3baed6515c8b86a289c70fca8f5d_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float2 _Add_98b310e19c5fa5899c39cc45969c15ea_Out_2;
            Unity_Add_float2(_Multiply_5d4c3baed6515c8b86a289c70fca8f5d_Out_2, float2(-1, -1), _Add_98b310e19c5fa5899c39cc45969c15ea_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_08b99582093b36869beb5ea3d18e765d_Out_0 = _DetailNormalScale;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float2 _Multiply_bf0b80fdb3271784900e5b5ea4c5550f_Out_2;
            Unity_Multiply_float(_Add_98b310e19c5fa5899c39cc45969c15ea_Out_2, (_Property_08b99582093b36869beb5ea3d18e765d_Out_0.xx), _Multiply_bf0b80fdb3271784900e5b5ea4c5550f_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Split_26c1e73f8436c78ebdae5b51365a072b_R_1 = _Multiply_bf0b80fdb3271784900e5b5ea4c5550f_Out_2[0];
            float _Split_26c1e73f8436c78ebdae5b51365a072b_G_2 = _Multiply_bf0b80fdb3271784900e5b5ea4c5550f_Out_2[1];
            float _Split_26c1e73f8436c78ebdae5b51365a072b_B_3 = 0;
            float _Split_26c1e73f8436c78ebdae5b51365a072b_A_4 = 0;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _DotProduct_50aca3ce0da1ad849d7ff4a99df3a322_Out_2;
            Unity_DotProduct_float2(_Multiply_bf0b80fdb3271784900e5b5ea4c5550f_Out_2, _Multiply_bf0b80fdb3271784900e5b5ea4c5550f_Out_2, _DotProduct_50aca3ce0da1ad849d7ff4a99df3a322_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Saturate_491f2ee8417b8782aee83358b89eeb08_Out_1;
            Unity_Saturate_float(_DotProduct_50aca3ce0da1ad849d7ff4a99df3a322_Out_2, _Saturate_491f2ee8417b8782aee83358b89eeb08_Out_1);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _OneMinus_46ad3170d736808d98bf74ffa45e0414_Out_1;
            Unity_OneMinus_float(_Saturate_491f2ee8417b8782aee83358b89eeb08_Out_1, _OneMinus_46ad3170d736808d98bf74ffa45e0414_Out_1);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _SquareRoot_dfeae899ebfeae8f9257c340ca22ce38_Out_1;
            Unity_SquareRoot_float(_OneMinus_46ad3170d736808d98bf74ffa45e0414_Out_1, _SquareRoot_dfeae899ebfeae8f9257c340ca22ce38_Out_1);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 _Vector3_ed3f80ed87524e8c99f98b224af5a610_Out_0 = float3(_Split_26c1e73f8436c78ebdae5b51365a072b_R_1, _Split_26c1e73f8436c78ebdae5b51365a072b_G_2, _SquareRoot_dfeae899ebfeae8f9257c340ca22ce38_Out_1);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            UnityTexture2D _Property_2cc39234d3d334899f94126a216a50fc_Out_0 = UnityBuildTexture2DStructNoScale(_BaseNormalMap);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            Bindings_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8 _PlanarNMn_4fde70f39e45398dbb9972941e88e2bf;
            _PlanarNMn_4fde70f39e45398dbb9972941e88e2bf.WorldSpaceNormal = IN.WorldSpaceNormal;
            _PlanarNMn_4fde70f39e45398dbb9972941e88e2bf.WorldSpaceTangent = IN.WorldSpaceTangent;
            _PlanarNMn_4fde70f39e45398dbb9972941e88e2bf.WorldSpaceBiTangent = IN.WorldSpaceBiTangent;
            _PlanarNMn_4fde70f39e45398dbb9972941e88e2bf.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            _PlanarNMn_4fde70f39e45398dbb9972941e88e2bf.uv0 = IN.uv0;
            float4 _PlanarNMn_4fde70f39e45398dbb9972941e88e2bf_XZ_2;
            SG_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8(_Property_2cc39234d3d334899f94126a216a50fc_Out_0, _Property_115fcc827510f38798b214d835c27637_Out_0, _Property_d83b8f290862b285bbe2f157190e1315_Out_0, _PlanarNMn_4fde70f39e45398dbb9972941e88e2bf, _PlanarNMn_4fde70f39e45398dbb9972941e88e2bf_XZ_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_020d569f63e9a2849e23988ff74eb005_Out_0 = _BaseNormalScale;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 _NormalStrength_0c71fb166ae841839a0a12ecc5afa6fe_Out_2;
            Unity_NormalStrength_float((_PlanarNMn_4fde70f39e45398dbb9972941e88e2bf_XZ_2.xyz), _Property_020d569f63e9a2849e23988ff74eb005_Out_0, _NormalStrength_0c71fb166ae841839a0a12ecc5afa6fe_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 _NormalBlend_be36dd49bea74c8f8dd52fa3a85a9534_Out_2;
            Unity_NormalBlend_float(_Vector3_ed3f80ed87524e8c99f98b224af5a610_Out_0, _NormalStrength_0c71fb166ae841839a0a12ecc5afa6fe_Out_2, _NormalBlend_be36dd49bea74c8f8dd52fa3a85a9534_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            UnityTexture2D _Property_a383045772822c87acd099bb4cd6c478_Out_0 = UnityBuildTexture2DStructNoScale(_CoverNormalMap);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            Bindings_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8 _PlanarNMn_79abde32a0223a89907c9f09efac8db7;
            _PlanarNMn_79abde32a0223a89907c9f09efac8db7.WorldSpaceNormal = IN.WorldSpaceNormal;
            _PlanarNMn_79abde32a0223a89907c9f09efac8db7.WorldSpaceTangent = IN.WorldSpaceTangent;
            _PlanarNMn_79abde32a0223a89907c9f09efac8db7.WorldSpaceBiTangent = IN.WorldSpaceBiTangent;
            _PlanarNMn_79abde32a0223a89907c9f09efac8db7.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            _PlanarNMn_79abde32a0223a89907c9f09efac8db7.uv0 = IN.uv0;
            float4 _PlanarNMn_79abde32a0223a89907c9f09efac8db7_XZ_2;
            SG_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8(_Property_a383045772822c87acd099bb4cd6c478_Out_0, _Property_e35c79b8cccfbe8ca0a3c33e8d32e319_Out_0, _Property_e3d8b38b51331e879b1d4012d65f53e6_Out_0, _PlanarNMn_79abde32a0223a89907c9f09efac8db7, _PlanarNMn_79abde32a0223a89907c9f09efac8db7_XZ_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_c688e246111fd881820a97415e14d8a3_Out_0 = _CoverNormalBlendHardness;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 _NormalStrength_0e5e0831ba0e98878220ca6021ea52a2_Out_2;
            Unity_NormalStrength_float((_PlanarNMn_79abde32a0223a89907c9f09efac8db7_XZ_2.xyz), _Property_c688e246111fd881820a97415e14d8a3_Out_0, _NormalStrength_0e5e0831ba0e98878220ca6021ea52a2_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Split_8cadce726725318fbacd47f436a8231d_R_1 = IN.WorldSpaceNormal[0];
            float _Split_8cadce726725318fbacd47f436a8231d_G_2 = IN.WorldSpaceNormal[1];
            float _Split_8cadce726725318fbacd47f436a8231d_B_3 = IN.WorldSpaceNormal[2];
            float _Split_8cadce726725318fbacd47f436a8231d_A_4 = 0;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_ce4e5954a0b7ff8c819fa53963327595_Out_0 = _Cover_Amount;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_384059e6344fb98a85eccad78dd82f36_Out_0 = _Cover_Amount_Grow_Speed;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Subtract_70fd06876db7fa85b0cc0bce8d926dff_Out_2;
            Unity_Subtract_float(4, _Property_384059e6344fb98a85eccad78dd82f36_Out_0, _Subtract_70fd06876db7fa85b0cc0bce8d926dff_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Divide_1a3a6334c3d8bc8f8ac262c7833e15d5_Out_2;
            Unity_Divide_float(_Property_ce4e5954a0b7ff8c819fa53963327595_Out_0, _Subtract_70fd06876db7fa85b0cc0bce8d926dff_Out_2, _Divide_1a3a6334c3d8bc8f8ac262c7833e15d5_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Absolute_f218d2b85ebf288f91234faffedb5f7b_Out_1;
            Unity_Absolute_float(_Divide_1a3a6334c3d8bc8f8ac262c7833e15d5_Out_2, _Absolute_f218d2b85ebf288f91234faffedb5f7b_Out_1);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Power_a9b8d4b65c44a98e9813f61c0e2dc0a3_Out_2;
            Unity_Power_float(_Absolute_f218d2b85ebf288f91234faffedb5f7b_Out_1, _Subtract_70fd06876db7fa85b0cc0bce8d926dff_Out_2, _Power_a9b8d4b65c44a98e9813f61c0e2dc0a3_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Clamp_95d579f83746cb82be79cf6739990e0b_Out_3;
            Unity_Clamp_float(_Power_a9b8d4b65c44a98e9813f61c0e2dc0a3_Out_2, 0, 2, _Clamp_95d579f83746cb82be79cf6739990e0b_Out_3);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Multiply_02a8aa0fa6974e81aa84caba54f63896_Out_2;
            Unity_Multiply_float(_Split_8cadce726725318fbacd47f436a8231d_G_2, _Clamp_95d579f83746cb82be79cf6739990e0b_Out_3, _Multiply_02a8aa0fa6974e81aa84caba54f63896_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Saturate_ada5e8f9ebdcb38d8f5e61e8d97424b9_Out_1;
            Unity_Saturate_float(_Multiply_02a8aa0fa6974e81aa84caba54f63896_Out_2, _Saturate_ada5e8f9ebdcb38d8f5e61e8d97424b9_Out_1);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Clamp_38bac9e8ef351789b5fd4f2201f1df7b_Out_3;
            Unity_Clamp_float(_Split_8cadce726725318fbacd47f436a8231d_G_2, 0, 0.9999, _Clamp_38bac9e8ef351789b5fd4f2201f1df7b_Out_3);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_9babc76177853482826cae0163ffe988_Out_0 = _Cover_Max_Angle;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Divide_3b22550205905d8da5870f9db56e44ff_Out_2;
            Unity_Divide_float(_Property_9babc76177853482826cae0163ffe988_Out_0, 45, _Divide_3b22550205905d8da5870f9db56e44ff_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _OneMinus_99a85b6952a41288afc86da0a6ca6ea0_Out_1;
            Unity_OneMinus_float(_Divide_3b22550205905d8da5870f9db56e44ff_Out_2, _OneMinus_99a85b6952a41288afc86da0a6ca6ea0_Out_1);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Subtract_2b63f3aaee26f686971dca1d28da283c_Out_2;
            Unity_Subtract_float(_Clamp_38bac9e8ef351789b5fd4f2201f1df7b_Out_3, _OneMinus_99a85b6952a41288afc86da0a6ca6ea0_Out_1, _Subtract_2b63f3aaee26f686971dca1d28da283c_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Clamp_6bd9bb4add91fe8eb80a958a6b1a2d01_Out_3;
            Unity_Clamp_float(_Subtract_2b63f3aaee26f686971dca1d28da283c_Out_2, 0, 2, _Clamp_6bd9bb4add91fe8eb80a958a6b1a2d01_Out_3);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Divide_a09d2d461b07e98999aba746fb52a3fc_Out_2;
            Unity_Divide_float(1, _Divide_3b22550205905d8da5870f9db56e44ff_Out_2, _Divide_a09d2d461b07e98999aba746fb52a3fc_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Multiply_89a8f5a279c73b898d4ca5d075786b53_Out_2;
            Unity_Multiply_float(_Clamp_6bd9bb4add91fe8eb80a958a6b1a2d01_Out_3, _Divide_a09d2d461b07e98999aba746fb52a3fc_Out_2, _Multiply_89a8f5a279c73b898d4ca5d075786b53_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Absolute_f98ce5feb185a68784b9b35eb71ec465_Out_1;
            Unity_Absolute_float(_Multiply_89a8f5a279c73b898d4ca5d075786b53_Out_2, _Absolute_f98ce5feb185a68784b9b35eb71ec465_Out_1);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_27e768ffa9c13e8ab65d48e7712e5b66_Out_0 = _CoverHardness;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Power_b9fdc3921d5b85878a1ec4baa1975184_Out_2;
            Unity_Power_float(_Absolute_f98ce5feb185a68784b9b35eb71ec465_Out_1, _Property_27e768ffa9c13e8ab65d48e7712e5b66_Out_0, _Power_b9fdc3921d5b85878a1ec4baa1975184_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_c442c20fdade808b8e1b93cfd6625ab9_Out_0 = _Cover_Min_Height;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _OneMinus_55530ddc82048c8aa2d082334edf6a57_Out_1;
            Unity_OneMinus_float(_Property_c442c20fdade808b8e1b93cfd6625ab9_Out_0, _OneMinus_55530ddc82048c8aa2d082334edf6a57_Out_1);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Split_7e5d084c5e6bfa83a9203dac971ea31e_R_1 = IN.AbsoluteWorldSpacePosition[0];
            float _Split_7e5d084c5e6bfa83a9203dac971ea31e_G_2 = IN.AbsoluteWorldSpacePosition[1];
            float _Split_7e5d084c5e6bfa83a9203dac971ea31e_B_3 = IN.AbsoluteWorldSpacePosition[2];
            float _Split_7e5d084c5e6bfa83a9203dac971ea31e_A_4 = 0;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Add_e4067b215657d98ab6ec4e0295ddfece_Out_2;
            Unity_Add_float(_OneMinus_55530ddc82048c8aa2d082334edf6a57_Out_1, _Split_7e5d084c5e6bfa83a9203dac971ea31e_G_2, _Add_e4067b215657d98ab6ec4e0295ddfece_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Add_a4387dfc1ea3ee8da0b04f433a7c63d0_Out_2;
            Unity_Add_float(_Add_e4067b215657d98ab6ec4e0295ddfece_Out_2, 1, _Add_a4387dfc1ea3ee8da0b04f433a7c63d0_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Clamp_570e1129ecb02c8b8be79d85f19d5ae1_Out_3;
            Unity_Clamp_float(_Add_a4387dfc1ea3ee8da0b04f433a7c63d0_Out_2, 0, 1, _Clamp_570e1129ecb02c8b8be79d85f19d5ae1_Out_3);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_5da709b259ac268bb134d927bcffa4b8_Out_0 = _Cover_Min_Height_Blending;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Add_c322347d9ddbcd83ba52983e9316c387_Out_2;
            Unity_Add_float(_Add_e4067b215657d98ab6ec4e0295ddfece_Out_2, _Property_5da709b259ac268bb134d927bcffa4b8_Out_0, _Add_c322347d9ddbcd83ba52983e9316c387_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Divide_078ffa7d6c597f819511c95d33b7d90e_Out_2;
            Unity_Divide_float(_Add_c322347d9ddbcd83ba52983e9316c387_Out_2, _Add_e4067b215657d98ab6ec4e0295ddfece_Out_2, _Divide_078ffa7d6c597f819511c95d33b7d90e_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _OneMinus_b9f8edced35e7b8cab9ca581d822e31f_Out_1;
            Unity_OneMinus_float(_Divide_078ffa7d6c597f819511c95d33b7d90e_Out_2, _OneMinus_b9f8edced35e7b8cab9ca581d822e31f_Out_1);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Add_95cd1778448bfe8d9f9fa9129235f2c2_Out_2;
            Unity_Add_float(_OneMinus_b9f8edced35e7b8cab9ca581d822e31f_Out_1, -0.5, _Add_95cd1778448bfe8d9f9fa9129235f2c2_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Clamp_23e760e01b7e0780a71d88813b5828d7_Out_3;
            Unity_Clamp_float(_Add_95cd1778448bfe8d9f9fa9129235f2c2_Out_2, 0, 1, _Clamp_23e760e01b7e0780a71d88813b5828d7_Out_3);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Add_674fcef023d728848510150af810a103_Out_2;
            Unity_Add_float(_Clamp_570e1129ecb02c8b8be79d85f19d5ae1_Out_3, _Clamp_23e760e01b7e0780a71d88813b5828d7_Out_3, _Add_674fcef023d728848510150af810a103_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Clamp_5b677be9d499c082bcbe316853b0adff_Out_3;
            Unity_Clamp_float(_Add_674fcef023d728848510150af810a103_Out_2, 0, 1, _Clamp_5b677be9d499c082bcbe316853b0adff_Out_3);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Multiply_7ea7400ed65a3582b000796fb39748e9_Out_2;
            Unity_Multiply_float(_Power_b9fdc3921d5b85878a1ec4baa1975184_Out_2, _Clamp_5b677be9d499c082bcbe316853b0adff_Out_3, _Multiply_7ea7400ed65a3582b000796fb39748e9_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Multiply_4d295791f4e23186acea64f2f4de94ea_Out_2;
            Unity_Multiply_float(_Saturate_ada5e8f9ebdcb38d8f5e61e8d97424b9_Out_1, _Multiply_7ea7400ed65a3582b000796fb39748e9_Out_2, _Multiply_4d295791f4e23186acea64f2f4de94ea_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 _Lerp_21eaf65c617b2d858b3b33154d55757a_Out_3;
            Unity_Lerp_float3(_NormalBlend_be36dd49bea74c8f8dd52fa3a85a9534_Out_2, _NormalStrength_0e5e0831ba0e98878220ca6021ea52a2_Out_2, (_Multiply_4d295791f4e23186acea64f2f4de94ea_Out_2.xxx), _Lerp_21eaf65c617b2d858b3b33154d55757a_Out_3);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3x3 Transform_1e4c3a2d6240958ab6858efb88c1d06a_transposeTangent = transpose(float3x3(IN.WorldSpaceTangent, IN.WorldSpaceBiTangent, IN.WorldSpaceNormal));
            float3 _Transform_1e4c3a2d6240958ab6858efb88c1d06a_Out_1 = normalize(mul(Transform_1e4c3a2d6240958ab6858efb88c1d06a_transposeTangent, _Lerp_21eaf65c617b2d858b3b33154d55757a_Out_3.xyz).xyz);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Split_600a9d271d96798a94ab28118977defd_R_1 = _Transform_1e4c3a2d6240958ab6858efb88c1d06a_Out_1[0];
            float _Split_600a9d271d96798a94ab28118977defd_G_2 = _Transform_1e4c3a2d6240958ab6858efb88c1d06a_Out_1[1];
            float _Split_600a9d271d96798a94ab28118977defd_B_3 = _Transform_1e4c3a2d6240958ab6858efb88c1d06a_Out_1[2];
            float _Split_600a9d271d96798a94ab28118977defd_A_4 = 0;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Multiply_2e5b010626435f8492a2690396ced19d_Out_2;
            Unity_Multiply_float(_Split_600a9d271d96798a94ab28118977defd_G_2, _Clamp_95d579f83746cb82be79cf6739990e0b_Out_3, _Multiply_2e5b010626435f8492a2690396ced19d_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Multiply_5a2397e0153ddb8f9bd457d9a301dc8b_Out_2;
            Unity_Multiply_float(_Clamp_95d579f83746cb82be79cf6739990e0b_Out_3, _Property_27e768ffa9c13e8ab65d48e7712e5b66_Out_0, _Multiply_5a2397e0153ddb8f9bd457d9a301dc8b_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Multiply_3aad76eaff60dd888c3e1783ecf03943_Out_2;
            Unity_Multiply_float(_Multiply_5a2397e0153ddb8f9bd457d9a301dc8b_Out_2, _Multiply_7ea7400ed65a3582b000796fb39748e9_Out_2, _Multiply_3aad76eaff60dd888c3e1783ecf03943_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Multiply_05614e740451f18f8301586390aa5a0a_Out_2;
            Unity_Multiply_float(_Multiply_2e5b010626435f8492a2690396ced19d_Out_2, _Multiply_3aad76eaff60dd888c3e1783ecf03943_Out_2, _Multiply_05614e740451f18f8301586390aa5a0a_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            UnityTexture2D _Property_a14f2476a35d208b988233c852f919ef_Out_0 = UnityBuildTexture2DStructNoScale(_CoverMaskMap);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            Bindings_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6 _PlanarNM_6858a0e821f26a8d87846d325e9bd170;
            _PlanarNM_6858a0e821f26a8d87846d325e9bd170.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            _PlanarNM_6858a0e821f26a8d87846d325e9bd170.uv0 = IN.uv0;
            float4 _PlanarNM_6858a0e821f26a8d87846d325e9bd170_XZ_2;
            SG_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6(_Property_a14f2476a35d208b988233c852f919ef_Out_0, _Property_e35c79b8cccfbe8ca0a3c33e8d32e319_Out_0, _Property_e3d8b38b51331e879b1d4012d65f53e6_Out_0, _PlanarNM_6858a0e821f26a8d87846d325e9bd170, _PlanarNM_6858a0e821f26a8d87846d325e9bd170_XZ_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Split_16313c20ccdeaa86a639068877a69a2f_R_1 = _PlanarNM_6858a0e821f26a8d87846d325e9bd170_XZ_2[0];
            float _Split_16313c20ccdeaa86a639068877a69a2f_G_2 = _PlanarNM_6858a0e821f26a8d87846d325e9bd170_XZ_2[1];
            float _Split_16313c20ccdeaa86a639068877a69a2f_B_3 = _PlanarNM_6858a0e821f26a8d87846d325e9bd170_XZ_2[2];
            float _Split_16313c20ccdeaa86a639068877a69a2f_A_4 = _PlanarNM_6858a0e821f26a8d87846d325e9bd170_XZ_2[3];
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_673896519f419589938b37e782b90141_Out_0 = _CoverHeightMapMin;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_c35906332422438da3b19f45cbd5ac17_Out_0 = _CoverHeightMapMax;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float2 _Vector2_81cbe1e5ea789e8697223cd3bfbca76c_Out_0 = float2(_Property_673896519f419589938b37e782b90141_Out_0, _Property_c35906332422438da3b19f45cbd5ac17_Out_0);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_88ab0068f899fc8ba94efdaec5e8966b_Out_0 = _CoverHeightMapOffset;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float2 _Add_cd623e3135271489b0d45b4d7edc5f7e_Out_2;
            Unity_Add_float2(_Vector2_81cbe1e5ea789e8697223cd3bfbca76c_Out_0, (_Property_88ab0068f899fc8ba94efdaec5e8966b_Out_0.xx), _Add_cd623e3135271489b0d45b4d7edc5f7e_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Remap_9a23d5f76fa8c38dbd73f43bd6397b0b_Out_3;
            Unity_Remap_float(_Split_16313c20ccdeaa86a639068877a69a2f_B_3, float2 (0, 1), _Add_cd623e3135271489b0d45b4d7edc5f7e_Out_2, _Remap_9a23d5f76fa8c38dbd73f43bd6397b0b_Out_3);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Multiply_0093be0fd848498b89a0fa282608e715_Out_2;
            Unity_Multiply_float(_Multiply_05614e740451f18f8301586390aa5a0a_Out_2, _Remap_9a23d5f76fa8c38dbd73f43bd6397b0b_Out_3, _Multiply_0093be0fd848498b89a0fa282608e715_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Multiply_d3190f97afd0398083623ecf71a41b1a_Out_2;
            Unity_Multiply_float(_Split_8ba5b67899f36b8f9dcf5c84092c0560_G_2, _Multiply_0093be0fd848498b89a0fa282608e715_Out_2, _Multiply_d3190f97afd0398083623ecf71a41b1a_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Saturate_cbcee34e7e6e6d8091d840550ab1c74a_Out_1;
            Unity_Saturate_float(_Multiply_d3190f97afd0398083623ecf71a41b1a_Out_2, _Saturate_cbcee34e7e6e6d8091d840550ab1c74a_Out_1);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Multiply_da35b9d9e4dd8c81871a9aea42c157ee_Out_2;
            Unity_Multiply_float(_Clamp_030a7c32684c258084338456eaddc77a_Out_3, _Saturate_cbcee34e7e6e6d8091d840550ab1c74a_Out_1, _Multiply_da35b9d9e4dd8c81871a9aea42c157ee_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Clamp_c95f5515948375878df6581a36d8b203_Out_3;
            Unity_Clamp_float(_Multiply_da35b9d9e4dd8c81871a9aea42c157ee_Out_2, 0, 1, _Clamp_c95f5515948375878df6581a36d8b203_Out_3);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            #if defined(_USEDYNAMICCOVERTSTATICMASKF_ON)
            float _UseDynamicCoverTStaticMaskF_0694902516172b8fa469c5d8b8e938c6_Out_0 = _Clamp_c95f5515948375878df6581a36d8b203_Out_3;
            #else
            float _UseDynamicCoverTStaticMaskF_0694902516172b8fa469c5d8b8e938c6_Out_0 = _Clamp_030a7c32684c258084338456eaddc77a_Out_3;
            #endif
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 _Lerp_87882219e20a6d818c0de017d739125f_Out_3;
            Unity_Lerp_float3(_BlendOverlayBaseColor_f3cd25d5b673648eb831a3f388201f73_OutVector4_1, (_Multiply_2eb83c7af5b6f58eabeec7b502517470_Out_2.xyz), (_UseDynamicCoverTStaticMaskF_0694902516172b8fa469c5d8b8e938c6_Out_0.xxx), _Lerp_87882219e20a6d818c0de017d739125f_Out_3);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 _Property_4c7bd3690d9d8a838e2524f5908e09ee_Out_0 = _WetColor;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 _Multiply_77c751a5503e948d8952b403163b4eeb_Out_2;
            Unity_Multiply_float((_Property_4c7bd3690d9d8a838e2524f5908e09ee_Out_0.xyz), _Lerp_87882219e20a6d818c0de017d739125f_Out_3, _Multiply_77c751a5503e948d8952b403163b4eeb_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _OneMinus_9b165e3f6c2fdd88a5f3a51230f8dd33_Out_1;
            Unity_OneMinus_float(_Split_8ba5b67899f36b8f9dcf5c84092c0560_R_1, _OneMinus_9b165e3f6c2fdd88a5f3a51230f8dd33_Out_1);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 _Lerp_538fa3f69b550a8bbe8ee20906ecc752_Out_3;
            Unity_Lerp_float3(_Lerp_87882219e20a6d818c0de017d739125f_Out_3, _Multiply_77c751a5503e948d8952b403163b4eeb_Out_2, (_OneMinus_9b165e3f6c2fdd88a5f3a51230f8dd33_Out_1.xxx), _Lerp_538fa3f69b550a8bbe8ee20906ecc752_Out_3);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_486692dad4d34a8c8410b4771efbf96b_Out_0 = _CoverNormalScale;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 _NormalStrength_d60a055f00d779808337e9d909827806_Out_2;
            Unity_NormalStrength_float((_PlanarNMn_79abde32a0223a89907c9f09efac8db7_XZ_2.xyz), _Property_486692dad4d34a8c8410b4771efbf96b_Out_0, _NormalStrength_d60a055f00d779808337e9d909827806_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 _Lerp_6861b6a37faf5e868527d229073a4d0f_Out_3;
            Unity_Lerp_float3(_NormalBlend_be36dd49bea74c8f8dd52fa3a85a9534_Out_2, _NormalStrength_d60a055f00d779808337e9d909827806_Out_2, (_UseDynamicCoverTStaticMaskF_0694902516172b8fa469c5d8b8e938c6_Out_0.xxx), _Lerp_6861b6a37faf5e868527d229073a4d0f_Out_3);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            UnityTexture2D _Property_a1adaaa2a22b0e829756ccb08eab9146_Out_0 = UnityBuildTexture2DStructNoScale(_BaseMaskMap);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            Bindings_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6 _PlanarNM_d26fd10040332c89b94151832fa36c95;
            _PlanarNM_d26fd10040332c89b94151832fa36c95.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            _PlanarNM_d26fd10040332c89b94151832fa36c95.uv0 = IN.uv0;
            float4 _PlanarNM_d26fd10040332c89b94151832fa36c95_XZ_2;
            SG_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6(_Property_a1adaaa2a22b0e829756ccb08eab9146_Out_0, _Property_115fcc827510f38798b214d835c27637_Out_0, _Property_d83b8f290862b285bbe2f157190e1315_Out_0, _PlanarNM_d26fd10040332c89b94151832fa36c95, _PlanarNM_d26fd10040332c89b94151832fa36c95_XZ_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Split_c8dcaee88e16428ab476271a494e0946_R_1 = _PlanarNM_d26fd10040332c89b94151832fa36c95_XZ_2[0];
            float _Split_c8dcaee88e16428ab476271a494e0946_G_2 = _PlanarNM_d26fd10040332c89b94151832fa36c95_XZ_2[1];
            float _Split_c8dcaee88e16428ab476271a494e0946_B_3 = _PlanarNM_d26fd10040332c89b94151832fa36c95_XZ_2[2];
            float _Split_c8dcaee88e16428ab476271a494e0946_A_4 = _PlanarNM_d26fd10040332c89b94151832fa36c95_XZ_2[3];
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_06c41396a31ba582877d3a10387f69e6_Out_0 = _BaseMetallic;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Multiply_1e8010b400ec9689a4d8570c8fb2dd6e_Out_2;
            Unity_Multiply_float(_Split_c8dcaee88e16428ab476271a494e0946_R_1, _Property_06c41396a31ba582877d3a10387f69e6_Out_0, _Multiply_1e8010b400ec9689a4d8570c8fb2dd6e_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_2dbdbebc756fb1819344efcc68c07d00_Out_0 = _BaseAORemapMin;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_bdc878630dfca586bff66e5b4bfffe30_Out_0 = _BaseAORemapMax;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float2 _Vector2_7f058afa3dd186869dd0f2d889a637bb_Out_0 = float2(_Property_2dbdbebc756fb1819344efcc68c07d00_Out_0, _Property_bdc878630dfca586bff66e5b4bfffe30_Out_0);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Remap_736c05b9e06ff78597a5b300523c5e04_Out_3;
            Unity_Remap_float(_Split_c8dcaee88e16428ab476271a494e0946_G_2, float2 (0, 1), _Vector2_7f058afa3dd186869dd0f2d889a637bb_Out_0, _Remap_736c05b9e06ff78597a5b300523c5e04_Out_3);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_dbfeaf948b34478090dd8f1a3d0e2440_Out_0 = _BaseSmoothnessRemapMin;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_d7d9704f0497d58ea30c73507241d8e4_Out_0 = _BaseSmoothnessRemapMax;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float2 _Vector2_03bee8a712eb848f9058c9ca67139ff0_Out_0 = float2(_Property_dbfeaf948b34478090dd8f1a3d0e2440_Out_0, _Property_d7d9704f0497d58ea30c73507241d8e4_Out_0);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Remap_9fa10d7f73353f8d98e7e00ad7887efd_Out_3;
            Unity_Remap_float(_Split_c8dcaee88e16428ab476271a494e0946_A_4, float2 (0, 1), _Vector2_03bee8a712eb848f9058c9ca67139ff0_Out_0, _Remap_9fa10d7f73353f8d98e7e00ad7887efd_Out_3);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Multiply_93138f23185e4d83b6825f8212653c3e_Out_2;
            Unity_Multiply_float(_SampleTexture2D_fa4ac40fc922b9869e37c06690c0f530_B_6, 2, _Multiply_93138f23185e4d83b6825f8212653c3e_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Add_53ebd006b8d6448881dfe527be4ca8e6_Out_2;
            Unity_Add_float(_Multiply_93138f23185e4d83b6825f8212653c3e_Out_2, -1, _Add_53ebd006b8d6448881dfe527be4ca8e6_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_dadcc7446e5d388e9a6730406295f93a_Out_0 = _DetailSmoothnessScale;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Multiply_1de6b43ae21981829be79a3a54ae243b_Out_2;
            Unity_Multiply_float(_Add_53ebd006b8d6448881dfe527be4ca8e6_Out_2, _Property_dadcc7446e5d388e9a6730406295f93a_Out_0, _Multiply_1de6b43ae21981829be79a3a54ae243b_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Saturate_0834275a3ed56c8fb32773dd6424fe67_Out_1;
            Unity_Saturate_float(_Multiply_1de6b43ae21981829be79a3a54ae243b_Out_2, _Saturate_0834275a3ed56c8fb32773dd6424fe67_Out_1);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Absolute_ca93b0439159da8d944e94364e98a3a5_Out_1;
            Unity_Absolute_float(_Saturate_0834275a3ed56c8fb32773dd6424fe67_Out_1, _Absolute_ca93b0439159da8d944e94364e98a3a5_Out_1);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            Bindings_BlendOverlayDetailSmoothness_06e12138dc89c0040b45a57abe520a1a _BlendOverlayDetailSmoothness_586cd13379fb3187a73a451ca1585fb7;
            float _BlendOverlayDetailSmoothness_586cd13379fb3187a73a451ca1585fb7_SmoothnessOverlay_1;
            SG_BlendOverlayDetailSmoothness_06e12138dc89c0040b45a57abe520a1a(_Remap_9fa10d7f73353f8d98e7e00ad7887efd_Out_3, _Add_53ebd006b8d6448881dfe527be4ca8e6_Out_2, _Absolute_ca93b0439159da8d944e94364e98a3a5_Out_1, _BlendOverlayDetailSmoothness_586cd13379fb3187a73a451ca1585fb7, _BlendOverlayDetailSmoothness_586cd13379fb3187a73a451ca1585fb7_SmoothnessOverlay_1);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Saturate_6a86fd5df2ee918a83675f1c42dd4511_Out_1;
            Unity_Saturate_float(_BlendOverlayDetailSmoothness_586cd13379fb3187a73a451ca1585fb7_SmoothnessOverlay_1, _Saturate_6a86fd5df2ee918a83675f1c42dd4511_Out_1);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 _Vector3_b34af5a5e4b21588a99ba5eb5358a84d_Out_0 = float3(_Multiply_1e8010b400ec9689a4d8570c8fb2dd6e_Out_2, _Remap_736c05b9e06ff78597a5b300523c5e04_Out_3, _Saturate_6a86fd5df2ee918a83675f1c42dd4511_Out_1);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_dc64ffdb5487f38c8fafcef1d518b3eb_Out_0 = _CoverMetallic;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Multiply_62c6df8b3ac33382bb38f0b594d1a4fa_Out_2;
            Unity_Multiply_float(_Split_16313c20ccdeaa86a639068877a69a2f_R_1, _Property_dc64ffdb5487f38c8fafcef1d518b3eb_Out_0, _Multiply_62c6df8b3ac33382bb38f0b594d1a4fa_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_2696a3815c73848db1c5516a77ad7e3e_Out_0 = _CoverAORemapMin;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_dc6e42b9f380d88fb5998902d1ddaa45_Out_0 = _CoverAORemapMax;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float2 _Vector2_6f054e667fb031849116087b7663e8de_Out_0 = float2(_Property_2696a3815c73848db1c5516a77ad7e3e_Out_0, _Property_dc6e42b9f380d88fb5998902d1ddaa45_Out_0);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Remap_805dc695e2ca6186842dd0c16c68fe7a_Out_3;
            Unity_Remap_float(_Split_16313c20ccdeaa86a639068877a69a2f_G_2, float2 (0, 1), _Vector2_6f054e667fb031849116087b7663e8de_Out_0, _Remap_805dc695e2ca6186842dd0c16c68fe7a_Out_3);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_05c4f672b1175a84b0d7ce44b23b4aa4_Out_0 = _CoverSmoothnessRemapMin;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_5f3529123a9ea982984b3bdc33dcb041_Out_0 = _CoverSmoothnessRemapMax;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float2 _Vector2_1eb7cc7a8699a889b2b636baa84fc4fd_Out_0 = float2(_Property_05c4f672b1175a84b0d7ce44b23b4aa4_Out_0, _Property_5f3529123a9ea982984b3bdc33dcb041_Out_0);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Remap_2e561d2a6ce223819f2665623c7c6c94_Out_3;
            Unity_Remap_float(_Split_16313c20ccdeaa86a639068877a69a2f_A_4, float2 (0, 1), _Vector2_1eb7cc7a8699a889b2b636baa84fc4fd_Out_0, _Remap_2e561d2a6ce223819f2665623c7c6c94_Out_3);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 _Vector3_9d828b596b436f898d7f64ebfd86402e_Out_0 = float3(_Multiply_62c6df8b3ac33382bb38f0b594d1a4fa_Out_2, _Remap_805dc695e2ca6186842dd0c16c68fe7a_Out_3, _Remap_2e561d2a6ce223819f2665623c7c6c94_Out_3);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 _Lerp_5a4703a1c1c9e387bdf52325fcd883e8_Out_3;
            Unity_Lerp_float3(_Vector3_b34af5a5e4b21588a99ba5eb5358a84d_Out_0, _Vector3_9d828b596b436f898d7f64ebfd86402e_Out_0, (_UseDynamicCoverTStaticMaskF_0694902516172b8fa469c5d8b8e938c6_Out_0.xxx), _Lerp_5a4703a1c1c9e387bdf52325fcd883e8_Out_3);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Split_b9b4ede5ed4eaf82a5409e98b1310654_R_1 = _Lerp_5a4703a1c1c9e387bdf52325fcd883e8_Out_3[0];
            float _Split_b9b4ede5ed4eaf82a5409e98b1310654_G_2 = _Lerp_5a4703a1c1c9e387bdf52325fcd883e8_Out_3[1];
            float _Split_b9b4ede5ed4eaf82a5409e98b1310654_B_3 = _Lerp_5a4703a1c1c9e387bdf52325fcd883e8_Out_3[2];
            float _Split_b9b4ede5ed4eaf82a5409e98b1310654_A_4 = 0;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_44a514a11d8fcc84aeab495181ebe3f0_Out_0 = _WetSmoothness;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Lerp_9c25fc1869bb8b83b41e153899e44f1a_Out_3;
            Unity_Lerp_float(_Split_b9b4ede5ed4eaf82a5409e98b1310654_B_3, _Property_44a514a11d8fcc84aeab495181ebe3f0_Out_0, _OneMinus_9b165e3f6c2fdd88a5f3a51230f8dd33_Out_1, _Lerp_9c25fc1869bb8b83b41e153899e44f1a_Out_3);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Split_31874fa1d55cb28e99a1333cf254676a_R_1 = _PlanarNM_6c8b686076db2a8c8b7d6cd91cf435f0_XZ_2[0];
            float _Split_31874fa1d55cb28e99a1333cf254676a_G_2 = _PlanarNM_6c8b686076db2a8c8b7d6cd91cf435f0_XZ_2[1];
            float _Split_31874fa1d55cb28e99a1333cf254676a_B_3 = _PlanarNM_6c8b686076db2a8c8b7d6cd91cf435f0_XZ_2[2];
            float _Split_31874fa1d55cb28e99a1333cf254676a_A_4 = _PlanarNM_6c8b686076db2a8c8b7d6cd91cf435f0_XZ_2[3];
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_881c341218ea2d81819695b0c7ddc4cb_Out_0 = _AlphaCutoff;
            #endif
            surface.BaseColor = _Lerp_538fa3f69b550a8bbe8ee20906ecc752_Out_3;
            surface.NormalTS = _Lerp_6861b6a37faf5e868527d229073a4d0f_Out_3;
            surface.Emission = float3(0, 0, 0);
            surface.Metallic = _Split_b9b4ede5ed4eaf82a5409e98b1310654_R_1;
            surface.Smoothness = _Lerp_9c25fc1869bb8b83b41e153899e44f1a_Out_3;
            surface.Occlusion = _Split_b9b4ede5ed4eaf82a5409e98b1310654_G_2;
            surface.Alpha = _Split_31874fa1d55cb28e99a1333cf254676a_A_4;
            surface.AlphaClipThreshold = _Property_881c341218ea2d81819695b0c7ddc4cb_Out_0;
            return surface;
        }

            // --------------------------------------------------
            // Build Graph Inputs

            VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.ObjectSpaceNormal =           input.normalOS;
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.ObjectSpaceTangent =          input.tangentOS.xyz;
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.ObjectSpacePosition =         input.positionOS;
        #endif


            return output;
        }
            SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        // must use interpolated tangent, bitangent and normal before they are normalized in the pixel shader.
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        float3 unnormalizedNormalWS = input.normalWS;
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        const float renormFactor = 1.0 / length(unnormalizedNormalWS);
        #endif


        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        // use bitangent on the fly like in hdrp
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        // IMPORTANT! If we ever support Flip on double sided materials ensure bitangent and tangent are NOT flipped.
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        float crossSign = (input.tangentWS.w > 0.0 ? 1.0 : -1.0) * GetOddNegativeScale();
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        float3 bitang = crossSign * cross(input.normalWS.xyz, input.tangentWS.xyz);
        #endif


        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.WorldSpaceNormal =            renormFactor*input.normalWS.xyz;      // we want a unit length Normal Vector node in shader graph
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.TangentSpaceNormal =          float3(0.0f, 0.0f, 1.0f);
        #endif


        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        // to preserve mikktspace compliance we use same scale renormFactor as was used on the normal.
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        // This is explained in section 2.2 in "surface gradient based bump mapping framework"
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.WorldSpaceTangent =           renormFactor*input.tangentWS.xyz;
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.WorldSpaceBiTangent =         renormFactor*bitang;
        #endif


        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.AbsoluteWorldSpacePosition =  GetAbsolutePositionWS(input.positionWS);
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.uv0 =                         input.texCoord0;
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.VertexColor =                 input.color;
        #endif

        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN

            return output;
        }

            // --------------------------------------------------
            // Main

            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/PBRForwardPass.hlsl"

            ENDHLSL
        }
        Pass
        {
            Name "ShadowCaster"
            Tags
            {
                "LightMode" = "ShadowCaster"
            }

            // Render State
            Cull Back
        Blend One Zero
        ZTest LEqual
        ZWrite On
        ColorMask 0

            // Debug
            // <None>

            // --------------------------------------------------
            // Pass

            HLSLPROGRAM

            // Pragmas
            #pragma target 2.0
        #pragma only_renderers gles gles3 glcore
        #pragma multi_compile_instancing
        #pragma vertex vert
        #pragma fragment frag

            // DotsInstancingOptions: <None>
            // HybridV1InjectedBuiltinProperties: <None>

            // Keywords
            #pragma multi_compile _ _CASTING_PUNCTUAL_LIGHT_SHADOW
            #pragma shader_feature_local _ _USEDYNAMICCOVERTSTATICMASKF_ON

        #if defined(_USEDYNAMICCOVERTSTATICMASKF_ON)
            #define KEYWORD_PERMUTATION_0
        #else
            #define KEYWORD_PERMUTATION_1
        #endif


            // Defines
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define _AlphaClip 1
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define _NORMALMAP 1
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define _NORMAL_DROPOFF_TS 1
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define ATTRIBUTES_NEED_NORMAL
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define ATTRIBUTES_NEED_TANGENT
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define ATTRIBUTES_NEED_TEXCOORD0
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define VARYINGS_NEED_POSITION_WS
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define VARYINGS_NEED_TEXCOORD0
        #endif

            #define FEATURES_GRAPH_VERTEX
            /* WARNING: $splice Could not find named fragment 'PassInstancing' */
            #define SHADERPASS SHADERPASS_SHADOWCASTER
            /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */

            // Includes
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"

            // --------------------------------------------------
            // Structs and Packing

            struct Attributes
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 positionOS : POSITION;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 normalOS : NORMAL;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 tangentOS : TANGENT;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 uv0 : TEXCOORD0;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            uint instanceID : INSTANCEID_SEMANTIC;
            #endif
            #endif
        };
        struct Varyings
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 positionCS : SV_POSITION;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 positionWS;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 texCoord0;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
            #endif
        };
        struct SurfaceDescriptionInputs
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 AbsoluteWorldSpacePosition;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 uv0;
            #endif
        };
        struct VertexDescriptionInputs
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 ObjectSpaceNormal;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 ObjectSpaceTangent;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 ObjectSpacePosition;
            #endif
        };
        struct PackedVaryings
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 positionCS : SV_POSITION;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 interp0 : TEXCOORD0;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 interp1 : TEXCOORD1;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
            #endif
        };

            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            output.positionCS = input.positionCS;
            output.interp0.xyz =  input.positionWS;
            output.interp1.xyzw =  input.texCoord0;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.positionWS = input.interp0.xyz;
            output.texCoord0 = input.interp1.xyzw;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        #endif

            // --------------------------------------------------
            // Graph

            // Graph Properties
            CBUFFER_START(UnityPerMaterial)
        float _AlphaCutoff;
        float4 _BaseColor;
        float4 _BaseColorMap_TexelSize;
        float _BaseUsePlanarUV;
        float4 _BaseTilingOffset;
        float4 _BaseNormalMap_TexelSize;
        float _BaseNormalScale;
        float4 _BaseMaskMap_TexelSize;
        float _BaseMetallic;
        float _BaseAORemapMin;
        float _BaseAORemapMax;
        float _BaseSmoothnessRemapMin;
        float _BaseSmoothnessRemapMax;
        float4 _CoverMaskA_TexelSize;
        float _CoverMaskPower;
        float _Cover_Amount;
        float _Cover_Amount_Grow_Speed;
        float _Cover_Max_Angle;
        float _Cover_Min_Height;
        float _Cover_Min_Height_Blending;
        float4 _CoverBaseColor;
        float4 _CoverBaseColorMap_TexelSize;
        float _CoverUsePlanarUV;
        float4 _CoverTilingOffset;
        float4 _CoverNormalMap_TexelSize;
        float _CoverNormalScale;
        float _CoverNormalBlendHardness;
        float _CoverHardness;
        float _CoverHeightMapMin;
        float _CoverHeightMapMax;
        float _CoverHeightMapOffset;
        float4 _CoverMaskMap_TexelSize;
        float _CoverMetallic;
        float _CoverAORemapMin;
        float _CoverAORemapMax;
        float _CoverSmoothnessRemapMin;
        float _CoverSmoothnessRemapMax;
        float4 _DetailMap_TexelSize;
        float4 _DetailTilingOffset;
        float _DetailAlbedoScale;
        float _DetailNormalScale;
        float _DetailSmoothnessScale;
        float4 _WetColor;
        float _WetSmoothness;
        CBUFFER_END

        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_BaseColorMap);
        SAMPLER(sampler_BaseColorMap);
        TEXTURE2D(_BaseNormalMap);
        SAMPLER(sampler_BaseNormalMap);
        TEXTURE2D(_BaseMaskMap);
        SAMPLER(sampler_BaseMaskMap);
        TEXTURE2D(_CoverMaskA);
        SAMPLER(sampler_CoverMaskA);
        TEXTURE2D(_CoverBaseColorMap);
        SAMPLER(sampler_CoverBaseColorMap);
        TEXTURE2D(_CoverNormalMap);
        SAMPLER(sampler_CoverNormalMap);
        TEXTURE2D(_CoverMaskMap);
        SAMPLER(sampler_CoverMaskMap);
        TEXTURE2D(_DetailMap);
        SAMPLER(sampler_DetailMap);

            // Graph Functions
            
        // f948cdce565a6e706cc57cb23fbf9d95
        #include "./NM_Object_VSPro_Indirect.cginc"

        void AddPragma_float(float3 A, out float3 Out){
            #pragma instancing_options renderinglayer procedural:setupVSPro
            Out = A;
        }

        struct Bindings_NMObjectVSProIndirect_0cfe1e4f145944241ab304331e53c93b
        {
        };

        void SG_NMObjectVSProIndirect_0cfe1e4f145944241ab304331e53c93b(float3 Vector3_314C8600, Bindings_NMObjectVSProIndirect_0cfe1e4f145944241ab304331e53c93b IN, out float3 ObjectSpacePosition_1)
        {
            float3 _Property_5ec158abd968858c9d31ab40df5e9e6f_Out_0 = Vector3_314C8600;
            float3 _InjectSetupCustomFunction_dec9b26544b4a788b8ecb4117dc3d24a_Out_1;
            InjectSetup_float(_Property_5ec158abd968858c9d31ab40df5e9e6f_Out_0, _InjectSetupCustomFunction_dec9b26544b4a788b8ecb4117dc3d24a_Out_1);
            float3 _AddPragmaCustomFunction_b2a053178906d0848480a1f463521a1b_Out_1;
            AddPragma_float(_InjectSetupCustomFunction_dec9b26544b4a788b8ecb4117dc3d24a_Out_1, _AddPragmaCustomFunction_b2a053178906d0848480a1f463521a1b_Out_1);
            ObjectSpacePosition_1 = _AddPragmaCustomFunction_b2a053178906d0848480a1f463521a1b_Out_1;
        }

        void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
        {
            RGBA = float4(R, G, B, A);
            RGB = float3(R, G, B);
            RG = float2(R, G);
        }

        void Unity_Divide_float(float A, float B, out float Out)
        {
            Out = A / B;
        }

        void Unity_Multiply_float(float4 A, float4 B, out float4 Out)
        {
            Out = A * B;
        }

        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }

        void Unity_Branch_float2(float Predicate, float2 True, float2 False, out float2 Out)
        {
            Out = Predicate ? True : False;
        }

        struct Bindings_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6
        {
            float3 AbsoluteWorldSpacePosition;
            half4 uv0;
        };

        void SG_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6(UnityTexture2D Texture2D_80A3D28F, float4 Vector4_2EBA7A3B, float Boolean_7ABB9909, Bindings_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6 IN, out float4 XZ_2)
        {
            UnityTexture2D _Property_3e01b4d2fc68d48ba3acbba9d5881e59_Out_0 = Texture2D_80A3D28F;
            float _Property_30834f691775a0898a45b1c868520436_Out_0 = Boolean_7ABB9909;
            float _Split_89ed63cb625cb3878c183d0b71c03400_R_1 = IN.AbsoluteWorldSpacePosition[0];
            float _Split_89ed63cb625cb3878c183d0b71c03400_G_2 = IN.AbsoluteWorldSpacePosition[1];
            float _Split_89ed63cb625cb3878c183d0b71c03400_B_3 = IN.AbsoluteWorldSpacePosition[2];
            float _Split_89ed63cb625cb3878c183d0b71c03400_A_4 = 0;
            float4 _Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4;
            float3 _Combine_cf2d04ff119ad88493f6460431765cbb_RGB_5;
            float2 _Combine_cf2d04ff119ad88493f6460431765cbb_RG_6;
            Unity_Combine_float(_Split_89ed63cb625cb3878c183d0b71c03400_R_1, _Split_89ed63cb625cb3878c183d0b71c03400_B_3, 0, 0, _Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4, _Combine_cf2d04ff119ad88493f6460431765cbb_RGB_5, _Combine_cf2d04ff119ad88493f6460431765cbb_RG_6);
            float4 _Property_8a66888ec47d0687ab1cb2f8abdc9da8_Out_0 = Vector4_2EBA7A3B;
            float _Split_2f0f52f6ef8c0e81af0da6476402bc1f_R_1 = _Property_8a66888ec47d0687ab1cb2f8abdc9da8_Out_0[0];
            float _Split_2f0f52f6ef8c0e81af0da6476402bc1f_G_2 = _Property_8a66888ec47d0687ab1cb2f8abdc9da8_Out_0[1];
            float _Split_2f0f52f6ef8c0e81af0da6476402bc1f_B_3 = _Property_8a66888ec47d0687ab1cb2f8abdc9da8_Out_0[2];
            float _Split_2f0f52f6ef8c0e81af0da6476402bc1f_A_4 = _Property_8a66888ec47d0687ab1cb2f8abdc9da8_Out_0[3];
            float _Divide_e64179199923c58289b6aa94ea6c9178_Out_2;
            Unity_Divide_float(1, _Split_2f0f52f6ef8c0e81af0da6476402bc1f_R_1, _Divide_e64179199923c58289b6aa94ea6c9178_Out_2);
            float4 _Multiply_14cec4902d0a00829e4555071a1b8ad1_Out_2;
            Unity_Multiply_float(_Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4, (_Divide_e64179199923c58289b6aa94ea6c9178_Out_2.xxxx), _Multiply_14cec4902d0a00829e4555071a1b8ad1_Out_2);
            float2 _Vector2_16c15d3bbdd14b85bd48e3a6cb318af7_Out_0 = float2(_Split_2f0f52f6ef8c0e81af0da6476402bc1f_R_1, _Split_2f0f52f6ef8c0e81af0da6476402bc1f_G_2);
            float2 _Vector2_f8d75f54e7705083bbec539a60185577_Out_0 = float2(_Split_2f0f52f6ef8c0e81af0da6476402bc1f_B_3, _Split_2f0f52f6ef8c0e81af0da6476402bc1f_A_4);
            float2 _TilingAndOffset_d91e2d25acd34686b562b7fe7e9d1d27_Out_3;
            Unity_TilingAndOffset_float(IN.uv0.xy, _Vector2_16c15d3bbdd14b85bd48e3a6cb318af7_Out_0, _Vector2_f8d75f54e7705083bbec539a60185577_Out_0, _TilingAndOffset_d91e2d25acd34686b562b7fe7e9d1d27_Out_3);
            float2 _Branch_8e5a4e8f4d52fc8aadd1f46485afc933_Out_3;
            Unity_Branch_float2(_Property_30834f691775a0898a45b1c868520436_Out_0, (_Multiply_14cec4902d0a00829e4555071a1b8ad1_Out_2.xy), _TilingAndOffset_d91e2d25acd34686b562b7fe7e9d1d27_Out_3, _Branch_8e5a4e8f4d52fc8aadd1f46485afc933_Out_3);
            float4 _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0 = SAMPLE_TEXTURE2D(_Property_3e01b4d2fc68d48ba3acbba9d5881e59_Out_0.tex, _Property_3e01b4d2fc68d48ba3acbba9d5881e59_Out_0.samplerstate, _Branch_8e5a4e8f4d52fc8aadd1f46485afc933_Out_3);
            float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_R_4 = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0.r;
            float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_G_5 = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0.g;
            float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_B_6 = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0.b;
            float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_A_7 = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0.a;
            XZ_2 = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0;
        }

            // Graph Vertex
            struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };

        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            Bindings_NMObjectVSProIndirect_0cfe1e4f145944241ab304331e53c93b _NMObjectVSProIndirect_adbe93754e069e8e87df45ef6e4b343e;
            float3 _NMObjectVSProIndirect_adbe93754e069e8e87df45ef6e4b343e_ObjectSpacePosition_1;
            SG_NMObjectVSProIndirect_0cfe1e4f145944241ab304331e53c93b(IN.ObjectSpacePosition, _NMObjectVSProIndirect_adbe93754e069e8e87df45ef6e4b343e, _NMObjectVSProIndirect_adbe93754e069e8e87df45ef6e4b343e_ObjectSpacePosition_1);
            #endif
            description.Position = _NMObjectVSProIndirect_adbe93754e069e8e87df45ef6e4b343e_ObjectSpacePosition_1;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }

            // Graph Pixel
            struct SurfaceDescription
        {
            float Alpha;
            float AlphaClipThreshold;
        };

        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            UnityTexture2D _Property_e4c53213449c7682b60df6ae54f219f0_Out_0 = UnityBuildTexture2DStructNoScale(_BaseColorMap);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 _Property_115fcc827510f38798b214d835c27637_Out_0 = _BaseTilingOffset;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_d83b8f290862b285bbe2f157190e1315_Out_0 = _BaseUsePlanarUV;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            Bindings_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6 _PlanarNM_6c8b686076db2a8c8b7d6cd91cf435f0;
            _PlanarNM_6c8b686076db2a8c8b7d6cd91cf435f0.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            _PlanarNM_6c8b686076db2a8c8b7d6cd91cf435f0.uv0 = IN.uv0;
            float4 _PlanarNM_6c8b686076db2a8c8b7d6cd91cf435f0_XZ_2;
            SG_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6(_Property_e4c53213449c7682b60df6ae54f219f0_Out_0, _Property_115fcc827510f38798b214d835c27637_Out_0, _Property_d83b8f290862b285bbe2f157190e1315_Out_0, _PlanarNM_6c8b686076db2a8c8b7d6cd91cf435f0, _PlanarNM_6c8b686076db2a8c8b7d6cd91cf435f0_XZ_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Split_31874fa1d55cb28e99a1333cf254676a_R_1 = _PlanarNM_6c8b686076db2a8c8b7d6cd91cf435f0_XZ_2[0];
            float _Split_31874fa1d55cb28e99a1333cf254676a_G_2 = _PlanarNM_6c8b686076db2a8c8b7d6cd91cf435f0_XZ_2[1];
            float _Split_31874fa1d55cb28e99a1333cf254676a_B_3 = _PlanarNM_6c8b686076db2a8c8b7d6cd91cf435f0_XZ_2[2];
            float _Split_31874fa1d55cb28e99a1333cf254676a_A_4 = _PlanarNM_6c8b686076db2a8c8b7d6cd91cf435f0_XZ_2[3];
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_881c341218ea2d81819695b0c7ddc4cb_Out_0 = _AlphaCutoff;
            #endif
            surface.Alpha = _Split_31874fa1d55cb28e99a1333cf254676a_A_4;
            surface.AlphaClipThreshold = _Property_881c341218ea2d81819695b0c7ddc4cb_Out_0;
            return surface;
        }

            // --------------------------------------------------
            // Build Graph Inputs

            VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.ObjectSpaceNormal =           input.normalOS;
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.ObjectSpaceTangent =          input.tangentOS.xyz;
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.ObjectSpacePosition =         input.positionOS;
        #endif


            return output;
        }
            SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);





        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.AbsoluteWorldSpacePosition =  GetAbsolutePositionWS(input.positionWS);
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.uv0 =                         input.texCoord0;
        #endif

        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN

            return output;
        }

            // --------------------------------------------------
            // Main

            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShadowCasterPass.hlsl"

            ENDHLSL
        }
        Pass
        {
            Name "DepthOnly"
            Tags
            {
                "LightMode" = "DepthOnly"
            }

            // Render State
            Cull Back
        Blend One Zero
        ZTest LEqual
        ZWrite On
        ColorMask 0

            // Debug
            // <None>

            // --------------------------------------------------
            // Pass

            HLSLPROGRAM

            // Pragmas
            #pragma target 2.0
        #pragma only_renderers gles gles3 glcore
        #pragma multi_compile_instancing
        #pragma vertex vert
        #pragma fragment frag

            // DotsInstancingOptions: <None>
            // HybridV1InjectedBuiltinProperties: <None>

            // Keywords
            // PassKeywords: <None>
            #pragma shader_feature_local _ _USEDYNAMICCOVERTSTATICMASKF_ON

        #if defined(_USEDYNAMICCOVERTSTATICMASKF_ON)
            #define KEYWORD_PERMUTATION_0
        #else
            #define KEYWORD_PERMUTATION_1
        #endif


            // Defines
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define _AlphaClip 1
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define _NORMALMAP 1
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define _NORMAL_DROPOFF_TS 1
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define ATTRIBUTES_NEED_NORMAL
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define ATTRIBUTES_NEED_TANGENT
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define ATTRIBUTES_NEED_TEXCOORD0
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define VARYINGS_NEED_POSITION_WS
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define VARYINGS_NEED_TEXCOORD0
        #endif

            #define FEATURES_GRAPH_VERTEX
            /* WARNING: $splice Could not find named fragment 'PassInstancing' */
            #define SHADERPASS SHADERPASS_DEPTHONLY
            /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */

            // Includes
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"

            // --------------------------------------------------
            // Structs and Packing

            struct Attributes
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 positionOS : POSITION;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 normalOS : NORMAL;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 tangentOS : TANGENT;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 uv0 : TEXCOORD0;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            uint instanceID : INSTANCEID_SEMANTIC;
            #endif
            #endif
        };
        struct Varyings
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 positionCS : SV_POSITION;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 positionWS;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 texCoord0;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
            #endif
        };
        struct SurfaceDescriptionInputs
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 AbsoluteWorldSpacePosition;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 uv0;
            #endif
        };
        struct VertexDescriptionInputs
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 ObjectSpaceNormal;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 ObjectSpaceTangent;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 ObjectSpacePosition;
            #endif
        };
        struct PackedVaryings
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 positionCS : SV_POSITION;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 interp0 : TEXCOORD0;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 interp1 : TEXCOORD1;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
            #endif
        };

            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            output.positionCS = input.positionCS;
            output.interp0.xyz =  input.positionWS;
            output.interp1.xyzw =  input.texCoord0;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.positionWS = input.interp0.xyz;
            output.texCoord0 = input.interp1.xyzw;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        #endif

            // --------------------------------------------------
            // Graph

            // Graph Properties
            CBUFFER_START(UnityPerMaterial)
        float _AlphaCutoff;
        float4 _BaseColor;
        float4 _BaseColorMap_TexelSize;
        float _BaseUsePlanarUV;
        float4 _BaseTilingOffset;
        float4 _BaseNormalMap_TexelSize;
        float _BaseNormalScale;
        float4 _BaseMaskMap_TexelSize;
        float _BaseMetallic;
        float _BaseAORemapMin;
        float _BaseAORemapMax;
        float _BaseSmoothnessRemapMin;
        float _BaseSmoothnessRemapMax;
        float4 _CoverMaskA_TexelSize;
        float _CoverMaskPower;
        float _Cover_Amount;
        float _Cover_Amount_Grow_Speed;
        float _Cover_Max_Angle;
        float _Cover_Min_Height;
        float _Cover_Min_Height_Blending;
        float4 _CoverBaseColor;
        float4 _CoverBaseColorMap_TexelSize;
        float _CoverUsePlanarUV;
        float4 _CoverTilingOffset;
        float4 _CoverNormalMap_TexelSize;
        float _CoverNormalScale;
        float _CoverNormalBlendHardness;
        float _CoverHardness;
        float _CoverHeightMapMin;
        float _CoverHeightMapMax;
        float _CoverHeightMapOffset;
        float4 _CoverMaskMap_TexelSize;
        float _CoverMetallic;
        float _CoverAORemapMin;
        float _CoverAORemapMax;
        float _CoverSmoothnessRemapMin;
        float _CoverSmoothnessRemapMax;
        float4 _DetailMap_TexelSize;
        float4 _DetailTilingOffset;
        float _DetailAlbedoScale;
        float _DetailNormalScale;
        float _DetailSmoothnessScale;
        float4 _WetColor;
        float _WetSmoothness;
        CBUFFER_END

        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_BaseColorMap);
        SAMPLER(sampler_BaseColorMap);
        TEXTURE2D(_BaseNormalMap);
        SAMPLER(sampler_BaseNormalMap);
        TEXTURE2D(_BaseMaskMap);
        SAMPLER(sampler_BaseMaskMap);
        TEXTURE2D(_CoverMaskA);
        SAMPLER(sampler_CoverMaskA);
        TEXTURE2D(_CoverBaseColorMap);
        SAMPLER(sampler_CoverBaseColorMap);
        TEXTURE2D(_CoverNormalMap);
        SAMPLER(sampler_CoverNormalMap);
        TEXTURE2D(_CoverMaskMap);
        SAMPLER(sampler_CoverMaskMap);
        TEXTURE2D(_DetailMap);
        SAMPLER(sampler_DetailMap);

            // Graph Functions
            
        // f948cdce565a6e706cc57cb23fbf9d95
        #include "./NM_Object_VSPro_Indirect.cginc"

        void AddPragma_float(float3 A, out float3 Out){
            #pragma instancing_options renderinglayer procedural:setupVSPro
            Out = A;
        }

        struct Bindings_NMObjectVSProIndirect_0cfe1e4f145944241ab304331e53c93b
        {
        };

        void SG_NMObjectVSProIndirect_0cfe1e4f145944241ab304331e53c93b(float3 Vector3_314C8600, Bindings_NMObjectVSProIndirect_0cfe1e4f145944241ab304331e53c93b IN, out float3 ObjectSpacePosition_1)
        {
            float3 _Property_5ec158abd968858c9d31ab40df5e9e6f_Out_0 = Vector3_314C8600;
            float3 _InjectSetupCustomFunction_dec9b26544b4a788b8ecb4117dc3d24a_Out_1;
            InjectSetup_float(_Property_5ec158abd968858c9d31ab40df5e9e6f_Out_0, _InjectSetupCustomFunction_dec9b26544b4a788b8ecb4117dc3d24a_Out_1);
            float3 _AddPragmaCustomFunction_b2a053178906d0848480a1f463521a1b_Out_1;
            AddPragma_float(_InjectSetupCustomFunction_dec9b26544b4a788b8ecb4117dc3d24a_Out_1, _AddPragmaCustomFunction_b2a053178906d0848480a1f463521a1b_Out_1);
            ObjectSpacePosition_1 = _AddPragmaCustomFunction_b2a053178906d0848480a1f463521a1b_Out_1;
        }

        void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
        {
            RGBA = float4(R, G, B, A);
            RGB = float3(R, G, B);
            RG = float2(R, G);
        }

        void Unity_Divide_float(float A, float B, out float Out)
        {
            Out = A / B;
        }

        void Unity_Multiply_float(float4 A, float4 B, out float4 Out)
        {
            Out = A * B;
        }

        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }

        void Unity_Branch_float2(float Predicate, float2 True, float2 False, out float2 Out)
        {
            Out = Predicate ? True : False;
        }

        struct Bindings_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6
        {
            float3 AbsoluteWorldSpacePosition;
            half4 uv0;
        };

        void SG_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6(UnityTexture2D Texture2D_80A3D28F, float4 Vector4_2EBA7A3B, float Boolean_7ABB9909, Bindings_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6 IN, out float4 XZ_2)
        {
            UnityTexture2D _Property_3e01b4d2fc68d48ba3acbba9d5881e59_Out_0 = Texture2D_80A3D28F;
            float _Property_30834f691775a0898a45b1c868520436_Out_0 = Boolean_7ABB9909;
            float _Split_89ed63cb625cb3878c183d0b71c03400_R_1 = IN.AbsoluteWorldSpacePosition[0];
            float _Split_89ed63cb625cb3878c183d0b71c03400_G_2 = IN.AbsoluteWorldSpacePosition[1];
            float _Split_89ed63cb625cb3878c183d0b71c03400_B_3 = IN.AbsoluteWorldSpacePosition[2];
            float _Split_89ed63cb625cb3878c183d0b71c03400_A_4 = 0;
            float4 _Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4;
            float3 _Combine_cf2d04ff119ad88493f6460431765cbb_RGB_5;
            float2 _Combine_cf2d04ff119ad88493f6460431765cbb_RG_6;
            Unity_Combine_float(_Split_89ed63cb625cb3878c183d0b71c03400_R_1, _Split_89ed63cb625cb3878c183d0b71c03400_B_3, 0, 0, _Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4, _Combine_cf2d04ff119ad88493f6460431765cbb_RGB_5, _Combine_cf2d04ff119ad88493f6460431765cbb_RG_6);
            float4 _Property_8a66888ec47d0687ab1cb2f8abdc9da8_Out_0 = Vector4_2EBA7A3B;
            float _Split_2f0f52f6ef8c0e81af0da6476402bc1f_R_1 = _Property_8a66888ec47d0687ab1cb2f8abdc9da8_Out_0[0];
            float _Split_2f0f52f6ef8c0e81af0da6476402bc1f_G_2 = _Property_8a66888ec47d0687ab1cb2f8abdc9da8_Out_0[1];
            float _Split_2f0f52f6ef8c0e81af0da6476402bc1f_B_3 = _Property_8a66888ec47d0687ab1cb2f8abdc9da8_Out_0[2];
            float _Split_2f0f52f6ef8c0e81af0da6476402bc1f_A_4 = _Property_8a66888ec47d0687ab1cb2f8abdc9da8_Out_0[3];
            float _Divide_e64179199923c58289b6aa94ea6c9178_Out_2;
            Unity_Divide_float(1, _Split_2f0f52f6ef8c0e81af0da6476402bc1f_R_1, _Divide_e64179199923c58289b6aa94ea6c9178_Out_2);
            float4 _Multiply_14cec4902d0a00829e4555071a1b8ad1_Out_2;
            Unity_Multiply_float(_Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4, (_Divide_e64179199923c58289b6aa94ea6c9178_Out_2.xxxx), _Multiply_14cec4902d0a00829e4555071a1b8ad1_Out_2);
            float2 _Vector2_16c15d3bbdd14b85bd48e3a6cb318af7_Out_0 = float2(_Split_2f0f52f6ef8c0e81af0da6476402bc1f_R_1, _Split_2f0f52f6ef8c0e81af0da6476402bc1f_G_2);
            float2 _Vector2_f8d75f54e7705083bbec539a60185577_Out_0 = float2(_Split_2f0f52f6ef8c0e81af0da6476402bc1f_B_3, _Split_2f0f52f6ef8c0e81af0da6476402bc1f_A_4);
            float2 _TilingAndOffset_d91e2d25acd34686b562b7fe7e9d1d27_Out_3;
            Unity_TilingAndOffset_float(IN.uv0.xy, _Vector2_16c15d3bbdd14b85bd48e3a6cb318af7_Out_0, _Vector2_f8d75f54e7705083bbec539a60185577_Out_0, _TilingAndOffset_d91e2d25acd34686b562b7fe7e9d1d27_Out_3);
            float2 _Branch_8e5a4e8f4d52fc8aadd1f46485afc933_Out_3;
            Unity_Branch_float2(_Property_30834f691775a0898a45b1c868520436_Out_0, (_Multiply_14cec4902d0a00829e4555071a1b8ad1_Out_2.xy), _TilingAndOffset_d91e2d25acd34686b562b7fe7e9d1d27_Out_3, _Branch_8e5a4e8f4d52fc8aadd1f46485afc933_Out_3);
            float4 _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0 = SAMPLE_TEXTURE2D(_Property_3e01b4d2fc68d48ba3acbba9d5881e59_Out_0.tex, _Property_3e01b4d2fc68d48ba3acbba9d5881e59_Out_0.samplerstate, _Branch_8e5a4e8f4d52fc8aadd1f46485afc933_Out_3);
            float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_R_4 = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0.r;
            float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_G_5 = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0.g;
            float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_B_6 = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0.b;
            float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_A_7 = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0.a;
            XZ_2 = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0;
        }

            // Graph Vertex
            struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };

        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            Bindings_NMObjectVSProIndirect_0cfe1e4f145944241ab304331e53c93b _NMObjectVSProIndirect_adbe93754e069e8e87df45ef6e4b343e;
            float3 _NMObjectVSProIndirect_adbe93754e069e8e87df45ef6e4b343e_ObjectSpacePosition_1;
            SG_NMObjectVSProIndirect_0cfe1e4f145944241ab304331e53c93b(IN.ObjectSpacePosition, _NMObjectVSProIndirect_adbe93754e069e8e87df45ef6e4b343e, _NMObjectVSProIndirect_adbe93754e069e8e87df45ef6e4b343e_ObjectSpacePosition_1);
            #endif
            description.Position = _NMObjectVSProIndirect_adbe93754e069e8e87df45ef6e4b343e_ObjectSpacePosition_1;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }

            // Graph Pixel
            struct SurfaceDescription
        {
            float Alpha;
            float AlphaClipThreshold;
        };

        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            UnityTexture2D _Property_e4c53213449c7682b60df6ae54f219f0_Out_0 = UnityBuildTexture2DStructNoScale(_BaseColorMap);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 _Property_115fcc827510f38798b214d835c27637_Out_0 = _BaseTilingOffset;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_d83b8f290862b285bbe2f157190e1315_Out_0 = _BaseUsePlanarUV;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            Bindings_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6 _PlanarNM_6c8b686076db2a8c8b7d6cd91cf435f0;
            _PlanarNM_6c8b686076db2a8c8b7d6cd91cf435f0.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            _PlanarNM_6c8b686076db2a8c8b7d6cd91cf435f0.uv0 = IN.uv0;
            float4 _PlanarNM_6c8b686076db2a8c8b7d6cd91cf435f0_XZ_2;
            SG_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6(_Property_e4c53213449c7682b60df6ae54f219f0_Out_0, _Property_115fcc827510f38798b214d835c27637_Out_0, _Property_d83b8f290862b285bbe2f157190e1315_Out_0, _PlanarNM_6c8b686076db2a8c8b7d6cd91cf435f0, _PlanarNM_6c8b686076db2a8c8b7d6cd91cf435f0_XZ_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Split_31874fa1d55cb28e99a1333cf254676a_R_1 = _PlanarNM_6c8b686076db2a8c8b7d6cd91cf435f0_XZ_2[0];
            float _Split_31874fa1d55cb28e99a1333cf254676a_G_2 = _PlanarNM_6c8b686076db2a8c8b7d6cd91cf435f0_XZ_2[1];
            float _Split_31874fa1d55cb28e99a1333cf254676a_B_3 = _PlanarNM_6c8b686076db2a8c8b7d6cd91cf435f0_XZ_2[2];
            float _Split_31874fa1d55cb28e99a1333cf254676a_A_4 = _PlanarNM_6c8b686076db2a8c8b7d6cd91cf435f0_XZ_2[3];
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_881c341218ea2d81819695b0c7ddc4cb_Out_0 = _AlphaCutoff;
            #endif
            surface.Alpha = _Split_31874fa1d55cb28e99a1333cf254676a_A_4;
            surface.AlphaClipThreshold = _Property_881c341218ea2d81819695b0c7ddc4cb_Out_0;
            return surface;
        }

            // --------------------------------------------------
            // Build Graph Inputs

            VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.ObjectSpaceNormal =           input.normalOS;
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.ObjectSpaceTangent =          input.tangentOS.xyz;
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.ObjectSpacePosition =         input.positionOS;
        #endif


            return output;
        }
            SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);





        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.AbsoluteWorldSpacePosition =  GetAbsolutePositionWS(input.positionWS);
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.uv0 =                         input.texCoord0;
        #endif

        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN

            return output;
        }

            // --------------------------------------------------
            // Main

            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/DepthOnlyPass.hlsl"

            ENDHLSL
        }
        Pass
        {
            Name "DepthNormals"
            Tags
            {
                "LightMode" = "DepthNormals"
            }

            // Render State
            Cull Back
        Blend One Zero
        ZTest LEqual
        ZWrite On

            // Debug
            // <None>

            // --------------------------------------------------
            // Pass

            HLSLPROGRAM

            // Pragmas
            #pragma target 2.0
        #pragma only_renderers gles gles3 glcore
        #pragma multi_compile_instancing
        #pragma vertex vert
        #pragma fragment frag

            // DotsInstancingOptions: <None>
            // HybridV1InjectedBuiltinProperties: <None>

            // Keywords
            // PassKeywords: <None>
            #pragma shader_feature_local _ _USEDYNAMICCOVERTSTATICMASKF_ON

        #if defined(_USEDYNAMICCOVERTSTATICMASKF_ON)
            #define KEYWORD_PERMUTATION_0
        #else
            #define KEYWORD_PERMUTATION_1
        #endif


            // Defines
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define _AlphaClip 1
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define _NORMALMAP 1
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define _NORMAL_DROPOFF_TS 1
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define ATTRIBUTES_NEED_NORMAL
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define ATTRIBUTES_NEED_TANGENT
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define ATTRIBUTES_NEED_TEXCOORD0
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define ATTRIBUTES_NEED_TEXCOORD1
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define ATTRIBUTES_NEED_COLOR
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define VARYINGS_NEED_POSITION_WS
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define VARYINGS_NEED_NORMAL_WS
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define VARYINGS_NEED_TANGENT_WS
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define VARYINGS_NEED_TEXCOORD0
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define VARYINGS_NEED_COLOR
        #endif

            #define FEATURES_GRAPH_VERTEX
            /* WARNING: $splice Could not find named fragment 'PassInstancing' */
            #define SHADERPASS SHADERPASS_DEPTHNORMALSONLY
            /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */

            // Includes
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"

            // --------------------------------------------------
            // Structs and Packing

            struct Attributes
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 positionOS : POSITION;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 normalOS : NORMAL;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 tangentOS : TANGENT;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 uv0 : TEXCOORD0;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 uv1 : TEXCOORD1;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 color : COLOR;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            uint instanceID : INSTANCEID_SEMANTIC;
            #endif
            #endif
        };
        struct Varyings
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 positionCS : SV_POSITION;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 positionWS;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 normalWS;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 tangentWS;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 texCoord0;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 color;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
            #endif
        };
        struct SurfaceDescriptionInputs
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 WorldSpaceNormal;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 TangentSpaceNormal;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 WorldSpaceTangent;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 WorldSpaceBiTangent;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 AbsoluteWorldSpacePosition;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 uv0;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 VertexColor;
            #endif
        };
        struct VertexDescriptionInputs
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 ObjectSpaceNormal;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 ObjectSpaceTangent;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 ObjectSpacePosition;
            #endif
        };
        struct PackedVaryings
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 positionCS : SV_POSITION;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 interp0 : TEXCOORD0;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 interp1 : TEXCOORD1;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 interp2 : TEXCOORD2;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 interp3 : TEXCOORD3;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 interp4 : TEXCOORD4;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
            #endif
        };

            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            output.positionCS = input.positionCS;
            output.interp0.xyz =  input.positionWS;
            output.interp1.xyz =  input.normalWS;
            output.interp2.xyzw =  input.tangentWS;
            output.interp3.xyzw =  input.texCoord0;
            output.interp4.xyzw =  input.color;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.positionWS = input.interp0.xyz;
            output.normalWS = input.interp1.xyz;
            output.tangentWS = input.interp2.xyzw;
            output.texCoord0 = input.interp3.xyzw;
            output.color = input.interp4.xyzw;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        #endif

            // --------------------------------------------------
            // Graph

            // Graph Properties
            CBUFFER_START(UnityPerMaterial)
        float _AlphaCutoff;
        float4 _BaseColor;
        float4 _BaseColorMap_TexelSize;
        float _BaseUsePlanarUV;
        float4 _BaseTilingOffset;
        float4 _BaseNormalMap_TexelSize;
        float _BaseNormalScale;
        float4 _BaseMaskMap_TexelSize;
        float _BaseMetallic;
        float _BaseAORemapMin;
        float _BaseAORemapMax;
        float _BaseSmoothnessRemapMin;
        float _BaseSmoothnessRemapMax;
        float4 _CoverMaskA_TexelSize;
        float _CoverMaskPower;
        float _Cover_Amount;
        float _Cover_Amount_Grow_Speed;
        float _Cover_Max_Angle;
        float _Cover_Min_Height;
        float _Cover_Min_Height_Blending;
        float4 _CoverBaseColor;
        float4 _CoverBaseColorMap_TexelSize;
        float _CoverUsePlanarUV;
        float4 _CoverTilingOffset;
        float4 _CoverNormalMap_TexelSize;
        float _CoverNormalScale;
        float _CoverNormalBlendHardness;
        float _CoverHardness;
        float _CoverHeightMapMin;
        float _CoverHeightMapMax;
        float _CoverHeightMapOffset;
        float4 _CoverMaskMap_TexelSize;
        float _CoverMetallic;
        float _CoverAORemapMin;
        float _CoverAORemapMax;
        float _CoverSmoothnessRemapMin;
        float _CoverSmoothnessRemapMax;
        float4 _DetailMap_TexelSize;
        float4 _DetailTilingOffset;
        float _DetailAlbedoScale;
        float _DetailNormalScale;
        float _DetailSmoothnessScale;
        float4 _WetColor;
        float _WetSmoothness;
        CBUFFER_END

        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_BaseColorMap);
        SAMPLER(sampler_BaseColorMap);
        TEXTURE2D(_BaseNormalMap);
        SAMPLER(sampler_BaseNormalMap);
        TEXTURE2D(_BaseMaskMap);
        SAMPLER(sampler_BaseMaskMap);
        TEXTURE2D(_CoverMaskA);
        SAMPLER(sampler_CoverMaskA);
        TEXTURE2D(_CoverBaseColorMap);
        SAMPLER(sampler_CoverBaseColorMap);
        TEXTURE2D(_CoverNormalMap);
        SAMPLER(sampler_CoverNormalMap);
        TEXTURE2D(_CoverMaskMap);
        SAMPLER(sampler_CoverMaskMap);
        TEXTURE2D(_DetailMap);
        SAMPLER(sampler_DetailMap);

            // Graph Functions
            
        // f948cdce565a6e706cc57cb23fbf9d95
        #include "./NM_Object_VSPro_Indirect.cginc"

        void AddPragma_float(float3 A, out float3 Out){
            #pragma instancing_options renderinglayer procedural:setupVSPro
            Out = A;
        }

        struct Bindings_NMObjectVSProIndirect_0cfe1e4f145944241ab304331e53c93b
        {
        };

        void SG_NMObjectVSProIndirect_0cfe1e4f145944241ab304331e53c93b(float3 Vector3_314C8600, Bindings_NMObjectVSProIndirect_0cfe1e4f145944241ab304331e53c93b IN, out float3 ObjectSpacePosition_1)
        {
            float3 _Property_5ec158abd968858c9d31ab40df5e9e6f_Out_0 = Vector3_314C8600;
            float3 _InjectSetupCustomFunction_dec9b26544b4a788b8ecb4117dc3d24a_Out_1;
            InjectSetup_float(_Property_5ec158abd968858c9d31ab40df5e9e6f_Out_0, _InjectSetupCustomFunction_dec9b26544b4a788b8ecb4117dc3d24a_Out_1);
            float3 _AddPragmaCustomFunction_b2a053178906d0848480a1f463521a1b_Out_1;
            AddPragma_float(_InjectSetupCustomFunction_dec9b26544b4a788b8ecb4117dc3d24a_Out_1, _AddPragmaCustomFunction_b2a053178906d0848480a1f463521a1b_Out_1);
            ObjectSpacePosition_1 = _AddPragmaCustomFunction_b2a053178906d0848480a1f463521a1b_Out_1;
        }

        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }

        void Unity_Multiply_float(float2 A, float2 B, out float2 Out)
        {
            Out = A * B;
        }

        void Unity_Add_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A + B;
        }

        void Unity_DotProduct_float2(float2 A, float2 B, out float Out)
        {
            Out = dot(A, B);
        }

        void Unity_Saturate_float(float In, out float Out)
        {
            Out = saturate(In);
        }

        void Unity_OneMinus_float(float In, out float Out)
        {
            Out = 1 - In;
        }

        void Unity_SquareRoot_float(float In, out float Out)
        {
            Out = sqrt(In);
        }

        void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
        {
            RGBA = float4(R, G, B, A);
            RGB = float3(R, G, B);
            RG = float2(R, G);
        }

        void Unity_Divide_float(float A, float B, out float Out)
        {
            Out = A / B;
        }

        void Unity_Multiply_float(float4 A, float4 B, out float4 Out)
        {
            Out = A * B;
        }

        void Unity_Branch_float2(float Predicate, float2 True, float2 False, out float2 Out)
        {
            Out = Predicate ? True : False;
        }

        void Unity_Sign_float3(float3 In, out float3 Out)
        {
            Out = sign(In);
        }

        void Unity_Multiply_float(float A, float B, out float Out)
        {
            Out = A * B;
        }

        void Unity_Normalize_float3(float3 In, out float3 Out)
        {
            Out = normalize(In);
        }

        void Unity_Branch_float3(float Predicate, float3 True, float3 False, out float3 Out)
        {
            Out = Predicate ? True : False;
        }

        struct Bindings_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8
        {
            float3 WorldSpaceNormal;
            float3 WorldSpaceTangent;
            float3 WorldSpaceBiTangent;
            float3 AbsoluteWorldSpacePosition;
            half4 uv0;
        };

        void SG_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8(UnityTexture2D Texture2D_80A3D28F, float4 Vector4_82674548, float Boolean_9FF42DF6, Bindings_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8 IN, out float4 XZ_2)
        {
            float _Property_1ef12cf3201a938993fe6a7951b0e754_Out_0 = Boolean_9FF42DF6;
            UnityTexture2D _Property_3e01b4d2fc68d48ba3acbba9d5881e59_Out_0 = Texture2D_80A3D28F;
            float _Split_89ed63cb625cb3878c183d0b71c03400_R_1 = IN.AbsoluteWorldSpacePosition[0];
            float _Split_89ed63cb625cb3878c183d0b71c03400_G_2 = IN.AbsoluteWorldSpacePosition[1];
            float _Split_89ed63cb625cb3878c183d0b71c03400_B_3 = IN.AbsoluteWorldSpacePosition[2];
            float _Split_89ed63cb625cb3878c183d0b71c03400_A_4 = 0;
            float4 _Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4;
            float3 _Combine_cf2d04ff119ad88493f6460431765cbb_RGB_5;
            float2 _Combine_cf2d04ff119ad88493f6460431765cbb_RG_6;
            Unity_Combine_float(_Split_89ed63cb625cb3878c183d0b71c03400_R_1, _Split_89ed63cb625cb3878c183d0b71c03400_B_3, 0, 0, _Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4, _Combine_cf2d04ff119ad88493f6460431765cbb_RGB_5, _Combine_cf2d04ff119ad88493f6460431765cbb_RG_6);
            float4 _Property_3fa1d6f912feb481ba60f2e55e62e746_Out_0 = Vector4_82674548;
            float _Split_a2e12fa5931da084b2949343a539dfd8_R_1 = _Property_3fa1d6f912feb481ba60f2e55e62e746_Out_0[0];
            float _Split_a2e12fa5931da084b2949343a539dfd8_G_2 = _Property_3fa1d6f912feb481ba60f2e55e62e746_Out_0[1];
            float _Split_a2e12fa5931da084b2949343a539dfd8_B_3 = _Property_3fa1d6f912feb481ba60f2e55e62e746_Out_0[2];
            float _Split_a2e12fa5931da084b2949343a539dfd8_A_4 = _Property_3fa1d6f912feb481ba60f2e55e62e746_Out_0[3];
            float _Divide_c36b770dfaa0bb8f85ab27da5fd794f0_Out_2;
            Unity_Divide_float(1, _Split_a2e12fa5931da084b2949343a539dfd8_R_1, _Divide_c36b770dfaa0bb8f85ab27da5fd794f0_Out_2);
            float4 _Multiply_14cec4902d0a00829e4555071a1b8ad1_Out_2;
            Unity_Multiply_float(_Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4, (_Divide_c36b770dfaa0bb8f85ab27da5fd794f0_Out_2.xxxx), _Multiply_14cec4902d0a00829e4555071a1b8ad1_Out_2);
            float2 _Vector2_6845d21872714d889783b0cb707df3e9_Out_0 = float2(_Split_a2e12fa5931da084b2949343a539dfd8_R_1, _Split_a2e12fa5931da084b2949343a539dfd8_G_2);
            float2 _Vector2_e2e2263627c6098e96a5b5d29350ad03_Out_0 = float2(_Split_a2e12fa5931da084b2949343a539dfd8_B_3, _Split_a2e12fa5931da084b2949343a539dfd8_A_4);
            float2 _TilingAndOffset_17582d056c0b8a8dab1017d37497fe59_Out_3;
            Unity_TilingAndOffset_float(IN.uv0.xy, _Vector2_6845d21872714d889783b0cb707df3e9_Out_0, _Vector2_e2e2263627c6098e96a5b5d29350ad03_Out_0, _TilingAndOffset_17582d056c0b8a8dab1017d37497fe59_Out_3);
            float2 _Branch_1e152f3aac57448f8518bf2852c000c3_Out_3;
            Unity_Branch_float2(_Property_1ef12cf3201a938993fe6a7951b0e754_Out_0, (_Multiply_14cec4902d0a00829e4555071a1b8ad1_Out_2.xy), _TilingAndOffset_17582d056c0b8a8dab1017d37497fe59_Out_3, _Branch_1e152f3aac57448f8518bf2852c000c3_Out_3);
            float4 _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0 = SAMPLE_TEXTURE2D(_Property_3e01b4d2fc68d48ba3acbba9d5881e59_Out_0.tex, _Property_3e01b4d2fc68d48ba3acbba9d5881e59_Out_0.samplerstate, _Branch_1e152f3aac57448f8518bf2852c000c3_Out_3);
            _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0.rgb = UnpackNormal(_SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0);
            float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_R_4 = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0.r;
            float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_G_5 = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0.g;
            float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_B_6 = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0.b;
            float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_A_7 = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0.a;
            float2 _Vector2_ad6bd100e273d78fa409a30a77bfa2cc_Out_0 = float2(_SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_R_4, _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_G_5);
            float3 _Sign_3a6ebf59931cf08cb0482e0144ddac24_Out_1;
            Unity_Sign_float3(IN.WorldSpaceNormal, _Sign_3a6ebf59931cf08cb0482e0144ddac24_Out_1);
            float _Split_6299d4ddcc4c74828aea40a46fdb896e_R_1 = _Sign_3a6ebf59931cf08cb0482e0144ddac24_Out_1[0];
            float _Split_6299d4ddcc4c74828aea40a46fdb896e_G_2 = _Sign_3a6ebf59931cf08cb0482e0144ddac24_Out_1[1];
            float _Split_6299d4ddcc4c74828aea40a46fdb896e_B_3 = _Sign_3a6ebf59931cf08cb0482e0144ddac24_Out_1[2];
            float _Split_6299d4ddcc4c74828aea40a46fdb896e_A_4 = 0;
            float2 _Vector2_b76cb1842101e58b9e636d49b075c612_Out_0 = float2(_Split_6299d4ddcc4c74828aea40a46fdb896e_G_2, 1);
            float2 _Multiply_31e8db88ee20c985a9850d1a58f3282b_Out_2;
            Unity_Multiply_float(_Vector2_ad6bd100e273d78fa409a30a77bfa2cc_Out_0, _Vector2_b76cb1842101e58b9e636d49b075c612_Out_0, _Multiply_31e8db88ee20c985a9850d1a58f3282b_Out_2);
            float _Split_5ed44bf2eca0868f81eb18100f49d1fa_R_1 = IN.WorldSpaceNormal[0];
            float _Split_5ed44bf2eca0868f81eb18100f49d1fa_G_2 = IN.WorldSpaceNormal[1];
            float _Split_5ed44bf2eca0868f81eb18100f49d1fa_B_3 = IN.WorldSpaceNormal[2];
            float _Split_5ed44bf2eca0868f81eb18100f49d1fa_A_4 = 0;
            float2 _Vector2_70e5837843f28b8b9d64cada3697bd5a_Out_0 = float2(_Split_5ed44bf2eca0868f81eb18100f49d1fa_R_1, _Split_5ed44bf2eca0868f81eb18100f49d1fa_B_3);
            float2 _Add_1145b2f896593d80aa864a34e6702562_Out_2;
            Unity_Add_float2(_Multiply_31e8db88ee20c985a9850d1a58f3282b_Out_2, _Vector2_70e5837843f28b8b9d64cada3697bd5a_Out_0, _Add_1145b2f896593d80aa864a34e6702562_Out_2);
            float _Split_2bc77ca2d17bd78cb2383770ce50b179_R_1 = _Add_1145b2f896593d80aa864a34e6702562_Out_2[0];
            float _Split_2bc77ca2d17bd78cb2383770ce50b179_G_2 = _Add_1145b2f896593d80aa864a34e6702562_Out_2[1];
            float _Split_2bc77ca2d17bd78cb2383770ce50b179_B_3 = 0;
            float _Split_2bc77ca2d17bd78cb2383770ce50b179_A_4 = 0;
            float _Multiply_ab12aea87465a78eaf7fc66c2598d266_Out_2;
            Unity_Multiply_float(_SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_B_6, _Split_5ed44bf2eca0868f81eb18100f49d1fa_G_2, _Multiply_ab12aea87465a78eaf7fc66c2598d266_Out_2);
            float3 _Vector3_433840b555db308b97e9b14b6a957195_Out_0 = float3(_Split_2bc77ca2d17bd78cb2383770ce50b179_R_1, _Multiply_ab12aea87465a78eaf7fc66c2598d266_Out_2, _Split_2bc77ca2d17bd78cb2383770ce50b179_G_2);
            float3x3 Transform_c7914cc45a011c89b3f53c55afb51673_tangentTransform_World = float3x3(IN.WorldSpaceTangent, IN.WorldSpaceBiTangent, IN.WorldSpaceNormal);
            float3 _Transform_c7914cc45a011c89b3f53c55afb51673_Out_1 = TransformWorldToTangent(_Vector3_433840b555db308b97e9b14b6a957195_Out_0.xyz, Transform_c7914cc45a011c89b3f53c55afb51673_tangentTransform_World);
            float3 _Normalize_09bf8a2bd0a4d38e8b97d5c674f79b44_Out_1;
            Unity_Normalize_float3(_Transform_c7914cc45a011c89b3f53c55afb51673_Out_1, _Normalize_09bf8a2bd0a4d38e8b97d5c674f79b44_Out_1);
            float3 _Branch_9eadf909a90f2f80880f8c56ecc2a91f_Out_3;
            Unity_Branch_float3(_Property_1ef12cf3201a938993fe6a7951b0e754_Out_0, _Normalize_09bf8a2bd0a4d38e8b97d5c674f79b44_Out_1, (_SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0.xyz), _Branch_9eadf909a90f2f80880f8c56ecc2a91f_Out_3);
            XZ_2 = (float4(_Branch_9eadf909a90f2f80880f8c56ecc2a91f_Out_3, 1.0));
        }

        void Unity_NormalStrength_float(float3 In, float Strength, out float3 Out)
        {
            Out = float3(In.rg * Strength, lerp(1, In.b, saturate(Strength)));
        }

        void Unity_NormalBlend_float(float3 A, float3 B, out float3 Out)
        {
            Out = SafeNormalize(float3(A.rg + B.rg, A.b * B.b));
        }

        void Unity_Clamp_float(float In, float Min, float Max, out float Out)
        {
            Out = clamp(In, Min, Max);
        }

        void Unity_Subtract_float(float A, float B, out float Out)
        {
            Out = A - B;
        }

        void Unity_Absolute_float(float In, out float Out)
        {
            Out = abs(In);
        }

        void Unity_Power_float(float A, float B, out float Out)
        {
            Out = pow(A, B);
        }

        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
        }

        void Unity_Lerp_float3(float3 A, float3 B, float3 T, out float3 Out)
        {
            Out = lerp(A, B, T);
        }

        struct Bindings_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6
        {
            float3 AbsoluteWorldSpacePosition;
            half4 uv0;
        };

        void SG_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6(UnityTexture2D Texture2D_80A3D28F, float4 Vector4_2EBA7A3B, float Boolean_7ABB9909, Bindings_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6 IN, out float4 XZ_2)
        {
            UnityTexture2D _Property_3e01b4d2fc68d48ba3acbba9d5881e59_Out_0 = Texture2D_80A3D28F;
            float _Property_30834f691775a0898a45b1c868520436_Out_0 = Boolean_7ABB9909;
            float _Split_89ed63cb625cb3878c183d0b71c03400_R_1 = IN.AbsoluteWorldSpacePosition[0];
            float _Split_89ed63cb625cb3878c183d0b71c03400_G_2 = IN.AbsoluteWorldSpacePosition[1];
            float _Split_89ed63cb625cb3878c183d0b71c03400_B_3 = IN.AbsoluteWorldSpacePosition[2];
            float _Split_89ed63cb625cb3878c183d0b71c03400_A_4 = 0;
            float4 _Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4;
            float3 _Combine_cf2d04ff119ad88493f6460431765cbb_RGB_5;
            float2 _Combine_cf2d04ff119ad88493f6460431765cbb_RG_6;
            Unity_Combine_float(_Split_89ed63cb625cb3878c183d0b71c03400_R_1, _Split_89ed63cb625cb3878c183d0b71c03400_B_3, 0, 0, _Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4, _Combine_cf2d04ff119ad88493f6460431765cbb_RGB_5, _Combine_cf2d04ff119ad88493f6460431765cbb_RG_6);
            float4 _Property_8a66888ec47d0687ab1cb2f8abdc9da8_Out_0 = Vector4_2EBA7A3B;
            float _Split_2f0f52f6ef8c0e81af0da6476402bc1f_R_1 = _Property_8a66888ec47d0687ab1cb2f8abdc9da8_Out_0[0];
            float _Split_2f0f52f6ef8c0e81af0da6476402bc1f_G_2 = _Property_8a66888ec47d0687ab1cb2f8abdc9da8_Out_0[1];
            float _Split_2f0f52f6ef8c0e81af0da6476402bc1f_B_3 = _Property_8a66888ec47d0687ab1cb2f8abdc9da8_Out_0[2];
            float _Split_2f0f52f6ef8c0e81af0da6476402bc1f_A_4 = _Property_8a66888ec47d0687ab1cb2f8abdc9da8_Out_0[3];
            float _Divide_e64179199923c58289b6aa94ea6c9178_Out_2;
            Unity_Divide_float(1, _Split_2f0f52f6ef8c0e81af0da6476402bc1f_R_1, _Divide_e64179199923c58289b6aa94ea6c9178_Out_2);
            float4 _Multiply_14cec4902d0a00829e4555071a1b8ad1_Out_2;
            Unity_Multiply_float(_Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4, (_Divide_e64179199923c58289b6aa94ea6c9178_Out_2.xxxx), _Multiply_14cec4902d0a00829e4555071a1b8ad1_Out_2);
            float2 _Vector2_16c15d3bbdd14b85bd48e3a6cb318af7_Out_0 = float2(_Split_2f0f52f6ef8c0e81af0da6476402bc1f_R_1, _Split_2f0f52f6ef8c0e81af0da6476402bc1f_G_2);
            float2 _Vector2_f8d75f54e7705083bbec539a60185577_Out_0 = float2(_Split_2f0f52f6ef8c0e81af0da6476402bc1f_B_3, _Split_2f0f52f6ef8c0e81af0da6476402bc1f_A_4);
            float2 _TilingAndOffset_d91e2d25acd34686b562b7fe7e9d1d27_Out_3;
            Unity_TilingAndOffset_float(IN.uv0.xy, _Vector2_16c15d3bbdd14b85bd48e3a6cb318af7_Out_0, _Vector2_f8d75f54e7705083bbec539a60185577_Out_0, _TilingAndOffset_d91e2d25acd34686b562b7fe7e9d1d27_Out_3);
            float2 _Branch_8e5a4e8f4d52fc8aadd1f46485afc933_Out_3;
            Unity_Branch_float2(_Property_30834f691775a0898a45b1c868520436_Out_0, (_Multiply_14cec4902d0a00829e4555071a1b8ad1_Out_2.xy), _TilingAndOffset_d91e2d25acd34686b562b7fe7e9d1d27_Out_3, _Branch_8e5a4e8f4d52fc8aadd1f46485afc933_Out_3);
            float4 _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0 = SAMPLE_TEXTURE2D(_Property_3e01b4d2fc68d48ba3acbba9d5881e59_Out_0.tex, _Property_3e01b4d2fc68d48ba3acbba9d5881e59_Out_0.samplerstate, _Branch_8e5a4e8f4d52fc8aadd1f46485afc933_Out_3);
            float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_R_4 = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0.r;
            float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_G_5 = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0.g;
            float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_B_6 = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0.b;
            float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_A_7 = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0.a;
            XZ_2 = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0;
        }

        void Unity_Remap_float(float In, float2 InMinMax, float2 OutMinMax, out float Out)
        {
            Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
        }

            // Graph Vertex
            struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };

        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            Bindings_NMObjectVSProIndirect_0cfe1e4f145944241ab304331e53c93b _NMObjectVSProIndirect_adbe93754e069e8e87df45ef6e4b343e;
            float3 _NMObjectVSProIndirect_adbe93754e069e8e87df45ef6e4b343e_ObjectSpacePosition_1;
            SG_NMObjectVSProIndirect_0cfe1e4f145944241ab304331e53c93b(IN.ObjectSpacePosition, _NMObjectVSProIndirect_adbe93754e069e8e87df45ef6e4b343e, _NMObjectVSProIndirect_adbe93754e069e8e87df45ef6e4b343e_ObjectSpacePosition_1);
            #endif
            description.Position = _NMObjectVSProIndirect_adbe93754e069e8e87df45ef6e4b343e_ObjectSpacePosition_1;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }

            // Graph Pixel
            struct SurfaceDescription
        {
            float3 NormalTS;
            float Alpha;
            float AlphaClipThreshold;
        };

        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            UnityTexture2D _Property_b561c414493a8f8299227a27e437f045_Out_0 = UnityBuildTexture2DStructNoScale(_DetailMap);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 _Property_70f1cc2b73af738d80b0d405e4bed8c5_Out_0 = _DetailTilingOffset;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Split_cda27505033cfc8eaf60fe914f0949b9_R_1 = _Property_70f1cc2b73af738d80b0d405e4bed8c5_Out_0[0];
            float _Split_cda27505033cfc8eaf60fe914f0949b9_G_2 = _Property_70f1cc2b73af738d80b0d405e4bed8c5_Out_0[1];
            float _Split_cda27505033cfc8eaf60fe914f0949b9_B_3 = _Property_70f1cc2b73af738d80b0d405e4bed8c5_Out_0[2];
            float _Split_cda27505033cfc8eaf60fe914f0949b9_A_4 = _Property_70f1cc2b73af738d80b0d405e4bed8c5_Out_0[3];
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float2 _Vector2_42d7e955009b6f8cb4d913530ff92840_Out_0 = float2(_Split_cda27505033cfc8eaf60fe914f0949b9_R_1, _Split_cda27505033cfc8eaf60fe914f0949b9_G_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float2 _Vector2_5452a0299d10b280aec51f7407d4d2ac_Out_0 = float2(_Split_cda27505033cfc8eaf60fe914f0949b9_B_3, _Split_cda27505033cfc8eaf60fe914f0949b9_A_4);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float2 _TilingAndOffset_e1c5b97bd253ca8f9f3d26f598e6d7fd_Out_3;
            Unity_TilingAndOffset_float(IN.uv0.xy, _Vector2_42d7e955009b6f8cb4d913530ff92840_Out_0, _Vector2_5452a0299d10b280aec51f7407d4d2ac_Out_0, _TilingAndOffset_e1c5b97bd253ca8f9f3d26f598e6d7fd_Out_3);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 _SampleTexture2D_fa4ac40fc922b9869e37c06690c0f530_RGBA_0 = SAMPLE_TEXTURE2D(_Property_b561c414493a8f8299227a27e437f045_Out_0.tex, _Property_b561c414493a8f8299227a27e437f045_Out_0.samplerstate, _TilingAndOffset_e1c5b97bd253ca8f9f3d26f598e6d7fd_Out_3);
            float _SampleTexture2D_fa4ac40fc922b9869e37c06690c0f530_R_4 = _SampleTexture2D_fa4ac40fc922b9869e37c06690c0f530_RGBA_0.r;
            float _SampleTexture2D_fa4ac40fc922b9869e37c06690c0f530_G_5 = _SampleTexture2D_fa4ac40fc922b9869e37c06690c0f530_RGBA_0.g;
            float _SampleTexture2D_fa4ac40fc922b9869e37c06690c0f530_B_6 = _SampleTexture2D_fa4ac40fc922b9869e37c06690c0f530_RGBA_0.b;
            float _SampleTexture2D_fa4ac40fc922b9869e37c06690c0f530_A_7 = _SampleTexture2D_fa4ac40fc922b9869e37c06690c0f530_RGBA_0.a;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float2 _Vector2_65060e9a9f687a89b68e32dc876be645_Out_0 = float2(_SampleTexture2D_fa4ac40fc922b9869e37c06690c0f530_A_7, _SampleTexture2D_fa4ac40fc922b9869e37c06690c0f530_G_5);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float2 _Multiply_5d4c3baed6515c8b86a289c70fca8f5d_Out_2;
            Unity_Multiply_float(_Vector2_65060e9a9f687a89b68e32dc876be645_Out_0, float2(2, 2), _Multiply_5d4c3baed6515c8b86a289c70fca8f5d_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float2 _Add_98b310e19c5fa5899c39cc45969c15ea_Out_2;
            Unity_Add_float2(_Multiply_5d4c3baed6515c8b86a289c70fca8f5d_Out_2, float2(-1, -1), _Add_98b310e19c5fa5899c39cc45969c15ea_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_08b99582093b36869beb5ea3d18e765d_Out_0 = _DetailNormalScale;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float2 _Multiply_bf0b80fdb3271784900e5b5ea4c5550f_Out_2;
            Unity_Multiply_float(_Add_98b310e19c5fa5899c39cc45969c15ea_Out_2, (_Property_08b99582093b36869beb5ea3d18e765d_Out_0.xx), _Multiply_bf0b80fdb3271784900e5b5ea4c5550f_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Split_26c1e73f8436c78ebdae5b51365a072b_R_1 = _Multiply_bf0b80fdb3271784900e5b5ea4c5550f_Out_2[0];
            float _Split_26c1e73f8436c78ebdae5b51365a072b_G_2 = _Multiply_bf0b80fdb3271784900e5b5ea4c5550f_Out_2[1];
            float _Split_26c1e73f8436c78ebdae5b51365a072b_B_3 = 0;
            float _Split_26c1e73f8436c78ebdae5b51365a072b_A_4 = 0;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _DotProduct_50aca3ce0da1ad849d7ff4a99df3a322_Out_2;
            Unity_DotProduct_float2(_Multiply_bf0b80fdb3271784900e5b5ea4c5550f_Out_2, _Multiply_bf0b80fdb3271784900e5b5ea4c5550f_Out_2, _DotProduct_50aca3ce0da1ad849d7ff4a99df3a322_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Saturate_491f2ee8417b8782aee83358b89eeb08_Out_1;
            Unity_Saturate_float(_DotProduct_50aca3ce0da1ad849d7ff4a99df3a322_Out_2, _Saturate_491f2ee8417b8782aee83358b89eeb08_Out_1);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _OneMinus_46ad3170d736808d98bf74ffa45e0414_Out_1;
            Unity_OneMinus_float(_Saturate_491f2ee8417b8782aee83358b89eeb08_Out_1, _OneMinus_46ad3170d736808d98bf74ffa45e0414_Out_1);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _SquareRoot_dfeae899ebfeae8f9257c340ca22ce38_Out_1;
            Unity_SquareRoot_float(_OneMinus_46ad3170d736808d98bf74ffa45e0414_Out_1, _SquareRoot_dfeae899ebfeae8f9257c340ca22ce38_Out_1);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 _Vector3_ed3f80ed87524e8c99f98b224af5a610_Out_0 = float3(_Split_26c1e73f8436c78ebdae5b51365a072b_R_1, _Split_26c1e73f8436c78ebdae5b51365a072b_G_2, _SquareRoot_dfeae899ebfeae8f9257c340ca22ce38_Out_1);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            UnityTexture2D _Property_2cc39234d3d334899f94126a216a50fc_Out_0 = UnityBuildTexture2DStructNoScale(_BaseNormalMap);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 _Property_115fcc827510f38798b214d835c27637_Out_0 = _BaseTilingOffset;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_d83b8f290862b285bbe2f157190e1315_Out_0 = _BaseUsePlanarUV;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            Bindings_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8 _PlanarNMn_4fde70f39e45398dbb9972941e88e2bf;
            _PlanarNMn_4fde70f39e45398dbb9972941e88e2bf.WorldSpaceNormal = IN.WorldSpaceNormal;
            _PlanarNMn_4fde70f39e45398dbb9972941e88e2bf.WorldSpaceTangent = IN.WorldSpaceTangent;
            _PlanarNMn_4fde70f39e45398dbb9972941e88e2bf.WorldSpaceBiTangent = IN.WorldSpaceBiTangent;
            _PlanarNMn_4fde70f39e45398dbb9972941e88e2bf.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            _PlanarNMn_4fde70f39e45398dbb9972941e88e2bf.uv0 = IN.uv0;
            float4 _PlanarNMn_4fde70f39e45398dbb9972941e88e2bf_XZ_2;
            SG_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8(_Property_2cc39234d3d334899f94126a216a50fc_Out_0, _Property_115fcc827510f38798b214d835c27637_Out_0, _Property_d83b8f290862b285bbe2f157190e1315_Out_0, _PlanarNMn_4fde70f39e45398dbb9972941e88e2bf, _PlanarNMn_4fde70f39e45398dbb9972941e88e2bf_XZ_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_020d569f63e9a2849e23988ff74eb005_Out_0 = _BaseNormalScale;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 _NormalStrength_0c71fb166ae841839a0a12ecc5afa6fe_Out_2;
            Unity_NormalStrength_float((_PlanarNMn_4fde70f39e45398dbb9972941e88e2bf_XZ_2.xyz), _Property_020d569f63e9a2849e23988ff74eb005_Out_0, _NormalStrength_0c71fb166ae841839a0a12ecc5afa6fe_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 _NormalBlend_be36dd49bea74c8f8dd52fa3a85a9534_Out_2;
            Unity_NormalBlend_float(_Vector3_ed3f80ed87524e8c99f98b224af5a610_Out_0, _NormalStrength_0c71fb166ae841839a0a12ecc5afa6fe_Out_2, _NormalBlend_be36dd49bea74c8f8dd52fa3a85a9534_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            UnityTexture2D _Property_a383045772822c87acd099bb4cd6c478_Out_0 = UnityBuildTexture2DStructNoScale(_CoverNormalMap);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 _Property_e35c79b8cccfbe8ca0a3c33e8d32e319_Out_0 = _CoverTilingOffset;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_e3d8b38b51331e879b1d4012d65f53e6_Out_0 = _CoverUsePlanarUV;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            Bindings_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8 _PlanarNMn_79abde32a0223a89907c9f09efac8db7;
            _PlanarNMn_79abde32a0223a89907c9f09efac8db7.WorldSpaceNormal = IN.WorldSpaceNormal;
            _PlanarNMn_79abde32a0223a89907c9f09efac8db7.WorldSpaceTangent = IN.WorldSpaceTangent;
            _PlanarNMn_79abde32a0223a89907c9f09efac8db7.WorldSpaceBiTangent = IN.WorldSpaceBiTangent;
            _PlanarNMn_79abde32a0223a89907c9f09efac8db7.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            _PlanarNMn_79abde32a0223a89907c9f09efac8db7.uv0 = IN.uv0;
            float4 _PlanarNMn_79abde32a0223a89907c9f09efac8db7_XZ_2;
            SG_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8(_Property_a383045772822c87acd099bb4cd6c478_Out_0, _Property_e35c79b8cccfbe8ca0a3c33e8d32e319_Out_0, _Property_e3d8b38b51331e879b1d4012d65f53e6_Out_0, _PlanarNMn_79abde32a0223a89907c9f09efac8db7, _PlanarNMn_79abde32a0223a89907c9f09efac8db7_XZ_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_486692dad4d34a8c8410b4771efbf96b_Out_0 = _CoverNormalScale;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 _NormalStrength_d60a055f00d779808337e9d909827806_Out_2;
            Unity_NormalStrength_float((_PlanarNMn_79abde32a0223a89907c9f09efac8db7_XZ_2.xyz), _Property_486692dad4d34a8c8410b4771efbf96b_Out_0, _NormalStrength_d60a055f00d779808337e9d909827806_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            UnityTexture2D _Property_356186a26fec8686a13bc6b57fd8f3ee_Out_0 = UnityBuildTexture2DStructNoScale(_CoverMaskA);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 _UV_045cea9e82354980a778f44d92578382_Out_0 = IN.uv0;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 _SampleTexture2D_0eef6ae3dab6e185bd0f65edecd80314_RGBA_0 = SAMPLE_TEXTURE2D(_Property_356186a26fec8686a13bc6b57fd8f3ee_Out_0.tex, _Property_356186a26fec8686a13bc6b57fd8f3ee_Out_0.samplerstate, (_UV_045cea9e82354980a778f44d92578382_Out_0.xy));
            float _SampleTexture2D_0eef6ae3dab6e185bd0f65edecd80314_R_4 = _SampleTexture2D_0eef6ae3dab6e185bd0f65edecd80314_RGBA_0.r;
            float _SampleTexture2D_0eef6ae3dab6e185bd0f65edecd80314_G_5 = _SampleTexture2D_0eef6ae3dab6e185bd0f65edecd80314_RGBA_0.g;
            float _SampleTexture2D_0eef6ae3dab6e185bd0f65edecd80314_B_6 = _SampleTexture2D_0eef6ae3dab6e185bd0f65edecd80314_RGBA_0.b;
            float _SampleTexture2D_0eef6ae3dab6e185bd0f65edecd80314_A_7 = _SampleTexture2D_0eef6ae3dab6e185bd0f65edecd80314_RGBA_0.a;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_4e8240836843df81941cdf6cf2cdd638_Out_0 = _CoverMaskPower;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Multiply_8b5250e5dfc73a84a41399a13b83c0a1_Out_2;
            Unity_Multiply_float(_SampleTexture2D_0eef6ae3dab6e185bd0f65edecd80314_A_7, _Property_4e8240836843df81941cdf6cf2cdd638_Out_0, _Multiply_8b5250e5dfc73a84a41399a13b83c0a1_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Clamp_030a7c32684c258084338456eaddc77a_Out_3;
            Unity_Clamp_float(_Multiply_8b5250e5dfc73a84a41399a13b83c0a1_Out_2, 0, 1, _Clamp_030a7c32684c258084338456eaddc77a_Out_3);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Split_8ba5b67899f36b8f9dcf5c84092c0560_R_1 = IN.VertexColor[0];
            float _Split_8ba5b67899f36b8f9dcf5c84092c0560_G_2 = IN.VertexColor[1];
            float _Split_8ba5b67899f36b8f9dcf5c84092c0560_B_3 = IN.VertexColor[2];
            float _Split_8ba5b67899f36b8f9dcf5c84092c0560_A_4 = IN.VertexColor[3];
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_c688e246111fd881820a97415e14d8a3_Out_0 = _CoverNormalBlendHardness;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 _NormalStrength_0e5e0831ba0e98878220ca6021ea52a2_Out_2;
            Unity_NormalStrength_float((_PlanarNMn_79abde32a0223a89907c9f09efac8db7_XZ_2.xyz), _Property_c688e246111fd881820a97415e14d8a3_Out_0, _NormalStrength_0e5e0831ba0e98878220ca6021ea52a2_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Split_8cadce726725318fbacd47f436a8231d_R_1 = IN.WorldSpaceNormal[0];
            float _Split_8cadce726725318fbacd47f436a8231d_G_2 = IN.WorldSpaceNormal[1];
            float _Split_8cadce726725318fbacd47f436a8231d_B_3 = IN.WorldSpaceNormal[2];
            float _Split_8cadce726725318fbacd47f436a8231d_A_4 = 0;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_ce4e5954a0b7ff8c819fa53963327595_Out_0 = _Cover_Amount;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_384059e6344fb98a85eccad78dd82f36_Out_0 = _Cover_Amount_Grow_Speed;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Subtract_70fd06876db7fa85b0cc0bce8d926dff_Out_2;
            Unity_Subtract_float(4, _Property_384059e6344fb98a85eccad78dd82f36_Out_0, _Subtract_70fd06876db7fa85b0cc0bce8d926dff_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Divide_1a3a6334c3d8bc8f8ac262c7833e15d5_Out_2;
            Unity_Divide_float(_Property_ce4e5954a0b7ff8c819fa53963327595_Out_0, _Subtract_70fd06876db7fa85b0cc0bce8d926dff_Out_2, _Divide_1a3a6334c3d8bc8f8ac262c7833e15d5_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Absolute_f218d2b85ebf288f91234faffedb5f7b_Out_1;
            Unity_Absolute_float(_Divide_1a3a6334c3d8bc8f8ac262c7833e15d5_Out_2, _Absolute_f218d2b85ebf288f91234faffedb5f7b_Out_1);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Power_a9b8d4b65c44a98e9813f61c0e2dc0a3_Out_2;
            Unity_Power_float(_Absolute_f218d2b85ebf288f91234faffedb5f7b_Out_1, _Subtract_70fd06876db7fa85b0cc0bce8d926dff_Out_2, _Power_a9b8d4b65c44a98e9813f61c0e2dc0a3_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Clamp_95d579f83746cb82be79cf6739990e0b_Out_3;
            Unity_Clamp_float(_Power_a9b8d4b65c44a98e9813f61c0e2dc0a3_Out_2, 0, 2, _Clamp_95d579f83746cb82be79cf6739990e0b_Out_3);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Multiply_02a8aa0fa6974e81aa84caba54f63896_Out_2;
            Unity_Multiply_float(_Split_8cadce726725318fbacd47f436a8231d_G_2, _Clamp_95d579f83746cb82be79cf6739990e0b_Out_3, _Multiply_02a8aa0fa6974e81aa84caba54f63896_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Saturate_ada5e8f9ebdcb38d8f5e61e8d97424b9_Out_1;
            Unity_Saturate_float(_Multiply_02a8aa0fa6974e81aa84caba54f63896_Out_2, _Saturate_ada5e8f9ebdcb38d8f5e61e8d97424b9_Out_1);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Clamp_38bac9e8ef351789b5fd4f2201f1df7b_Out_3;
            Unity_Clamp_float(_Split_8cadce726725318fbacd47f436a8231d_G_2, 0, 0.9999, _Clamp_38bac9e8ef351789b5fd4f2201f1df7b_Out_3);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_9babc76177853482826cae0163ffe988_Out_0 = _Cover_Max_Angle;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Divide_3b22550205905d8da5870f9db56e44ff_Out_2;
            Unity_Divide_float(_Property_9babc76177853482826cae0163ffe988_Out_0, 45, _Divide_3b22550205905d8da5870f9db56e44ff_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _OneMinus_99a85b6952a41288afc86da0a6ca6ea0_Out_1;
            Unity_OneMinus_float(_Divide_3b22550205905d8da5870f9db56e44ff_Out_2, _OneMinus_99a85b6952a41288afc86da0a6ca6ea0_Out_1);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Subtract_2b63f3aaee26f686971dca1d28da283c_Out_2;
            Unity_Subtract_float(_Clamp_38bac9e8ef351789b5fd4f2201f1df7b_Out_3, _OneMinus_99a85b6952a41288afc86da0a6ca6ea0_Out_1, _Subtract_2b63f3aaee26f686971dca1d28da283c_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Clamp_6bd9bb4add91fe8eb80a958a6b1a2d01_Out_3;
            Unity_Clamp_float(_Subtract_2b63f3aaee26f686971dca1d28da283c_Out_2, 0, 2, _Clamp_6bd9bb4add91fe8eb80a958a6b1a2d01_Out_3);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Divide_a09d2d461b07e98999aba746fb52a3fc_Out_2;
            Unity_Divide_float(1, _Divide_3b22550205905d8da5870f9db56e44ff_Out_2, _Divide_a09d2d461b07e98999aba746fb52a3fc_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Multiply_89a8f5a279c73b898d4ca5d075786b53_Out_2;
            Unity_Multiply_float(_Clamp_6bd9bb4add91fe8eb80a958a6b1a2d01_Out_3, _Divide_a09d2d461b07e98999aba746fb52a3fc_Out_2, _Multiply_89a8f5a279c73b898d4ca5d075786b53_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Absolute_f98ce5feb185a68784b9b35eb71ec465_Out_1;
            Unity_Absolute_float(_Multiply_89a8f5a279c73b898d4ca5d075786b53_Out_2, _Absolute_f98ce5feb185a68784b9b35eb71ec465_Out_1);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_27e768ffa9c13e8ab65d48e7712e5b66_Out_0 = _CoverHardness;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Power_b9fdc3921d5b85878a1ec4baa1975184_Out_2;
            Unity_Power_float(_Absolute_f98ce5feb185a68784b9b35eb71ec465_Out_1, _Property_27e768ffa9c13e8ab65d48e7712e5b66_Out_0, _Power_b9fdc3921d5b85878a1ec4baa1975184_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_c442c20fdade808b8e1b93cfd6625ab9_Out_0 = _Cover_Min_Height;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _OneMinus_55530ddc82048c8aa2d082334edf6a57_Out_1;
            Unity_OneMinus_float(_Property_c442c20fdade808b8e1b93cfd6625ab9_Out_0, _OneMinus_55530ddc82048c8aa2d082334edf6a57_Out_1);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Split_7e5d084c5e6bfa83a9203dac971ea31e_R_1 = IN.AbsoluteWorldSpacePosition[0];
            float _Split_7e5d084c5e6bfa83a9203dac971ea31e_G_2 = IN.AbsoluteWorldSpacePosition[1];
            float _Split_7e5d084c5e6bfa83a9203dac971ea31e_B_3 = IN.AbsoluteWorldSpacePosition[2];
            float _Split_7e5d084c5e6bfa83a9203dac971ea31e_A_4 = 0;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Add_e4067b215657d98ab6ec4e0295ddfece_Out_2;
            Unity_Add_float(_OneMinus_55530ddc82048c8aa2d082334edf6a57_Out_1, _Split_7e5d084c5e6bfa83a9203dac971ea31e_G_2, _Add_e4067b215657d98ab6ec4e0295ddfece_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Add_a4387dfc1ea3ee8da0b04f433a7c63d0_Out_2;
            Unity_Add_float(_Add_e4067b215657d98ab6ec4e0295ddfece_Out_2, 1, _Add_a4387dfc1ea3ee8da0b04f433a7c63d0_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Clamp_570e1129ecb02c8b8be79d85f19d5ae1_Out_3;
            Unity_Clamp_float(_Add_a4387dfc1ea3ee8da0b04f433a7c63d0_Out_2, 0, 1, _Clamp_570e1129ecb02c8b8be79d85f19d5ae1_Out_3);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_5da709b259ac268bb134d927bcffa4b8_Out_0 = _Cover_Min_Height_Blending;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Add_c322347d9ddbcd83ba52983e9316c387_Out_2;
            Unity_Add_float(_Add_e4067b215657d98ab6ec4e0295ddfece_Out_2, _Property_5da709b259ac268bb134d927bcffa4b8_Out_0, _Add_c322347d9ddbcd83ba52983e9316c387_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Divide_078ffa7d6c597f819511c95d33b7d90e_Out_2;
            Unity_Divide_float(_Add_c322347d9ddbcd83ba52983e9316c387_Out_2, _Add_e4067b215657d98ab6ec4e0295ddfece_Out_2, _Divide_078ffa7d6c597f819511c95d33b7d90e_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _OneMinus_b9f8edced35e7b8cab9ca581d822e31f_Out_1;
            Unity_OneMinus_float(_Divide_078ffa7d6c597f819511c95d33b7d90e_Out_2, _OneMinus_b9f8edced35e7b8cab9ca581d822e31f_Out_1);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Add_95cd1778448bfe8d9f9fa9129235f2c2_Out_2;
            Unity_Add_float(_OneMinus_b9f8edced35e7b8cab9ca581d822e31f_Out_1, -0.5, _Add_95cd1778448bfe8d9f9fa9129235f2c2_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Clamp_23e760e01b7e0780a71d88813b5828d7_Out_3;
            Unity_Clamp_float(_Add_95cd1778448bfe8d9f9fa9129235f2c2_Out_2, 0, 1, _Clamp_23e760e01b7e0780a71d88813b5828d7_Out_3);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Add_674fcef023d728848510150af810a103_Out_2;
            Unity_Add_float(_Clamp_570e1129ecb02c8b8be79d85f19d5ae1_Out_3, _Clamp_23e760e01b7e0780a71d88813b5828d7_Out_3, _Add_674fcef023d728848510150af810a103_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Clamp_5b677be9d499c082bcbe316853b0adff_Out_3;
            Unity_Clamp_float(_Add_674fcef023d728848510150af810a103_Out_2, 0, 1, _Clamp_5b677be9d499c082bcbe316853b0adff_Out_3);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Multiply_7ea7400ed65a3582b000796fb39748e9_Out_2;
            Unity_Multiply_float(_Power_b9fdc3921d5b85878a1ec4baa1975184_Out_2, _Clamp_5b677be9d499c082bcbe316853b0adff_Out_3, _Multiply_7ea7400ed65a3582b000796fb39748e9_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Multiply_4d295791f4e23186acea64f2f4de94ea_Out_2;
            Unity_Multiply_float(_Saturate_ada5e8f9ebdcb38d8f5e61e8d97424b9_Out_1, _Multiply_7ea7400ed65a3582b000796fb39748e9_Out_2, _Multiply_4d295791f4e23186acea64f2f4de94ea_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 _Lerp_21eaf65c617b2d858b3b33154d55757a_Out_3;
            Unity_Lerp_float3(_NormalBlend_be36dd49bea74c8f8dd52fa3a85a9534_Out_2, _NormalStrength_0e5e0831ba0e98878220ca6021ea52a2_Out_2, (_Multiply_4d295791f4e23186acea64f2f4de94ea_Out_2.xxx), _Lerp_21eaf65c617b2d858b3b33154d55757a_Out_3);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3x3 Transform_1e4c3a2d6240958ab6858efb88c1d06a_transposeTangent = transpose(float3x3(IN.WorldSpaceTangent, IN.WorldSpaceBiTangent, IN.WorldSpaceNormal));
            float3 _Transform_1e4c3a2d6240958ab6858efb88c1d06a_Out_1 = normalize(mul(Transform_1e4c3a2d6240958ab6858efb88c1d06a_transposeTangent, _Lerp_21eaf65c617b2d858b3b33154d55757a_Out_3.xyz).xyz);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Split_600a9d271d96798a94ab28118977defd_R_1 = _Transform_1e4c3a2d6240958ab6858efb88c1d06a_Out_1[0];
            float _Split_600a9d271d96798a94ab28118977defd_G_2 = _Transform_1e4c3a2d6240958ab6858efb88c1d06a_Out_1[1];
            float _Split_600a9d271d96798a94ab28118977defd_B_3 = _Transform_1e4c3a2d6240958ab6858efb88c1d06a_Out_1[2];
            float _Split_600a9d271d96798a94ab28118977defd_A_4 = 0;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Multiply_2e5b010626435f8492a2690396ced19d_Out_2;
            Unity_Multiply_float(_Split_600a9d271d96798a94ab28118977defd_G_2, _Clamp_95d579f83746cb82be79cf6739990e0b_Out_3, _Multiply_2e5b010626435f8492a2690396ced19d_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Multiply_5a2397e0153ddb8f9bd457d9a301dc8b_Out_2;
            Unity_Multiply_float(_Clamp_95d579f83746cb82be79cf6739990e0b_Out_3, _Property_27e768ffa9c13e8ab65d48e7712e5b66_Out_0, _Multiply_5a2397e0153ddb8f9bd457d9a301dc8b_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Multiply_3aad76eaff60dd888c3e1783ecf03943_Out_2;
            Unity_Multiply_float(_Multiply_5a2397e0153ddb8f9bd457d9a301dc8b_Out_2, _Multiply_7ea7400ed65a3582b000796fb39748e9_Out_2, _Multiply_3aad76eaff60dd888c3e1783ecf03943_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Multiply_05614e740451f18f8301586390aa5a0a_Out_2;
            Unity_Multiply_float(_Multiply_2e5b010626435f8492a2690396ced19d_Out_2, _Multiply_3aad76eaff60dd888c3e1783ecf03943_Out_2, _Multiply_05614e740451f18f8301586390aa5a0a_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            UnityTexture2D _Property_a14f2476a35d208b988233c852f919ef_Out_0 = UnityBuildTexture2DStructNoScale(_CoverMaskMap);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            Bindings_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6 _PlanarNM_6858a0e821f26a8d87846d325e9bd170;
            _PlanarNM_6858a0e821f26a8d87846d325e9bd170.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            _PlanarNM_6858a0e821f26a8d87846d325e9bd170.uv0 = IN.uv0;
            float4 _PlanarNM_6858a0e821f26a8d87846d325e9bd170_XZ_2;
            SG_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6(_Property_a14f2476a35d208b988233c852f919ef_Out_0, _Property_e35c79b8cccfbe8ca0a3c33e8d32e319_Out_0, _Property_e3d8b38b51331e879b1d4012d65f53e6_Out_0, _PlanarNM_6858a0e821f26a8d87846d325e9bd170, _PlanarNM_6858a0e821f26a8d87846d325e9bd170_XZ_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Split_16313c20ccdeaa86a639068877a69a2f_R_1 = _PlanarNM_6858a0e821f26a8d87846d325e9bd170_XZ_2[0];
            float _Split_16313c20ccdeaa86a639068877a69a2f_G_2 = _PlanarNM_6858a0e821f26a8d87846d325e9bd170_XZ_2[1];
            float _Split_16313c20ccdeaa86a639068877a69a2f_B_3 = _PlanarNM_6858a0e821f26a8d87846d325e9bd170_XZ_2[2];
            float _Split_16313c20ccdeaa86a639068877a69a2f_A_4 = _PlanarNM_6858a0e821f26a8d87846d325e9bd170_XZ_2[3];
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_673896519f419589938b37e782b90141_Out_0 = _CoverHeightMapMin;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_c35906332422438da3b19f45cbd5ac17_Out_0 = _CoverHeightMapMax;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float2 _Vector2_81cbe1e5ea789e8697223cd3bfbca76c_Out_0 = float2(_Property_673896519f419589938b37e782b90141_Out_0, _Property_c35906332422438da3b19f45cbd5ac17_Out_0);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_88ab0068f899fc8ba94efdaec5e8966b_Out_0 = _CoverHeightMapOffset;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float2 _Add_cd623e3135271489b0d45b4d7edc5f7e_Out_2;
            Unity_Add_float2(_Vector2_81cbe1e5ea789e8697223cd3bfbca76c_Out_0, (_Property_88ab0068f899fc8ba94efdaec5e8966b_Out_0.xx), _Add_cd623e3135271489b0d45b4d7edc5f7e_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Remap_9a23d5f76fa8c38dbd73f43bd6397b0b_Out_3;
            Unity_Remap_float(_Split_16313c20ccdeaa86a639068877a69a2f_B_3, float2 (0, 1), _Add_cd623e3135271489b0d45b4d7edc5f7e_Out_2, _Remap_9a23d5f76fa8c38dbd73f43bd6397b0b_Out_3);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Multiply_0093be0fd848498b89a0fa282608e715_Out_2;
            Unity_Multiply_float(_Multiply_05614e740451f18f8301586390aa5a0a_Out_2, _Remap_9a23d5f76fa8c38dbd73f43bd6397b0b_Out_3, _Multiply_0093be0fd848498b89a0fa282608e715_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Multiply_d3190f97afd0398083623ecf71a41b1a_Out_2;
            Unity_Multiply_float(_Split_8ba5b67899f36b8f9dcf5c84092c0560_G_2, _Multiply_0093be0fd848498b89a0fa282608e715_Out_2, _Multiply_d3190f97afd0398083623ecf71a41b1a_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Saturate_cbcee34e7e6e6d8091d840550ab1c74a_Out_1;
            Unity_Saturate_float(_Multiply_d3190f97afd0398083623ecf71a41b1a_Out_2, _Saturate_cbcee34e7e6e6d8091d840550ab1c74a_Out_1);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Multiply_da35b9d9e4dd8c81871a9aea42c157ee_Out_2;
            Unity_Multiply_float(_Clamp_030a7c32684c258084338456eaddc77a_Out_3, _Saturate_cbcee34e7e6e6d8091d840550ab1c74a_Out_1, _Multiply_da35b9d9e4dd8c81871a9aea42c157ee_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Clamp_c95f5515948375878df6581a36d8b203_Out_3;
            Unity_Clamp_float(_Multiply_da35b9d9e4dd8c81871a9aea42c157ee_Out_2, 0, 1, _Clamp_c95f5515948375878df6581a36d8b203_Out_3);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            #if defined(_USEDYNAMICCOVERTSTATICMASKF_ON)
            float _UseDynamicCoverTStaticMaskF_0694902516172b8fa469c5d8b8e938c6_Out_0 = _Clamp_c95f5515948375878df6581a36d8b203_Out_3;
            #else
            float _UseDynamicCoverTStaticMaskF_0694902516172b8fa469c5d8b8e938c6_Out_0 = _Clamp_030a7c32684c258084338456eaddc77a_Out_3;
            #endif
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 _Lerp_6861b6a37faf5e868527d229073a4d0f_Out_3;
            Unity_Lerp_float3(_NormalBlend_be36dd49bea74c8f8dd52fa3a85a9534_Out_2, _NormalStrength_d60a055f00d779808337e9d909827806_Out_2, (_UseDynamicCoverTStaticMaskF_0694902516172b8fa469c5d8b8e938c6_Out_0.xxx), _Lerp_6861b6a37faf5e868527d229073a4d0f_Out_3);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            UnityTexture2D _Property_e4c53213449c7682b60df6ae54f219f0_Out_0 = UnityBuildTexture2DStructNoScale(_BaseColorMap);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            Bindings_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6 _PlanarNM_6c8b686076db2a8c8b7d6cd91cf435f0;
            _PlanarNM_6c8b686076db2a8c8b7d6cd91cf435f0.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            _PlanarNM_6c8b686076db2a8c8b7d6cd91cf435f0.uv0 = IN.uv0;
            float4 _PlanarNM_6c8b686076db2a8c8b7d6cd91cf435f0_XZ_2;
            SG_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6(_Property_e4c53213449c7682b60df6ae54f219f0_Out_0, _Property_115fcc827510f38798b214d835c27637_Out_0, _Property_d83b8f290862b285bbe2f157190e1315_Out_0, _PlanarNM_6c8b686076db2a8c8b7d6cd91cf435f0, _PlanarNM_6c8b686076db2a8c8b7d6cd91cf435f0_XZ_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Split_31874fa1d55cb28e99a1333cf254676a_R_1 = _PlanarNM_6c8b686076db2a8c8b7d6cd91cf435f0_XZ_2[0];
            float _Split_31874fa1d55cb28e99a1333cf254676a_G_2 = _PlanarNM_6c8b686076db2a8c8b7d6cd91cf435f0_XZ_2[1];
            float _Split_31874fa1d55cb28e99a1333cf254676a_B_3 = _PlanarNM_6c8b686076db2a8c8b7d6cd91cf435f0_XZ_2[2];
            float _Split_31874fa1d55cb28e99a1333cf254676a_A_4 = _PlanarNM_6c8b686076db2a8c8b7d6cd91cf435f0_XZ_2[3];
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_881c341218ea2d81819695b0c7ddc4cb_Out_0 = _AlphaCutoff;
            #endif
            surface.NormalTS = _Lerp_6861b6a37faf5e868527d229073a4d0f_Out_3;
            surface.Alpha = _Split_31874fa1d55cb28e99a1333cf254676a_A_4;
            surface.AlphaClipThreshold = _Property_881c341218ea2d81819695b0c7ddc4cb_Out_0;
            return surface;
        }

            // --------------------------------------------------
            // Build Graph Inputs

            VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.ObjectSpaceNormal =           input.normalOS;
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.ObjectSpaceTangent =          input.tangentOS.xyz;
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.ObjectSpacePosition =         input.positionOS;
        #endif


            return output;
        }
            SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        // must use interpolated tangent, bitangent and normal before they are normalized in the pixel shader.
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        float3 unnormalizedNormalWS = input.normalWS;
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        const float renormFactor = 1.0 / length(unnormalizedNormalWS);
        #endif


        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        // use bitangent on the fly like in hdrp
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        // IMPORTANT! If we ever support Flip on double sided materials ensure bitangent and tangent are NOT flipped.
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        float crossSign = (input.tangentWS.w > 0.0 ? 1.0 : -1.0) * GetOddNegativeScale();
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        float3 bitang = crossSign * cross(input.normalWS.xyz, input.tangentWS.xyz);
        #endif


        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.WorldSpaceNormal =            renormFactor*input.normalWS.xyz;      // we want a unit length Normal Vector node in shader graph
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.TangentSpaceNormal =          float3(0.0f, 0.0f, 1.0f);
        #endif


        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        // to preserve mikktspace compliance we use same scale renormFactor as was used on the normal.
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        // This is explained in section 2.2 in "surface gradient based bump mapping framework"
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.WorldSpaceTangent =           renormFactor*input.tangentWS.xyz;
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.WorldSpaceBiTangent =         renormFactor*bitang;
        #endif


        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.AbsoluteWorldSpacePosition =  GetAbsolutePositionWS(input.positionWS);
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.uv0 =                         input.texCoord0;
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.VertexColor =                 input.color;
        #endif

        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN

            return output;
        }

            // --------------------------------------------------
            // Main

            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/DepthNormalsOnlyPass.hlsl"

            ENDHLSL
        }
        Pass
        {
            Name "Meta"
            Tags
            {
                "LightMode" = "Meta"
            }

            // Render State
            Cull Off

            // Debug
            // <None>

            // --------------------------------------------------
            // Pass

            HLSLPROGRAM

            // Pragmas
            #pragma target 2.0
        #pragma only_renderers gles gles3 glcore
        #pragma vertex vert
        #pragma fragment frag

            // DotsInstancingOptions: <None>
            // HybridV1InjectedBuiltinProperties: <None>

            // Keywords
            #pragma shader_feature _ _SMOOTHNESS_TEXTURE_ALBEDO_CHANNEL_A
            #pragma shader_feature_local _ _USEDYNAMICCOVERTSTATICMASKF_ON

        #if defined(_USEDYNAMICCOVERTSTATICMASKF_ON)
            #define KEYWORD_PERMUTATION_0
        #else
            #define KEYWORD_PERMUTATION_1
        #endif


            // Defines
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define _AlphaClip 1
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define _NORMALMAP 1
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define _NORMAL_DROPOFF_TS 1
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define ATTRIBUTES_NEED_NORMAL
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define ATTRIBUTES_NEED_TANGENT
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define ATTRIBUTES_NEED_TEXCOORD0
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define ATTRIBUTES_NEED_TEXCOORD1
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define ATTRIBUTES_NEED_TEXCOORD2
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define ATTRIBUTES_NEED_COLOR
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define VARYINGS_NEED_POSITION_WS
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define VARYINGS_NEED_NORMAL_WS
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define VARYINGS_NEED_TANGENT_WS
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define VARYINGS_NEED_TEXCOORD0
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define VARYINGS_NEED_COLOR
        #endif

            #define FEATURES_GRAPH_VERTEX
            /* WARNING: $splice Could not find named fragment 'PassInstancing' */
            #define SHADERPASS SHADERPASS_META
            /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */

            // Includes
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/MetaInput.hlsl"

            // --------------------------------------------------
            // Structs and Packing

            struct Attributes
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 positionOS : POSITION;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 normalOS : NORMAL;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 tangentOS : TANGENT;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 uv0 : TEXCOORD0;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 uv1 : TEXCOORD1;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 uv2 : TEXCOORD2;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 color : COLOR;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            uint instanceID : INSTANCEID_SEMANTIC;
            #endif
            #endif
        };
        struct Varyings
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 positionCS : SV_POSITION;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 positionWS;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 normalWS;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 tangentWS;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 texCoord0;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 color;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
            #endif
        };
        struct SurfaceDescriptionInputs
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 WorldSpaceNormal;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 WorldSpaceTangent;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 WorldSpaceBiTangent;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 AbsoluteWorldSpacePosition;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 uv0;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 VertexColor;
            #endif
        };
        struct VertexDescriptionInputs
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 ObjectSpaceNormal;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 ObjectSpaceTangent;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 ObjectSpacePosition;
            #endif
        };
        struct PackedVaryings
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 positionCS : SV_POSITION;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 interp0 : TEXCOORD0;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 interp1 : TEXCOORD1;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 interp2 : TEXCOORD2;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 interp3 : TEXCOORD3;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 interp4 : TEXCOORD4;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
            #endif
        };

            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            output.positionCS = input.positionCS;
            output.interp0.xyz =  input.positionWS;
            output.interp1.xyz =  input.normalWS;
            output.interp2.xyzw =  input.tangentWS;
            output.interp3.xyzw =  input.texCoord0;
            output.interp4.xyzw =  input.color;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.positionWS = input.interp0.xyz;
            output.normalWS = input.interp1.xyz;
            output.tangentWS = input.interp2.xyzw;
            output.texCoord0 = input.interp3.xyzw;
            output.color = input.interp4.xyzw;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        #endif

            // --------------------------------------------------
            // Graph

            // Graph Properties
            CBUFFER_START(UnityPerMaterial)
        float _AlphaCutoff;
        float4 _BaseColor;
        float4 _BaseColorMap_TexelSize;
        float _BaseUsePlanarUV;
        float4 _BaseTilingOffset;
        float4 _BaseNormalMap_TexelSize;
        float _BaseNormalScale;
        float4 _BaseMaskMap_TexelSize;
        float _BaseMetallic;
        float _BaseAORemapMin;
        float _BaseAORemapMax;
        float _BaseSmoothnessRemapMin;
        float _BaseSmoothnessRemapMax;
        float4 _CoverMaskA_TexelSize;
        float _CoverMaskPower;
        float _Cover_Amount;
        float _Cover_Amount_Grow_Speed;
        float _Cover_Max_Angle;
        float _Cover_Min_Height;
        float _Cover_Min_Height_Blending;
        float4 _CoverBaseColor;
        float4 _CoverBaseColorMap_TexelSize;
        float _CoverUsePlanarUV;
        float4 _CoverTilingOffset;
        float4 _CoverNormalMap_TexelSize;
        float _CoverNormalScale;
        float _CoverNormalBlendHardness;
        float _CoverHardness;
        float _CoverHeightMapMin;
        float _CoverHeightMapMax;
        float _CoverHeightMapOffset;
        float4 _CoverMaskMap_TexelSize;
        float _CoverMetallic;
        float _CoverAORemapMin;
        float _CoverAORemapMax;
        float _CoverSmoothnessRemapMin;
        float _CoverSmoothnessRemapMax;
        float4 _DetailMap_TexelSize;
        float4 _DetailTilingOffset;
        float _DetailAlbedoScale;
        float _DetailNormalScale;
        float _DetailSmoothnessScale;
        float4 _WetColor;
        float _WetSmoothness;
        CBUFFER_END

        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_BaseColorMap);
        SAMPLER(sampler_BaseColorMap);
        TEXTURE2D(_BaseNormalMap);
        SAMPLER(sampler_BaseNormalMap);
        TEXTURE2D(_BaseMaskMap);
        SAMPLER(sampler_BaseMaskMap);
        TEXTURE2D(_CoverMaskA);
        SAMPLER(sampler_CoverMaskA);
        TEXTURE2D(_CoverBaseColorMap);
        SAMPLER(sampler_CoverBaseColorMap);
        TEXTURE2D(_CoverNormalMap);
        SAMPLER(sampler_CoverNormalMap);
        TEXTURE2D(_CoverMaskMap);
        SAMPLER(sampler_CoverMaskMap);
        TEXTURE2D(_DetailMap);
        SAMPLER(sampler_DetailMap);

            // Graph Functions
            
        // f948cdce565a6e706cc57cb23fbf9d95
        #include "./NM_Object_VSPro_Indirect.cginc"

        void AddPragma_float(float3 A, out float3 Out){
            #pragma instancing_options renderinglayer procedural:setupVSPro
            Out = A;
        }

        struct Bindings_NMObjectVSProIndirect_0cfe1e4f145944241ab304331e53c93b
        {
        };

        void SG_NMObjectVSProIndirect_0cfe1e4f145944241ab304331e53c93b(float3 Vector3_314C8600, Bindings_NMObjectVSProIndirect_0cfe1e4f145944241ab304331e53c93b IN, out float3 ObjectSpacePosition_1)
        {
            float3 _Property_5ec158abd968858c9d31ab40df5e9e6f_Out_0 = Vector3_314C8600;
            float3 _InjectSetupCustomFunction_dec9b26544b4a788b8ecb4117dc3d24a_Out_1;
            InjectSetup_float(_Property_5ec158abd968858c9d31ab40df5e9e6f_Out_0, _InjectSetupCustomFunction_dec9b26544b4a788b8ecb4117dc3d24a_Out_1);
            float3 _AddPragmaCustomFunction_b2a053178906d0848480a1f463521a1b_Out_1;
            AddPragma_float(_InjectSetupCustomFunction_dec9b26544b4a788b8ecb4117dc3d24a_Out_1, _AddPragmaCustomFunction_b2a053178906d0848480a1f463521a1b_Out_1);
            ObjectSpacePosition_1 = _AddPragmaCustomFunction_b2a053178906d0848480a1f463521a1b_Out_1;
        }

        void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
        {
            RGBA = float4(R, G, B, A);
            RGB = float3(R, G, B);
            RG = float2(R, G);
        }

        void Unity_Divide_float(float A, float B, out float Out)
        {
            Out = A / B;
        }

        void Unity_Multiply_float(float4 A, float4 B, out float4 Out)
        {
            Out = A * B;
        }

        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }

        void Unity_Branch_float2(float Predicate, float2 True, float2 False, out float2 Out)
        {
            Out = Predicate ? True : False;
        }

        struct Bindings_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6
        {
            float3 AbsoluteWorldSpacePosition;
            half4 uv0;
        };

        void SG_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6(UnityTexture2D Texture2D_80A3D28F, float4 Vector4_2EBA7A3B, float Boolean_7ABB9909, Bindings_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6 IN, out float4 XZ_2)
        {
            UnityTexture2D _Property_3e01b4d2fc68d48ba3acbba9d5881e59_Out_0 = Texture2D_80A3D28F;
            float _Property_30834f691775a0898a45b1c868520436_Out_0 = Boolean_7ABB9909;
            float _Split_89ed63cb625cb3878c183d0b71c03400_R_1 = IN.AbsoluteWorldSpacePosition[0];
            float _Split_89ed63cb625cb3878c183d0b71c03400_G_2 = IN.AbsoluteWorldSpacePosition[1];
            float _Split_89ed63cb625cb3878c183d0b71c03400_B_3 = IN.AbsoluteWorldSpacePosition[2];
            float _Split_89ed63cb625cb3878c183d0b71c03400_A_4 = 0;
            float4 _Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4;
            float3 _Combine_cf2d04ff119ad88493f6460431765cbb_RGB_5;
            float2 _Combine_cf2d04ff119ad88493f6460431765cbb_RG_6;
            Unity_Combine_float(_Split_89ed63cb625cb3878c183d0b71c03400_R_1, _Split_89ed63cb625cb3878c183d0b71c03400_B_3, 0, 0, _Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4, _Combine_cf2d04ff119ad88493f6460431765cbb_RGB_5, _Combine_cf2d04ff119ad88493f6460431765cbb_RG_6);
            float4 _Property_8a66888ec47d0687ab1cb2f8abdc9da8_Out_0 = Vector4_2EBA7A3B;
            float _Split_2f0f52f6ef8c0e81af0da6476402bc1f_R_1 = _Property_8a66888ec47d0687ab1cb2f8abdc9da8_Out_0[0];
            float _Split_2f0f52f6ef8c0e81af0da6476402bc1f_G_2 = _Property_8a66888ec47d0687ab1cb2f8abdc9da8_Out_0[1];
            float _Split_2f0f52f6ef8c0e81af0da6476402bc1f_B_3 = _Property_8a66888ec47d0687ab1cb2f8abdc9da8_Out_0[2];
            float _Split_2f0f52f6ef8c0e81af0da6476402bc1f_A_4 = _Property_8a66888ec47d0687ab1cb2f8abdc9da8_Out_0[3];
            float _Divide_e64179199923c58289b6aa94ea6c9178_Out_2;
            Unity_Divide_float(1, _Split_2f0f52f6ef8c0e81af0da6476402bc1f_R_1, _Divide_e64179199923c58289b6aa94ea6c9178_Out_2);
            float4 _Multiply_14cec4902d0a00829e4555071a1b8ad1_Out_2;
            Unity_Multiply_float(_Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4, (_Divide_e64179199923c58289b6aa94ea6c9178_Out_2.xxxx), _Multiply_14cec4902d0a00829e4555071a1b8ad1_Out_2);
            float2 _Vector2_16c15d3bbdd14b85bd48e3a6cb318af7_Out_0 = float2(_Split_2f0f52f6ef8c0e81af0da6476402bc1f_R_1, _Split_2f0f52f6ef8c0e81af0da6476402bc1f_G_2);
            float2 _Vector2_f8d75f54e7705083bbec539a60185577_Out_0 = float2(_Split_2f0f52f6ef8c0e81af0da6476402bc1f_B_3, _Split_2f0f52f6ef8c0e81af0da6476402bc1f_A_4);
            float2 _TilingAndOffset_d91e2d25acd34686b562b7fe7e9d1d27_Out_3;
            Unity_TilingAndOffset_float(IN.uv0.xy, _Vector2_16c15d3bbdd14b85bd48e3a6cb318af7_Out_0, _Vector2_f8d75f54e7705083bbec539a60185577_Out_0, _TilingAndOffset_d91e2d25acd34686b562b7fe7e9d1d27_Out_3);
            float2 _Branch_8e5a4e8f4d52fc8aadd1f46485afc933_Out_3;
            Unity_Branch_float2(_Property_30834f691775a0898a45b1c868520436_Out_0, (_Multiply_14cec4902d0a00829e4555071a1b8ad1_Out_2.xy), _TilingAndOffset_d91e2d25acd34686b562b7fe7e9d1d27_Out_3, _Branch_8e5a4e8f4d52fc8aadd1f46485afc933_Out_3);
            float4 _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0 = SAMPLE_TEXTURE2D(_Property_3e01b4d2fc68d48ba3acbba9d5881e59_Out_0.tex, _Property_3e01b4d2fc68d48ba3acbba9d5881e59_Out_0.samplerstate, _Branch_8e5a4e8f4d52fc8aadd1f46485afc933_Out_3);
            float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_R_4 = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0.r;
            float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_G_5 = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0.g;
            float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_B_6 = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0.b;
            float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_A_7 = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0.a;
            XZ_2 = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0;
        }

        void Unity_Multiply_float(float A, float B, out float Out)
        {
            Out = A * B;
        }

        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
        }

        void Unity_Saturate_float(float In, out float Out)
        {
            Out = saturate(In);
        }

        void Unity_Absolute_float(float In, out float Out)
        {
            Out = abs(In);
        }

        void Unity_SquareRoot_float4(float4 In, out float4 Out)
        {
            Out = sqrt(In);
        }

        void Unity_Sign_float(float In, out float Out)
        {
            Out = sign(In);
        }

        void Unity_Ceiling_float(float In, out float Out)
        {
            Out = ceil(In);
        }

        void Unity_Lerp_float4(float4 A, float4 B, float4 T, out float4 Out)
        {
            Out = lerp(A, B, T);
        }

        struct Bindings_BlendOverlayBaseColor_acdb3dfca72bd6b42bbc35f4613331a2
        {
        };

        void SG_BlendOverlayBaseColor_acdb3dfca72bd6b42bbc35f4613331a2(float4 Color_9AA111D3, float Vector1_FBE622A2, float Vector1_8C15C351, Bindings_BlendOverlayBaseColor_acdb3dfca72bd6b42bbc35f4613331a2 IN, out float3 OutVector4_1)
        {
            float4 _Property_012510d774fb7f8b860f5270dca4500f_Out_0 = Color_9AA111D3;
            float4 _SquareRoot_c2c57d0223a9538aa9240890c3cacb0c_Out_1;
            Unity_SquareRoot_float4(_Property_012510d774fb7f8b860f5270dca4500f_Out_0, _SquareRoot_c2c57d0223a9538aa9240890c3cacb0c_Out_1);
            float _Property_a00e29241d12f983b30177515b367ec9_Out_0 = Vector1_FBE622A2;
            float _Sign_343a45ede7349283a681c6bd9998fd8e_Out_1;
            Unity_Sign_float(_Property_a00e29241d12f983b30177515b367ec9_Out_0, _Sign_343a45ede7349283a681c6bd9998fd8e_Out_1);
            float _Add_681019b8f5d3d68bb482d419c9fc61a9_Out_2;
            Unity_Add_float(_Sign_343a45ede7349283a681c6bd9998fd8e_Out_1, 1, _Add_681019b8f5d3d68bb482d419c9fc61a9_Out_2);
            float _Multiply_e8f4cb722712a880ac0db6c7461427f7_Out_2;
            Unity_Multiply_float(_Add_681019b8f5d3d68bb482d419c9fc61a9_Out_2, 0.5, _Multiply_e8f4cb722712a880ac0db6c7461427f7_Out_2);
            float _Ceiling_95ad15988aa9b98184875fa754feae01_Out_1;
            Unity_Ceiling_float(_Multiply_e8f4cb722712a880ac0db6c7461427f7_Out_2, _Ceiling_95ad15988aa9b98184875fa754feae01_Out_1);
            float _Property_2db1c747a05ee284a8b00076062f91a4_Out_0 = Vector1_8C15C351;
            float _Multiply_9564ecda5193bc8286d9ff771c9226cd_Out_2;
            Unity_Multiply_float(_Property_2db1c747a05ee284a8b00076062f91a4_Out_0, _Property_2db1c747a05ee284a8b00076062f91a4_Out_0, _Multiply_9564ecda5193bc8286d9ff771c9226cd_Out_2);
            float4 _Lerp_b3cdb01fc3c5b988ac9b184943bf7c01_Out_3;
            Unity_Lerp_float4(_SquareRoot_c2c57d0223a9538aa9240890c3cacb0c_Out_1, (_Ceiling_95ad15988aa9b98184875fa754feae01_Out_1.xxxx), (_Multiply_9564ecda5193bc8286d9ff771c9226cd_Out_2.xxxx), _Lerp_b3cdb01fc3c5b988ac9b184943bf7c01_Out_3);
            float4 _Multiply_39d1daff98488f8ea2cd794ad4f20926_Out_2;
            Unity_Multiply_float(_Lerp_b3cdb01fc3c5b988ac9b184943bf7c01_Out_3, _Lerp_b3cdb01fc3c5b988ac9b184943bf7c01_Out_3, _Multiply_39d1daff98488f8ea2cd794ad4f20926_Out_2);
            OutVector4_1 = (_Multiply_39d1daff98488f8ea2cd794ad4f20926_Out_2.xyz);
        }

        void Unity_Clamp_float(float In, float Min, float Max, out float Out)
        {
            Out = clamp(In, Min, Max);
        }

        void Unity_Multiply_float(float2 A, float2 B, out float2 Out)
        {
            Out = A * B;
        }

        void Unity_Add_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A + B;
        }

        void Unity_DotProduct_float2(float2 A, float2 B, out float Out)
        {
            Out = dot(A, B);
        }

        void Unity_OneMinus_float(float In, out float Out)
        {
            Out = 1 - In;
        }

        void Unity_SquareRoot_float(float In, out float Out)
        {
            Out = sqrt(In);
        }

        void Unity_Sign_float3(float3 In, out float3 Out)
        {
            Out = sign(In);
        }

        void Unity_Normalize_float3(float3 In, out float3 Out)
        {
            Out = normalize(In);
        }

        void Unity_Branch_float3(float Predicate, float3 True, float3 False, out float3 Out)
        {
            Out = Predicate ? True : False;
        }

        struct Bindings_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8
        {
            float3 WorldSpaceNormal;
            float3 WorldSpaceTangent;
            float3 WorldSpaceBiTangent;
            float3 AbsoluteWorldSpacePosition;
            half4 uv0;
        };

        void SG_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8(UnityTexture2D Texture2D_80A3D28F, float4 Vector4_82674548, float Boolean_9FF42DF6, Bindings_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8 IN, out float4 XZ_2)
        {
            float _Property_1ef12cf3201a938993fe6a7951b0e754_Out_0 = Boolean_9FF42DF6;
            UnityTexture2D _Property_3e01b4d2fc68d48ba3acbba9d5881e59_Out_0 = Texture2D_80A3D28F;
            float _Split_89ed63cb625cb3878c183d0b71c03400_R_1 = IN.AbsoluteWorldSpacePosition[0];
            float _Split_89ed63cb625cb3878c183d0b71c03400_G_2 = IN.AbsoluteWorldSpacePosition[1];
            float _Split_89ed63cb625cb3878c183d0b71c03400_B_3 = IN.AbsoluteWorldSpacePosition[2];
            float _Split_89ed63cb625cb3878c183d0b71c03400_A_4 = 0;
            float4 _Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4;
            float3 _Combine_cf2d04ff119ad88493f6460431765cbb_RGB_5;
            float2 _Combine_cf2d04ff119ad88493f6460431765cbb_RG_6;
            Unity_Combine_float(_Split_89ed63cb625cb3878c183d0b71c03400_R_1, _Split_89ed63cb625cb3878c183d0b71c03400_B_3, 0, 0, _Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4, _Combine_cf2d04ff119ad88493f6460431765cbb_RGB_5, _Combine_cf2d04ff119ad88493f6460431765cbb_RG_6);
            float4 _Property_3fa1d6f912feb481ba60f2e55e62e746_Out_0 = Vector4_82674548;
            float _Split_a2e12fa5931da084b2949343a539dfd8_R_1 = _Property_3fa1d6f912feb481ba60f2e55e62e746_Out_0[0];
            float _Split_a2e12fa5931da084b2949343a539dfd8_G_2 = _Property_3fa1d6f912feb481ba60f2e55e62e746_Out_0[1];
            float _Split_a2e12fa5931da084b2949343a539dfd8_B_3 = _Property_3fa1d6f912feb481ba60f2e55e62e746_Out_0[2];
            float _Split_a2e12fa5931da084b2949343a539dfd8_A_4 = _Property_3fa1d6f912feb481ba60f2e55e62e746_Out_0[3];
            float _Divide_c36b770dfaa0bb8f85ab27da5fd794f0_Out_2;
            Unity_Divide_float(1, _Split_a2e12fa5931da084b2949343a539dfd8_R_1, _Divide_c36b770dfaa0bb8f85ab27da5fd794f0_Out_2);
            float4 _Multiply_14cec4902d0a00829e4555071a1b8ad1_Out_2;
            Unity_Multiply_float(_Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4, (_Divide_c36b770dfaa0bb8f85ab27da5fd794f0_Out_2.xxxx), _Multiply_14cec4902d0a00829e4555071a1b8ad1_Out_2);
            float2 _Vector2_6845d21872714d889783b0cb707df3e9_Out_0 = float2(_Split_a2e12fa5931da084b2949343a539dfd8_R_1, _Split_a2e12fa5931da084b2949343a539dfd8_G_2);
            float2 _Vector2_e2e2263627c6098e96a5b5d29350ad03_Out_0 = float2(_Split_a2e12fa5931da084b2949343a539dfd8_B_3, _Split_a2e12fa5931da084b2949343a539dfd8_A_4);
            float2 _TilingAndOffset_17582d056c0b8a8dab1017d37497fe59_Out_3;
            Unity_TilingAndOffset_float(IN.uv0.xy, _Vector2_6845d21872714d889783b0cb707df3e9_Out_0, _Vector2_e2e2263627c6098e96a5b5d29350ad03_Out_0, _TilingAndOffset_17582d056c0b8a8dab1017d37497fe59_Out_3);
            float2 _Branch_1e152f3aac57448f8518bf2852c000c3_Out_3;
            Unity_Branch_float2(_Property_1ef12cf3201a938993fe6a7951b0e754_Out_0, (_Multiply_14cec4902d0a00829e4555071a1b8ad1_Out_2.xy), _TilingAndOffset_17582d056c0b8a8dab1017d37497fe59_Out_3, _Branch_1e152f3aac57448f8518bf2852c000c3_Out_3);
            float4 _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0 = SAMPLE_TEXTURE2D(_Property_3e01b4d2fc68d48ba3acbba9d5881e59_Out_0.tex, _Property_3e01b4d2fc68d48ba3acbba9d5881e59_Out_0.samplerstate, _Branch_1e152f3aac57448f8518bf2852c000c3_Out_3);
            _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0.rgb = UnpackNormal(_SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0);
            float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_R_4 = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0.r;
            float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_G_5 = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0.g;
            float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_B_6 = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0.b;
            float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_A_7 = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0.a;
            float2 _Vector2_ad6bd100e273d78fa409a30a77bfa2cc_Out_0 = float2(_SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_R_4, _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_G_5);
            float3 _Sign_3a6ebf59931cf08cb0482e0144ddac24_Out_1;
            Unity_Sign_float3(IN.WorldSpaceNormal, _Sign_3a6ebf59931cf08cb0482e0144ddac24_Out_1);
            float _Split_6299d4ddcc4c74828aea40a46fdb896e_R_1 = _Sign_3a6ebf59931cf08cb0482e0144ddac24_Out_1[0];
            float _Split_6299d4ddcc4c74828aea40a46fdb896e_G_2 = _Sign_3a6ebf59931cf08cb0482e0144ddac24_Out_1[1];
            float _Split_6299d4ddcc4c74828aea40a46fdb896e_B_3 = _Sign_3a6ebf59931cf08cb0482e0144ddac24_Out_1[2];
            float _Split_6299d4ddcc4c74828aea40a46fdb896e_A_4 = 0;
            float2 _Vector2_b76cb1842101e58b9e636d49b075c612_Out_0 = float2(_Split_6299d4ddcc4c74828aea40a46fdb896e_G_2, 1);
            float2 _Multiply_31e8db88ee20c985a9850d1a58f3282b_Out_2;
            Unity_Multiply_float(_Vector2_ad6bd100e273d78fa409a30a77bfa2cc_Out_0, _Vector2_b76cb1842101e58b9e636d49b075c612_Out_0, _Multiply_31e8db88ee20c985a9850d1a58f3282b_Out_2);
            float _Split_5ed44bf2eca0868f81eb18100f49d1fa_R_1 = IN.WorldSpaceNormal[0];
            float _Split_5ed44bf2eca0868f81eb18100f49d1fa_G_2 = IN.WorldSpaceNormal[1];
            float _Split_5ed44bf2eca0868f81eb18100f49d1fa_B_3 = IN.WorldSpaceNormal[2];
            float _Split_5ed44bf2eca0868f81eb18100f49d1fa_A_4 = 0;
            float2 _Vector2_70e5837843f28b8b9d64cada3697bd5a_Out_0 = float2(_Split_5ed44bf2eca0868f81eb18100f49d1fa_R_1, _Split_5ed44bf2eca0868f81eb18100f49d1fa_B_3);
            float2 _Add_1145b2f896593d80aa864a34e6702562_Out_2;
            Unity_Add_float2(_Multiply_31e8db88ee20c985a9850d1a58f3282b_Out_2, _Vector2_70e5837843f28b8b9d64cada3697bd5a_Out_0, _Add_1145b2f896593d80aa864a34e6702562_Out_2);
            float _Split_2bc77ca2d17bd78cb2383770ce50b179_R_1 = _Add_1145b2f896593d80aa864a34e6702562_Out_2[0];
            float _Split_2bc77ca2d17bd78cb2383770ce50b179_G_2 = _Add_1145b2f896593d80aa864a34e6702562_Out_2[1];
            float _Split_2bc77ca2d17bd78cb2383770ce50b179_B_3 = 0;
            float _Split_2bc77ca2d17bd78cb2383770ce50b179_A_4 = 0;
            float _Multiply_ab12aea87465a78eaf7fc66c2598d266_Out_2;
            Unity_Multiply_float(_SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_B_6, _Split_5ed44bf2eca0868f81eb18100f49d1fa_G_2, _Multiply_ab12aea87465a78eaf7fc66c2598d266_Out_2);
            float3 _Vector3_433840b555db308b97e9b14b6a957195_Out_0 = float3(_Split_2bc77ca2d17bd78cb2383770ce50b179_R_1, _Multiply_ab12aea87465a78eaf7fc66c2598d266_Out_2, _Split_2bc77ca2d17bd78cb2383770ce50b179_G_2);
            float3x3 Transform_c7914cc45a011c89b3f53c55afb51673_tangentTransform_World = float3x3(IN.WorldSpaceTangent, IN.WorldSpaceBiTangent, IN.WorldSpaceNormal);
            float3 _Transform_c7914cc45a011c89b3f53c55afb51673_Out_1 = TransformWorldToTangent(_Vector3_433840b555db308b97e9b14b6a957195_Out_0.xyz, Transform_c7914cc45a011c89b3f53c55afb51673_tangentTransform_World);
            float3 _Normalize_09bf8a2bd0a4d38e8b97d5c674f79b44_Out_1;
            Unity_Normalize_float3(_Transform_c7914cc45a011c89b3f53c55afb51673_Out_1, _Normalize_09bf8a2bd0a4d38e8b97d5c674f79b44_Out_1);
            float3 _Branch_9eadf909a90f2f80880f8c56ecc2a91f_Out_3;
            Unity_Branch_float3(_Property_1ef12cf3201a938993fe6a7951b0e754_Out_0, _Normalize_09bf8a2bd0a4d38e8b97d5c674f79b44_Out_1, (_SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0.xyz), _Branch_9eadf909a90f2f80880f8c56ecc2a91f_Out_3);
            XZ_2 = (float4(_Branch_9eadf909a90f2f80880f8c56ecc2a91f_Out_3, 1.0));
        }

        void Unity_NormalStrength_float(float3 In, float Strength, out float3 Out)
        {
            Out = float3(In.rg * Strength, lerp(1, In.b, saturate(Strength)));
        }

        void Unity_NormalBlend_float(float3 A, float3 B, out float3 Out)
        {
            Out = SafeNormalize(float3(A.rg + B.rg, A.b * B.b));
        }

        void Unity_Subtract_float(float A, float B, out float Out)
        {
            Out = A - B;
        }

        void Unity_Power_float(float A, float B, out float Out)
        {
            Out = pow(A, B);
        }

        void Unity_Lerp_float3(float3 A, float3 B, float3 T, out float3 Out)
        {
            Out = lerp(A, B, T);
        }

        void Unity_Remap_float(float In, float2 InMinMax, float2 OutMinMax, out float Out)
        {
            Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
        }

        void Unity_Multiply_float(float3 A, float3 B, out float3 Out)
        {
            Out = A * B;
        }

            // Graph Vertex
            struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };

        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            Bindings_NMObjectVSProIndirect_0cfe1e4f145944241ab304331e53c93b _NMObjectVSProIndirect_adbe93754e069e8e87df45ef6e4b343e;
            float3 _NMObjectVSProIndirect_adbe93754e069e8e87df45ef6e4b343e_ObjectSpacePosition_1;
            SG_NMObjectVSProIndirect_0cfe1e4f145944241ab304331e53c93b(IN.ObjectSpacePosition, _NMObjectVSProIndirect_adbe93754e069e8e87df45ef6e4b343e, _NMObjectVSProIndirect_adbe93754e069e8e87df45ef6e4b343e_ObjectSpacePosition_1);
            #endif
            description.Position = _NMObjectVSProIndirect_adbe93754e069e8e87df45ef6e4b343e_ObjectSpacePosition_1;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }

            // Graph Pixel
            struct SurfaceDescription
        {
            float3 BaseColor;
            float3 Emission;
            float Alpha;
            float AlphaClipThreshold;
        };

        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            UnityTexture2D _Property_e4c53213449c7682b60df6ae54f219f0_Out_0 = UnityBuildTexture2DStructNoScale(_BaseColorMap);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 _Property_115fcc827510f38798b214d835c27637_Out_0 = _BaseTilingOffset;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_d83b8f290862b285bbe2f157190e1315_Out_0 = _BaseUsePlanarUV;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            Bindings_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6 _PlanarNM_6c8b686076db2a8c8b7d6cd91cf435f0;
            _PlanarNM_6c8b686076db2a8c8b7d6cd91cf435f0.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            _PlanarNM_6c8b686076db2a8c8b7d6cd91cf435f0.uv0 = IN.uv0;
            float4 _PlanarNM_6c8b686076db2a8c8b7d6cd91cf435f0_XZ_2;
            SG_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6(_Property_e4c53213449c7682b60df6ae54f219f0_Out_0, _Property_115fcc827510f38798b214d835c27637_Out_0, _Property_d83b8f290862b285bbe2f157190e1315_Out_0, _PlanarNM_6c8b686076db2a8c8b7d6cd91cf435f0, _PlanarNM_6c8b686076db2a8c8b7d6cd91cf435f0_XZ_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 _Property_13c79aaf332e20868551d934a2cb7112_Out_0 = _BaseColor;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 _Multiply_3d0c2fda612cfe87aa84bc17ad099a61_Out_2;
            Unity_Multiply_float(_PlanarNM_6c8b686076db2a8c8b7d6cd91cf435f0_XZ_2, _Property_13c79aaf332e20868551d934a2cb7112_Out_0, _Multiply_3d0c2fda612cfe87aa84bc17ad099a61_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            UnityTexture2D _Property_b561c414493a8f8299227a27e437f045_Out_0 = UnityBuildTexture2DStructNoScale(_DetailMap);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 _Property_70f1cc2b73af738d80b0d405e4bed8c5_Out_0 = _DetailTilingOffset;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Split_cda27505033cfc8eaf60fe914f0949b9_R_1 = _Property_70f1cc2b73af738d80b0d405e4bed8c5_Out_0[0];
            float _Split_cda27505033cfc8eaf60fe914f0949b9_G_2 = _Property_70f1cc2b73af738d80b0d405e4bed8c5_Out_0[1];
            float _Split_cda27505033cfc8eaf60fe914f0949b9_B_3 = _Property_70f1cc2b73af738d80b0d405e4bed8c5_Out_0[2];
            float _Split_cda27505033cfc8eaf60fe914f0949b9_A_4 = _Property_70f1cc2b73af738d80b0d405e4bed8c5_Out_0[3];
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float2 _Vector2_42d7e955009b6f8cb4d913530ff92840_Out_0 = float2(_Split_cda27505033cfc8eaf60fe914f0949b9_R_1, _Split_cda27505033cfc8eaf60fe914f0949b9_G_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float2 _Vector2_5452a0299d10b280aec51f7407d4d2ac_Out_0 = float2(_Split_cda27505033cfc8eaf60fe914f0949b9_B_3, _Split_cda27505033cfc8eaf60fe914f0949b9_A_4);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float2 _TilingAndOffset_e1c5b97bd253ca8f9f3d26f598e6d7fd_Out_3;
            Unity_TilingAndOffset_float(IN.uv0.xy, _Vector2_42d7e955009b6f8cb4d913530ff92840_Out_0, _Vector2_5452a0299d10b280aec51f7407d4d2ac_Out_0, _TilingAndOffset_e1c5b97bd253ca8f9f3d26f598e6d7fd_Out_3);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 _SampleTexture2D_fa4ac40fc922b9869e37c06690c0f530_RGBA_0 = SAMPLE_TEXTURE2D(_Property_b561c414493a8f8299227a27e437f045_Out_0.tex, _Property_b561c414493a8f8299227a27e437f045_Out_0.samplerstate, _TilingAndOffset_e1c5b97bd253ca8f9f3d26f598e6d7fd_Out_3);
            float _SampleTexture2D_fa4ac40fc922b9869e37c06690c0f530_R_4 = _SampleTexture2D_fa4ac40fc922b9869e37c06690c0f530_RGBA_0.r;
            float _SampleTexture2D_fa4ac40fc922b9869e37c06690c0f530_G_5 = _SampleTexture2D_fa4ac40fc922b9869e37c06690c0f530_RGBA_0.g;
            float _SampleTexture2D_fa4ac40fc922b9869e37c06690c0f530_B_6 = _SampleTexture2D_fa4ac40fc922b9869e37c06690c0f530_RGBA_0.b;
            float _SampleTexture2D_fa4ac40fc922b9869e37c06690c0f530_A_7 = _SampleTexture2D_fa4ac40fc922b9869e37c06690c0f530_RGBA_0.a;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Multiply_d0f6aeb5b3f04288b51a5ded8986b5a4_Out_2;
            Unity_Multiply_float(_SampleTexture2D_fa4ac40fc922b9869e37c06690c0f530_R_4, 2, _Multiply_d0f6aeb5b3f04288b51a5ded8986b5a4_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Add_d382719213f8618f88c54f7c3dfbd8c2_Out_2;
            Unity_Add_float(_Multiply_d0f6aeb5b3f04288b51a5ded8986b5a4_Out_2, -1, _Add_d382719213f8618f88c54f7c3dfbd8c2_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_02e7dd176dc59f8a9a62453677916b24_Out_0 = _DetailAlbedoScale;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Multiply_fd406247e3137a8b8777918477740653_Out_2;
            Unity_Multiply_float(_Add_d382719213f8618f88c54f7c3dfbd8c2_Out_2, _Property_02e7dd176dc59f8a9a62453677916b24_Out_0, _Multiply_fd406247e3137a8b8777918477740653_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Saturate_d6f590fb1b9d188e981ebb0ec4d36ba9_Out_1;
            Unity_Saturate_float(_Multiply_fd406247e3137a8b8777918477740653_Out_2, _Saturate_d6f590fb1b9d188e981ebb0ec4d36ba9_Out_1);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Absolute_dc927550b803d18ba3ff372995e6d25c_Out_1;
            Unity_Absolute_float(_Saturate_d6f590fb1b9d188e981ebb0ec4d36ba9_Out_1, _Absolute_dc927550b803d18ba3ff372995e6d25c_Out_1);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            Bindings_BlendOverlayBaseColor_acdb3dfca72bd6b42bbc35f4613331a2 _BlendOverlayBaseColor_f3cd25d5b673648eb831a3f388201f73;
            float3 _BlendOverlayBaseColor_f3cd25d5b673648eb831a3f388201f73_OutVector4_1;
            SG_BlendOverlayBaseColor_acdb3dfca72bd6b42bbc35f4613331a2(_Multiply_3d0c2fda612cfe87aa84bc17ad099a61_Out_2, _Add_d382719213f8618f88c54f7c3dfbd8c2_Out_2, _Absolute_dc927550b803d18ba3ff372995e6d25c_Out_1, _BlendOverlayBaseColor_f3cd25d5b673648eb831a3f388201f73, _BlendOverlayBaseColor_f3cd25d5b673648eb831a3f388201f73_OutVector4_1);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            UnityTexture2D _Property_f4db51ec2412c48cbcf2128b7bd8caf8_Out_0 = UnityBuildTexture2DStructNoScale(_CoverBaseColorMap);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 _Property_e35c79b8cccfbe8ca0a3c33e8d32e319_Out_0 = _CoverTilingOffset;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_e3d8b38b51331e879b1d4012d65f53e6_Out_0 = _CoverUsePlanarUV;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            Bindings_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6 _PlanarNM_c2ec737ef76d6286b8eedb44a2d24e50;
            _PlanarNM_c2ec737ef76d6286b8eedb44a2d24e50.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            _PlanarNM_c2ec737ef76d6286b8eedb44a2d24e50.uv0 = IN.uv0;
            float4 _PlanarNM_c2ec737ef76d6286b8eedb44a2d24e50_XZ_2;
            SG_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6(_Property_f4db51ec2412c48cbcf2128b7bd8caf8_Out_0, _Property_e35c79b8cccfbe8ca0a3c33e8d32e319_Out_0, _Property_e3d8b38b51331e879b1d4012d65f53e6_Out_0, _PlanarNM_c2ec737ef76d6286b8eedb44a2d24e50, _PlanarNM_c2ec737ef76d6286b8eedb44a2d24e50_XZ_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 _Property_7d3af9045f54ef8ba8629ebbbc3f4ad7_Out_0 = _CoverBaseColor;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 _Multiply_2eb83c7af5b6f58eabeec7b502517470_Out_2;
            Unity_Multiply_float(_PlanarNM_c2ec737ef76d6286b8eedb44a2d24e50_XZ_2, _Property_7d3af9045f54ef8ba8629ebbbc3f4ad7_Out_0, _Multiply_2eb83c7af5b6f58eabeec7b502517470_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            UnityTexture2D _Property_356186a26fec8686a13bc6b57fd8f3ee_Out_0 = UnityBuildTexture2DStructNoScale(_CoverMaskA);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 _UV_045cea9e82354980a778f44d92578382_Out_0 = IN.uv0;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 _SampleTexture2D_0eef6ae3dab6e185bd0f65edecd80314_RGBA_0 = SAMPLE_TEXTURE2D(_Property_356186a26fec8686a13bc6b57fd8f3ee_Out_0.tex, _Property_356186a26fec8686a13bc6b57fd8f3ee_Out_0.samplerstate, (_UV_045cea9e82354980a778f44d92578382_Out_0.xy));
            float _SampleTexture2D_0eef6ae3dab6e185bd0f65edecd80314_R_4 = _SampleTexture2D_0eef6ae3dab6e185bd0f65edecd80314_RGBA_0.r;
            float _SampleTexture2D_0eef6ae3dab6e185bd0f65edecd80314_G_5 = _SampleTexture2D_0eef6ae3dab6e185bd0f65edecd80314_RGBA_0.g;
            float _SampleTexture2D_0eef6ae3dab6e185bd0f65edecd80314_B_6 = _SampleTexture2D_0eef6ae3dab6e185bd0f65edecd80314_RGBA_0.b;
            float _SampleTexture2D_0eef6ae3dab6e185bd0f65edecd80314_A_7 = _SampleTexture2D_0eef6ae3dab6e185bd0f65edecd80314_RGBA_0.a;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_4e8240836843df81941cdf6cf2cdd638_Out_0 = _CoverMaskPower;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Multiply_8b5250e5dfc73a84a41399a13b83c0a1_Out_2;
            Unity_Multiply_float(_SampleTexture2D_0eef6ae3dab6e185bd0f65edecd80314_A_7, _Property_4e8240836843df81941cdf6cf2cdd638_Out_0, _Multiply_8b5250e5dfc73a84a41399a13b83c0a1_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Clamp_030a7c32684c258084338456eaddc77a_Out_3;
            Unity_Clamp_float(_Multiply_8b5250e5dfc73a84a41399a13b83c0a1_Out_2, 0, 1, _Clamp_030a7c32684c258084338456eaddc77a_Out_3);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Split_8ba5b67899f36b8f9dcf5c84092c0560_R_1 = IN.VertexColor[0];
            float _Split_8ba5b67899f36b8f9dcf5c84092c0560_G_2 = IN.VertexColor[1];
            float _Split_8ba5b67899f36b8f9dcf5c84092c0560_B_3 = IN.VertexColor[2];
            float _Split_8ba5b67899f36b8f9dcf5c84092c0560_A_4 = IN.VertexColor[3];
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float2 _Vector2_65060e9a9f687a89b68e32dc876be645_Out_0 = float2(_SampleTexture2D_fa4ac40fc922b9869e37c06690c0f530_A_7, _SampleTexture2D_fa4ac40fc922b9869e37c06690c0f530_G_5);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float2 _Multiply_5d4c3baed6515c8b86a289c70fca8f5d_Out_2;
            Unity_Multiply_float(_Vector2_65060e9a9f687a89b68e32dc876be645_Out_0, float2(2, 2), _Multiply_5d4c3baed6515c8b86a289c70fca8f5d_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float2 _Add_98b310e19c5fa5899c39cc45969c15ea_Out_2;
            Unity_Add_float2(_Multiply_5d4c3baed6515c8b86a289c70fca8f5d_Out_2, float2(-1, -1), _Add_98b310e19c5fa5899c39cc45969c15ea_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_08b99582093b36869beb5ea3d18e765d_Out_0 = _DetailNormalScale;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float2 _Multiply_bf0b80fdb3271784900e5b5ea4c5550f_Out_2;
            Unity_Multiply_float(_Add_98b310e19c5fa5899c39cc45969c15ea_Out_2, (_Property_08b99582093b36869beb5ea3d18e765d_Out_0.xx), _Multiply_bf0b80fdb3271784900e5b5ea4c5550f_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Split_26c1e73f8436c78ebdae5b51365a072b_R_1 = _Multiply_bf0b80fdb3271784900e5b5ea4c5550f_Out_2[0];
            float _Split_26c1e73f8436c78ebdae5b51365a072b_G_2 = _Multiply_bf0b80fdb3271784900e5b5ea4c5550f_Out_2[1];
            float _Split_26c1e73f8436c78ebdae5b51365a072b_B_3 = 0;
            float _Split_26c1e73f8436c78ebdae5b51365a072b_A_4 = 0;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _DotProduct_50aca3ce0da1ad849d7ff4a99df3a322_Out_2;
            Unity_DotProduct_float2(_Multiply_bf0b80fdb3271784900e5b5ea4c5550f_Out_2, _Multiply_bf0b80fdb3271784900e5b5ea4c5550f_Out_2, _DotProduct_50aca3ce0da1ad849d7ff4a99df3a322_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Saturate_491f2ee8417b8782aee83358b89eeb08_Out_1;
            Unity_Saturate_float(_DotProduct_50aca3ce0da1ad849d7ff4a99df3a322_Out_2, _Saturate_491f2ee8417b8782aee83358b89eeb08_Out_1);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _OneMinus_46ad3170d736808d98bf74ffa45e0414_Out_1;
            Unity_OneMinus_float(_Saturate_491f2ee8417b8782aee83358b89eeb08_Out_1, _OneMinus_46ad3170d736808d98bf74ffa45e0414_Out_1);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _SquareRoot_dfeae899ebfeae8f9257c340ca22ce38_Out_1;
            Unity_SquareRoot_float(_OneMinus_46ad3170d736808d98bf74ffa45e0414_Out_1, _SquareRoot_dfeae899ebfeae8f9257c340ca22ce38_Out_1);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 _Vector3_ed3f80ed87524e8c99f98b224af5a610_Out_0 = float3(_Split_26c1e73f8436c78ebdae5b51365a072b_R_1, _Split_26c1e73f8436c78ebdae5b51365a072b_G_2, _SquareRoot_dfeae899ebfeae8f9257c340ca22ce38_Out_1);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            UnityTexture2D _Property_2cc39234d3d334899f94126a216a50fc_Out_0 = UnityBuildTexture2DStructNoScale(_BaseNormalMap);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            Bindings_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8 _PlanarNMn_4fde70f39e45398dbb9972941e88e2bf;
            _PlanarNMn_4fde70f39e45398dbb9972941e88e2bf.WorldSpaceNormal = IN.WorldSpaceNormal;
            _PlanarNMn_4fde70f39e45398dbb9972941e88e2bf.WorldSpaceTangent = IN.WorldSpaceTangent;
            _PlanarNMn_4fde70f39e45398dbb9972941e88e2bf.WorldSpaceBiTangent = IN.WorldSpaceBiTangent;
            _PlanarNMn_4fde70f39e45398dbb9972941e88e2bf.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            _PlanarNMn_4fde70f39e45398dbb9972941e88e2bf.uv0 = IN.uv0;
            float4 _PlanarNMn_4fde70f39e45398dbb9972941e88e2bf_XZ_2;
            SG_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8(_Property_2cc39234d3d334899f94126a216a50fc_Out_0, _Property_115fcc827510f38798b214d835c27637_Out_0, _Property_d83b8f290862b285bbe2f157190e1315_Out_0, _PlanarNMn_4fde70f39e45398dbb9972941e88e2bf, _PlanarNMn_4fde70f39e45398dbb9972941e88e2bf_XZ_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_020d569f63e9a2849e23988ff74eb005_Out_0 = _BaseNormalScale;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 _NormalStrength_0c71fb166ae841839a0a12ecc5afa6fe_Out_2;
            Unity_NormalStrength_float((_PlanarNMn_4fde70f39e45398dbb9972941e88e2bf_XZ_2.xyz), _Property_020d569f63e9a2849e23988ff74eb005_Out_0, _NormalStrength_0c71fb166ae841839a0a12ecc5afa6fe_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 _NormalBlend_be36dd49bea74c8f8dd52fa3a85a9534_Out_2;
            Unity_NormalBlend_float(_Vector3_ed3f80ed87524e8c99f98b224af5a610_Out_0, _NormalStrength_0c71fb166ae841839a0a12ecc5afa6fe_Out_2, _NormalBlend_be36dd49bea74c8f8dd52fa3a85a9534_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            UnityTexture2D _Property_a383045772822c87acd099bb4cd6c478_Out_0 = UnityBuildTexture2DStructNoScale(_CoverNormalMap);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            Bindings_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8 _PlanarNMn_79abde32a0223a89907c9f09efac8db7;
            _PlanarNMn_79abde32a0223a89907c9f09efac8db7.WorldSpaceNormal = IN.WorldSpaceNormal;
            _PlanarNMn_79abde32a0223a89907c9f09efac8db7.WorldSpaceTangent = IN.WorldSpaceTangent;
            _PlanarNMn_79abde32a0223a89907c9f09efac8db7.WorldSpaceBiTangent = IN.WorldSpaceBiTangent;
            _PlanarNMn_79abde32a0223a89907c9f09efac8db7.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            _PlanarNMn_79abde32a0223a89907c9f09efac8db7.uv0 = IN.uv0;
            float4 _PlanarNMn_79abde32a0223a89907c9f09efac8db7_XZ_2;
            SG_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8(_Property_a383045772822c87acd099bb4cd6c478_Out_0, _Property_e35c79b8cccfbe8ca0a3c33e8d32e319_Out_0, _Property_e3d8b38b51331e879b1d4012d65f53e6_Out_0, _PlanarNMn_79abde32a0223a89907c9f09efac8db7, _PlanarNMn_79abde32a0223a89907c9f09efac8db7_XZ_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_c688e246111fd881820a97415e14d8a3_Out_0 = _CoverNormalBlendHardness;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 _NormalStrength_0e5e0831ba0e98878220ca6021ea52a2_Out_2;
            Unity_NormalStrength_float((_PlanarNMn_79abde32a0223a89907c9f09efac8db7_XZ_2.xyz), _Property_c688e246111fd881820a97415e14d8a3_Out_0, _NormalStrength_0e5e0831ba0e98878220ca6021ea52a2_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Split_8cadce726725318fbacd47f436a8231d_R_1 = IN.WorldSpaceNormal[0];
            float _Split_8cadce726725318fbacd47f436a8231d_G_2 = IN.WorldSpaceNormal[1];
            float _Split_8cadce726725318fbacd47f436a8231d_B_3 = IN.WorldSpaceNormal[2];
            float _Split_8cadce726725318fbacd47f436a8231d_A_4 = 0;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_ce4e5954a0b7ff8c819fa53963327595_Out_0 = _Cover_Amount;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_384059e6344fb98a85eccad78dd82f36_Out_0 = _Cover_Amount_Grow_Speed;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Subtract_70fd06876db7fa85b0cc0bce8d926dff_Out_2;
            Unity_Subtract_float(4, _Property_384059e6344fb98a85eccad78dd82f36_Out_0, _Subtract_70fd06876db7fa85b0cc0bce8d926dff_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Divide_1a3a6334c3d8bc8f8ac262c7833e15d5_Out_2;
            Unity_Divide_float(_Property_ce4e5954a0b7ff8c819fa53963327595_Out_0, _Subtract_70fd06876db7fa85b0cc0bce8d926dff_Out_2, _Divide_1a3a6334c3d8bc8f8ac262c7833e15d5_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Absolute_f218d2b85ebf288f91234faffedb5f7b_Out_1;
            Unity_Absolute_float(_Divide_1a3a6334c3d8bc8f8ac262c7833e15d5_Out_2, _Absolute_f218d2b85ebf288f91234faffedb5f7b_Out_1);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Power_a9b8d4b65c44a98e9813f61c0e2dc0a3_Out_2;
            Unity_Power_float(_Absolute_f218d2b85ebf288f91234faffedb5f7b_Out_1, _Subtract_70fd06876db7fa85b0cc0bce8d926dff_Out_2, _Power_a9b8d4b65c44a98e9813f61c0e2dc0a3_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Clamp_95d579f83746cb82be79cf6739990e0b_Out_3;
            Unity_Clamp_float(_Power_a9b8d4b65c44a98e9813f61c0e2dc0a3_Out_2, 0, 2, _Clamp_95d579f83746cb82be79cf6739990e0b_Out_3);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Multiply_02a8aa0fa6974e81aa84caba54f63896_Out_2;
            Unity_Multiply_float(_Split_8cadce726725318fbacd47f436a8231d_G_2, _Clamp_95d579f83746cb82be79cf6739990e0b_Out_3, _Multiply_02a8aa0fa6974e81aa84caba54f63896_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Saturate_ada5e8f9ebdcb38d8f5e61e8d97424b9_Out_1;
            Unity_Saturate_float(_Multiply_02a8aa0fa6974e81aa84caba54f63896_Out_2, _Saturate_ada5e8f9ebdcb38d8f5e61e8d97424b9_Out_1);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Clamp_38bac9e8ef351789b5fd4f2201f1df7b_Out_3;
            Unity_Clamp_float(_Split_8cadce726725318fbacd47f436a8231d_G_2, 0, 0.9999, _Clamp_38bac9e8ef351789b5fd4f2201f1df7b_Out_3);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_9babc76177853482826cae0163ffe988_Out_0 = _Cover_Max_Angle;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Divide_3b22550205905d8da5870f9db56e44ff_Out_2;
            Unity_Divide_float(_Property_9babc76177853482826cae0163ffe988_Out_0, 45, _Divide_3b22550205905d8da5870f9db56e44ff_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _OneMinus_99a85b6952a41288afc86da0a6ca6ea0_Out_1;
            Unity_OneMinus_float(_Divide_3b22550205905d8da5870f9db56e44ff_Out_2, _OneMinus_99a85b6952a41288afc86da0a6ca6ea0_Out_1);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Subtract_2b63f3aaee26f686971dca1d28da283c_Out_2;
            Unity_Subtract_float(_Clamp_38bac9e8ef351789b5fd4f2201f1df7b_Out_3, _OneMinus_99a85b6952a41288afc86da0a6ca6ea0_Out_1, _Subtract_2b63f3aaee26f686971dca1d28da283c_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Clamp_6bd9bb4add91fe8eb80a958a6b1a2d01_Out_3;
            Unity_Clamp_float(_Subtract_2b63f3aaee26f686971dca1d28da283c_Out_2, 0, 2, _Clamp_6bd9bb4add91fe8eb80a958a6b1a2d01_Out_3);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Divide_a09d2d461b07e98999aba746fb52a3fc_Out_2;
            Unity_Divide_float(1, _Divide_3b22550205905d8da5870f9db56e44ff_Out_2, _Divide_a09d2d461b07e98999aba746fb52a3fc_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Multiply_89a8f5a279c73b898d4ca5d075786b53_Out_2;
            Unity_Multiply_float(_Clamp_6bd9bb4add91fe8eb80a958a6b1a2d01_Out_3, _Divide_a09d2d461b07e98999aba746fb52a3fc_Out_2, _Multiply_89a8f5a279c73b898d4ca5d075786b53_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Absolute_f98ce5feb185a68784b9b35eb71ec465_Out_1;
            Unity_Absolute_float(_Multiply_89a8f5a279c73b898d4ca5d075786b53_Out_2, _Absolute_f98ce5feb185a68784b9b35eb71ec465_Out_1);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_27e768ffa9c13e8ab65d48e7712e5b66_Out_0 = _CoverHardness;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Power_b9fdc3921d5b85878a1ec4baa1975184_Out_2;
            Unity_Power_float(_Absolute_f98ce5feb185a68784b9b35eb71ec465_Out_1, _Property_27e768ffa9c13e8ab65d48e7712e5b66_Out_0, _Power_b9fdc3921d5b85878a1ec4baa1975184_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_c442c20fdade808b8e1b93cfd6625ab9_Out_0 = _Cover_Min_Height;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _OneMinus_55530ddc82048c8aa2d082334edf6a57_Out_1;
            Unity_OneMinus_float(_Property_c442c20fdade808b8e1b93cfd6625ab9_Out_0, _OneMinus_55530ddc82048c8aa2d082334edf6a57_Out_1);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Split_7e5d084c5e6bfa83a9203dac971ea31e_R_1 = IN.AbsoluteWorldSpacePosition[0];
            float _Split_7e5d084c5e6bfa83a9203dac971ea31e_G_2 = IN.AbsoluteWorldSpacePosition[1];
            float _Split_7e5d084c5e6bfa83a9203dac971ea31e_B_3 = IN.AbsoluteWorldSpacePosition[2];
            float _Split_7e5d084c5e6bfa83a9203dac971ea31e_A_4 = 0;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Add_e4067b215657d98ab6ec4e0295ddfece_Out_2;
            Unity_Add_float(_OneMinus_55530ddc82048c8aa2d082334edf6a57_Out_1, _Split_7e5d084c5e6bfa83a9203dac971ea31e_G_2, _Add_e4067b215657d98ab6ec4e0295ddfece_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Add_a4387dfc1ea3ee8da0b04f433a7c63d0_Out_2;
            Unity_Add_float(_Add_e4067b215657d98ab6ec4e0295ddfece_Out_2, 1, _Add_a4387dfc1ea3ee8da0b04f433a7c63d0_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Clamp_570e1129ecb02c8b8be79d85f19d5ae1_Out_3;
            Unity_Clamp_float(_Add_a4387dfc1ea3ee8da0b04f433a7c63d0_Out_2, 0, 1, _Clamp_570e1129ecb02c8b8be79d85f19d5ae1_Out_3);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_5da709b259ac268bb134d927bcffa4b8_Out_0 = _Cover_Min_Height_Blending;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Add_c322347d9ddbcd83ba52983e9316c387_Out_2;
            Unity_Add_float(_Add_e4067b215657d98ab6ec4e0295ddfece_Out_2, _Property_5da709b259ac268bb134d927bcffa4b8_Out_0, _Add_c322347d9ddbcd83ba52983e9316c387_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Divide_078ffa7d6c597f819511c95d33b7d90e_Out_2;
            Unity_Divide_float(_Add_c322347d9ddbcd83ba52983e9316c387_Out_2, _Add_e4067b215657d98ab6ec4e0295ddfece_Out_2, _Divide_078ffa7d6c597f819511c95d33b7d90e_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _OneMinus_b9f8edced35e7b8cab9ca581d822e31f_Out_1;
            Unity_OneMinus_float(_Divide_078ffa7d6c597f819511c95d33b7d90e_Out_2, _OneMinus_b9f8edced35e7b8cab9ca581d822e31f_Out_1);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Add_95cd1778448bfe8d9f9fa9129235f2c2_Out_2;
            Unity_Add_float(_OneMinus_b9f8edced35e7b8cab9ca581d822e31f_Out_1, -0.5, _Add_95cd1778448bfe8d9f9fa9129235f2c2_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Clamp_23e760e01b7e0780a71d88813b5828d7_Out_3;
            Unity_Clamp_float(_Add_95cd1778448bfe8d9f9fa9129235f2c2_Out_2, 0, 1, _Clamp_23e760e01b7e0780a71d88813b5828d7_Out_3);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Add_674fcef023d728848510150af810a103_Out_2;
            Unity_Add_float(_Clamp_570e1129ecb02c8b8be79d85f19d5ae1_Out_3, _Clamp_23e760e01b7e0780a71d88813b5828d7_Out_3, _Add_674fcef023d728848510150af810a103_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Clamp_5b677be9d499c082bcbe316853b0adff_Out_3;
            Unity_Clamp_float(_Add_674fcef023d728848510150af810a103_Out_2, 0, 1, _Clamp_5b677be9d499c082bcbe316853b0adff_Out_3);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Multiply_7ea7400ed65a3582b000796fb39748e9_Out_2;
            Unity_Multiply_float(_Power_b9fdc3921d5b85878a1ec4baa1975184_Out_2, _Clamp_5b677be9d499c082bcbe316853b0adff_Out_3, _Multiply_7ea7400ed65a3582b000796fb39748e9_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Multiply_4d295791f4e23186acea64f2f4de94ea_Out_2;
            Unity_Multiply_float(_Saturate_ada5e8f9ebdcb38d8f5e61e8d97424b9_Out_1, _Multiply_7ea7400ed65a3582b000796fb39748e9_Out_2, _Multiply_4d295791f4e23186acea64f2f4de94ea_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 _Lerp_21eaf65c617b2d858b3b33154d55757a_Out_3;
            Unity_Lerp_float3(_NormalBlend_be36dd49bea74c8f8dd52fa3a85a9534_Out_2, _NormalStrength_0e5e0831ba0e98878220ca6021ea52a2_Out_2, (_Multiply_4d295791f4e23186acea64f2f4de94ea_Out_2.xxx), _Lerp_21eaf65c617b2d858b3b33154d55757a_Out_3);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3x3 Transform_1e4c3a2d6240958ab6858efb88c1d06a_transposeTangent = transpose(float3x3(IN.WorldSpaceTangent, IN.WorldSpaceBiTangent, IN.WorldSpaceNormal));
            float3 _Transform_1e4c3a2d6240958ab6858efb88c1d06a_Out_1 = normalize(mul(Transform_1e4c3a2d6240958ab6858efb88c1d06a_transposeTangent, _Lerp_21eaf65c617b2d858b3b33154d55757a_Out_3.xyz).xyz);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Split_600a9d271d96798a94ab28118977defd_R_1 = _Transform_1e4c3a2d6240958ab6858efb88c1d06a_Out_1[0];
            float _Split_600a9d271d96798a94ab28118977defd_G_2 = _Transform_1e4c3a2d6240958ab6858efb88c1d06a_Out_1[1];
            float _Split_600a9d271d96798a94ab28118977defd_B_3 = _Transform_1e4c3a2d6240958ab6858efb88c1d06a_Out_1[2];
            float _Split_600a9d271d96798a94ab28118977defd_A_4 = 0;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Multiply_2e5b010626435f8492a2690396ced19d_Out_2;
            Unity_Multiply_float(_Split_600a9d271d96798a94ab28118977defd_G_2, _Clamp_95d579f83746cb82be79cf6739990e0b_Out_3, _Multiply_2e5b010626435f8492a2690396ced19d_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Multiply_5a2397e0153ddb8f9bd457d9a301dc8b_Out_2;
            Unity_Multiply_float(_Clamp_95d579f83746cb82be79cf6739990e0b_Out_3, _Property_27e768ffa9c13e8ab65d48e7712e5b66_Out_0, _Multiply_5a2397e0153ddb8f9bd457d9a301dc8b_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Multiply_3aad76eaff60dd888c3e1783ecf03943_Out_2;
            Unity_Multiply_float(_Multiply_5a2397e0153ddb8f9bd457d9a301dc8b_Out_2, _Multiply_7ea7400ed65a3582b000796fb39748e9_Out_2, _Multiply_3aad76eaff60dd888c3e1783ecf03943_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Multiply_05614e740451f18f8301586390aa5a0a_Out_2;
            Unity_Multiply_float(_Multiply_2e5b010626435f8492a2690396ced19d_Out_2, _Multiply_3aad76eaff60dd888c3e1783ecf03943_Out_2, _Multiply_05614e740451f18f8301586390aa5a0a_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            UnityTexture2D _Property_a14f2476a35d208b988233c852f919ef_Out_0 = UnityBuildTexture2DStructNoScale(_CoverMaskMap);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            Bindings_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6 _PlanarNM_6858a0e821f26a8d87846d325e9bd170;
            _PlanarNM_6858a0e821f26a8d87846d325e9bd170.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            _PlanarNM_6858a0e821f26a8d87846d325e9bd170.uv0 = IN.uv0;
            float4 _PlanarNM_6858a0e821f26a8d87846d325e9bd170_XZ_2;
            SG_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6(_Property_a14f2476a35d208b988233c852f919ef_Out_0, _Property_e35c79b8cccfbe8ca0a3c33e8d32e319_Out_0, _Property_e3d8b38b51331e879b1d4012d65f53e6_Out_0, _PlanarNM_6858a0e821f26a8d87846d325e9bd170, _PlanarNM_6858a0e821f26a8d87846d325e9bd170_XZ_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Split_16313c20ccdeaa86a639068877a69a2f_R_1 = _PlanarNM_6858a0e821f26a8d87846d325e9bd170_XZ_2[0];
            float _Split_16313c20ccdeaa86a639068877a69a2f_G_2 = _PlanarNM_6858a0e821f26a8d87846d325e9bd170_XZ_2[1];
            float _Split_16313c20ccdeaa86a639068877a69a2f_B_3 = _PlanarNM_6858a0e821f26a8d87846d325e9bd170_XZ_2[2];
            float _Split_16313c20ccdeaa86a639068877a69a2f_A_4 = _PlanarNM_6858a0e821f26a8d87846d325e9bd170_XZ_2[3];
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_673896519f419589938b37e782b90141_Out_0 = _CoverHeightMapMin;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_c35906332422438da3b19f45cbd5ac17_Out_0 = _CoverHeightMapMax;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float2 _Vector2_81cbe1e5ea789e8697223cd3bfbca76c_Out_0 = float2(_Property_673896519f419589938b37e782b90141_Out_0, _Property_c35906332422438da3b19f45cbd5ac17_Out_0);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_88ab0068f899fc8ba94efdaec5e8966b_Out_0 = _CoverHeightMapOffset;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float2 _Add_cd623e3135271489b0d45b4d7edc5f7e_Out_2;
            Unity_Add_float2(_Vector2_81cbe1e5ea789e8697223cd3bfbca76c_Out_0, (_Property_88ab0068f899fc8ba94efdaec5e8966b_Out_0.xx), _Add_cd623e3135271489b0d45b4d7edc5f7e_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Remap_9a23d5f76fa8c38dbd73f43bd6397b0b_Out_3;
            Unity_Remap_float(_Split_16313c20ccdeaa86a639068877a69a2f_B_3, float2 (0, 1), _Add_cd623e3135271489b0d45b4d7edc5f7e_Out_2, _Remap_9a23d5f76fa8c38dbd73f43bd6397b0b_Out_3);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Multiply_0093be0fd848498b89a0fa282608e715_Out_2;
            Unity_Multiply_float(_Multiply_05614e740451f18f8301586390aa5a0a_Out_2, _Remap_9a23d5f76fa8c38dbd73f43bd6397b0b_Out_3, _Multiply_0093be0fd848498b89a0fa282608e715_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Multiply_d3190f97afd0398083623ecf71a41b1a_Out_2;
            Unity_Multiply_float(_Split_8ba5b67899f36b8f9dcf5c84092c0560_G_2, _Multiply_0093be0fd848498b89a0fa282608e715_Out_2, _Multiply_d3190f97afd0398083623ecf71a41b1a_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Saturate_cbcee34e7e6e6d8091d840550ab1c74a_Out_1;
            Unity_Saturate_float(_Multiply_d3190f97afd0398083623ecf71a41b1a_Out_2, _Saturate_cbcee34e7e6e6d8091d840550ab1c74a_Out_1);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Multiply_da35b9d9e4dd8c81871a9aea42c157ee_Out_2;
            Unity_Multiply_float(_Clamp_030a7c32684c258084338456eaddc77a_Out_3, _Saturate_cbcee34e7e6e6d8091d840550ab1c74a_Out_1, _Multiply_da35b9d9e4dd8c81871a9aea42c157ee_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Clamp_c95f5515948375878df6581a36d8b203_Out_3;
            Unity_Clamp_float(_Multiply_da35b9d9e4dd8c81871a9aea42c157ee_Out_2, 0, 1, _Clamp_c95f5515948375878df6581a36d8b203_Out_3);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            #if defined(_USEDYNAMICCOVERTSTATICMASKF_ON)
            float _UseDynamicCoverTStaticMaskF_0694902516172b8fa469c5d8b8e938c6_Out_0 = _Clamp_c95f5515948375878df6581a36d8b203_Out_3;
            #else
            float _UseDynamicCoverTStaticMaskF_0694902516172b8fa469c5d8b8e938c6_Out_0 = _Clamp_030a7c32684c258084338456eaddc77a_Out_3;
            #endif
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 _Lerp_87882219e20a6d818c0de017d739125f_Out_3;
            Unity_Lerp_float3(_BlendOverlayBaseColor_f3cd25d5b673648eb831a3f388201f73_OutVector4_1, (_Multiply_2eb83c7af5b6f58eabeec7b502517470_Out_2.xyz), (_UseDynamicCoverTStaticMaskF_0694902516172b8fa469c5d8b8e938c6_Out_0.xxx), _Lerp_87882219e20a6d818c0de017d739125f_Out_3);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 _Property_4c7bd3690d9d8a838e2524f5908e09ee_Out_0 = _WetColor;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 _Multiply_77c751a5503e948d8952b403163b4eeb_Out_2;
            Unity_Multiply_float((_Property_4c7bd3690d9d8a838e2524f5908e09ee_Out_0.xyz), _Lerp_87882219e20a6d818c0de017d739125f_Out_3, _Multiply_77c751a5503e948d8952b403163b4eeb_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _OneMinus_9b165e3f6c2fdd88a5f3a51230f8dd33_Out_1;
            Unity_OneMinus_float(_Split_8ba5b67899f36b8f9dcf5c84092c0560_R_1, _OneMinus_9b165e3f6c2fdd88a5f3a51230f8dd33_Out_1);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 _Lerp_538fa3f69b550a8bbe8ee20906ecc752_Out_3;
            Unity_Lerp_float3(_Lerp_87882219e20a6d818c0de017d739125f_Out_3, _Multiply_77c751a5503e948d8952b403163b4eeb_Out_2, (_OneMinus_9b165e3f6c2fdd88a5f3a51230f8dd33_Out_1.xxx), _Lerp_538fa3f69b550a8bbe8ee20906ecc752_Out_3);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Split_31874fa1d55cb28e99a1333cf254676a_R_1 = _PlanarNM_6c8b686076db2a8c8b7d6cd91cf435f0_XZ_2[0];
            float _Split_31874fa1d55cb28e99a1333cf254676a_G_2 = _PlanarNM_6c8b686076db2a8c8b7d6cd91cf435f0_XZ_2[1];
            float _Split_31874fa1d55cb28e99a1333cf254676a_B_3 = _PlanarNM_6c8b686076db2a8c8b7d6cd91cf435f0_XZ_2[2];
            float _Split_31874fa1d55cb28e99a1333cf254676a_A_4 = _PlanarNM_6c8b686076db2a8c8b7d6cd91cf435f0_XZ_2[3];
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_881c341218ea2d81819695b0c7ddc4cb_Out_0 = _AlphaCutoff;
            #endif
            surface.BaseColor = _Lerp_538fa3f69b550a8bbe8ee20906ecc752_Out_3;
            surface.Emission = float3(0, 0, 0);
            surface.Alpha = _Split_31874fa1d55cb28e99a1333cf254676a_A_4;
            surface.AlphaClipThreshold = _Property_881c341218ea2d81819695b0c7ddc4cb_Out_0;
            return surface;
        }

            // --------------------------------------------------
            // Build Graph Inputs

            VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.ObjectSpaceNormal =           input.normalOS;
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.ObjectSpaceTangent =          input.tangentOS.xyz;
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.ObjectSpacePosition =         input.positionOS;
        #endif


            return output;
        }
            SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        // must use interpolated tangent, bitangent and normal before they are normalized in the pixel shader.
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        float3 unnormalizedNormalWS = input.normalWS;
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        const float renormFactor = 1.0 / length(unnormalizedNormalWS);
        #endif


        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        // use bitangent on the fly like in hdrp
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        // IMPORTANT! If we ever support Flip on double sided materials ensure bitangent and tangent are NOT flipped.
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        float crossSign = (input.tangentWS.w > 0.0 ? 1.0 : -1.0) * GetOddNegativeScale();
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        float3 bitang = crossSign * cross(input.normalWS.xyz, input.tangentWS.xyz);
        #endif


        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.WorldSpaceNormal =            renormFactor*input.normalWS.xyz;      // we want a unit length Normal Vector node in shader graph
        #endif


        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        // to preserve mikktspace compliance we use same scale renormFactor as was used on the normal.
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        // This is explained in section 2.2 in "surface gradient based bump mapping framework"
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.WorldSpaceTangent =           renormFactor*input.tangentWS.xyz;
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.WorldSpaceBiTangent =         renormFactor*bitang;
        #endif


        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.AbsoluteWorldSpacePosition =  GetAbsolutePositionWS(input.positionWS);
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.uv0 =                         input.texCoord0;
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.VertexColor =                 input.color;
        #endif

        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN

            return output;
        }

            // --------------------------------------------------
            // Main

            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/LightingMetaPass.hlsl"

            ENDHLSL
        }
        Pass
        {
            // Name: <None>
            Tags
            {
                "LightMode" = "Universal2D"
            }

            // Render State
            Cull Back
        Blend One Zero
        ZTest LEqual
        ZWrite On

            // Debug
            // <None>

            // --------------------------------------------------
            // Pass

            HLSLPROGRAM

            // Pragmas
            #pragma target 2.0
        #pragma only_renderers gles gles3 glcore
        #pragma multi_compile_instancing
        #pragma vertex vert
        #pragma fragment frag

            // DotsInstancingOptions: <None>
            // HybridV1InjectedBuiltinProperties: <None>

            // Keywords
            // PassKeywords: <None>
            #pragma shader_feature_local _ _USEDYNAMICCOVERTSTATICMASKF_ON

        #if defined(_USEDYNAMICCOVERTSTATICMASKF_ON)
            #define KEYWORD_PERMUTATION_0
        #else
            #define KEYWORD_PERMUTATION_1
        #endif


            // Defines
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define _AlphaClip 1
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define _NORMALMAP 1
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define _NORMAL_DROPOFF_TS 1
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define ATTRIBUTES_NEED_NORMAL
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define ATTRIBUTES_NEED_TANGENT
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define ATTRIBUTES_NEED_TEXCOORD0
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define ATTRIBUTES_NEED_COLOR
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define VARYINGS_NEED_POSITION_WS
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define VARYINGS_NEED_NORMAL_WS
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define VARYINGS_NEED_TANGENT_WS
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define VARYINGS_NEED_TEXCOORD0
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define VARYINGS_NEED_COLOR
        #endif

            #define FEATURES_GRAPH_VERTEX
            /* WARNING: $splice Could not find named fragment 'PassInstancing' */
            #define SHADERPASS SHADERPASS_2D
            /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */

            // Includes
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"

            // --------------------------------------------------
            // Structs and Packing

            struct Attributes
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 positionOS : POSITION;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 normalOS : NORMAL;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 tangentOS : TANGENT;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 uv0 : TEXCOORD0;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 color : COLOR;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            uint instanceID : INSTANCEID_SEMANTIC;
            #endif
            #endif
        };
        struct Varyings
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 positionCS : SV_POSITION;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 positionWS;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 normalWS;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 tangentWS;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 texCoord0;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 color;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
            #endif
        };
        struct SurfaceDescriptionInputs
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 WorldSpaceNormal;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 WorldSpaceTangent;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 WorldSpaceBiTangent;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 AbsoluteWorldSpacePosition;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 uv0;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 VertexColor;
            #endif
        };
        struct VertexDescriptionInputs
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 ObjectSpaceNormal;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 ObjectSpaceTangent;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 ObjectSpacePosition;
            #endif
        };
        struct PackedVaryings
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 positionCS : SV_POSITION;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 interp0 : TEXCOORD0;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 interp1 : TEXCOORD1;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 interp2 : TEXCOORD2;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 interp3 : TEXCOORD3;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 interp4 : TEXCOORD4;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
            #endif
        };

            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            output.positionCS = input.positionCS;
            output.interp0.xyz =  input.positionWS;
            output.interp1.xyz =  input.normalWS;
            output.interp2.xyzw =  input.tangentWS;
            output.interp3.xyzw =  input.texCoord0;
            output.interp4.xyzw =  input.color;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.positionWS = input.interp0.xyz;
            output.normalWS = input.interp1.xyz;
            output.tangentWS = input.interp2.xyzw;
            output.texCoord0 = input.interp3.xyzw;
            output.color = input.interp4.xyzw;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        #endif

            // --------------------------------------------------
            // Graph

            // Graph Properties
            CBUFFER_START(UnityPerMaterial)
        float _AlphaCutoff;
        float4 _BaseColor;
        float4 _BaseColorMap_TexelSize;
        float _BaseUsePlanarUV;
        float4 _BaseTilingOffset;
        float4 _BaseNormalMap_TexelSize;
        float _BaseNormalScale;
        float4 _BaseMaskMap_TexelSize;
        float _BaseMetallic;
        float _BaseAORemapMin;
        float _BaseAORemapMax;
        float _BaseSmoothnessRemapMin;
        float _BaseSmoothnessRemapMax;
        float4 _CoverMaskA_TexelSize;
        float _CoverMaskPower;
        float _Cover_Amount;
        float _Cover_Amount_Grow_Speed;
        float _Cover_Max_Angle;
        float _Cover_Min_Height;
        float _Cover_Min_Height_Blending;
        float4 _CoverBaseColor;
        float4 _CoverBaseColorMap_TexelSize;
        float _CoverUsePlanarUV;
        float4 _CoverTilingOffset;
        float4 _CoverNormalMap_TexelSize;
        float _CoverNormalScale;
        float _CoverNormalBlendHardness;
        float _CoverHardness;
        float _CoverHeightMapMin;
        float _CoverHeightMapMax;
        float _CoverHeightMapOffset;
        float4 _CoverMaskMap_TexelSize;
        float _CoverMetallic;
        float _CoverAORemapMin;
        float _CoverAORemapMax;
        float _CoverSmoothnessRemapMin;
        float _CoverSmoothnessRemapMax;
        float4 _DetailMap_TexelSize;
        float4 _DetailTilingOffset;
        float _DetailAlbedoScale;
        float _DetailNormalScale;
        float _DetailSmoothnessScale;
        float4 _WetColor;
        float _WetSmoothness;
        CBUFFER_END

        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_BaseColorMap);
        SAMPLER(sampler_BaseColorMap);
        TEXTURE2D(_BaseNormalMap);
        SAMPLER(sampler_BaseNormalMap);
        TEXTURE2D(_BaseMaskMap);
        SAMPLER(sampler_BaseMaskMap);
        TEXTURE2D(_CoverMaskA);
        SAMPLER(sampler_CoverMaskA);
        TEXTURE2D(_CoverBaseColorMap);
        SAMPLER(sampler_CoverBaseColorMap);
        TEXTURE2D(_CoverNormalMap);
        SAMPLER(sampler_CoverNormalMap);
        TEXTURE2D(_CoverMaskMap);
        SAMPLER(sampler_CoverMaskMap);
        TEXTURE2D(_DetailMap);
        SAMPLER(sampler_DetailMap);

            // Graph Functions
            
        // f948cdce565a6e706cc57cb23fbf9d95
        #include "./NM_Object_VSPro_Indirect.cginc"

        void AddPragma_float(float3 A, out float3 Out){
            #pragma instancing_options renderinglayer procedural:setupVSPro
            Out = A;
        }

        struct Bindings_NMObjectVSProIndirect_0cfe1e4f145944241ab304331e53c93b
        {
        };

        void SG_NMObjectVSProIndirect_0cfe1e4f145944241ab304331e53c93b(float3 Vector3_314C8600, Bindings_NMObjectVSProIndirect_0cfe1e4f145944241ab304331e53c93b IN, out float3 ObjectSpacePosition_1)
        {
            float3 _Property_5ec158abd968858c9d31ab40df5e9e6f_Out_0 = Vector3_314C8600;
            float3 _InjectSetupCustomFunction_dec9b26544b4a788b8ecb4117dc3d24a_Out_1;
            InjectSetup_float(_Property_5ec158abd968858c9d31ab40df5e9e6f_Out_0, _InjectSetupCustomFunction_dec9b26544b4a788b8ecb4117dc3d24a_Out_1);
            float3 _AddPragmaCustomFunction_b2a053178906d0848480a1f463521a1b_Out_1;
            AddPragma_float(_InjectSetupCustomFunction_dec9b26544b4a788b8ecb4117dc3d24a_Out_1, _AddPragmaCustomFunction_b2a053178906d0848480a1f463521a1b_Out_1);
            ObjectSpacePosition_1 = _AddPragmaCustomFunction_b2a053178906d0848480a1f463521a1b_Out_1;
        }

        void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
        {
            RGBA = float4(R, G, B, A);
            RGB = float3(R, G, B);
            RG = float2(R, G);
        }

        void Unity_Divide_float(float A, float B, out float Out)
        {
            Out = A / B;
        }

        void Unity_Multiply_float(float4 A, float4 B, out float4 Out)
        {
            Out = A * B;
        }

        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }

        void Unity_Branch_float2(float Predicate, float2 True, float2 False, out float2 Out)
        {
            Out = Predicate ? True : False;
        }

        struct Bindings_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6
        {
            float3 AbsoluteWorldSpacePosition;
            half4 uv0;
        };

        void SG_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6(UnityTexture2D Texture2D_80A3D28F, float4 Vector4_2EBA7A3B, float Boolean_7ABB9909, Bindings_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6 IN, out float4 XZ_2)
        {
            UnityTexture2D _Property_3e01b4d2fc68d48ba3acbba9d5881e59_Out_0 = Texture2D_80A3D28F;
            float _Property_30834f691775a0898a45b1c868520436_Out_0 = Boolean_7ABB9909;
            float _Split_89ed63cb625cb3878c183d0b71c03400_R_1 = IN.AbsoluteWorldSpacePosition[0];
            float _Split_89ed63cb625cb3878c183d0b71c03400_G_2 = IN.AbsoluteWorldSpacePosition[1];
            float _Split_89ed63cb625cb3878c183d0b71c03400_B_3 = IN.AbsoluteWorldSpacePosition[2];
            float _Split_89ed63cb625cb3878c183d0b71c03400_A_4 = 0;
            float4 _Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4;
            float3 _Combine_cf2d04ff119ad88493f6460431765cbb_RGB_5;
            float2 _Combine_cf2d04ff119ad88493f6460431765cbb_RG_6;
            Unity_Combine_float(_Split_89ed63cb625cb3878c183d0b71c03400_R_1, _Split_89ed63cb625cb3878c183d0b71c03400_B_3, 0, 0, _Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4, _Combine_cf2d04ff119ad88493f6460431765cbb_RGB_5, _Combine_cf2d04ff119ad88493f6460431765cbb_RG_6);
            float4 _Property_8a66888ec47d0687ab1cb2f8abdc9da8_Out_0 = Vector4_2EBA7A3B;
            float _Split_2f0f52f6ef8c0e81af0da6476402bc1f_R_1 = _Property_8a66888ec47d0687ab1cb2f8abdc9da8_Out_0[0];
            float _Split_2f0f52f6ef8c0e81af0da6476402bc1f_G_2 = _Property_8a66888ec47d0687ab1cb2f8abdc9da8_Out_0[1];
            float _Split_2f0f52f6ef8c0e81af0da6476402bc1f_B_3 = _Property_8a66888ec47d0687ab1cb2f8abdc9da8_Out_0[2];
            float _Split_2f0f52f6ef8c0e81af0da6476402bc1f_A_4 = _Property_8a66888ec47d0687ab1cb2f8abdc9da8_Out_0[3];
            float _Divide_e64179199923c58289b6aa94ea6c9178_Out_2;
            Unity_Divide_float(1, _Split_2f0f52f6ef8c0e81af0da6476402bc1f_R_1, _Divide_e64179199923c58289b6aa94ea6c9178_Out_2);
            float4 _Multiply_14cec4902d0a00829e4555071a1b8ad1_Out_2;
            Unity_Multiply_float(_Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4, (_Divide_e64179199923c58289b6aa94ea6c9178_Out_2.xxxx), _Multiply_14cec4902d0a00829e4555071a1b8ad1_Out_2);
            float2 _Vector2_16c15d3bbdd14b85bd48e3a6cb318af7_Out_0 = float2(_Split_2f0f52f6ef8c0e81af0da6476402bc1f_R_1, _Split_2f0f52f6ef8c0e81af0da6476402bc1f_G_2);
            float2 _Vector2_f8d75f54e7705083bbec539a60185577_Out_0 = float2(_Split_2f0f52f6ef8c0e81af0da6476402bc1f_B_3, _Split_2f0f52f6ef8c0e81af0da6476402bc1f_A_4);
            float2 _TilingAndOffset_d91e2d25acd34686b562b7fe7e9d1d27_Out_3;
            Unity_TilingAndOffset_float(IN.uv0.xy, _Vector2_16c15d3bbdd14b85bd48e3a6cb318af7_Out_0, _Vector2_f8d75f54e7705083bbec539a60185577_Out_0, _TilingAndOffset_d91e2d25acd34686b562b7fe7e9d1d27_Out_3);
            float2 _Branch_8e5a4e8f4d52fc8aadd1f46485afc933_Out_3;
            Unity_Branch_float2(_Property_30834f691775a0898a45b1c868520436_Out_0, (_Multiply_14cec4902d0a00829e4555071a1b8ad1_Out_2.xy), _TilingAndOffset_d91e2d25acd34686b562b7fe7e9d1d27_Out_3, _Branch_8e5a4e8f4d52fc8aadd1f46485afc933_Out_3);
            float4 _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0 = SAMPLE_TEXTURE2D(_Property_3e01b4d2fc68d48ba3acbba9d5881e59_Out_0.tex, _Property_3e01b4d2fc68d48ba3acbba9d5881e59_Out_0.samplerstate, _Branch_8e5a4e8f4d52fc8aadd1f46485afc933_Out_3);
            float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_R_4 = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0.r;
            float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_G_5 = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0.g;
            float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_B_6 = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0.b;
            float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_A_7 = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0.a;
            XZ_2 = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0;
        }

        void Unity_Multiply_float(float A, float B, out float Out)
        {
            Out = A * B;
        }

        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
        }

        void Unity_Saturate_float(float In, out float Out)
        {
            Out = saturate(In);
        }

        void Unity_Absolute_float(float In, out float Out)
        {
            Out = abs(In);
        }

        void Unity_SquareRoot_float4(float4 In, out float4 Out)
        {
            Out = sqrt(In);
        }

        void Unity_Sign_float(float In, out float Out)
        {
            Out = sign(In);
        }

        void Unity_Ceiling_float(float In, out float Out)
        {
            Out = ceil(In);
        }

        void Unity_Lerp_float4(float4 A, float4 B, float4 T, out float4 Out)
        {
            Out = lerp(A, B, T);
        }

        struct Bindings_BlendOverlayBaseColor_acdb3dfca72bd6b42bbc35f4613331a2
        {
        };

        void SG_BlendOverlayBaseColor_acdb3dfca72bd6b42bbc35f4613331a2(float4 Color_9AA111D3, float Vector1_FBE622A2, float Vector1_8C15C351, Bindings_BlendOverlayBaseColor_acdb3dfca72bd6b42bbc35f4613331a2 IN, out float3 OutVector4_1)
        {
            float4 _Property_012510d774fb7f8b860f5270dca4500f_Out_0 = Color_9AA111D3;
            float4 _SquareRoot_c2c57d0223a9538aa9240890c3cacb0c_Out_1;
            Unity_SquareRoot_float4(_Property_012510d774fb7f8b860f5270dca4500f_Out_0, _SquareRoot_c2c57d0223a9538aa9240890c3cacb0c_Out_1);
            float _Property_a00e29241d12f983b30177515b367ec9_Out_0 = Vector1_FBE622A2;
            float _Sign_343a45ede7349283a681c6bd9998fd8e_Out_1;
            Unity_Sign_float(_Property_a00e29241d12f983b30177515b367ec9_Out_0, _Sign_343a45ede7349283a681c6bd9998fd8e_Out_1);
            float _Add_681019b8f5d3d68bb482d419c9fc61a9_Out_2;
            Unity_Add_float(_Sign_343a45ede7349283a681c6bd9998fd8e_Out_1, 1, _Add_681019b8f5d3d68bb482d419c9fc61a9_Out_2);
            float _Multiply_e8f4cb722712a880ac0db6c7461427f7_Out_2;
            Unity_Multiply_float(_Add_681019b8f5d3d68bb482d419c9fc61a9_Out_2, 0.5, _Multiply_e8f4cb722712a880ac0db6c7461427f7_Out_2);
            float _Ceiling_95ad15988aa9b98184875fa754feae01_Out_1;
            Unity_Ceiling_float(_Multiply_e8f4cb722712a880ac0db6c7461427f7_Out_2, _Ceiling_95ad15988aa9b98184875fa754feae01_Out_1);
            float _Property_2db1c747a05ee284a8b00076062f91a4_Out_0 = Vector1_8C15C351;
            float _Multiply_9564ecda5193bc8286d9ff771c9226cd_Out_2;
            Unity_Multiply_float(_Property_2db1c747a05ee284a8b00076062f91a4_Out_0, _Property_2db1c747a05ee284a8b00076062f91a4_Out_0, _Multiply_9564ecda5193bc8286d9ff771c9226cd_Out_2);
            float4 _Lerp_b3cdb01fc3c5b988ac9b184943bf7c01_Out_3;
            Unity_Lerp_float4(_SquareRoot_c2c57d0223a9538aa9240890c3cacb0c_Out_1, (_Ceiling_95ad15988aa9b98184875fa754feae01_Out_1.xxxx), (_Multiply_9564ecda5193bc8286d9ff771c9226cd_Out_2.xxxx), _Lerp_b3cdb01fc3c5b988ac9b184943bf7c01_Out_3);
            float4 _Multiply_39d1daff98488f8ea2cd794ad4f20926_Out_2;
            Unity_Multiply_float(_Lerp_b3cdb01fc3c5b988ac9b184943bf7c01_Out_3, _Lerp_b3cdb01fc3c5b988ac9b184943bf7c01_Out_3, _Multiply_39d1daff98488f8ea2cd794ad4f20926_Out_2);
            OutVector4_1 = (_Multiply_39d1daff98488f8ea2cd794ad4f20926_Out_2.xyz);
        }

        void Unity_Clamp_float(float In, float Min, float Max, out float Out)
        {
            Out = clamp(In, Min, Max);
        }

        void Unity_Multiply_float(float2 A, float2 B, out float2 Out)
        {
            Out = A * B;
        }

        void Unity_Add_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A + B;
        }

        void Unity_DotProduct_float2(float2 A, float2 B, out float Out)
        {
            Out = dot(A, B);
        }

        void Unity_OneMinus_float(float In, out float Out)
        {
            Out = 1 - In;
        }

        void Unity_SquareRoot_float(float In, out float Out)
        {
            Out = sqrt(In);
        }

        void Unity_Sign_float3(float3 In, out float3 Out)
        {
            Out = sign(In);
        }

        void Unity_Normalize_float3(float3 In, out float3 Out)
        {
            Out = normalize(In);
        }

        void Unity_Branch_float3(float Predicate, float3 True, float3 False, out float3 Out)
        {
            Out = Predicate ? True : False;
        }

        struct Bindings_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8
        {
            float3 WorldSpaceNormal;
            float3 WorldSpaceTangent;
            float3 WorldSpaceBiTangent;
            float3 AbsoluteWorldSpacePosition;
            half4 uv0;
        };

        void SG_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8(UnityTexture2D Texture2D_80A3D28F, float4 Vector4_82674548, float Boolean_9FF42DF6, Bindings_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8 IN, out float4 XZ_2)
        {
            float _Property_1ef12cf3201a938993fe6a7951b0e754_Out_0 = Boolean_9FF42DF6;
            UnityTexture2D _Property_3e01b4d2fc68d48ba3acbba9d5881e59_Out_0 = Texture2D_80A3D28F;
            float _Split_89ed63cb625cb3878c183d0b71c03400_R_1 = IN.AbsoluteWorldSpacePosition[0];
            float _Split_89ed63cb625cb3878c183d0b71c03400_G_2 = IN.AbsoluteWorldSpacePosition[1];
            float _Split_89ed63cb625cb3878c183d0b71c03400_B_3 = IN.AbsoluteWorldSpacePosition[2];
            float _Split_89ed63cb625cb3878c183d0b71c03400_A_4 = 0;
            float4 _Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4;
            float3 _Combine_cf2d04ff119ad88493f6460431765cbb_RGB_5;
            float2 _Combine_cf2d04ff119ad88493f6460431765cbb_RG_6;
            Unity_Combine_float(_Split_89ed63cb625cb3878c183d0b71c03400_R_1, _Split_89ed63cb625cb3878c183d0b71c03400_B_3, 0, 0, _Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4, _Combine_cf2d04ff119ad88493f6460431765cbb_RGB_5, _Combine_cf2d04ff119ad88493f6460431765cbb_RG_6);
            float4 _Property_3fa1d6f912feb481ba60f2e55e62e746_Out_0 = Vector4_82674548;
            float _Split_a2e12fa5931da084b2949343a539dfd8_R_1 = _Property_3fa1d6f912feb481ba60f2e55e62e746_Out_0[0];
            float _Split_a2e12fa5931da084b2949343a539dfd8_G_2 = _Property_3fa1d6f912feb481ba60f2e55e62e746_Out_0[1];
            float _Split_a2e12fa5931da084b2949343a539dfd8_B_3 = _Property_3fa1d6f912feb481ba60f2e55e62e746_Out_0[2];
            float _Split_a2e12fa5931da084b2949343a539dfd8_A_4 = _Property_3fa1d6f912feb481ba60f2e55e62e746_Out_0[3];
            float _Divide_c36b770dfaa0bb8f85ab27da5fd794f0_Out_2;
            Unity_Divide_float(1, _Split_a2e12fa5931da084b2949343a539dfd8_R_1, _Divide_c36b770dfaa0bb8f85ab27da5fd794f0_Out_2);
            float4 _Multiply_14cec4902d0a00829e4555071a1b8ad1_Out_2;
            Unity_Multiply_float(_Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4, (_Divide_c36b770dfaa0bb8f85ab27da5fd794f0_Out_2.xxxx), _Multiply_14cec4902d0a00829e4555071a1b8ad1_Out_2);
            float2 _Vector2_6845d21872714d889783b0cb707df3e9_Out_0 = float2(_Split_a2e12fa5931da084b2949343a539dfd8_R_1, _Split_a2e12fa5931da084b2949343a539dfd8_G_2);
            float2 _Vector2_e2e2263627c6098e96a5b5d29350ad03_Out_0 = float2(_Split_a2e12fa5931da084b2949343a539dfd8_B_3, _Split_a2e12fa5931da084b2949343a539dfd8_A_4);
            float2 _TilingAndOffset_17582d056c0b8a8dab1017d37497fe59_Out_3;
            Unity_TilingAndOffset_float(IN.uv0.xy, _Vector2_6845d21872714d889783b0cb707df3e9_Out_0, _Vector2_e2e2263627c6098e96a5b5d29350ad03_Out_0, _TilingAndOffset_17582d056c0b8a8dab1017d37497fe59_Out_3);
            float2 _Branch_1e152f3aac57448f8518bf2852c000c3_Out_3;
            Unity_Branch_float2(_Property_1ef12cf3201a938993fe6a7951b0e754_Out_0, (_Multiply_14cec4902d0a00829e4555071a1b8ad1_Out_2.xy), _TilingAndOffset_17582d056c0b8a8dab1017d37497fe59_Out_3, _Branch_1e152f3aac57448f8518bf2852c000c3_Out_3);
            float4 _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0 = SAMPLE_TEXTURE2D(_Property_3e01b4d2fc68d48ba3acbba9d5881e59_Out_0.tex, _Property_3e01b4d2fc68d48ba3acbba9d5881e59_Out_0.samplerstate, _Branch_1e152f3aac57448f8518bf2852c000c3_Out_3);
            _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0.rgb = UnpackNormal(_SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0);
            float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_R_4 = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0.r;
            float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_G_5 = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0.g;
            float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_B_6 = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0.b;
            float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_A_7 = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0.a;
            float2 _Vector2_ad6bd100e273d78fa409a30a77bfa2cc_Out_0 = float2(_SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_R_4, _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_G_5);
            float3 _Sign_3a6ebf59931cf08cb0482e0144ddac24_Out_1;
            Unity_Sign_float3(IN.WorldSpaceNormal, _Sign_3a6ebf59931cf08cb0482e0144ddac24_Out_1);
            float _Split_6299d4ddcc4c74828aea40a46fdb896e_R_1 = _Sign_3a6ebf59931cf08cb0482e0144ddac24_Out_1[0];
            float _Split_6299d4ddcc4c74828aea40a46fdb896e_G_2 = _Sign_3a6ebf59931cf08cb0482e0144ddac24_Out_1[1];
            float _Split_6299d4ddcc4c74828aea40a46fdb896e_B_3 = _Sign_3a6ebf59931cf08cb0482e0144ddac24_Out_1[2];
            float _Split_6299d4ddcc4c74828aea40a46fdb896e_A_4 = 0;
            float2 _Vector2_b76cb1842101e58b9e636d49b075c612_Out_0 = float2(_Split_6299d4ddcc4c74828aea40a46fdb896e_G_2, 1);
            float2 _Multiply_31e8db88ee20c985a9850d1a58f3282b_Out_2;
            Unity_Multiply_float(_Vector2_ad6bd100e273d78fa409a30a77bfa2cc_Out_0, _Vector2_b76cb1842101e58b9e636d49b075c612_Out_0, _Multiply_31e8db88ee20c985a9850d1a58f3282b_Out_2);
            float _Split_5ed44bf2eca0868f81eb18100f49d1fa_R_1 = IN.WorldSpaceNormal[0];
            float _Split_5ed44bf2eca0868f81eb18100f49d1fa_G_2 = IN.WorldSpaceNormal[1];
            float _Split_5ed44bf2eca0868f81eb18100f49d1fa_B_3 = IN.WorldSpaceNormal[2];
            float _Split_5ed44bf2eca0868f81eb18100f49d1fa_A_4 = 0;
            float2 _Vector2_70e5837843f28b8b9d64cada3697bd5a_Out_0 = float2(_Split_5ed44bf2eca0868f81eb18100f49d1fa_R_1, _Split_5ed44bf2eca0868f81eb18100f49d1fa_B_3);
            float2 _Add_1145b2f896593d80aa864a34e6702562_Out_2;
            Unity_Add_float2(_Multiply_31e8db88ee20c985a9850d1a58f3282b_Out_2, _Vector2_70e5837843f28b8b9d64cada3697bd5a_Out_0, _Add_1145b2f896593d80aa864a34e6702562_Out_2);
            float _Split_2bc77ca2d17bd78cb2383770ce50b179_R_1 = _Add_1145b2f896593d80aa864a34e6702562_Out_2[0];
            float _Split_2bc77ca2d17bd78cb2383770ce50b179_G_2 = _Add_1145b2f896593d80aa864a34e6702562_Out_2[1];
            float _Split_2bc77ca2d17bd78cb2383770ce50b179_B_3 = 0;
            float _Split_2bc77ca2d17bd78cb2383770ce50b179_A_4 = 0;
            float _Multiply_ab12aea87465a78eaf7fc66c2598d266_Out_2;
            Unity_Multiply_float(_SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_B_6, _Split_5ed44bf2eca0868f81eb18100f49d1fa_G_2, _Multiply_ab12aea87465a78eaf7fc66c2598d266_Out_2);
            float3 _Vector3_433840b555db308b97e9b14b6a957195_Out_0 = float3(_Split_2bc77ca2d17bd78cb2383770ce50b179_R_1, _Multiply_ab12aea87465a78eaf7fc66c2598d266_Out_2, _Split_2bc77ca2d17bd78cb2383770ce50b179_G_2);
            float3x3 Transform_c7914cc45a011c89b3f53c55afb51673_tangentTransform_World = float3x3(IN.WorldSpaceTangent, IN.WorldSpaceBiTangent, IN.WorldSpaceNormal);
            float3 _Transform_c7914cc45a011c89b3f53c55afb51673_Out_1 = TransformWorldToTangent(_Vector3_433840b555db308b97e9b14b6a957195_Out_0.xyz, Transform_c7914cc45a011c89b3f53c55afb51673_tangentTransform_World);
            float3 _Normalize_09bf8a2bd0a4d38e8b97d5c674f79b44_Out_1;
            Unity_Normalize_float3(_Transform_c7914cc45a011c89b3f53c55afb51673_Out_1, _Normalize_09bf8a2bd0a4d38e8b97d5c674f79b44_Out_1);
            float3 _Branch_9eadf909a90f2f80880f8c56ecc2a91f_Out_3;
            Unity_Branch_float3(_Property_1ef12cf3201a938993fe6a7951b0e754_Out_0, _Normalize_09bf8a2bd0a4d38e8b97d5c674f79b44_Out_1, (_SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0.xyz), _Branch_9eadf909a90f2f80880f8c56ecc2a91f_Out_3);
            XZ_2 = (float4(_Branch_9eadf909a90f2f80880f8c56ecc2a91f_Out_3, 1.0));
        }

        void Unity_NormalStrength_float(float3 In, float Strength, out float3 Out)
        {
            Out = float3(In.rg * Strength, lerp(1, In.b, saturate(Strength)));
        }

        void Unity_NormalBlend_float(float3 A, float3 B, out float3 Out)
        {
            Out = SafeNormalize(float3(A.rg + B.rg, A.b * B.b));
        }

        void Unity_Subtract_float(float A, float B, out float Out)
        {
            Out = A - B;
        }

        void Unity_Power_float(float A, float B, out float Out)
        {
            Out = pow(A, B);
        }

        void Unity_Lerp_float3(float3 A, float3 B, float3 T, out float3 Out)
        {
            Out = lerp(A, B, T);
        }

        void Unity_Remap_float(float In, float2 InMinMax, float2 OutMinMax, out float Out)
        {
            Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
        }

        void Unity_Multiply_float(float3 A, float3 B, out float3 Out)
        {
            Out = A * B;
        }

            // Graph Vertex
            struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };

        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            Bindings_NMObjectVSProIndirect_0cfe1e4f145944241ab304331e53c93b _NMObjectVSProIndirect_adbe93754e069e8e87df45ef6e4b343e;
            float3 _NMObjectVSProIndirect_adbe93754e069e8e87df45ef6e4b343e_ObjectSpacePosition_1;
            SG_NMObjectVSProIndirect_0cfe1e4f145944241ab304331e53c93b(IN.ObjectSpacePosition, _NMObjectVSProIndirect_adbe93754e069e8e87df45ef6e4b343e, _NMObjectVSProIndirect_adbe93754e069e8e87df45ef6e4b343e_ObjectSpacePosition_1);
            #endif
            description.Position = _NMObjectVSProIndirect_adbe93754e069e8e87df45ef6e4b343e_ObjectSpacePosition_1;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }

            // Graph Pixel
            struct SurfaceDescription
        {
            float3 BaseColor;
            float Alpha;
            float AlphaClipThreshold;
        };

        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            UnityTexture2D _Property_e4c53213449c7682b60df6ae54f219f0_Out_0 = UnityBuildTexture2DStructNoScale(_BaseColorMap);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 _Property_115fcc827510f38798b214d835c27637_Out_0 = _BaseTilingOffset;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_d83b8f290862b285bbe2f157190e1315_Out_0 = _BaseUsePlanarUV;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            Bindings_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6 _PlanarNM_6c8b686076db2a8c8b7d6cd91cf435f0;
            _PlanarNM_6c8b686076db2a8c8b7d6cd91cf435f0.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            _PlanarNM_6c8b686076db2a8c8b7d6cd91cf435f0.uv0 = IN.uv0;
            float4 _PlanarNM_6c8b686076db2a8c8b7d6cd91cf435f0_XZ_2;
            SG_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6(_Property_e4c53213449c7682b60df6ae54f219f0_Out_0, _Property_115fcc827510f38798b214d835c27637_Out_0, _Property_d83b8f290862b285bbe2f157190e1315_Out_0, _PlanarNM_6c8b686076db2a8c8b7d6cd91cf435f0, _PlanarNM_6c8b686076db2a8c8b7d6cd91cf435f0_XZ_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 _Property_13c79aaf332e20868551d934a2cb7112_Out_0 = _BaseColor;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 _Multiply_3d0c2fda612cfe87aa84bc17ad099a61_Out_2;
            Unity_Multiply_float(_PlanarNM_6c8b686076db2a8c8b7d6cd91cf435f0_XZ_2, _Property_13c79aaf332e20868551d934a2cb7112_Out_0, _Multiply_3d0c2fda612cfe87aa84bc17ad099a61_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            UnityTexture2D _Property_b561c414493a8f8299227a27e437f045_Out_0 = UnityBuildTexture2DStructNoScale(_DetailMap);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 _Property_70f1cc2b73af738d80b0d405e4bed8c5_Out_0 = _DetailTilingOffset;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Split_cda27505033cfc8eaf60fe914f0949b9_R_1 = _Property_70f1cc2b73af738d80b0d405e4bed8c5_Out_0[0];
            float _Split_cda27505033cfc8eaf60fe914f0949b9_G_2 = _Property_70f1cc2b73af738d80b0d405e4bed8c5_Out_0[1];
            float _Split_cda27505033cfc8eaf60fe914f0949b9_B_3 = _Property_70f1cc2b73af738d80b0d405e4bed8c5_Out_0[2];
            float _Split_cda27505033cfc8eaf60fe914f0949b9_A_4 = _Property_70f1cc2b73af738d80b0d405e4bed8c5_Out_0[3];
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float2 _Vector2_42d7e955009b6f8cb4d913530ff92840_Out_0 = float2(_Split_cda27505033cfc8eaf60fe914f0949b9_R_1, _Split_cda27505033cfc8eaf60fe914f0949b9_G_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float2 _Vector2_5452a0299d10b280aec51f7407d4d2ac_Out_0 = float2(_Split_cda27505033cfc8eaf60fe914f0949b9_B_3, _Split_cda27505033cfc8eaf60fe914f0949b9_A_4);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float2 _TilingAndOffset_e1c5b97bd253ca8f9f3d26f598e6d7fd_Out_3;
            Unity_TilingAndOffset_float(IN.uv0.xy, _Vector2_42d7e955009b6f8cb4d913530ff92840_Out_0, _Vector2_5452a0299d10b280aec51f7407d4d2ac_Out_0, _TilingAndOffset_e1c5b97bd253ca8f9f3d26f598e6d7fd_Out_3);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 _SampleTexture2D_fa4ac40fc922b9869e37c06690c0f530_RGBA_0 = SAMPLE_TEXTURE2D(_Property_b561c414493a8f8299227a27e437f045_Out_0.tex, _Property_b561c414493a8f8299227a27e437f045_Out_0.samplerstate, _TilingAndOffset_e1c5b97bd253ca8f9f3d26f598e6d7fd_Out_3);
            float _SampleTexture2D_fa4ac40fc922b9869e37c06690c0f530_R_4 = _SampleTexture2D_fa4ac40fc922b9869e37c06690c0f530_RGBA_0.r;
            float _SampleTexture2D_fa4ac40fc922b9869e37c06690c0f530_G_5 = _SampleTexture2D_fa4ac40fc922b9869e37c06690c0f530_RGBA_0.g;
            float _SampleTexture2D_fa4ac40fc922b9869e37c06690c0f530_B_6 = _SampleTexture2D_fa4ac40fc922b9869e37c06690c0f530_RGBA_0.b;
            float _SampleTexture2D_fa4ac40fc922b9869e37c06690c0f530_A_7 = _SampleTexture2D_fa4ac40fc922b9869e37c06690c0f530_RGBA_0.a;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Multiply_d0f6aeb5b3f04288b51a5ded8986b5a4_Out_2;
            Unity_Multiply_float(_SampleTexture2D_fa4ac40fc922b9869e37c06690c0f530_R_4, 2, _Multiply_d0f6aeb5b3f04288b51a5ded8986b5a4_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Add_d382719213f8618f88c54f7c3dfbd8c2_Out_2;
            Unity_Add_float(_Multiply_d0f6aeb5b3f04288b51a5ded8986b5a4_Out_2, -1, _Add_d382719213f8618f88c54f7c3dfbd8c2_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_02e7dd176dc59f8a9a62453677916b24_Out_0 = _DetailAlbedoScale;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Multiply_fd406247e3137a8b8777918477740653_Out_2;
            Unity_Multiply_float(_Add_d382719213f8618f88c54f7c3dfbd8c2_Out_2, _Property_02e7dd176dc59f8a9a62453677916b24_Out_0, _Multiply_fd406247e3137a8b8777918477740653_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Saturate_d6f590fb1b9d188e981ebb0ec4d36ba9_Out_1;
            Unity_Saturate_float(_Multiply_fd406247e3137a8b8777918477740653_Out_2, _Saturate_d6f590fb1b9d188e981ebb0ec4d36ba9_Out_1);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Absolute_dc927550b803d18ba3ff372995e6d25c_Out_1;
            Unity_Absolute_float(_Saturate_d6f590fb1b9d188e981ebb0ec4d36ba9_Out_1, _Absolute_dc927550b803d18ba3ff372995e6d25c_Out_1);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            Bindings_BlendOverlayBaseColor_acdb3dfca72bd6b42bbc35f4613331a2 _BlendOverlayBaseColor_f3cd25d5b673648eb831a3f388201f73;
            float3 _BlendOverlayBaseColor_f3cd25d5b673648eb831a3f388201f73_OutVector4_1;
            SG_BlendOverlayBaseColor_acdb3dfca72bd6b42bbc35f4613331a2(_Multiply_3d0c2fda612cfe87aa84bc17ad099a61_Out_2, _Add_d382719213f8618f88c54f7c3dfbd8c2_Out_2, _Absolute_dc927550b803d18ba3ff372995e6d25c_Out_1, _BlendOverlayBaseColor_f3cd25d5b673648eb831a3f388201f73, _BlendOverlayBaseColor_f3cd25d5b673648eb831a3f388201f73_OutVector4_1);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            UnityTexture2D _Property_f4db51ec2412c48cbcf2128b7bd8caf8_Out_0 = UnityBuildTexture2DStructNoScale(_CoverBaseColorMap);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 _Property_e35c79b8cccfbe8ca0a3c33e8d32e319_Out_0 = _CoverTilingOffset;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_e3d8b38b51331e879b1d4012d65f53e6_Out_0 = _CoverUsePlanarUV;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            Bindings_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6 _PlanarNM_c2ec737ef76d6286b8eedb44a2d24e50;
            _PlanarNM_c2ec737ef76d6286b8eedb44a2d24e50.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            _PlanarNM_c2ec737ef76d6286b8eedb44a2d24e50.uv0 = IN.uv0;
            float4 _PlanarNM_c2ec737ef76d6286b8eedb44a2d24e50_XZ_2;
            SG_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6(_Property_f4db51ec2412c48cbcf2128b7bd8caf8_Out_0, _Property_e35c79b8cccfbe8ca0a3c33e8d32e319_Out_0, _Property_e3d8b38b51331e879b1d4012d65f53e6_Out_0, _PlanarNM_c2ec737ef76d6286b8eedb44a2d24e50, _PlanarNM_c2ec737ef76d6286b8eedb44a2d24e50_XZ_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 _Property_7d3af9045f54ef8ba8629ebbbc3f4ad7_Out_0 = _CoverBaseColor;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 _Multiply_2eb83c7af5b6f58eabeec7b502517470_Out_2;
            Unity_Multiply_float(_PlanarNM_c2ec737ef76d6286b8eedb44a2d24e50_XZ_2, _Property_7d3af9045f54ef8ba8629ebbbc3f4ad7_Out_0, _Multiply_2eb83c7af5b6f58eabeec7b502517470_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            UnityTexture2D _Property_356186a26fec8686a13bc6b57fd8f3ee_Out_0 = UnityBuildTexture2DStructNoScale(_CoverMaskA);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 _UV_045cea9e82354980a778f44d92578382_Out_0 = IN.uv0;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 _SampleTexture2D_0eef6ae3dab6e185bd0f65edecd80314_RGBA_0 = SAMPLE_TEXTURE2D(_Property_356186a26fec8686a13bc6b57fd8f3ee_Out_0.tex, _Property_356186a26fec8686a13bc6b57fd8f3ee_Out_0.samplerstate, (_UV_045cea9e82354980a778f44d92578382_Out_0.xy));
            float _SampleTexture2D_0eef6ae3dab6e185bd0f65edecd80314_R_4 = _SampleTexture2D_0eef6ae3dab6e185bd0f65edecd80314_RGBA_0.r;
            float _SampleTexture2D_0eef6ae3dab6e185bd0f65edecd80314_G_5 = _SampleTexture2D_0eef6ae3dab6e185bd0f65edecd80314_RGBA_0.g;
            float _SampleTexture2D_0eef6ae3dab6e185bd0f65edecd80314_B_6 = _SampleTexture2D_0eef6ae3dab6e185bd0f65edecd80314_RGBA_0.b;
            float _SampleTexture2D_0eef6ae3dab6e185bd0f65edecd80314_A_7 = _SampleTexture2D_0eef6ae3dab6e185bd0f65edecd80314_RGBA_0.a;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_4e8240836843df81941cdf6cf2cdd638_Out_0 = _CoverMaskPower;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Multiply_8b5250e5dfc73a84a41399a13b83c0a1_Out_2;
            Unity_Multiply_float(_SampleTexture2D_0eef6ae3dab6e185bd0f65edecd80314_A_7, _Property_4e8240836843df81941cdf6cf2cdd638_Out_0, _Multiply_8b5250e5dfc73a84a41399a13b83c0a1_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Clamp_030a7c32684c258084338456eaddc77a_Out_3;
            Unity_Clamp_float(_Multiply_8b5250e5dfc73a84a41399a13b83c0a1_Out_2, 0, 1, _Clamp_030a7c32684c258084338456eaddc77a_Out_3);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Split_8ba5b67899f36b8f9dcf5c84092c0560_R_1 = IN.VertexColor[0];
            float _Split_8ba5b67899f36b8f9dcf5c84092c0560_G_2 = IN.VertexColor[1];
            float _Split_8ba5b67899f36b8f9dcf5c84092c0560_B_3 = IN.VertexColor[2];
            float _Split_8ba5b67899f36b8f9dcf5c84092c0560_A_4 = IN.VertexColor[3];
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float2 _Vector2_65060e9a9f687a89b68e32dc876be645_Out_0 = float2(_SampleTexture2D_fa4ac40fc922b9869e37c06690c0f530_A_7, _SampleTexture2D_fa4ac40fc922b9869e37c06690c0f530_G_5);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float2 _Multiply_5d4c3baed6515c8b86a289c70fca8f5d_Out_2;
            Unity_Multiply_float(_Vector2_65060e9a9f687a89b68e32dc876be645_Out_0, float2(2, 2), _Multiply_5d4c3baed6515c8b86a289c70fca8f5d_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float2 _Add_98b310e19c5fa5899c39cc45969c15ea_Out_2;
            Unity_Add_float2(_Multiply_5d4c3baed6515c8b86a289c70fca8f5d_Out_2, float2(-1, -1), _Add_98b310e19c5fa5899c39cc45969c15ea_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_08b99582093b36869beb5ea3d18e765d_Out_0 = _DetailNormalScale;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float2 _Multiply_bf0b80fdb3271784900e5b5ea4c5550f_Out_2;
            Unity_Multiply_float(_Add_98b310e19c5fa5899c39cc45969c15ea_Out_2, (_Property_08b99582093b36869beb5ea3d18e765d_Out_0.xx), _Multiply_bf0b80fdb3271784900e5b5ea4c5550f_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Split_26c1e73f8436c78ebdae5b51365a072b_R_1 = _Multiply_bf0b80fdb3271784900e5b5ea4c5550f_Out_2[0];
            float _Split_26c1e73f8436c78ebdae5b51365a072b_G_2 = _Multiply_bf0b80fdb3271784900e5b5ea4c5550f_Out_2[1];
            float _Split_26c1e73f8436c78ebdae5b51365a072b_B_3 = 0;
            float _Split_26c1e73f8436c78ebdae5b51365a072b_A_4 = 0;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _DotProduct_50aca3ce0da1ad849d7ff4a99df3a322_Out_2;
            Unity_DotProduct_float2(_Multiply_bf0b80fdb3271784900e5b5ea4c5550f_Out_2, _Multiply_bf0b80fdb3271784900e5b5ea4c5550f_Out_2, _DotProduct_50aca3ce0da1ad849d7ff4a99df3a322_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Saturate_491f2ee8417b8782aee83358b89eeb08_Out_1;
            Unity_Saturate_float(_DotProduct_50aca3ce0da1ad849d7ff4a99df3a322_Out_2, _Saturate_491f2ee8417b8782aee83358b89eeb08_Out_1);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _OneMinus_46ad3170d736808d98bf74ffa45e0414_Out_1;
            Unity_OneMinus_float(_Saturate_491f2ee8417b8782aee83358b89eeb08_Out_1, _OneMinus_46ad3170d736808d98bf74ffa45e0414_Out_1);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _SquareRoot_dfeae899ebfeae8f9257c340ca22ce38_Out_1;
            Unity_SquareRoot_float(_OneMinus_46ad3170d736808d98bf74ffa45e0414_Out_1, _SquareRoot_dfeae899ebfeae8f9257c340ca22ce38_Out_1);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 _Vector3_ed3f80ed87524e8c99f98b224af5a610_Out_0 = float3(_Split_26c1e73f8436c78ebdae5b51365a072b_R_1, _Split_26c1e73f8436c78ebdae5b51365a072b_G_2, _SquareRoot_dfeae899ebfeae8f9257c340ca22ce38_Out_1);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            UnityTexture2D _Property_2cc39234d3d334899f94126a216a50fc_Out_0 = UnityBuildTexture2DStructNoScale(_BaseNormalMap);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            Bindings_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8 _PlanarNMn_4fde70f39e45398dbb9972941e88e2bf;
            _PlanarNMn_4fde70f39e45398dbb9972941e88e2bf.WorldSpaceNormal = IN.WorldSpaceNormal;
            _PlanarNMn_4fde70f39e45398dbb9972941e88e2bf.WorldSpaceTangent = IN.WorldSpaceTangent;
            _PlanarNMn_4fde70f39e45398dbb9972941e88e2bf.WorldSpaceBiTangent = IN.WorldSpaceBiTangent;
            _PlanarNMn_4fde70f39e45398dbb9972941e88e2bf.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            _PlanarNMn_4fde70f39e45398dbb9972941e88e2bf.uv0 = IN.uv0;
            float4 _PlanarNMn_4fde70f39e45398dbb9972941e88e2bf_XZ_2;
            SG_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8(_Property_2cc39234d3d334899f94126a216a50fc_Out_0, _Property_115fcc827510f38798b214d835c27637_Out_0, _Property_d83b8f290862b285bbe2f157190e1315_Out_0, _PlanarNMn_4fde70f39e45398dbb9972941e88e2bf, _PlanarNMn_4fde70f39e45398dbb9972941e88e2bf_XZ_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_020d569f63e9a2849e23988ff74eb005_Out_0 = _BaseNormalScale;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 _NormalStrength_0c71fb166ae841839a0a12ecc5afa6fe_Out_2;
            Unity_NormalStrength_float((_PlanarNMn_4fde70f39e45398dbb9972941e88e2bf_XZ_2.xyz), _Property_020d569f63e9a2849e23988ff74eb005_Out_0, _NormalStrength_0c71fb166ae841839a0a12ecc5afa6fe_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 _NormalBlend_be36dd49bea74c8f8dd52fa3a85a9534_Out_2;
            Unity_NormalBlend_float(_Vector3_ed3f80ed87524e8c99f98b224af5a610_Out_0, _NormalStrength_0c71fb166ae841839a0a12ecc5afa6fe_Out_2, _NormalBlend_be36dd49bea74c8f8dd52fa3a85a9534_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            UnityTexture2D _Property_a383045772822c87acd099bb4cd6c478_Out_0 = UnityBuildTexture2DStructNoScale(_CoverNormalMap);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            Bindings_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8 _PlanarNMn_79abde32a0223a89907c9f09efac8db7;
            _PlanarNMn_79abde32a0223a89907c9f09efac8db7.WorldSpaceNormal = IN.WorldSpaceNormal;
            _PlanarNMn_79abde32a0223a89907c9f09efac8db7.WorldSpaceTangent = IN.WorldSpaceTangent;
            _PlanarNMn_79abde32a0223a89907c9f09efac8db7.WorldSpaceBiTangent = IN.WorldSpaceBiTangent;
            _PlanarNMn_79abde32a0223a89907c9f09efac8db7.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            _PlanarNMn_79abde32a0223a89907c9f09efac8db7.uv0 = IN.uv0;
            float4 _PlanarNMn_79abde32a0223a89907c9f09efac8db7_XZ_2;
            SG_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8(_Property_a383045772822c87acd099bb4cd6c478_Out_0, _Property_e35c79b8cccfbe8ca0a3c33e8d32e319_Out_0, _Property_e3d8b38b51331e879b1d4012d65f53e6_Out_0, _PlanarNMn_79abde32a0223a89907c9f09efac8db7, _PlanarNMn_79abde32a0223a89907c9f09efac8db7_XZ_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_c688e246111fd881820a97415e14d8a3_Out_0 = _CoverNormalBlendHardness;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 _NormalStrength_0e5e0831ba0e98878220ca6021ea52a2_Out_2;
            Unity_NormalStrength_float((_PlanarNMn_79abde32a0223a89907c9f09efac8db7_XZ_2.xyz), _Property_c688e246111fd881820a97415e14d8a3_Out_0, _NormalStrength_0e5e0831ba0e98878220ca6021ea52a2_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Split_8cadce726725318fbacd47f436a8231d_R_1 = IN.WorldSpaceNormal[0];
            float _Split_8cadce726725318fbacd47f436a8231d_G_2 = IN.WorldSpaceNormal[1];
            float _Split_8cadce726725318fbacd47f436a8231d_B_3 = IN.WorldSpaceNormal[2];
            float _Split_8cadce726725318fbacd47f436a8231d_A_4 = 0;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_ce4e5954a0b7ff8c819fa53963327595_Out_0 = _Cover_Amount;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_384059e6344fb98a85eccad78dd82f36_Out_0 = _Cover_Amount_Grow_Speed;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Subtract_70fd06876db7fa85b0cc0bce8d926dff_Out_2;
            Unity_Subtract_float(4, _Property_384059e6344fb98a85eccad78dd82f36_Out_0, _Subtract_70fd06876db7fa85b0cc0bce8d926dff_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Divide_1a3a6334c3d8bc8f8ac262c7833e15d5_Out_2;
            Unity_Divide_float(_Property_ce4e5954a0b7ff8c819fa53963327595_Out_0, _Subtract_70fd06876db7fa85b0cc0bce8d926dff_Out_2, _Divide_1a3a6334c3d8bc8f8ac262c7833e15d5_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Absolute_f218d2b85ebf288f91234faffedb5f7b_Out_1;
            Unity_Absolute_float(_Divide_1a3a6334c3d8bc8f8ac262c7833e15d5_Out_2, _Absolute_f218d2b85ebf288f91234faffedb5f7b_Out_1);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Power_a9b8d4b65c44a98e9813f61c0e2dc0a3_Out_2;
            Unity_Power_float(_Absolute_f218d2b85ebf288f91234faffedb5f7b_Out_1, _Subtract_70fd06876db7fa85b0cc0bce8d926dff_Out_2, _Power_a9b8d4b65c44a98e9813f61c0e2dc0a3_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Clamp_95d579f83746cb82be79cf6739990e0b_Out_3;
            Unity_Clamp_float(_Power_a9b8d4b65c44a98e9813f61c0e2dc0a3_Out_2, 0, 2, _Clamp_95d579f83746cb82be79cf6739990e0b_Out_3);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Multiply_02a8aa0fa6974e81aa84caba54f63896_Out_2;
            Unity_Multiply_float(_Split_8cadce726725318fbacd47f436a8231d_G_2, _Clamp_95d579f83746cb82be79cf6739990e0b_Out_3, _Multiply_02a8aa0fa6974e81aa84caba54f63896_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Saturate_ada5e8f9ebdcb38d8f5e61e8d97424b9_Out_1;
            Unity_Saturate_float(_Multiply_02a8aa0fa6974e81aa84caba54f63896_Out_2, _Saturate_ada5e8f9ebdcb38d8f5e61e8d97424b9_Out_1);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Clamp_38bac9e8ef351789b5fd4f2201f1df7b_Out_3;
            Unity_Clamp_float(_Split_8cadce726725318fbacd47f436a8231d_G_2, 0, 0.9999, _Clamp_38bac9e8ef351789b5fd4f2201f1df7b_Out_3);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_9babc76177853482826cae0163ffe988_Out_0 = _Cover_Max_Angle;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Divide_3b22550205905d8da5870f9db56e44ff_Out_2;
            Unity_Divide_float(_Property_9babc76177853482826cae0163ffe988_Out_0, 45, _Divide_3b22550205905d8da5870f9db56e44ff_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _OneMinus_99a85b6952a41288afc86da0a6ca6ea0_Out_1;
            Unity_OneMinus_float(_Divide_3b22550205905d8da5870f9db56e44ff_Out_2, _OneMinus_99a85b6952a41288afc86da0a6ca6ea0_Out_1);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Subtract_2b63f3aaee26f686971dca1d28da283c_Out_2;
            Unity_Subtract_float(_Clamp_38bac9e8ef351789b5fd4f2201f1df7b_Out_3, _OneMinus_99a85b6952a41288afc86da0a6ca6ea0_Out_1, _Subtract_2b63f3aaee26f686971dca1d28da283c_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Clamp_6bd9bb4add91fe8eb80a958a6b1a2d01_Out_3;
            Unity_Clamp_float(_Subtract_2b63f3aaee26f686971dca1d28da283c_Out_2, 0, 2, _Clamp_6bd9bb4add91fe8eb80a958a6b1a2d01_Out_3);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Divide_a09d2d461b07e98999aba746fb52a3fc_Out_2;
            Unity_Divide_float(1, _Divide_3b22550205905d8da5870f9db56e44ff_Out_2, _Divide_a09d2d461b07e98999aba746fb52a3fc_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Multiply_89a8f5a279c73b898d4ca5d075786b53_Out_2;
            Unity_Multiply_float(_Clamp_6bd9bb4add91fe8eb80a958a6b1a2d01_Out_3, _Divide_a09d2d461b07e98999aba746fb52a3fc_Out_2, _Multiply_89a8f5a279c73b898d4ca5d075786b53_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Absolute_f98ce5feb185a68784b9b35eb71ec465_Out_1;
            Unity_Absolute_float(_Multiply_89a8f5a279c73b898d4ca5d075786b53_Out_2, _Absolute_f98ce5feb185a68784b9b35eb71ec465_Out_1);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_27e768ffa9c13e8ab65d48e7712e5b66_Out_0 = _CoverHardness;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Power_b9fdc3921d5b85878a1ec4baa1975184_Out_2;
            Unity_Power_float(_Absolute_f98ce5feb185a68784b9b35eb71ec465_Out_1, _Property_27e768ffa9c13e8ab65d48e7712e5b66_Out_0, _Power_b9fdc3921d5b85878a1ec4baa1975184_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_c442c20fdade808b8e1b93cfd6625ab9_Out_0 = _Cover_Min_Height;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _OneMinus_55530ddc82048c8aa2d082334edf6a57_Out_1;
            Unity_OneMinus_float(_Property_c442c20fdade808b8e1b93cfd6625ab9_Out_0, _OneMinus_55530ddc82048c8aa2d082334edf6a57_Out_1);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Split_7e5d084c5e6bfa83a9203dac971ea31e_R_1 = IN.AbsoluteWorldSpacePosition[0];
            float _Split_7e5d084c5e6bfa83a9203dac971ea31e_G_2 = IN.AbsoluteWorldSpacePosition[1];
            float _Split_7e5d084c5e6bfa83a9203dac971ea31e_B_3 = IN.AbsoluteWorldSpacePosition[2];
            float _Split_7e5d084c5e6bfa83a9203dac971ea31e_A_4 = 0;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Add_e4067b215657d98ab6ec4e0295ddfece_Out_2;
            Unity_Add_float(_OneMinus_55530ddc82048c8aa2d082334edf6a57_Out_1, _Split_7e5d084c5e6bfa83a9203dac971ea31e_G_2, _Add_e4067b215657d98ab6ec4e0295ddfece_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Add_a4387dfc1ea3ee8da0b04f433a7c63d0_Out_2;
            Unity_Add_float(_Add_e4067b215657d98ab6ec4e0295ddfece_Out_2, 1, _Add_a4387dfc1ea3ee8da0b04f433a7c63d0_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Clamp_570e1129ecb02c8b8be79d85f19d5ae1_Out_3;
            Unity_Clamp_float(_Add_a4387dfc1ea3ee8da0b04f433a7c63d0_Out_2, 0, 1, _Clamp_570e1129ecb02c8b8be79d85f19d5ae1_Out_3);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_5da709b259ac268bb134d927bcffa4b8_Out_0 = _Cover_Min_Height_Blending;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Add_c322347d9ddbcd83ba52983e9316c387_Out_2;
            Unity_Add_float(_Add_e4067b215657d98ab6ec4e0295ddfece_Out_2, _Property_5da709b259ac268bb134d927bcffa4b8_Out_0, _Add_c322347d9ddbcd83ba52983e9316c387_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Divide_078ffa7d6c597f819511c95d33b7d90e_Out_2;
            Unity_Divide_float(_Add_c322347d9ddbcd83ba52983e9316c387_Out_2, _Add_e4067b215657d98ab6ec4e0295ddfece_Out_2, _Divide_078ffa7d6c597f819511c95d33b7d90e_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _OneMinus_b9f8edced35e7b8cab9ca581d822e31f_Out_1;
            Unity_OneMinus_float(_Divide_078ffa7d6c597f819511c95d33b7d90e_Out_2, _OneMinus_b9f8edced35e7b8cab9ca581d822e31f_Out_1);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Add_95cd1778448bfe8d9f9fa9129235f2c2_Out_2;
            Unity_Add_float(_OneMinus_b9f8edced35e7b8cab9ca581d822e31f_Out_1, -0.5, _Add_95cd1778448bfe8d9f9fa9129235f2c2_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Clamp_23e760e01b7e0780a71d88813b5828d7_Out_3;
            Unity_Clamp_float(_Add_95cd1778448bfe8d9f9fa9129235f2c2_Out_2, 0, 1, _Clamp_23e760e01b7e0780a71d88813b5828d7_Out_3);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Add_674fcef023d728848510150af810a103_Out_2;
            Unity_Add_float(_Clamp_570e1129ecb02c8b8be79d85f19d5ae1_Out_3, _Clamp_23e760e01b7e0780a71d88813b5828d7_Out_3, _Add_674fcef023d728848510150af810a103_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Clamp_5b677be9d499c082bcbe316853b0adff_Out_3;
            Unity_Clamp_float(_Add_674fcef023d728848510150af810a103_Out_2, 0, 1, _Clamp_5b677be9d499c082bcbe316853b0adff_Out_3);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Multiply_7ea7400ed65a3582b000796fb39748e9_Out_2;
            Unity_Multiply_float(_Power_b9fdc3921d5b85878a1ec4baa1975184_Out_2, _Clamp_5b677be9d499c082bcbe316853b0adff_Out_3, _Multiply_7ea7400ed65a3582b000796fb39748e9_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Multiply_4d295791f4e23186acea64f2f4de94ea_Out_2;
            Unity_Multiply_float(_Saturate_ada5e8f9ebdcb38d8f5e61e8d97424b9_Out_1, _Multiply_7ea7400ed65a3582b000796fb39748e9_Out_2, _Multiply_4d295791f4e23186acea64f2f4de94ea_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 _Lerp_21eaf65c617b2d858b3b33154d55757a_Out_3;
            Unity_Lerp_float3(_NormalBlend_be36dd49bea74c8f8dd52fa3a85a9534_Out_2, _NormalStrength_0e5e0831ba0e98878220ca6021ea52a2_Out_2, (_Multiply_4d295791f4e23186acea64f2f4de94ea_Out_2.xxx), _Lerp_21eaf65c617b2d858b3b33154d55757a_Out_3);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3x3 Transform_1e4c3a2d6240958ab6858efb88c1d06a_transposeTangent = transpose(float3x3(IN.WorldSpaceTangent, IN.WorldSpaceBiTangent, IN.WorldSpaceNormal));
            float3 _Transform_1e4c3a2d6240958ab6858efb88c1d06a_Out_1 = normalize(mul(Transform_1e4c3a2d6240958ab6858efb88c1d06a_transposeTangent, _Lerp_21eaf65c617b2d858b3b33154d55757a_Out_3.xyz).xyz);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Split_600a9d271d96798a94ab28118977defd_R_1 = _Transform_1e4c3a2d6240958ab6858efb88c1d06a_Out_1[0];
            float _Split_600a9d271d96798a94ab28118977defd_G_2 = _Transform_1e4c3a2d6240958ab6858efb88c1d06a_Out_1[1];
            float _Split_600a9d271d96798a94ab28118977defd_B_3 = _Transform_1e4c3a2d6240958ab6858efb88c1d06a_Out_1[2];
            float _Split_600a9d271d96798a94ab28118977defd_A_4 = 0;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Multiply_2e5b010626435f8492a2690396ced19d_Out_2;
            Unity_Multiply_float(_Split_600a9d271d96798a94ab28118977defd_G_2, _Clamp_95d579f83746cb82be79cf6739990e0b_Out_3, _Multiply_2e5b010626435f8492a2690396ced19d_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Multiply_5a2397e0153ddb8f9bd457d9a301dc8b_Out_2;
            Unity_Multiply_float(_Clamp_95d579f83746cb82be79cf6739990e0b_Out_3, _Property_27e768ffa9c13e8ab65d48e7712e5b66_Out_0, _Multiply_5a2397e0153ddb8f9bd457d9a301dc8b_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Multiply_3aad76eaff60dd888c3e1783ecf03943_Out_2;
            Unity_Multiply_float(_Multiply_5a2397e0153ddb8f9bd457d9a301dc8b_Out_2, _Multiply_7ea7400ed65a3582b000796fb39748e9_Out_2, _Multiply_3aad76eaff60dd888c3e1783ecf03943_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Multiply_05614e740451f18f8301586390aa5a0a_Out_2;
            Unity_Multiply_float(_Multiply_2e5b010626435f8492a2690396ced19d_Out_2, _Multiply_3aad76eaff60dd888c3e1783ecf03943_Out_2, _Multiply_05614e740451f18f8301586390aa5a0a_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            UnityTexture2D _Property_a14f2476a35d208b988233c852f919ef_Out_0 = UnityBuildTexture2DStructNoScale(_CoverMaskMap);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            Bindings_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6 _PlanarNM_6858a0e821f26a8d87846d325e9bd170;
            _PlanarNM_6858a0e821f26a8d87846d325e9bd170.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            _PlanarNM_6858a0e821f26a8d87846d325e9bd170.uv0 = IN.uv0;
            float4 _PlanarNM_6858a0e821f26a8d87846d325e9bd170_XZ_2;
            SG_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6(_Property_a14f2476a35d208b988233c852f919ef_Out_0, _Property_e35c79b8cccfbe8ca0a3c33e8d32e319_Out_0, _Property_e3d8b38b51331e879b1d4012d65f53e6_Out_0, _PlanarNM_6858a0e821f26a8d87846d325e9bd170, _PlanarNM_6858a0e821f26a8d87846d325e9bd170_XZ_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Split_16313c20ccdeaa86a639068877a69a2f_R_1 = _PlanarNM_6858a0e821f26a8d87846d325e9bd170_XZ_2[0];
            float _Split_16313c20ccdeaa86a639068877a69a2f_G_2 = _PlanarNM_6858a0e821f26a8d87846d325e9bd170_XZ_2[1];
            float _Split_16313c20ccdeaa86a639068877a69a2f_B_3 = _PlanarNM_6858a0e821f26a8d87846d325e9bd170_XZ_2[2];
            float _Split_16313c20ccdeaa86a639068877a69a2f_A_4 = _PlanarNM_6858a0e821f26a8d87846d325e9bd170_XZ_2[3];
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_673896519f419589938b37e782b90141_Out_0 = _CoverHeightMapMin;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_c35906332422438da3b19f45cbd5ac17_Out_0 = _CoverHeightMapMax;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float2 _Vector2_81cbe1e5ea789e8697223cd3bfbca76c_Out_0 = float2(_Property_673896519f419589938b37e782b90141_Out_0, _Property_c35906332422438da3b19f45cbd5ac17_Out_0);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_88ab0068f899fc8ba94efdaec5e8966b_Out_0 = _CoverHeightMapOffset;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float2 _Add_cd623e3135271489b0d45b4d7edc5f7e_Out_2;
            Unity_Add_float2(_Vector2_81cbe1e5ea789e8697223cd3bfbca76c_Out_0, (_Property_88ab0068f899fc8ba94efdaec5e8966b_Out_0.xx), _Add_cd623e3135271489b0d45b4d7edc5f7e_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Remap_9a23d5f76fa8c38dbd73f43bd6397b0b_Out_3;
            Unity_Remap_float(_Split_16313c20ccdeaa86a639068877a69a2f_B_3, float2 (0, 1), _Add_cd623e3135271489b0d45b4d7edc5f7e_Out_2, _Remap_9a23d5f76fa8c38dbd73f43bd6397b0b_Out_3);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Multiply_0093be0fd848498b89a0fa282608e715_Out_2;
            Unity_Multiply_float(_Multiply_05614e740451f18f8301586390aa5a0a_Out_2, _Remap_9a23d5f76fa8c38dbd73f43bd6397b0b_Out_3, _Multiply_0093be0fd848498b89a0fa282608e715_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Multiply_d3190f97afd0398083623ecf71a41b1a_Out_2;
            Unity_Multiply_float(_Split_8ba5b67899f36b8f9dcf5c84092c0560_G_2, _Multiply_0093be0fd848498b89a0fa282608e715_Out_2, _Multiply_d3190f97afd0398083623ecf71a41b1a_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Saturate_cbcee34e7e6e6d8091d840550ab1c74a_Out_1;
            Unity_Saturate_float(_Multiply_d3190f97afd0398083623ecf71a41b1a_Out_2, _Saturate_cbcee34e7e6e6d8091d840550ab1c74a_Out_1);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Multiply_da35b9d9e4dd8c81871a9aea42c157ee_Out_2;
            Unity_Multiply_float(_Clamp_030a7c32684c258084338456eaddc77a_Out_3, _Saturate_cbcee34e7e6e6d8091d840550ab1c74a_Out_1, _Multiply_da35b9d9e4dd8c81871a9aea42c157ee_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Clamp_c95f5515948375878df6581a36d8b203_Out_3;
            Unity_Clamp_float(_Multiply_da35b9d9e4dd8c81871a9aea42c157ee_Out_2, 0, 1, _Clamp_c95f5515948375878df6581a36d8b203_Out_3);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            #if defined(_USEDYNAMICCOVERTSTATICMASKF_ON)
            float _UseDynamicCoverTStaticMaskF_0694902516172b8fa469c5d8b8e938c6_Out_0 = _Clamp_c95f5515948375878df6581a36d8b203_Out_3;
            #else
            float _UseDynamicCoverTStaticMaskF_0694902516172b8fa469c5d8b8e938c6_Out_0 = _Clamp_030a7c32684c258084338456eaddc77a_Out_3;
            #endif
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 _Lerp_87882219e20a6d818c0de017d739125f_Out_3;
            Unity_Lerp_float3(_BlendOverlayBaseColor_f3cd25d5b673648eb831a3f388201f73_OutVector4_1, (_Multiply_2eb83c7af5b6f58eabeec7b502517470_Out_2.xyz), (_UseDynamicCoverTStaticMaskF_0694902516172b8fa469c5d8b8e938c6_Out_0.xxx), _Lerp_87882219e20a6d818c0de017d739125f_Out_3);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 _Property_4c7bd3690d9d8a838e2524f5908e09ee_Out_0 = _WetColor;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 _Multiply_77c751a5503e948d8952b403163b4eeb_Out_2;
            Unity_Multiply_float((_Property_4c7bd3690d9d8a838e2524f5908e09ee_Out_0.xyz), _Lerp_87882219e20a6d818c0de017d739125f_Out_3, _Multiply_77c751a5503e948d8952b403163b4eeb_Out_2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _OneMinus_9b165e3f6c2fdd88a5f3a51230f8dd33_Out_1;
            Unity_OneMinus_float(_Split_8ba5b67899f36b8f9dcf5c84092c0560_R_1, _OneMinus_9b165e3f6c2fdd88a5f3a51230f8dd33_Out_1);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 _Lerp_538fa3f69b550a8bbe8ee20906ecc752_Out_3;
            Unity_Lerp_float3(_Lerp_87882219e20a6d818c0de017d739125f_Out_3, _Multiply_77c751a5503e948d8952b403163b4eeb_Out_2, (_OneMinus_9b165e3f6c2fdd88a5f3a51230f8dd33_Out_1.xxx), _Lerp_538fa3f69b550a8bbe8ee20906ecc752_Out_3);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Split_31874fa1d55cb28e99a1333cf254676a_R_1 = _PlanarNM_6c8b686076db2a8c8b7d6cd91cf435f0_XZ_2[0];
            float _Split_31874fa1d55cb28e99a1333cf254676a_G_2 = _PlanarNM_6c8b686076db2a8c8b7d6cd91cf435f0_XZ_2[1];
            float _Split_31874fa1d55cb28e99a1333cf254676a_B_3 = _PlanarNM_6c8b686076db2a8c8b7d6cd91cf435f0_XZ_2[2];
            float _Split_31874fa1d55cb28e99a1333cf254676a_A_4 = _PlanarNM_6c8b686076db2a8c8b7d6cd91cf435f0_XZ_2[3];
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_881c341218ea2d81819695b0c7ddc4cb_Out_0 = _AlphaCutoff;
            #endif
            surface.BaseColor = _Lerp_538fa3f69b550a8bbe8ee20906ecc752_Out_3;
            surface.Alpha = _Split_31874fa1d55cb28e99a1333cf254676a_A_4;
            surface.AlphaClipThreshold = _Property_881c341218ea2d81819695b0c7ddc4cb_Out_0;
            return surface;
        }

            // --------------------------------------------------
            // Build Graph Inputs

            VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.ObjectSpaceNormal =           input.normalOS;
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.ObjectSpaceTangent =          input.tangentOS.xyz;
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.ObjectSpacePosition =         input.positionOS;
        #endif


            return output;
        }
            SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        // must use interpolated tangent, bitangent and normal before they are normalized in the pixel shader.
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        float3 unnormalizedNormalWS = input.normalWS;
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        const float renormFactor = 1.0 / length(unnormalizedNormalWS);
        #endif


        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        // use bitangent on the fly like in hdrp
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        // IMPORTANT! If we ever support Flip on double sided materials ensure bitangent and tangent are NOT flipped.
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        float crossSign = (input.tangentWS.w > 0.0 ? 1.0 : -1.0) * GetOddNegativeScale();
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        float3 bitang = crossSign * cross(input.normalWS.xyz, input.tangentWS.xyz);
        #endif


        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.WorldSpaceNormal =            renormFactor*input.normalWS.xyz;      // we want a unit length Normal Vector node in shader graph
        #endif


        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        // to preserve mikktspace compliance we use same scale renormFactor as was used on the normal.
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        // This is explained in section 2.2 in "surface gradient based bump mapping framework"
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.WorldSpaceTangent =           renormFactor*input.tangentWS.xyz;
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.WorldSpaceBiTangent =         renormFactor*bitang;
        #endif


        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.AbsoluteWorldSpacePosition =  GetAbsolutePositionWS(input.positionWS);
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.uv0 =                         input.texCoord0;
        #endif

        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.VertexColor =                 input.color;
        #endif

        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN

            return output;
        }

            // --------------------------------------------------
            // Main

            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/PBR2DPass.hlsl"

            ENDHLSL
        }
    }
    CustomEditorForRenderPipeline "ShaderGraph.PBRMasterGUI" "UnityEngine.Rendering.Universal.UniversalRenderPipelineAsset"
    FallBack "Hidden/Shader Graph/FallbackError"
}