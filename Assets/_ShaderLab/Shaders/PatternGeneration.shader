Shader "Unlit/FireShader"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        [PowerSlider(3.0)]
        _UNoise ("X Scale Noise", Range(0.01, 10)) = 0.00
        [PowerSlider(3.0)]
        _VNoise ("Y Scale Noise", Range(0.01, 10)) = 0.00
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100
        Cull back
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float2 _MainTex_TexelSize;
            float x,y;
            float _UNoise, _VNoise;
            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }
            float random (float2 st) {
                return frac(sin(dot(st.xy,
                                    float2(12.9898,78.233)))*
                    43758.5453123);
            }
            fixed4 frag (v2f i) : SV_Target
            {
                float2 st = floor(tex2D(_MainTex, i.uv) / (float2(_VNoise, _VNoise) * _SinTime)) ;

                float rnd = random(st);
                float rnd1 = random(st * 2);
                float rnd2 = random(st / 2);
                float rnd3 = random(st + 2);
                fixed4 col = fixed4(rnd, rnd, rnd, rnd); 
                // sample the texture
                //fixed4 col = tex2D(_MainTex, i.uv);
                // apply fog
                UNITY_APPLY_FOG(i.fogCoord, col);
                return col;
            }
            ENDCG
        }
    }
}
