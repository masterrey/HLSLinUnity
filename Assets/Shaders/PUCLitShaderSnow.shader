Shader "PUCLitShaderSnow"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _OldTex("OldTexture", 2D) = "white" {}
        _WindSelect("WindSelect", Range(0,1)) = 0.5
        _WindForce("WindForce", Range(0,0.002)) = 0.5
        _LeafSelect("SnowForce", Range(0,5)) = 0.5
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
                float _LeafSelect;
                texture2D _MainTex;
                float4 _MainTex_ST;
                SamplerState sampler_MainTex;
                texture2D _OldTex;
                SamplerState sampler_OldTex;


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
                    
                    half3 normalVAR : NORMAL;
                };

                Varyings vert(Attributes Input)
                {
                    Varyings Output;
                    float3 position = Input.position.xyz;

                    if (Input.color.y > _WindSelect) {
                        position = Input.position.xyz + Input.normal * (-_WindForce + cos(_Time.w + Input.position.y * 100) * _WindForce);
                    }

                    Output.positionVAR = TransformObjectToHClip(position);
                   
                    Output.uvVAR = (Input.uv * _MainTex_ST.xy + _MainTex_ST.zw);//tiling
                   
                    Output.normalVAR = Input.normal;
                    Output.color = Input.color;
                    

                    return Output;
                }
                half4 frag(Varyings Input) :SV_TARGET
                { 
                    half4 color = Input.color;
                    color *= _MainTex.Sample(sampler_MainTex, Input.uvVAR);
                    float snowforce = dot(TransformObjectToWorldNormal(Input.normalVAR), float3(0, 1, 0));

                   
                    if (snowforce >0) {
                     
                        color += _OldTex.Sample(sampler_OldTex, Input.uvVAR)* snowforce * _LeafSelect;
                    }
                   Light l = GetMainLight();

                   float intensity = dot(l.direction, TransformObjectToWorldNormal(Input.normalVAR));

                    return color* intensity;
                }



            ENDHLSL
        }
    }
}
