extends Node2D

@export_enum("pawn", "king") var unit_type: String = "pawn"
@export_enum("blue", "red", "yellow", "purple") var unit_aggresion: String = "blue"

@onready var selected_effect = $SelectedEffect
@onready var animation_player = $AnimationPlayer
@onready var sprites = $UnitSprites

var should_move = false
var target_position = Vector2.ZERO

signal was_selected(unit)
signal was_deselected(unit)
signal interact_with(unit, target_global_position)

var move_directions = []
var attack_directions = []

func _ready():
	var unit_info = Constants.UNTIS[unit_type]
	move_directions = unit_info["move_directions"]
	attack_directions = unit_info["attack_directions"]
	sprites.update_sprites(unit_info["sprites"])
	sprites.update_color(unit_aggresion)
	update_unit_groups()

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

func look_towards(target_global_position):
	var direction = target_global_position - global_position
	if direction.x < 0:
		sprites.scale.x = -1
	else:
		sprites.scale.x = 1

func move_to(target_global_position):
	target_position = target_global_position
	should_move = true
	
	look_towards(target_global_position)
	animation_player.play("Move")

func attack_at(target_global_position):
	look_towards(target_global_position)
	animation_player.play("Attack")

func _on_animation_player_Attack_finished():
	animation_player.play("Idle")

func _on_selection_area_input_event(_viewport, event, _shape_idx):
	if is_in_group("Enemy"):
		return
	
	if event.is_action_pressed("LeftMouseClick"):
		GameState.is_unit_selected = true
		GameState.selected_unit = self
		selected_effect.visible = true
		emit_signal("was_selected", self)

func send_move_event_intent(target_global_position):
	emit_signal("interact_with", self, target_global_position)

func unselect():
	GameState.is_unit_selected = false
	GameState.selected_unit = null
	selected_effect.visible = false
	emit_signal("was_deselected", self)

func update_unit_groups():
	match unit_aggresion:
		"blue":
			add_to_group("Ally")
		"red":
			add_to_group("Enemy")
		"yellow":
			add_to_group("Vendor")
		"purple":
			add_to_group("Mercenary")
