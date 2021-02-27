Shader "Effect/HeightFogShader"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_FogColor("Fog Color", Color) = (1,1,1,1)
		_FogStart("Fog Start", float) = 1
		_FogEnd("Fog End", float) = 1
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
				float4 interpolatedRay : TEXCOORD2;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			float4 _FogColor;
			float _FogStart, _FogEnd, _FogStrength;

			float4x4 _FrustumCornersRay;

			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				o.scrPos = ComputeScreenPos(o.vertex);

				int index = 0;
				if(v.uv.x < 0.5 && v.uv.y < 0.5){
					index = 0;
				}else if (v.uv.x > 0.5 && v.uv.y < 0.5){
					index = 1;
				}else if (v.uv.x > 0.5 && v.uv.y > 0.5){
					index = 2;
				}else{
					index = 3;
				}
				o.interpolatedRay = _FrustumCornersRay[index];

				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				float depthValue = Linear01Depth(tex2Dproj(_CameraDepthTexture, UNITY_PROJ_COORD(i.scrPos)).r) * _ProjectionParams.z;
				
				//depthValue = saturate((depthValue - _DepthStart) / _DepthDistance);

				float3 worldPos = _WorldSpaceCameraPos + depthValue * i.interpolatedRay.xyz;

				float fogDensity = (_FogEnd - worldPos.y) / (_FogEnd - _FogStart);
				fogDensity = saturate(fogDensity * _FogStrength);

				fixed4 fogColor = _FogColor;
				fixed4 col = tex2Dproj(_MainTex, i.scrPos);

				return lerp(col, fogColor, fogDensity);
				//return fixed4(fogDensity, fogDensity, fogDensity,1);
			}
			ENDCG
		}
	}
}
