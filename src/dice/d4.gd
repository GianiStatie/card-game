extends AnimatedSprite2D

@onready var label = $Label
@onready var animation_player = $AnimationPlayer

var rng = RandomNumberGenerator.new()
var nb_faces = 4

func _on_animation_finished():
	var random_number = rng.randi_range(1, nb_faces)
	label.text = str(random_number)
	animation_player.play("Animate")

func _on_animation_player_Animate_finished():
	queue_free()
