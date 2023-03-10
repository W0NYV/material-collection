Shader "W0NYV/Flat"
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

            #include "Flat.cginc"
            
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

            #include "Flat.cginc"
            
            ENDCG
        }
    }
}
