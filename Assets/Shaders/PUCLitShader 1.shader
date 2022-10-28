Shader "PUCLitShaderWind"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _WindSelect("WindSelect", Range(0,1)) = 0.5
        _WindForce("WindForce", Range(0,0.002)) = 0.5
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

                float _WindSelect;
                float _WindForce;
                texture2D _MainTex;
                SamplerState sampler_MainTex;


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
                    half4 color : COLOR0;
                };

                Varyings vert(Attributes Input)
                {
                    Varyings Output;
                    float3 position = Input.position.xyz;

                    if (Input.color.y > _WindSelect) {
                        position = Input.position.xyz + Input.normal * (-_WindForce + cos(_Time.w + Input.position.y * 100) * _WindForce);
                    }

                    Output.positionVAR = TransformObjectToHClip(position);

                    Output.uvVAR = Input.uv;
                  
                    Light l = GetMainLight();
                   
                    float intensity = dot(l.direction, TransformObjectToWorldNormal(Input.normal));
                    Output.color = Input.color* intensity;
                    

                    return Output;
                }
                half4 frag(Varyings Input) :SV_TARGET
                { 
                    half4 color = Input.color;

                    color *= _MainTex.Sample(sampler_MainTex, Input.uvVAR);
                    
                    return color;
                }



            ENDHLSL
        }
    }
}
