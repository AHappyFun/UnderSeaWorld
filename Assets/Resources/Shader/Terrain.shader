// Upgrade NOTE: replaced '_LightMatrix0' with 'unity_WorldToLight'

Shader "UnderSea/Terrain"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
		_NoiseTex ("Noise", 2D) = "white" {}
		_NoiseAmount("Noise程度", Range(0,1)) = 0.5
		_NoiseSpeed("Nosie速度", float) = 2
		_Color("Color",color) = (1,1,1,1)
    }
    SubShader
    {
        Tags { "RenderType"="Opaque"  }
        LOD 100

        Pass
        {
			Tags{
				"LightMode" = "ForwardBase"
			}
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "AutoLight.cginc"   

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
				float3 normal : NORMAL;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
				float2 uvN : TEXCOORD1;
                float4 pos : SV_POSITION;
				float3 worldPos : TEXCOORD2;
				float3 worldNormal:NORMAL;

				SHADOW_COORDS(3)  
            };

            sampler2D _MainTex;
			sampler2D _NoiseTex;
            float4 _MainTex_ST;
			float4 _NoiseTex_ST;

			float _NoiseSpeed;
			fixed4 _Color;

            v2f vert (appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);				

				o.uvN = TRANSFORM_TEX(v.uv, _NoiseTex);
				o.uvN += frac(_Time.y * _NoiseSpeed);

				o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
				o.worldNormal = mul(v.normal, (float3x3)unity_WorldToObject);
				TRANSFER_SHADOW(o);   //计算阴影纹理坐标

                return o;
            }

			float _NoiseAmount;
            fixed4 frag (v2f i) : SV_Target
            {
				fixed3 worldNormal = normalize(i.worldNormal);
				fixed3 worldLightDir = normalize(_WorldSpaceLightPos0.xyz);

				//ForwardBase
				fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz;
				fixed3 diffuse = _LightColor0.rgb * max(0.0, dot(worldNormal, worldLightDir));

				//光照衰减
				fixed atten = 1;
				fixed3 phong = ambient + diffuse * atten;

				//SHADOW
				fixed shadow = SHADOW_ATTENUATION(i);

                fixed4 col = tex2D(_MainTex, i.uv)* _Color;
				fixed4 nC = tex2D(_NoiseTex, i.uvN);
				fixed3 c = lerp(col, nC, _NoiseAmount).rgb * phong * shadow;

				return fixed4(c, 1);
            }
            ENDCG
        }

		Pass
        {   //前向渲染的addpass
			Tags { 
				"TagName" = "Add"
				"LightMode" = "ForwardAdd"
			}
			Blend One One  //叠加

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

			#pragma multi_compile_fwdadd  

            #include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "AutoLight.cginc"

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
				float3 worldPos : TEXCOORD1;
				float3 worldNormal:NORMAL;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
			fixed4 _Color;

            v2f vert (appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
				o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
				o.worldNormal = mul(v.normal, (float3x3)unity_WorldToObject);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
				fixed3 worldNormal = normalize(i.worldNormal);
				#ifdef USING_DIRECTION_LIGHT
					fixed3 worldLightDir = normalize(_WorldSpaceLightPos0.xyz);
				#else
					fixed3 worldLightDir = normalize(_WorldSpaceLightPos0.xyz - i.worldPos.xyz);
				#endif

				fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz;
				fixed3 diffuse = _LightColor0.rgb * max(0.0, dot(worldNormal, worldLightDir));



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
				
				fixed3 phong = ambient + diffuse * atten * _Color;

                fixed3 col = tex2D(_MainTex, i.uv) * phong ;
                return fixed4(col,1);
            }
            ENDCG
        }

    }

	Fallback "Legacy Shaders/VertexLit"
}
