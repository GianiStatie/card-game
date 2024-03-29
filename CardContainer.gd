extends Container

const CardScene = preload("res://card.tscn")

@export var curve_y_start = 983: set = _set_curve_y_start, get = _get_curve_y_start
@export var curve_y_end = -883: set = _set_curve_y_end, get = _get_curve_y_end
@export var curve_margin = -660: set = _set_curve_margin, get = _get_curve_margin
@export_range(-1, 1, 0.01) var card_overlap = 0.18: set = _set_card_overlap, get = _get_card_overlap

@onready var screen_size = get_viewport().size

var card_size = Vector2.ZERO

signal card_was_picked_up(card)
signal card_was_released(card)


func _ready():
	connect("child_order_changed", _on_child_order_changed)

func _quadratic_bezier(p0: Vector2, p1: Vector2, p2: Vector2, t: float):
	var q0 = p0.lerp(p1, t)
	var q1 = p1.lerp(p2, t)
	var r = q0.lerp(q1, t)
	return r

func draw_card():
	var card = CardScene.instantiate()
	add_child(card)
	card.connect("card_was_picked_up", _on_Card_was_picked_up)
	card.connect("card_was_released", _on_Card_was_released)
	
	if card_size == Vector2.ZERO:
		card_size = card.size

func reorder_cards_in_hand():
	var center_x = screen_size.x / 2 - card_size.x / 2
	
	var p0_x = curve_margin - card_size.x / 2
	var p2_x = screen_size.x - curve_margin - card_size.x / 2
	
	var p0 = Vector2(p0_x, curve_y_start)
	var p2 = Vector2(p2_x, curve_y_start)
	var p1 = Vector2(center_x, curve_y_end)
	
	var nb_children = get_child_count()
	var x_shift = card_size.x * (nb_children - 1) / 2
	
	for child_idx in nb_children:
		var child = get_child(child_idx)
		var child_position_x = center_x + card_size.x * child_idx - x_shift
		var t = (child_position_x - p0_x) / (p2_x - p0_x)
		var centered_t = (t - 0.5) * 2
		t -= centered_t * card_overlap
		
		var bez_pos = _quadratic_bezier(p0, p1, p2, t)
		var bez_rot = deg_to_rad(45) * centered_t
		
		child.set_transform(bez_pos, bez_rot)

func _on_Card_was_picked_up(card):
	GameState.is_holding_card = true
	GameState.held_card = card
	emit_signal("card_was_picked_up", card)

func _on_Card_was_released(card):
	GameState.is_holding_card = false
	GameState.held_card = null
	emit_signal("card_was_released", card)

func _on_child_order_changed():
	reorder_cards_in_hand()

func _set_curve_y_start(value):
	curve_y_start = value
	reorder_cards_in_hand()

func _get_curve_y_start():
	return curve_y_start

func _set_curve_y_end(value):
	curve_y_end = value
	reorder_cards_in_hand()

func _get_curve_y_end():
	return curve_y_end

func _set_curve_margin(value):
	curve_margin = value
	reorder_cards_in_hand()

func _get_curve_margin():
	return curve_margin

func _set_card_overlap(value):
	card_overlap = value
	reorder_cards_in_hand()

func _get_card_overlap():
	return card_overlap

func _on_draw_card_button_pressed():
	draw_card()
