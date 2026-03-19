shader_type canvas_item;

uniform float wake_angle : hint_range(0.1, 1.5) = 0.6;
uniform float wake_length : hint_range(0.1, 2.0) = 1.0;
uniform float wake_speed : hint_range(0.0, 5.0) = 2.0;
uniform float wake_strength : hint_range(0.0, 1.0) = 1.0;
uniform float squiggle_amount : hint_range(0.0, 0.2) = 0.05;
uniform float squiggle_frequency : hint_range(1.0, 20.0) = 8.0;
uniform vec4 wake_color : source_color = vec4(0.9, 0.97, 1.0, 1.0);

void fragment() {
	vec2 uv = UV - vec2(0.5, 0.5);

	// NAUGHTY V SHAPES GET PUT IN THE EDGE WIGGLER
	float squiggle_x = sin(uv.y * squiggle_frequency + TIME * wake_speed) * squiggle_amount;
	float squiggle_y = sin(uv.x * squiggle_frequency + TIME * wake_speed * 0.7) * squiggle_amount;
	vec2 warped_uv = uv + vec2(squiggle_x, squiggle_y);

	float angle = abs(warped_uv.x) / max(abs(warped_uv.y), 0.001);
	float v_shape = smoothstep(wake_angle + 0.05, wake_angle - 0.05, angle);

	// Only behind
	float behind = smoothstep(0.0, 0.02, warped_uv.y);

	// Animated lines along arms
	float lines = sin((uv.y * 15.0 / wake_length) - TIME * wake_speed) * 0.5 + 0.5;
	lines = smoothstep(0.3, 0.7, lines);

	float edge = abs(angle - wake_angle);
	float edge_glow = smoothstep(0.15, 0.0, edge) * 2.0;

	float edge_squiggle = sin(uv.y * squiggle_frequency * 2.0 + TIME * wake_speed * 1.3) * 0.5 + 0.5;
	edge_glow *= mix(0.5, 1.0, edge_squiggle);

	float fade = smoothstep(0.5, 0.05, length(uv));
	float tip_fade = smoothstep(0.0, 0.1, abs(uv.y));

	float wake = (v_shape * lines + edge_glow) * behind * fade * tip_fade;
	wake = clamp(wake, 0.0, 1.0);

	COLOR = vec4(wake_color.rgb, wake * wake_strength);
}