// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "FirstShader/ColorTween"
{
	Properties
	{
		_MainTexture("Texture", 2D) = "white" {}
	_PrimaryColor("Primary Color", color) = (1, 1, 1, 1)
		_SecondaryColor("Secondary Color", color) = (0, 0, 0, 1)
		_Tween("Tween", range(0, 1)) = 0
	}

		SubShader
	{
		Tags
	{
		"Queue" = "Transparent"
	}

		Pass
	{
		Blend SrcAlpha OneMinusSrcAlpha

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
	};

	sampler2D _MainTex;
	float4 _MainTex_ST;

	v2f vert(appdata v)
	{
		v2f o;
		o.vertex = UnityObjectToClipPos(v.vertex);
		o.uv = v.uv;
		return o;
	}

	sampler2D _MainTexture;
	float4 _PrimaryColor;
	float4 _SecondaryColor;
	float _Tween;

	fixed4 frag(v2f i) : SV_Target
	{
		float4 texture1 = tex2D(_MainTexture, i.uv) * _PrimaryColor;
		float4 texture2 = tex2D(_MainTexture, i.uv) * _SecondaryColor;

		float4 color = lerp(texture1, texture2, _Tween);

		return color;
	}
		ENDCG
	}
	}
}

