shader_type canvas_item;

// Shared
uniform vec2 wind_dir = vec2(0.5, 0.8);
uniform float wind_speed : hint_range(0.0, 5.0) = 1.2;

uniform vec2 current_a_dir = vec2(1.0, 0.3);
uniform vec2 current_b_dir = vec2(-0.3, 1.0);
uniform float current_a_speed : hint_range(0.0, 5.0) = 0.1;
uniform float current_b_speed : hint_range(0.0, 5.0) = 0.5;
uniform float current_a_frequency : hint_range(0.0, 2.0) = 0.2;
uniform float current_b_frequency : hint_range(0.0, 2.0) = 0.15;

// Deep water
uniform sampler2D noise_texture : repeat_enable;
uniform float time_scale : hint_range(0.0, 1.0) = 0.05;
uniform vec4 deep_color_a : source_color = vec4(0.0, 0.6, 1.0, 1.0);
uniform vec4 deep_color_b : source_color = vec4(0.0, 0.6, 0.5, 1.0);

// Waves
uniform sampler2D wave_noise_texture : repeat_enable;
uniform float wave_scale : hint_range(0.0, 5.0) = 1.5;
uniform float wave_strength : hint_range(0.0, 1.0) = 0.5;
uniform vec4 wave_crest_color : source_color = vec4(0.3, 0.75, 0.9, 1.0);

// Foam
uniform sampler2D foam_noise_texture : repeat_enable;
uniform float foam_scale : hint_range(0.01, 10.0) = 0.3;
uniform float foam_noise_scale : hint_range(0.1, 5.0) = 0.1;
uniform float foam_threshold : hint_range(0.0, 1.0) = 0.1;
uniform float foam_strength : hint_range(0.0, 1.0) = 0.8;
uniform vec4 foam_color : source_color = vec4(0.9, 0.95, 1.0, 1.0);

// Anti-repetition 
uniform float world_scale : hint_range(0.0001, 0.02) = 0.005;
uniform float layer_b_scale : hint_range(1.0, 4.0) = 2.2;
uniform float layer_c_scale : hint_range(1.0, 8.0) = 5.7;
uniform float warp_strength : hint_range(0.0, 1.0) = 0.6;

float layered_noise(sampler2D tex, vec2 uv, vec2 t) {
    float a = texture(tex, uv + t).r;
    float b = texture(tex, uv * layer_b_scale + t * 1.3 + vec2(0.2, 0.7)).r;
    float c = texture(tex, uv * layer_c_scale + t * 0.7 + vec2(0.5, 0.3)).r;
    return a * 0.5 + b * 0.3 + c * 0.2;
}

vec2 domain_warp(sampler2D tex, vec2 uv, float t, float strength) {
    float wx = texture(tex, uv * 0.4 + t * 0.03).r;
    float wy = texture(tex, uv * 0.4 + t * 0.03 + vec2(0.43, 0.71)).r;
    return (vec2(wx, wy) * 2.0 - 1.0) * strength;
}

void fragment() {
    // World UVs!! These are p much so we get less repeating and is reliant on set stuff.

    vec2 world_uv = (SCREEN_UV + TIME * 0.0) / world_scale;

    // Current speeds (oscillating) - I know Fiachna did some current stuff, unsure on how to connect these to those...
    vec2 cur_a = normalize(current_a_dir);
    vec2 cur_b = normalize(current_b_dir);
    float speed_a = current_a_speed * (sin(TIME * current_a_frequency) * 0.5 + 0.5);
    float speed_b = current_b_speed * (sin(TIME * current_b_frequency) * 0.5 + 0.5);

    vec2 warp = domain_warp(noise_texture, world_uv, TIME, warp_strength);

    // --- Deep water ---
    vec2 deep_uv = world_uv + warp + TIME * time_scale;
    float noise = layered_noise(noise_texture, deep_uv, vec2(0.0));
    vec4 deep_water = mix(deep_color_a, deep_color_b, noise);

    // --- Waves ---
    vec2 wave_uv = world_uv + warp;
    float wave_a = layered_noise(wave_noise_texture,
        wave_uv * wave_scale + cur_a * TIME * 0.01 * speed_a,
        vec2(0.0));
    float wave_b = layered_noise(wave_noise_texture,
        wave_uv * wave_scale + cur_b * TIME * 0.01 * speed_b,
        vec2(0.17, 0.53));

    float wave = max(wave_a, wave_b);
    wave = smoothstep(0.45, 0.55, wave);
    vec4 surface = mix(deep_water, wave_crest_color, wave * wave_strength);

    // --- Foam ---
    // more warp! more chaos!
    vec2 foam_warp = domain_warp(noise_texture, world_uv * 0.5, TIME, warp_strength * 0.5);
    vec2 foam_uv_a = (world_uv + foam_warp) * foam_scale + cur_a * TIME * 0.1 * speed_a;
    vec2 foam_uv_b = (world_uv + foam_warp) * foam_scale + cur_b * TIME * 0.1 * speed_b;

    float foam_a = layered_noise(foam_noise_texture, foam_uv_a, vec2(0.0));
    float foam_b = layered_noise(foam_noise_texture, foam_uv_b, vec2(0.31, 0.62));

    float foam_cells = max(foam_a, foam_b);
    float foam = smoothstep(foam_threshold, foam_threshold + 0.4, foam_cells);

    vec4 final = mix(surface, foam_color, clamp(foam * foam_strength, 0.0, 1.0));
    COLOR = final;
}