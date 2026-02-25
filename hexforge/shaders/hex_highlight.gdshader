shader_type canvas_item;

uniform vec4 highlight_color : source_color = vec4(1.0, 1.0, 0.0, 0.4);
uniform float pulse_speed : hint_range(0.5, 5.0) = 2.0;
uniform bool enabled = false;

void fragment() {
	vec4 tex = texture(TEXTURE, UV);
	if (enabled) {
		float pulse = (sin(TIME * pulse_speed) + 1.0) * 0.5;
		float alpha = mix(0.2, highlight_color.a, pulse);
		COLOR = mix(tex, highlight_color, alpha);
		COLOR.a = tex.a;
	} else {
		COLOR = tex;
	}
}
