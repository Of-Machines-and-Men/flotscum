// HOLMES' ADVICE:
//   - For objects "above" the water, increase shadow_distance and lower shadow_opacity.
//   - For things resting on the surface, keep shadow_distance short and opacity high.
//   - I'd suggest a  slight blue/teal shadow_color tint. Matches the water.

shader_type canvas_item;

// ── Shadow shape ──────────────────────────────────────────────────────────────
/// Direction the shadow is cast (in pixels, UV-space is compensated internally).
uniform vec2 shadow_offset = vec2(0.15, 0.25);
uniform float shadow_spread: hint_range(0.0, 16.0) = 2.0;
uniform float shadow_blur: hint_range(0.0, 32.0) = 6.0;

// ── Shadow appearance ─────────────────────────────────────────────────────────
uniform vec4 shadow_color: source_color = vec4(0.02, 0.08, 0.12, 1.0);
uniform float shadow_scale : hint_range(0.1, 3.0) = 1.0;
uniform float shadow_opacity: hint_range(0.0, 1.0) = 0.55;
uniform float shadow_falloff: hint_range(0.5, 8.0) = 1.8;

// ── Water ripple distortion ───────────────────────────────────────────────────
uniform float ripple_strength: hint_range(0.0, 0.05) = 0.012;
uniform float ripple_speed: hint_range(0.0, 4.0) = 1.2;
uniform float ripple_frequency: hint_range(1.0, 40.0) = 14.0;

// ── Helpers ───────────────────────────────────────────────────────────────────
float sample_shadow_alpha(sampler2D tex, vec2 uv, vec2 tex_size) {
	vec2 texel = 1.0 / tex_size;

	// Real cheap blur approx
	float total = 0.0;
	float weight_sum = 0.0;
	float total_radius = shadow_spread + shadow_blur;
	int steps = max(1, int(total_radius * 2.0));

	for (int x = -steps; x <= steps; x++) {
		for (int y = -steps; y <= steps; y++) {
			float dist = length(vec2(float(x), float(y)));
			if (dist > total_radius) { continue; }
			float w = exp(-0.5 * pow(max(0.0, dist - shadow_spread) / max(0.001, shadow_blur * 0.4), 2.0));
			total += texture(tex, uv + vec2(float(x), float(y)) * texel).a * w;
			weight_sum += w;
		}
	}

	return clamp(total / max(weight_sum, 0.001), 0.0, 1.0);
}

void fragment() {
	// Texture size (needed to convert offset from pixels → UV) ────────────
	vec2 tex_size = vec2(textureSize(TEXTURE, 0));
	
	vec2 ripple_uv = UV;
	if (ripple_strength > 0.0) {
		float t  = TIME * ripple_speed;
		float wx = sin(ripple_uv.y * ripple_frequency + t * 1.3) * ripple_strength;
		float wy = cos(ripple_uv.x * ripple_frequency + t)       * ripple_strength;
		ripple_uv += vec2(wx, wy);
	}

	// Offset UV for shadow (shadow lives "behind" the sprite) ─────────────
	vec2 shadow_uv = ripple_uv - shadow_offset / tex_size * vec2(textureSize(TEXTURE, 0));
	shadow_uv = (shadow_uv - 0.5) / shadow_scale + 0.5;
	shadow_uv = clamp(shadow_uv, vec2(0.0), vec2(1.0));
	float s_alpha = sample_shadow_alpha(TEXTURE, shadow_uv, tex_size);

	s_alpha = pow(s_alpha, 1.0 / shadow_falloff);
	s_alpha *= shadow_opacity;
	
	vec4 sprite = texture(TEXTURE, UV) * COLOR;
	vec4 shadow_pixel = vec4(shadow_color.rgb, s_alpha * shadow_color.a);
	COLOR = mix(shadow_pixel, sprite, sprite.a);
}
