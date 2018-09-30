// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "FirstShader/MultiplyTextureColor"
{
	Properties
	{
		_MainTexture("Texture", 2D) = "white" {}
		_Tween("Tween", range (1, 10)) = 1
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
			int _Tween;

			fixed4 frag (v2f i) : SV_Target
			{
				float4 color = tex2D(_MainTexture, i.uv * _Tween) * float4(i.uv.x, i.uv.y, 1, 1);
				return color;
			}
			ENDCG
		}
	}
}
