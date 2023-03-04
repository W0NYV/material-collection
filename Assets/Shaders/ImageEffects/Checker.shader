Shader "Hidden/Checker"
{
	Properties
	{
		[HideInInspector]
		_MainTex ("Texture", 2D) = "white" {}
		
		_Grid ("Grid", Range(1.0, 10.0)) = 1.0 
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
			float _Grid;

			fixed4 frag (v2f i) : SV_Target
			{

				//ぱっと思いついた方法やけどあんまかもな
				float2 f = frac(i.uv * _Grid);
				
				float s = step(f.x, 0.5);
				float s2 = step(f.y, 0.5);

				float checker = (s*s2) + ((1-s)*(1-s2));
				
				fixed4 col = fixed4((fixed3)checker, 1.0);
			
				return col;
			}
			ENDCG
		}
	}
}