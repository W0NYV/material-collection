Shader "Hidden/Glow"
{
	Properties
	{
		[HideInInspector] _MainTex ("Texture", 2D) = "white" {}
		[IntRange] _FilterSize ("FilterSize", Range(1, 30)) = 1
		_Threshold ("Threshold", Range(1, 0)) = 0.6
		_Intensity ("Intensity", Range(0, 10)) = 3
	}
	SubShader
	{
		// No culling or depth
		Cull Off ZWrite Off ZTest Always
		
		//全てのPassに埋め込めれられる
		CGINCLUDE

		#include "UnityCG.cginc"

		sampler2D _MainTex;
		float4 _MainTex_TexelSize;
		int _FilterSize;

		ENDCG
		
		//デバッグ用のPass		
		Pass
		{
			CGPROGRAM

			#pragma vertex vert_img
			#pragma fragment frag

			fixed4 frag(v2f_img i) : SV_Target
			{
				return tex2D(_MainTex, i.uv);
			}
			
			ENDCG
		}
		
		//ある閾値以上の輝度を抜き出すPass
		Pass
		{
			CGPROGRAM

			#pragma vertex vert_img
			#pragma fragment frag

			float _Threshold;
			float _Intensity;

			fixed4 frag(v2f_img i) : SV_Target
			{
				float4 col = tex2D(_MainTex, i.uv);
				return max(col - _Threshold, 0) * _Intensity;
			}
			
			ENDCG
		}

		//合成するPass
		Pass
		{
			CGPROGRAM

			#pragma vertex vert_img
			#pragma fragment frag

			sampler2D _BrightnessTex;

			fixed4 frag(v2f_img i) : SV_Target
			{
				float4 col = tex2D(_MainTex, i.uv);
				float4 brightness = tex2D(_BrightnessTex, i.uv);

				return saturate(col + brightness);
			}
			
			ENDCG
		}
		
		//ぼかすPass
		Pass
		{
			CGPROGRAM

			#pragma vertex vert_img
			#pragma fragment frag

			fixed4 frag(v2f_img i) : SV_Target
			{

				float4 col = float4(0, 0, 0, 1);

				for(int x = -_FilterSize; x < _FilterSize; x++)
				{
					for(int y = -_FilterSize; y < _FilterSize; y++)
					{
						float2 temp = float2(i.uv.x + _MainTex_TexelSize.x * x,
											 i.uv.y + _MainTex_TexelSize.y * y);

						col.rgb += tex2D(_MainTex, temp).rgb;
					}
				}

				col.rgb /= pow(_FilterSize * 2 + 1, 2);

				return col;
				
			}
			
			ENDCG
		}
		
		Pass
		{
			CGPROGRAM

			#pragma vertex vert_img
			#pragma fragment frag

			fixed4 frag(v2f_img i) : SV_Target
			{

				float4 col = float4(0, 0, 0, 1);

				for(int x = -_FilterSize; x < _FilterSize; x++)
				{
					float2 temp = float2(i.uv.x + _MainTex_TexelSize.x * x, i.uv.y);
					col.rgb += tex2D(_MainTex, temp).rgb;
				}

				for(int y = -_FilterSize; y < _FilterSize; y++)
				{
					float2 temp = float2(i.uv.x, i.uv.y + _MainTex_TexelSize.y * y);
					col.rgb += tex2D(_MainTex, temp).rgb;
				}

				col.rgb /= pow(_FilterSize * 2 + 1, 2);

				return col;
				
			}
			
			ENDCG
		}
			
	}
}