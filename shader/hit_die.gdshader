shader_type canvas_item;

uniform float opacity_percent: hint_range(0.0, 1.0, 0.1) = 1.0;
uniform float white_percent: hint_range(0.0, 1.0, 0.1) = 0.0;

void fragment() {
	vec4 white_color = vec4(1.0, 1.0, 1.0, texture(TEXTURE, UV).a);
	vec4 color = mix(texture(TEXTURE, UV), white_color, white_percent);
	COLOR = mix(color, vec4(0.0, 0.0, 0.0, 0.0), 1.0 - opacity_percent);
}

