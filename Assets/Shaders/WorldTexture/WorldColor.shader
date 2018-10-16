// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

Shader "WorldPositionTexture/WorldColor"
{
	Properties
	{
		_MainTex("Texture", 2D) = "white" {}
	_Scale("Texture Scale", float) = 0.5
	}

		SubShader
	{

		Tags{ "RenderType" = "Opaque" }

		CGPROGRAM
#pragma surface surf Standard

		struct Input
	{
		float3 worldNormal;
		float3 worldPos;
	};

	sampler2D _MainTex;
	float _Scale;

	void surf(Input IN, inout SurfaceOutputStandard  o)
	{
		if (abs(IN.worldNormal.y) > 0.5)
		{
			o.Albedo = tex2D(_MainTex, IN.worldPos.xz * _Scale) * float4(abs(IN.worldPos.y / 15) % 1 + 0.2, 0, abs(IN.worldPos.y / 15) % 1, 1);
			//o.Albedo = color.xyz;
		}
		else if (abs(IN.worldNormal.x) > 0.5)
		{
			o.Albedo = tex2D(_MainTex, IN.worldPos.yz * _Scale) * float4(abs(IN.worldPos.y / 15) % 1 + 0.2, 0, abs(IN.worldPos.y / 15) % 1, 1);
		}
		else
		{
			o.Albedo = tex2D(_MainTex, IN.worldPos.xy * _Scale) * float4(abs(IN.worldPos.y / 15) % 1 + 0.2, 0, abs(IN.worldPos.y / 15) % 1, 1);
		}

		o.Emission = o.Albedo;
	}

	ENDCG
	}

		FallBack "Diffuse"
}
