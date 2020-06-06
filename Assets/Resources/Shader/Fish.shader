// Upgrade NOTE: replaced '_LightMatrix0' with 'unity_WorldToLight'

// Upgrade NOTE: replaced '_LightMatrix0' with 'unity_WorldToLight'

Shader "UnderSea/Fish"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
		_Size("WaveSize", float) = 2
		_Frequency("Frequency", float) = 2
		_SinMaxValue("SinMaxValue", float) = 2
    }
    SubShader
    {
        Tags { "RenderType" = "Opaque" }
        LOD 100

        Pass
        {
			Tags{ "LightMode" = "ForwardBase" "TagName" = "Base"}
			ZTest LEqual
			ZWrite On
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
			#include "Lighting.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
				float3 normal : NORMAL;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 pos : SV_POSITION;
				float3 worldNormal : NORMAL;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

			float _Size;
			float _Frequency;
			float _SinMaxValue;

            v2f vert (appdata v)
            {
                v2f o;
				float4 offset;
				offset.yzw = float3(0.0, 0.0, 0.0);
				offset.x = sin(_Time.y * _Frequency + (v.vertex.z) * _Size) * _SinMaxValue;

                o.pos = UnityObjectToClipPos(v.vertex + offset);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				o.worldNormal = mul(v.normal, (float3x3)unity_WorldToObject);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 col = tex2D(_MainTex, i.uv);

				float3 worldNormal = i.worldNormal;
				float3 worldLightDir = normalize(_WorldSpaceLightPos0.xyz);

				fixed3 ambientC = UNITY_LIGHTMODEL_AMBIENT.xyz;
				fixed3 diffuseC = _LightColor0.rgb * max(0, dot(worldNormal, worldLightDir));

				//光照衰减
				#ifdef USING_DIRECTIONAL_LIGHT
					fixed atten = 1.0;
				#else
					#if defined (POINT)			
						float3 lightCoord = mul(unity_WorldToLight, float4(i.worldPos, 1)).xyz;
						fixed atten = tex2D(_LightTexture0, dot(lightCoord, lightCoord).rr).UNITY_ATTEN_CHANNEL;
				#elif defined (SPOT)
						float4 lightCoord = mul(unity_WorldToLight, float4(i.worldPos, 1));
						fixed atten = (lightCoord.z > 0) * tex2D(_LightTexture0, lightCoord.xy / lightCoord.w + 0.5).w * tex2D(_LightTextureB0, dot(lightCoord, lightCoord).rr).UNITY_ATTEN_CHANNEL;
					#else
						fixed atten = 1.0;
					#endif
				#endif

				fixed3 C = ambientC + diffuseC * atten;

                return fixed4(C * col.rgb,1);
            }
            ENDCG
        }		
    }
	Fallback "Legacy Shaders/VertexLit"
}
