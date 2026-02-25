shader_type spatial;
render_mode blend_add, depth_draw_never, cull_disabled, unshaded;

uniform vec4 beam_color : source_color = vec4(1.0, 0.95, 0.8, 1.0);
uniform float intensity : hint_range(0.0, 5.0) = 1.5;
uniform float fade_distance : hint_range(0.1, 10.0) = 5.0;
uniform float noise_scale : hint_range(0.1, 10.0) = 2.0;
uniform float time_speed : hint_range(0.0, 5.0) = 0.5;

float hash(vec3 p) {
	p = fract(p * vec3(443.897, 441.423, 437.195));
	p += dot(p, p.yzx + 19.19);
	return fract((p.x + p.y) * p.z);
}

float noise(vec3 p) {
	vec3 i = floor(p);
	vec3 f = fract(p);
	f = f * f * (3.0 - 2.0 * f);
	float a = hash(i);
	float b = hash(i + vec3(1, 0, 0));
	float c = hash(i + vec3(0, 1, 0));
	float d = hash(i + vec3(1, 1, 0));
	float e = hash(i + vec3(0, 0, 1));
	float f2 = hash(i + vec3(1, 0, 1));
	float g = hash(i + vec3(0, 1, 1));
	float h = hash(i + vec3(1, 1, 1));
	return mix(mix(mix(a, b, f.x), mix(c, d, f.x), f.y),
	           mix(mix(e, f2, f.x), mix(g, h, f.x), f.y), f.z);
}

void fragment() {
	float depth_fade = 1.0 - smoothstep(0.0, fade_distance, length(VERTEX));
	float n = noise(VERTEX * noise_scale + vec3(TIME * time_speed));
	float alpha = beam_color.a * intensity * depth_fade * n;
	ALBEDO = beam_color.rgb;
	ALPHA = clamp(alpha, 0.0, 1.0);
}
