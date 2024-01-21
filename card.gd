extends Panel

const hover_move_speed = 420
const hover_scale_speed = 10
const hover_rotate_speed = 10

const default_move_speed = 5000
const default_scale_speed = 2500
const default_rotate_speed = 2500

var return_position = null
var return_rotation = null
var return_scale = Vector2.ONE
var return_z_index = null

var reposition_card = false
var new_position = Vector2.ZERO
var new_rotation = 0
var new_scale = Vector2.ONE * 1.35
var new_z_index = 11

var is_hovered = false
var is_selected = false
var follow_mouse = false

signal card_was_picked_up(card)
signal card_was_released(card)

func _input(event):
	if event.is_action_pressed("LeftMouseClick") and is_hovered:
		is_selected = true
		_on_mouse_exited() # check type of card
		emit_signal("card_was_picked_up", self)
	if event.is_action_released("LeftMouseClick") and is_selected:
		is_selected = false
		_on_mouse_exited()
		emit_signal("card_was_released", self)

func _process(delta):
	var card_move_speed = default_move_speed
	var card_scale_speed = default_scale_speed
	var card_rotate_speed = default_rotate_speed
	
	if is_hovered and not follow_mouse:
		card_move_speed = hover_move_speed
		card_scale_speed = hover_scale_speed
		card_rotate_speed = hover_rotate_speed
	
	position = position.move_toward(new_position, card_move_speed * delta)
	scale = scale.move_toward(new_scale, card_scale_speed * delta)
	rotation = move_toward(rotation, new_rotation, hover_scale_speed * delta)

func move_card_to_mouse():
	new_position = _get_mouse_position()

func set_transform(new_position, new_rotation=0, new_z_index=0):
	return_position = new_position
	return_rotation = new_rotation
	return_z_index = new_z_index
	_on_mouse_exited()

func get_global_center():
	var global_center = global_position
	global_center.x += size.x / 2
	global_center.y += size.y / 2
	return global_center

func _get_mouse_position():
	var screen_size = get_viewport().size
	var mouse_position = get_global_mouse_position()
	
	var card_relative_mouse_position = Vector2.ZERO
	card_relative_mouse_position.x = mouse_position.x - (size.x / 2)
	card_relative_mouse_position.y = (mouse_position.y - screen_size.y) + size.y
	
	return card_relative_mouse_position

func _on_mouse_entered():
	if GameState.is_holding_card:
		return
	
	is_hovered = true
	z_index = new_z_index
	new_position.x = return_position.x
	new_position.y = size.y / 5
	new_rotation = 0
	new_scale = Vector2.ONE * 1.5

func _on_mouse_exited():
	if follow_mouse:
		return
	
	is_hovered = false
	z_index = return_z_index
	new_position = return_position
	new_rotation = return_rotation
	new_scale = return_scale
