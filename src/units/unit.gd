extends Node2D

@onready var selected_effect = $SelectedEffect
@onready var animation_player = $AnimationPlayer
@onready var sprite = $Sprite2D

var should_move = false
var target_position = Vector2.ZERO

signal was_selected(unit)
signal was_deselected(unit)
signal want_to_move(unit, target_global_position)

var move_directions = [
	Vector2i(1, 1),
	Vector2i(-1, 1),
	Vector2i(-1, -1),
	Vector2i(1, -1),
]


func _ready():
	var source_color = Constants.DEFAULT_PALETTE
	var target_color = Constants.PALETTS["yellow"]
	sprite.material.set_shader_parameter("old_main_color", source_color["old_main_color"])
	sprite.material.set_shader_parameter("old_shadow_color", source_color["old_shadow_color"])
	sprite.material.set_shader_parameter("new_main_color", target_color["new_main_color"])
	sprite.material.set_shader_parameter("new_shadow_color", target_color["new_shadow_color"])


func _input(event):
	if event.is_action_pressed("LeftMouseClick"):
		if GameState.is_unit_selected and GameState.selected_unit == self:
			unselect()
	if event.is_action_pressed("RightMouseClick"):
		if GameState.is_unit_selected and GameState.selected_unit == self:
			send_move_event_intent(get_global_mouse_position())

func _process(delta):
	if not should_move:
		return
	
	if global_position.is_equal_approx(target_position):
		should_move = false
		animation_player.play("Idle")
		return
	
	global_position = global_position.move_toward(target_position, 100 * delta)

func move_to(target_global_position):
	target_position = target_global_position
	should_move = true
	
	var direction = target_global_position - global_position
	if direction.x < 0:
		sprite.scale.x = -1
	else:
		sprite.scale.x = 1
	
	animation_player.play("Move")
	unselect()

func _on_selection_area_input_event(_viewport, event, _shape_idx):
	if event.is_action_pressed("LeftMouseClick"):
		GameState.is_unit_selected = true
		GameState.selected_unit = self
		selected_effect.visible = true
		emit_signal("was_selected", self)

func send_move_event_intent(target_global_position):
	emit_signal("want_to_move", self, target_global_position)

func unselect():
	GameState.is_unit_selected = false
	GameState.selected_unit = null
	selected_effect.visible = false
	emit_signal("was_deselected", self)
