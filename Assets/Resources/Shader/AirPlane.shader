//飞机Shader
//1.为什么Opaque的没写入深度图里？？？
// 居然就加一个Fallback "Legacy Shaders/VertexLit"就好了？？？为什么

Shader "UnderSea/AirPlane"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
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

            v2f vert (appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
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

				fixed3 C = ambientC + diffuseC;

                return fixed4(C * col.rgb,1);
            }
            ENDCG
        }

		Pass
        {   //addpass
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

				//ForwardBase
				fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz;

				fixed3 diffuse = _LightColor0.rgb * max(0.0, dot(worldNormal, worldLightDir));


				//光照衰减
				#ifdef USING_DIRECTION_LIGHT
					fixed atten = 1;
				#else
					float3 lightCoord = mul(unity_WorldToLight , float4(i.worldPos,1)).xyz;
					fixed atten = tex2D(_LightTexture0, dot(lightCoord, lightCoord).rr).UNITY_ATTEN_CHANNEL;
				#endif
				
				fixed3 phong = ambient + diffuse * atten;

                fixed3 col = tex2D(_MainTex, i.uv) * phong ;
                return fixed4(col,1);
            }
            ENDCG
        }
    }
	Fallback "Legacy Shaders/VertexLit"
}
