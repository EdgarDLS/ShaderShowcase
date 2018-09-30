Shader "ImageEffects/PixelatedEffect"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_Pixel_H("Pixel Height",  Range(1, 150)) = 100
		_Pixel_W("Pixel Width",  Range(1, 150)) = 100
		_Pixelation("Pixelation",  Range(0, 1)) = 1
		_ScreenPercent("Screen Percentage", Range(0, 100)) = 50
	}
	SubShader
	{
		Cull Off ZWrite Off ZTest Always

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
			};
			
			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = v.uv;
				return o;
			}
			
			sampler2D _MainTex;
			float _Pixel_H;
			float _Pixel_W;
			float _Pixelation;
			float2 pixelatedUV;
			float _ScreenPercent;

			fixed4 frag (v2f i) : SV_Target
			{
				// Easy pixelation
				// float2 newUV = floor(i.uv * 60) / 60;

				pixelatedUV.x = (i.uv.x * (1.f - _Pixelation)) + (_Pixelation * floor(i.uv.x * _Pixel_W) / _Pixel_W);
				pixelatedUV.y = (i.uv.y * (1.f - _Pixelation)) + (_Pixelation * floor(i.uv.y * _Pixel_H) / _Pixel_H);

				float4 col = tex2D(_MainTex, pixelatedUV);

				if (i.uv.x < _ScreenPercent / 100)
				{
					return col;
				}
				else
				{
					return tex2D(_MainTex, i.uv);
				}
			}

			ENDCG
		}
	}
}
