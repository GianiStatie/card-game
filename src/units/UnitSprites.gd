extends Node2D

@onready var head_sprite = $Head
@onready var body_sprite = $Body
@onready var left_arm_sprite = $LeftArm
@onready var right_arm_sprite = $RightArm

var body_source_color = Constants.DEFAULT_PALETTE
var body_target_color = Constants.PALETTS["blue"]


func update_sprites(sprite_info):
	for key in sprite_info:
		match key:
			"Head":
				head_sprite.texture = load(sprite_info[key])
			"Body":
				body_sprite.texture = load(sprite_info[key])
			"LeftArm":
				left_arm_sprite.texture = load(sprite_info[key])
			"RightArm":
				right_arm_sprite.texture = load(sprite_info[key])
			_:
				print("Unknown key: %s"%key)

func update_palettes():
	body_sprite.material.set_shader_parameter("old_main_color", body_source_color["old_main_color"])
	body_sprite.material.set_shader_parameter("new_main_color", body_target_color["new_main_color"])
	
	body_sprite.material.set_shader_parameter("old_shadow_color", body_source_color["old_shadow_color"])
	body_sprite.material.set_shader_parameter("new_shadow_color", body_target_color["new_shadow_color"])
	
	body_sprite.material.set_shader_parameter("old_light_color", body_source_color["old_light_color"])
	body_sprite.material.set_shader_parameter("new_light_color", body_target_color["new_light_color"])

func update_color(color):
	body_target_color = Constants.PALETTS[color]
	update_palettes()
