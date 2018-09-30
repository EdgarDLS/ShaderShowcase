// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "FirstShader/PixelLuminance"
{
	Properties
	{
		_MainTexture("Texture", 2D) = "white" {}
		_Color("Color", color) = (1, 1, 1, 1)
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
			
			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = v.uv;
				return o;
			}
			
			sampler2D _MainTexture;
			float4 _Color;

			fixed4 frag (v2f i) : SV_Target
			{
				float4 color = tex2D(_MainTexture, i.uv);
				float pixelLuminance = color.r * 0.3 + color.g * 0.59 + color.b * 0.11;
				float4 grayScale = float4 (pixelLuminance, pixelLuminance, pixelLuminance, color.a);
				return grayScale * _Color;
			}
			ENDCG
		}
	}
}
