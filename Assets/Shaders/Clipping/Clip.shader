Shader "Clipping/Clip" 
{
	Properties 
	{
		_Color("Color", Color) = (1,1,1,1)
		_MainTex("Texture", 2D) = "white"{}
		_ClipDistance("Clipping distance", float) = 0.1
	}

	SubShader 
	{
		Tags { "RenderType"="Opaque" }

		Cull Off

		CGPROGRAM
		#pragma surface surf Standard

		struct Input 
	{
			float2 uv_MainTex;
			float3 worldPos;
		};

		fixed4 _Color;
		sampler2D _MainTex;
		float _ClipDistance;

		void surf (Input IN, inout SurfaceOutputStandard o) 
		{
			clip(frac((IN.worldPos.y + IN.worldPos.z * 0.1) * _ClipDistance) - 0.5);
			clip(frac((IN.worldPos.x + IN.worldPos.z * 0.1) * _ClipDistance) - 0.5);
			float3 worldTexture = tex2D(_MainTex, IN.uv_MainTex).rgb;
			o.Albedo = worldTexture * _Color;
		}

		ENDCG
	}

	FallBack "Diffuse"
}
