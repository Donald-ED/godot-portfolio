shader_type canvas_item;

uniform float scanline_amount : hint_range(0.0, 1.0) = 0.3;
uniform float vignette_strength : hint_range(0.0, 1.0) = 0.4;
uniform float aberration : hint_range(0.0, 0.01) = 0.002;
uniform float curvature : hint_range(0.0, 0.1) = 0.03;

vec2 curve(vec2 uv) {
	uv = uv * 2.0 - 1.0;
	uv *= 1.0 + curvature * (dot(uv, uv));
	return uv * 0.5 + 0.5;
}

void fragment() {
	vec2 uv = curve(UV);
	if (uv.x < 0.0 || uv.x > 1.0 || uv.y < 0.0 || uv.y > 1.0) {
		COLOR = vec4(0.0);
		return;
	}
	float r = texture(TEXTURE, uv + vec2(aberration, 0.0)).r;
	float g = texture(TEXTURE, uv).g;
	float b = texture(TEXTURE, uv - vec2(aberration, 0.0)).b;
	float a = texture(TEXTURE, uv).a;
	float scanline = sin(uv.y * 800.0) * scanline_amount;
	float vignette = smoothstep(0.8, 0.3, length(uv - 0.5));
	vec3 color = vec3(r, g, b);
	color -= scanline;
	color *= mix(1.0, vignette, vignette_strength);
	COLOR = vec4(color, a);
}
