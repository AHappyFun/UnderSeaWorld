Shader "Hidden/Universal Render Pipeline/FogGreyShader"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
	}
		SubShader
	{
		Tags { "RenderType" = "Opaque" "RenderPipeline" = "UniversalPipeline" }
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
				float4 vertex : SV_POSITION;
				float4 scrPos : TEXCOORD1;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;

			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				o.scrPos = ComputeScreenPos(o.vertex); //齐次坐标下的屏幕坐标， 范围(0,w)    在tex2Dproj中采样，会自动除以w,使分量范围在(0,1)
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				// ----------灰度GreyColor		
				fixed4 selfColor = tex2Dproj(_MainTex, i.scrPos);  //原色
				float gray = (selfColor.r * 30 + selfColor.g * 59 + selfColor.b * 11 + 50 ) / (100 );    //灰度转化公式
				fixed4 c = fixed4(gray, gray, gray, 1) ;
				return c;
			}
			ENDCG
		}
	}
}

