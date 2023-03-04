Shader "Hidden/MovingAverage"
{
	Properties
	{
		[HideInInspector]
		_MainTex ("Texture", 2D) = "white" {}
		
		_FilterSize ("FilterSize", Range(1.0, 30.0)) = 1.0
	}
	SubShader
	{
		// No culling or depth
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
			float4 _MainTex_TexelSize;
			float _FilterSize;

			fixed4 frag (v2f i) : SV_Target
			{
				//移動平均フィルターの実装

				float filterSize = _FilterSize;
				
				float4 color = float4(0, 0, 0, 1);

				for(int x = -filterSize; x < filterSize; x++)
				{
					for(int y = -filterSize; y < filterSize; y++)
					{
						float2 temp = float2(i.uv.x + _MainTex_TexelSize.x * x,
											 i.uv.y + _MainTex_TexelSize.y * y);

						color.rgb += tex2D(_MainTex, temp).rgb;
					}	
				}

				color.rgb /= pow(filterSize * 2 + 1, 2);

				return  color;
				
			}
			ENDCG
		}
	}
}