shader_type spatial;
render_mode unshaded;

uniform float threshold : hint_range(0.0, 1.0) = 0.3;
uniform vec4 shadow_color : source_color = vec4(0.2, 0.0, 0.4, 0.8);
uniform vec4 lit_color : source_color = vec4(1.0, 1.0, 1.0, 0.0);

varying float light_amount;

void fragment() {
	ALBEDO = mix(shadow_color.rgb, lit_color.rgb, light_amount);
	ALPHA = mix(shadow_color.a, lit_color.a, light_amount);
}

void light() {
	light_amount = ATTENUATION.r;
}
