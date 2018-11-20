Shader "ForceField/WinstonField"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_Color("Color", Color) = (1,1,1,1)
		_ColorIntersection("Intersection Color", Color) = (1,1,1,1)
		_IntersectionStrength("Intersection Strength", Range(0.0,1)) = 0.5
	}
	SubShader
	{
		Tags
		{
			"RenderType" = "Transparent"
			"Queue" = "Transparent"
		}

		Pass
		{
			Blend One One
			ZWrite Off
			Cull Off

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
				float2 screenuv : TEXCOORD1;
				float3 viewDir : TEXCOORD2;
				float3 objectPos : TEXCOORD3;
				float4 vertex : SV_POSITION;
				float depth : DEPTH;
				float3 normal : NORMAL;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			
			sampler2D _CameraDepthNormalsTexture;
			fixed4 _Color;
			fixed4 _ColorIntersection;
			float _IntersectionStrength;
			
			v2f vert (appdata v)
			{
				v2f o;
				
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);

				o.screenuv = ((o.vertex.xy / o.vertex.w) + 1) / 2;
				o.screenuv.y = 1 - o.screenuv.y;
				o.depth = -mul(UNITY_MATRIX_MV, v.vertex).z * _ProjectionParams.w;

				o.objectPos = v.vertex.xyz;

				return o;
			}

			float triWave(float t, float offset, float yOffset)
			{
				return saturate(abs(frac(offset + t) * 2 - 1) + yOffset);
			}

			fixed4 texColor(v2f i, float rim)
			{
				fixed4 mainTex = tex2D(_MainTex, i.uv);
				mainTex.r *= triWave(_Time.x * 5, abs(i.objectPos.y) * 2, -0.7) * 6;
				// I ended up saturaing the rim calculation because negative values caused weird artifacts
				//mainTex.g *= saturate(rim) * (sin(_Time.z + mainTex.b * 5) + 1);
				return mainTex.r * _Color;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				float screenDepth = DecodeFloatRG(tex2D(_CameraDepthNormalsTexture, i.screenuv).zw);
				float diff = screenDepth - i.depth;
				float intersect = 0;

				if (diff > 0)
					intersect = 1 - smoothstep(0, _ProjectionParams.w * _IntersectionStrength, diff);

				float rim = 1 - abs(dot(i.normal, normalize(i.viewDir))) * 2;		
				
				fixed4 hexTexture = texColor(i, rim);

				//fixed4 niceColor = fixed4(lerp(_Color.rgb, fixed3(1, 1, 1), pow(intersect, 4)), 1);

				fixed4 col = _Color * _Color.a + (intersect * _ColorIntersection) + hexTexture;
				return col;
			}
			ENDCG
		}
	}
}
