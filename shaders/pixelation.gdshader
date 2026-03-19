shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_nearest;
uniform float pixel_size : hint_range(1.0, 32.0) = 4.0;

void fragment() {
    vec2 uv = SCREEN_UV;
    vec2 pixel_uv = floor(uv / (pixel_size * SCREEN_PIXEL_SIZE)) * (pixel_size * SCREEN_PIXEL_SIZE);
    COLOR = texture(SCREEN_TEXTURE, pixel_uv);
}