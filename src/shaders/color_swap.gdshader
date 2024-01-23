shader_type canvas_item;

uniform vec4 old_main_color : source_color;
uniform vec4 old_shadow_color: source_color;
uniform vec4 old_light_color: source_color;

uniform vec4 new_main_color : source_color;
uniform vec4 new_shadow_color: source_color;
uniform vec4 new_light_color: source_color;

void fragment() {
    vec4 current_pixel = texture(TEXTURE, UV);

    if (current_pixel == old_main_color) {
		COLOR = new_main_color;
	}
        
	if (current_pixel == old_shadow_color) {
		COLOR = new_shadow_color;
	}
        
	if (current_pixel == old_light_color) {
		COLOR = new_light_color;
	}
}