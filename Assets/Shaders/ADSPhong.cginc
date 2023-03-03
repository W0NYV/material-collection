#ifndef ADS_PHONG_INCLUDED
#define ADS_PHONG_INCLUDED

#include "UnityCG.cginc"
#include "Lighting.cginc"
#include "AutoLight.cginc"

float4 _MainColor;
float _Shiness;

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

    float3 view = normalize(_WorldSpaceCameraPos - i.vertexW);
    float3 rflt = normalize(reflect(-light, normal));

    float diffuse = saturate(dot(normal, light));

    float specular = _Shiness != 0 ?
                     pow(saturate(dot(view, rflt)), _Shiness) :
                     0;

    float3 ambient = ShadeSH9(half4(normal, 1));

    fixed4 col = diffuse * _MainColor * _LightColor0
            + specular * _LightColor0;

    col.rgb += ambient;
    
    return col * attenuation;
}

#endif