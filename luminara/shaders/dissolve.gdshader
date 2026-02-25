shader_type spatial;

uniform float dissolve_amount : hint_range(0.0, 1.0) = 0.0;
uniform float edge_width : hint_range(0.0, 0.2) = 0.05;
uniform vec4 edge_color : source_color = vec4(0.4, 0.0, 1.0, 1.0);
uniform vec4 base_color : source_color = vec4(0.3, 0.3, 0.4, 1.0);
uniform float noise_scale : hint_range(0.1, 20.0) = 5.0;

float hash(vec2 p) {
	return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453);
}

float noise(vec2 p) {
	vec2 i = floor(p);
	vec2 f = fract(p);
	f = f * f * (3.0 - 2.0 * f);
	float a = hash(i);
	float b = hash(i + vec2(1.0, 0.0));
	float c = hash(i + vec2(0.0, 1.0));
	float d = hash(i + vec2(1.0, 1.0));
	return mix(mix(a, b, f.x), mix(c, d, f.x), f.y);
}

void fragment() {
	float n = noise(UV * noise_scale);
	float dissolve = smoothstep(dissolve_amount - edge_width, dissolve_amount, n);
	float edge = smoothstep(dissolve_amount, dissolve_amount + edge_width, n);
	ALBEDO = mix(edge_color.rgb, base_color.rgb, edge);
	ALPHA = dissolve;
	if (n < dissolve_amount - edge_width) {
		discard;
	}
}
