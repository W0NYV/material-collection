Shader "W0NYV/Phong/Lambert"
{
    Properties
    {
        _MainColor("Main Color", Color) = (1, 1, 1, 1)
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

            #include "LambertPhong.cginc"
            
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

            #include "LambertPhong.cginc"
            
            ENDCG
        }
    }
}
