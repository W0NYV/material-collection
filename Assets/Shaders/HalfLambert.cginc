﻿#ifndef HALF_LAMBERT_INCLUDED
#define HALF_LAMBERT_INCLUDED

#include "UnityCG.cginc"
#include "Lighting.cginc"
#include "AutoLight.cginc"

float4 _MainColor;

struct v2f
{
    float4 vertex : SV_POSITION;
    float3 vertexW : TEXCOORD0;
    float3 normal : TEXCOORD1;
};

v2f vert(appdata_base v)
{
    v2f o;

    o.vertex = UnityObjectToClipPos(v.vertex);
    o.vertexW = (mul(unity_ObjectToWorld, v.vertex));
    o.normal = normalize(UnityObjectToWorldNormal(v.normal));

    return o;
}

fixed4 frag(v2f i) : SV_Target
{
    UNITY_LIGHT_ATTENUATION(attenuation, i, i.vertexW);

    float3 normal = normalize(i.normal);
    
    float3 light = normalize(_WorldSpaceLightPos0.w == 0 ?
                             _WorldSpaceLightPos0.xyz :
                             _WorldSpaceLightPos0.xyz - i.vertexW); 

    float diffuse = saturate(dot(normal, light));

    diffuse = diffuse * 0.5 + 0.5;
    diffuse = diffuse * diffuse;

    fixed4 col = diffuse * _MainColor * _LightColor0;
    
    return col * attenuation;
}

#endif