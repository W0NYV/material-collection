#ifndef LAMBERT_GOURAUD_INCLUDED
#define LAMBERT_GOURAUD_INCLUDED

#include "UnityCG.cginc"
#include "Lighting.cginc"
#include "AutoLight.cginc"

float4 _MainColor;

struct v2f
{
    float4 vertex : SV_POSITION;
    float3 vertexW : TEXCOORD0;
    float4 color : TEXCOORD1;
};

v2f vert(appdata_base v)
{
    v2f o;

    o.vertex = UnityObjectToClipPos(v.vertex);
    o.vertexW = (mul(unity_ObjectToWorld, v.vertex));

    float3 normal = normalize(UnityObjectToWorldNormal(v.normal));
    float3 light = normalize(_WorldSpaceLightPos0.w == 0 ?
                             _WorldSpaceLightPos0.xyz :
                             _WorldSpaceLightPos0.xyz - o.vertexW); 

    float diffuse = saturate(dot(normal, light));

    o.color = diffuse * _MainColor * _LightColor0;

    return o;
}

fixed4 frag(v2f i) : SV_Target
{
    UNITY_LIGHT_ATTENUATION(attenuation, i, i.vertexW);
    return i.color * attenuation;
}

#endif