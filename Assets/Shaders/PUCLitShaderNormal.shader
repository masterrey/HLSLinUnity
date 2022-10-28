Shader "PUCLitShaderNormal"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _NormalTex("Texture", 2D) = "white" {}
        _NormalForce("NormalForce", Range(-2,2)) = 1
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
                float _NormalForce;

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
                    Output.normalVar = TransformObjectToWorldNormal(Input.normal);

                    return Output;
                }

                half4 frag(Varyings Input) :SV_TARGET
                { 
                    half4 color = Input.colorVar;
                    
                    Light l = GetMainLight();

                   half4 normalmap= _NormalTex.Sample(sampler_NormalTex, Input.uvVAR)*2-1;

                   float intensity = dot(l.direction, Input.normalVar+ normalmap.xzy* _NormalForce);

                    color *= _MainTex.Sample(sampler_MainTex, Input.uvVAR);
                    color *= intensity;
                    return color;
                }



            ENDHLSL
        }
    }
}
