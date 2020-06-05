Shader "UnderSea/Terrain"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
		_NoiseTex ("Noise", 2D) = "white" {}
		_NoiseAmount("Noise程度", Range(0,1)) = 0.5
		_NoiseSpeed("Nosie速度", float) = 2
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
				float2 uvN : TEXCOORD1;
                float4 pos : SV_POSITION;
            };

            sampler2D _MainTex;
			sampler2D _NoiseTex;
            float4 _MainTex_ST;
			float4 _NoiseTex_ST;

			float _NoiseSpeed;

            v2f vert (appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);				

				o.uvN = TRANSFORM_TEX(v.uv, _NoiseTex);
				o.uvN += frac(_Time.y * _NoiseSpeed);

                return o;
            }

			float _NoiseAmount;
            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 col = tex2D(_MainTex, i.uv);
				fixed4 nC = tex2D(_NoiseTex, i.uvN);
				fixed4 c = lerp(col, nC, _NoiseAmount);

				return c;
            }
            ENDCG
        }
    }
	Fallback "Legacy Shaders/VertexLit"
}
