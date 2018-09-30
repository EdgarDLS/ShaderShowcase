// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "FirstShader/TextureTween"
{
	Properties
	{
		_MainTexture("Texture", 2D) = "white" {}
		_SecondTexture("Second Texture", 2D) = "white" {}
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
	sampler2D _SecondTexture;
	float _Tween;

	fixed4 frag(v2f i) : SV_Target
	{
		float4 texture1 = tex2D(_MainTexture, i.uv);
		float4 texture2 = tex2D(_SecondTexture, i.uv);

		float4 color = lerp(texture1, texture2, _Tween);

		return color;
	}
		ENDCG
	}
	}
}
