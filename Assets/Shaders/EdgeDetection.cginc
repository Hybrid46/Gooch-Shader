//Edge Detection from Depth texture in URP/HDRP by Gábor Rácz: https://github.com/Hybrid46

TEXTURE2D(_CameraDepthTexture);
SamplerState sampler_CameraDepthTexture;
float4 _CameraDepthTexture_TexelSize;

void EdgeDetection_float(float3 InColor, float2 screenUV, float edgeWidth, out float3 OutColor)
{
    float edgeWidthTexels = edgeWidth * _CameraDepthTexture_TexelSize;

    //neighbour pixels
    float n = Linear01Depth(SAMPLE_TEXTURE2D(_CameraDepthTexture,sampler_CameraDepthTexture, screenUV + edgeWidthTexels * float2(0, 1)).r,_ZBufferParams);
    float e = Linear01Depth(SAMPLE_TEXTURE2D(_CameraDepthTexture,sampler_CameraDepthTexture, screenUV + edgeWidthTexels * float2(1, 0)).r,_ZBufferParams);
    float s = Linear01Depth(SAMPLE_TEXTURE2D(_CameraDepthTexture,sampler_CameraDepthTexture, screenUV + edgeWidthTexels * float2(0, -1)).r,_ZBufferParams);
    float w = Linear01Depth(SAMPLE_TEXTURE2D(_CameraDepthTexture,sampler_CameraDepthTexture, screenUV + edgeWidthTexels * float2(-1, 0)).r,_ZBufferParams);
    float ne = Linear01Depth(SAMPLE_TEXTURE2D(_CameraDepthTexture,sampler_CameraDepthTexture, screenUV + edgeWidthTexels * float2(1, 1)).r,_ZBufferParams);
    float nw = Linear01Depth(SAMPLE_TEXTURE2D(_CameraDepthTexture,sampler_CameraDepthTexture, screenUV + edgeWidthTexels * float2(-1, 1)).r,_ZBufferParams);
    float se = Linear01Depth(SAMPLE_TEXTURE2D(_CameraDepthTexture,sampler_CameraDepthTexture, screenUV + edgeWidthTexels * float2(1, -1)).r,_ZBufferParams);
    float sw = Linear01Depth(SAMPLE_TEXTURE2D(_CameraDepthTexture,sampler_CameraDepthTexture, screenUV + edgeWidthTexels * float2(-1, -1)).r,_ZBufferParams);

    OutColor = InColor;

    //if the neighbour pixel difference is bigger than 0.1 it means its an edge
    if (n - s > 0.1 || w - e > 0.1 || e - w > 0.1 || s - n > 0.1)
        OutColor = 0.0;
                
    if (nw - se > 0.1 || ne - sw > 0.1 || se - nw > 0.1 || sw - ne > 0.1)
        OutColor = 0.0;
}