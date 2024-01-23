extends Node2D

const DeathEffectScene = preload("res://src/effect/DeathEffect.tscn")

@onready var animation_player = $AnimationPlayer
@onready var sprite = $Sprite2D

signal hover_start(unit)
signal hover_end(unit)
signal was_selected(unit)
signal has_died(unit_global_position)


func _ready():
	var source_color = Constants.DEFAULT_PALETTE
	var target_color = Constants.PALETTS["red"]
	
	sprite.material.set_shader_parameter("old_main_color", source_color["old_main_color"])
	sprite.material.set_shader_parameter("new_main_color", target_color["new_main_color"])
	
	sprite.material.set_shader_parameter("old_shadow_color", source_color["old_shadow_color"])
	sprite.material.set_shader_parameter("new_shadow_color", target_color["new_shadow_color"])
	
	sprite.material.set_shader_parameter("old_light_color", source_color["old_light_color"])
	sprite.material.set_shader_parameter("new_light_color", target_color["new_light_color"])
	

func is_attacked():
	Utils.instance_scene_on_main(DeathEffectScene, global_position)
	emit_signal("has_died", global_position)
	queue_free()

func _on_selection_area_mouse_entered():
	emit_signal("hover_start", self)

func _on_selection_area_mouse_exited():
	emit_signal("hover_end", self)
