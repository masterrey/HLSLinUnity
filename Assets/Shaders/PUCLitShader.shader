Shader "PUCLitShader"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _NormalTex("Texture", 2D) = "white" {}
        
    }
        SubShader
        {
            Tags { "RenderType" = "Opaque" }
            LOD 100
            Pass
            {
                HLSLPROGRAM
                    #pragma vertex vert
                    #pragma fragment frag
                    #include  "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
                    #include  "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"

               
                texture2D _MainTex;
                SamplerState sampler_MainTex;
                texture2D _NormalTex;
                SamplerState sampler_NormalTex;


                struct Attributes
                {
                    float4 position :POSITION;
                    half2 uv       :TEXCOORD0;
                    half3 normal : NORMAL;
                    half4 color : COLOR;
                };
            
                struct Varyings 
                {
                    float4 positionVAR :SV_POSITION;
                    half2 uvVAR       : TEXCOORD0;
                    half3 normalVar : NORMAL;
                    half4 colorVar : COLOR0;
                };

                Varyings vert(Attributes Input)
                {
                    Varyings Output;
                    float3 position = Input.position.xyz;
                    Output.positionVAR = TransformObjectToHClip(position);
                    Output.uvVAR = Input.uv;
                    Output.colorVar = Input.color;
                    

                    return Output;
                }

                half4 frag(Varyings Input) :SV_TARGET
                { 
                    half4 color = Input.color;
                    
                    Light l = GetMainLight();

                   // float intensity = dot(l.direction, TransformObjectToWorldNormal(Input.normal));

                    color *= _MainTex.Sample(sampler_MainTex, Input.uvVAR);
                    
                    return color;
                }



            ENDHLSL
        }
    }
}
