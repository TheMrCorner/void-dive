shader_type canvas_item;
uniform vec4 AUX_Color = vec4(0.1, 0.2, 0.3, 1);
const vec4 Mask1 = vec4(1, 1, 1, 1);
const vec4 Mask2 = vec4(0, 0, 0, 0);

void fragment() {
	// Called for every pixel the material is visible on.
	vec4 txtColor = texture(TEXTURE, UV);
	if(txtColor == Mask2){
		COLOR = AUX_Color;
	}
}
