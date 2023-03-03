﻿Shader "W0NYV/Phong/Blinn-Phong"
{
    Properties
    {
        _MainColor("Main Color", Color) = (1, 1, 1, 1)
        _Shiness("Shiness", Range(0, 150)) = 10
    }
    
    SubShader
    {
        Pass
        {
            Tags
            {
                "LightMode" = "ForwardBase"
            }
            
            CGPROGRAM

            #pragma vertex vert
            #pragma fragment frag

            #include "Blinn.cginc"
            
            ENDCG
        }
        
        Pass
        {
            Tags
            {
                "LightMode" = "ForwardAdd"
            }
            
            Blend One One
            
            CGPROGRAM

            #pragma multi_compile_fwdadd
            #pragma vertex vert
            #pragma fragment frag

            #include "Blinn.cginc"
            
            ENDCG
        }
    }
}
