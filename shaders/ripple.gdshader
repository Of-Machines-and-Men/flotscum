shader_type canvas_item;

uniform float ripple_speed : hint_range(0.0, 5.0) = 2.0;
uniform float ripple_frequency : hint_range(1.0, 20.0) = 8.0;
uniform float ripple_strength : hint_range(0.0, 1.0) = 0.6;
uniform vec4 ripple_color : source_color = vec4(0.8, 0.95, 1.0, 0.5);

void fragment() {
	vec2 uv = UV - vec2(0.5, 0.5);
	float dist = length(uv);

	float ripple = sin(dist * ripple_frequency - TIME * ripple_speed) * 0.5 + 0.5;
	ripple = smoothstep(0.4, 0.6, ripple);

	float fade = smoothstep(0.5, 0.35, dist) * smoothstep(0.0, 0.1, dist);

	float final = ripple * fade;
	COLOR = vec4(ripple_color.rgb, final * ripple_strength * ripple_color.a);
}
