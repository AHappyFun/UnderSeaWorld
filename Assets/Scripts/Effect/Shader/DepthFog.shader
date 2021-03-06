﻿Shader "Effect/DepthFogShader"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_FogColor("Fog Color", Color) = (1,1,1,1)
		_DepthStart("Depth Start", float) = 1
		_DepthDistance("Depth Distance", float) = 1
		_FogStrength("FogStrength", float) = 1
	}
		SubShader
	{
		Tags { "RenderType" = "Opaque" }
		LOD 100

		Pass
		{
			Cull Off ZWrite Off ZTest Always
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			#include "UnityCG.cginc"
			sampler2D _CameraDepthTexture;

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
				float4 scrPos : TEXCOORD1;
				//float4 interpolatedRay : TEXCOORD2;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			float4 _FogColor;
			float _DepthStart, _DepthDistance, _FogStrength;

			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				o.scrPos = ComputeScreenPos(o.vertex);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				float depthValue = Linear01Depth(tex2Dproj(_CameraDepthTexture, UNITY_PROJ_COORD(i.scrPos)).r) * _ProjectionParams.z;
				
				depthValue = saturate((depthValue - _DepthStart) / _DepthDistance);

				//float3 worldPos = _WorldSpaceCameraPos + depthValue * i.interpolatedRay.xyz;
				
				fixed4 fogColor = _FogColor * depthValue;
				fixed4 col = tex2Dproj(_MainTex, i.scrPos);

				
				return lerp(col, fogColor, depthValue);
				//return fixed4(depthValue, depthValue, depthValue,1);
			}
			ENDCG
		}
	}
}
