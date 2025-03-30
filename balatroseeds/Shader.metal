#include <metal_stdlib>
using namespace metal;

struct VertexOut {
    float4 position [[position]];
    float2 uv;
};

// Ensure explicit packing to match Swift side
struct ShaderParameters {
    float time;
    float2 resolution;
    float2 offset;
    float4 colour_1;
    float4 colour_2;
    float4 colour_3;
    float spin_rotation_speed;
    float move_speed;
    float contrast;
    float lighting;
    float spin_amount;
    float pixel_filter;
    uint is_rotating;  // Using uint instead of bool for consistent size
};

// Add a simple vertex shader if it's missing
vertex VertexOut vertexShader(uint vertexID [[vertex_id]],
                              constant float *vertices [[buffer(0)]]) {
    VertexOut out;
    float2 position = float2(vertices[vertexID * 6], vertices[vertexID * 6 + 1]);
    out.position = float4(position, 0, 1);
    out.uv = float2(vertices[vertexID * 6 + 4], vertices[vertexID * 6 + 5]);
    return out;
}

fragment float4 balatroFragment(VertexOut in [[stage_in]],
                             constant ShaderParameters &params [[buffer(0)]]) {
    float2 screenSize = params.resolution;
    float2 screen_coords = in.uv * screenSize;
    
    // Pixel size based on filter
    float pixel_size = length(screenSize.xy) / params.pixel_filter;
    float2 uv = (floor(screen_coords.xy*(1./pixel_size))*pixel_size - 0.5*screenSize.xy)/length(screenSize.xy) - params.offset;
    float uv_len = length(uv);

    // Calculate rotation
    float SPIN_EASE = 1.0;
    float speed = (params.spin_rotation_speed * SPIN_EASE * 0.2);
    if (params.is_rotating > 0) {  // Using uint comparison
        speed = params.time * speed;
    }
    speed += 302.2;
    
    float new_pixel_angle = (atan2(uv.y, uv.x)) + speed - SPIN_EASE * 20.0 * (1.0 * params.spin_amount * uv_len + (1.0 - 1.0 * params.spin_amount));
    float2 mid = (screenSize.xy / length(screenSize.xy)) / 2.0;
    uv = (float2((uv_len * cos(new_pixel_angle) + mid.x), (uv_len * sin(new_pixel_angle) + mid.y)) - mid);

    uv *= 30.0;
    speed = params.time * (params.move_speed);
    float2 uv2 = float2(uv.x + uv.y);

    // Apply iterations to create fluid pattern
    for (int i = 0; i < 5; i++) {
        uv2 += sin(max(uv.x, uv.y)) + uv;
        uv += 0.5 * float2(cos(5.1123314 + 0.353 * uv2.y + speed * 0.131121), sin(uv2.x - 0.113 * speed));
        uv -= 1.0 * cos(uv.x + uv.y) - 1.0 * sin(uv.x * 0.711 - uv.y);
    }

    // Calculate color mixing
    float contrast_mod = (0.25 * params.contrast + 0.5 * params.spin_amount + 1.2);
    float paint_res = min(2.0, max(0.0, length(uv) * (0.035) * contrast_mod));
    float c1p = max(0.0, 1.0 - contrast_mod * abs(1.0 - paint_res));
    float c2p = max(0.0, 1.0 - contrast_mod * abs(paint_res));
    float c3p = 1.0 - min(1.0, c1p + c2p);
    
    float light = (params.lighting - 0.2) * max(c1p * 5.0 - 4.0, 0.0) + params.lighting * max(c2p * 5.0 - 4.0, 0.0);
    float4 ret_col = (0.3/params.contrast) * params.colour_1 +
                     (1.0 - 0.3/params.contrast) * (params.colour_1 * c1p + params.colour_2 * c2p + float4(c3p * params.colour_3.rgb, c3p * params.colour_1.a)) + light;
    return ret_col;
}
