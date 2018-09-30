Shader "ImageEffects/PsychedelicEffect"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_RampTexture("Ramp Texture", 2D) = "white"{}
		_Speed("Color Speed", Range(1, 10)) = 1
	}
	SubShader
	{
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
			sampler2D _RampTexture;
			float _Speed;

			fixed4 frag (v2f i) : SV_Target
			{
				float4 col = tex2D(_MainTex, i.uv);
				float4 rampedTexture = tex2D(_RampTexture, col.r + _Time.x * _Speed);

				return rampedTexture;
			}

			ENDCG
		}
	}
}
