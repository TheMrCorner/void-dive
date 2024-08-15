shader_type canvas_item;
// Color gradient
uniform vec4 PRIMARY_COLOR = vec4(1, 1, 1, 1);
uniform vec4 SECONDARY_COLOR = vec4(1, 1, 1, 1);
uniform vec4 TERTIARY_COLOR = vec4(1, 1, 1, 1);

// Masks
const vec4 PRIMARY_MASK = vec4(0.372, 0.372, 0.372, 1);
const vec4 SECONDARY_MASK = vec4(0.556, 0.556, 0.556, 1);
const vec4 TERTIARY_MASK = vec4(0.741, 0.741, 0.741, 1);

void fragment() {
	// Called for every pixel the material is visible on.
	vec4 txtColor = texture(TEXTURE, UV);
	if(txtColor == PRIMARY_MASK){
		COLOR = PRIMARY_COLOR;
	} else if(txtColor == SECONDARY_MASK) {
		COLOR = SECONDARY_COLOR;
	} else if(txtColor == TERTIARY_MASK) {
		COLOR = TERTIARY_COLOR;
	}
}
