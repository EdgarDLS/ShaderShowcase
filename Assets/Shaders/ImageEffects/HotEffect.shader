Shader "ImageEffects/HotEffect"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_DisplacementTexture("Texture", 2D) = "white" {}
		_Magnitude("Magnitude", Range(0, 0.1)) = 1
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
			sampler2D _DisplacementTexture;
			float _Magnitude;

			fixed4 frag (v2f i) : SV_Target
			{
				float2 displacement = tex2D(_DisplacementTexture, float2(i.uv.x + _Time.x, i.uv.y)).xy ;
				displacement = ((displacement * 2) - 1) * _Magnitude ;

				float4 col = tex2D(_MainTex, i.uv + displacement);
				return col;
			}

			ENDCG
		}
	}
}
