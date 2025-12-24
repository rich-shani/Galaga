// Simple Bloom Post-Processing Shader (5-tap)
varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform float intensity;      // Bloom intensity (0.0 to 1.0)
uniform float threshold;      // Brightness threshold (0.5 to 1.0)
uniform vec2 texel_size;      // 1.0 / texture_dimensions

void main() {
    // Sample original color
    vec4 color = texture2D(gm_BaseTexture, v_vTexcoord);

    // Extract bright pixels (luminance threshold)
    float luminance = dot(color.rgb, vec3(0.299, 0.587, 0.114));
    
    // Simple 5-tap blur (center + 4 directions)
    vec3 bloom = vec3(0.0);
    
    // Center sample
    if (luminance > threshold) {
        bloom += color.rgb * 0.4;
    }
    
    // Cardinal directions (up, down, left, right)
    vec2 blur_radius = texel_size * 3.0;
    
    vec4 up = texture2D(gm_BaseTexture, v_vTexcoord + vec2(0.0, -1.0) * blur_radius);
    if (dot(up.rgb, vec3(0.299, 0.587, 0.114)) > threshold) {
        bloom += up.rgb * 0.15;
    }
    
    vec4 down = texture2D(gm_BaseTexture, v_vTexcoord + vec2(0.0, 1.0) * blur_radius);
    if (dot(down.rgb, vec3(0.299, 0.587, 0.114)) > threshold) {
        bloom += down.rgb * 0.15;
    }
    
    vec4 left = texture2D(gm_BaseTexture, v_vTexcoord + vec2(-1.0, 0.0) * blur_radius);
    if (dot(left.rgb, vec3(0.299, 0.587, 0.114)) > threshold) {
        bloom += left.rgb * 0.15;
    }
    
    vec4 right = texture2D(gm_BaseTexture, v_vTexcoord + vec2(1.0, 0.0) * blur_radius);
    if (dot(right.rgb, vec3(0.299, 0.587, 0.114)) > threshold) {
        bloom += right.rgb * 0.15;
    }

    // Combine original with bloom
    vec3 result = color.rgb + (bloom * intensity);

    gl_FragColor = vec4(result, color.a) * v_vColour;
}