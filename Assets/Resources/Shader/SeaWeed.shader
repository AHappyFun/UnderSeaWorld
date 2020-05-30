Shader "Plants/SeaWeed"
{
    Properties
	{
		_MainTex("Texture", 2D) = "white" {}
		_Color("Color", Color) = (1,1,1,1)
	}
	SubShader
	{
			Tags{
				"Queue" = "AlphaTest"
				"IgnoreProjector" = "True"
				"RenderType" = "TransparentCutout"
			}
			Pass
			{
				Tags{ "LightMode" = "ForwardBase" }
				Cull off
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
					float4 pos : SV_POSITION;
					float3 worldNormal :NORMAL;
					float3 worldPos : TEXCOORD1;
					SHADOW_COORDS(2)
				};

				sampler2D _MainTex;
				float4 _MainTex_ST;  //命名格式  纹理_ST  保存缩放xy和偏移值zw	

				v2f vert(appdata v)
				{
					v2f o;
					o.pos = UnityObjectToClipPos(v.vertex);
					o.worldNormal = mul(v.normal, (float3x3)unity_WorldToObject);
					o.worldPos = mul(unity_ObjectToWorld, v.vertex);

					o.uv = TRANSFORM_TEX(v.uv, _MainTex);

					TRANSFER_SHADOW(o);

					return o;
				}
				float4 _Color;
				fixed4 frag(v2f i) : SV_Target
				{
					fixed4 col = tex2D(_MainTex, i.uv);

					clip(col.a - 0.01);
				

					fixed3 ambientColor = col.rgb * _Color.rgb *  UNITY_LIGHTMODEL_AMBIENT.rgb;

					fixed3 worldNormal = normalize(i.worldNormal);
					fixed3 worldLightDir = normalize(_WorldSpaceLightPos0.xyz);
					fixed3 diffuse = max(0.0, dot(worldNormal, worldLightDir));
					fixed3 diffuseColor = diffuse  * _LightColor0.xyz;

					UNITY_LIGHT_ATTENUATION(atten, i, i.worldPos);   //atten 包含的是阴影和衰减的乘积

					fixed4 color = fixed4(ambientColor + diffuseColor * atten , 1.0);

					return color;
				}
				ENDCG
			}	
	}
}
