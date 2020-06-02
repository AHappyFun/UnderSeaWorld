Shader "UnderSea/Fish"
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
			#pragma   multi_compile_instancing
            #include "UnityCG.cginc"
			#include "Lighting.cginc"

			UNITY_INSTANCING_BUFFER_START(Props)
				//UNITY_DEFINE_INSTANCED_PROP(fixed4, _Color)     //这里把_Color声明为了实例化属性
			UNITY_INSTANCING_BUFFER_END(Props)

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
				float3 normal : NORMAL;
				UNITY_VERTEX_INPUT_INSTANCE_ID
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 pos : SV_POSITION;
				float3 worldNormal : NORMAL;
				UNITY_VERTEX_INPUT_INSTANCE_ID
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            v2f vert (appdata v)
            {
                v2f o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);

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
	}
}
