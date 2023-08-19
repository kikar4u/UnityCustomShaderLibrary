Shader "Unlit/ShaderTest"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _MaskTexture ("Mask To Apply", 2D) = "black" {}
        _Mask2Texture ("Border", 2D) = "black" {}
        _Glossiness ("Smoothness", Range(0,1)) = 0.5
        _Metallic ("Metallic", Range(0,1)) = 0.0
        _Opacity("Opacity", Range(0,1)) = 0.0
        [KeywordEnum(Off, On)]
        _Options ("Switch Texture", Int) = 0
    }
    SubShader
    {
        Tags {"Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent"}
        LOD 200
        ZWrite Off
        Blend SrcAlpha OneMinusSrcAlpha
        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf Standard fullforwardshadows alpha:fade

        // Use shader model 3.0 target, to get nicer looking lighting
        #pragma target 3.0

        sampler2D _MainTex;
        sampler2D _SecondTexture;
        sampler2D _MaskTexture;
        sampler2D _Mask2Texture;

        struct Input
        {
            float2 uv_MainTex;
            float2 uv_MaskTexture;
            float2 uv_Mask2Texture;
        };

        half _Glossiness;
        half _Metallic;
        fixed4 _Color;
        half _Opacity;

        // Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
        // See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
        // #pragma instancing_options assumeuniformscaling
        UNITY_INSTANCING_BUFFER_START(Props)
            // put more per-instance properties here
        UNITY_INSTANCING_BUFFER_END(Props)

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            
            // Albedo comes from a texture tinted by color
            fixed4 c;
            c = lerp(tex2D(_MainTex, IN.uv_MainTex), _Color, tex2D(_MaskTexture, IN.uv_MaskTexture));
            o.Albedo = c.rgb;
            // Metallic and smoothness come from slider variables
            o.Metallic = _Metallic;
            o.Smoothness = _Glossiness;
            o.Alpha = tex2D(_Mask2Texture, IN.uv_Mask2Texture).a;
            // tex2D(_MainTex, IN.uv_MainTex), tex2D(_SecondTexture, IN.uv_SecondTexture), tex2D(_MaskTexture, IN.uv_MaskTexture)
        }

        ENDCG
    }
    FallBack "Diffuse"
}
