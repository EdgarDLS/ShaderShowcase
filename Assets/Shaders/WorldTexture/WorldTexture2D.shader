Shader "WorldPositionTexture/WorldTexture2D" 
{
	Properties {
		_Color("Color", Color) = (1,1,1,1)
		_MainTex("Base Color", 2D) = "white" {}
		_UVs("UV Scale", float) = 1.0
	}

	SubShader 
	{
		Tags { "RenderType"="Opaque" }

		CGPROGRAM

		#pragma surface surf Standard fullforwardshadows
		#pragma target 3.0

		struct Input 
		{
			float3 worldPos;
		};
		
		fixed4 _Color;
		sampler2D _MainTex;
		float _UVs;

		UNITY_INSTANCING_BUFFER_START(Props)
		UNITY_INSTANCING_BUFFER_END(Props)

		#include "UnityCG.cginc"

		void surf (Input IN, inout SurfaceOutputStandard o) 
		{
			float3 pos = IN.worldPos / (-1.0 * abs(_UVs));		// To scale the texture UVs

			float worldTexture = tex2D(_MainTex, pos.xy).rgba;

			o.Albedo = worldTexture * _Color;
		}

		ENDCG
	}
	FallBack "Diffuse"
}
