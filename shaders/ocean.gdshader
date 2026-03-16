shader_type canvas_item;

// Shared
// We don't use these yet, but might be worth holding onto
uniform vec2 wind_dir = vec2(0.5, 0.8);
uniform float wind_speed : hint_range(0.0, 5.0) = 1.2;

uniform vec2 current_a_dir = vec2(0.7, 0.3);
uniform vec2 current_b_dir = vec2(-0.3, 0.7);
uniform float current_a_speed : hint_range(0.0, 5.0) = 0.2;
uniform float current_b_speed : hint_range(0.0, 5.0) = 0.1;
uniform float current_a_frequency : hint_range(0.0, 2.0) = 0.2;
uniform float current_b_frequency : hint_range(0.0, 2.0) = 0.15;

// Deep water
uniform sampler2D noise_texture : repeat_enable;
uniform float time_scale : hint_range(0.0, 1.0) = 0.05;
uniform vec4 deep_color_a : source_color = vec4(0.0, 0.6, 1.0, 1.0);
uniform vec4 deep_color_b : source_color = vec4(0.0, 0.6, 0.5, 1.0);

// Waves
uniform sampler2D wave_noise_texture : repeat_enable;
uniform float wave_scale : hint_range(0.0, 5.0) = 1.0;
uniform float wave_strength : hint_range(0.0, 1) = 0.5;
uniform vec4 wave_crest_color : source_color = vec4(0.3, 0.75, 0.9, 1.0);

// Foam
uniform sampler2D foam_noise_texture : repeat_enable;
uniform float foam_scale : hint_range(1.0, 50.0) = 10.0;
uniform float foam_noise_scale : hint_range(0.1, 5.0) = 2.0;
uniform float foam_threshold : hint_range(0.0, 1.0) = 0.5;
uniform float foam_strength : hint_range(0.0, 1.0) = 0.8;
uniform vec4 foam_color : source_color = vec4(0.9, 0.95, 1.0, 1.0);

void fragment() {
	// Deep water
	vec2 uv = UV + TIME * time_scale;
	float noise = texture(noise_texture, uv).r;
	vec4 deep_water = mix(deep_color_a, deep_color_b, noise);
	
	vec2 current_a = normalize(current_a_dir);
	vec2 current_b = normalize(current_b_dir);
	
	float speed_a = current_a_speed * (sin(TIME * current_a_frequency) * 0.5 + 0.5);
	float speed_b = current_a_speed * (sin(TIME * current_b_frequency) * 0.5 + 0.5);
	
	float wave_a = texture(wave_noise_texture, UV * wave_scale + current_a * TIME * 0.01 * speed_a).r;
	float wave_b = texture(wave_noise_texture, UV * wave_scale + current_b * TIME * 0.01 * speed_b).r;
	
	float wave = max(wave_a, wave_b);
	wave = smoothstep(0.45, 0.55, wave);
	
	vec4 surface = mix(deep_water, wave_crest_color, wave * wave_strength);
	
	vec2 foam_warp = vec2(
	    texture(noise_texture, UV * 0.5 + TIME * 0.02).r,
	    texture(noise_texture, UV * 0.5 + TIME * 0.02 + vec2(0.4)).r
	) * 2.0 - 1.0;
	vec2 foam_uv_a = (UV + foam_warp * 0.15) * foam_scale + current_a * TIME * 0.1 * speed_a;
	vec2 foam_uv_b = (UV + foam_warp * 0.15) * foam_scale + current_b * TIME * 0.1 * speed_b;
	
	float foam_a = texture(foam_noise_texture, foam_uv_a).r;
	float foam_b = texture(foam_noise_texture, foam_uv_b).r;
	
	float foam_cells = max(foam_a, foam_b);
	
	float foam = smoothstep(foam_threshold, foam_threshold + 0.1, foam_cells);
	
	vec4 final = mix(surface, foam_color, clamp(foam * foam_strength, 0.0, 1.0));
	
	COLOR = final;
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
