extends Node2D

@onready var animation_player = $AnimationPlayer

func update(new_position):
	global_position = new_position

func _on_visible_on_screen_notifier_2d_screen_entered():
	animation_player.play("Animate")

func _on_visible_on_screen_notifier_2d_screen_exited():
	animation_player.play("RESET")
