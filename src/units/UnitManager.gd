extends Node2D

const UnitScene = preload("res://src/units/unit.tscn")

@export var map: TileMap

var occupied_cells = {}


func _ready():
	# set occupied cells
	for child in get_children():
		var child_cell = map.global_to_map(child.global_position)
		set_cell_occupied(child_cell, child)
		child.connect("has_died", _on_unit_has_died)
	
	connect("child_entered_tree", _on_child_entered_tree)

func set_cell_occupied(cell, object):
	occupied_cells[str(cell)] = {"object": object, "cell": cell}

func set_cell_free(cell):
	occupied_cells.erase(str(cell))

func get_unit_at_cell(cell):
	var fetched_cell = occupied_cells.get(str(cell), {})
	return fetched_cell.get("object", null)

func is_occupied_cell(cell):
	return get_unit_at_cell(cell) != null

func highlight_unit_move_cells(unit):
	var to_be_highlighted = []
	var unit_cell = map.global_to_map(unit.global_position)
	for direction in unit.move_directions:
		var move_cell = unit_cell + direction
		if map.is_valid_cell(move_cell) and not is_occupied_cell(move_cell):
			to_be_highlighted.append(move_cell)
	map.highlight_cells(to_be_highlighted, "move")

func highlight_unit_attack_cells(unit):
	var to_be_highlighted = []
	var unit_cell = map.global_to_map(unit.global_position)
	for direction in unit.attack_directions:
		var attack_cell = unit_cell + direction
		if map.is_valid_cell(attack_cell) and is_occupied_cell(attack_cell):
			var unit_at_cell = get_unit_at_cell(attack_cell)
			if unit_at_cell.is_in_group("Enemy"):
				to_be_highlighted.append(attack_cell)
	map.highlight_cells(to_be_highlighted, "attack")

func _on_unit_was_selected(unit):
	if unit.is_in_group("Unit"):
		highlight_unit_move_cells(unit)
		highlight_unit_attack_cells(unit)

func _on_unit_was_unselected(_unit):
	map.unhilight_all_cells()

func _on_unit_interact_with(unit, target_global_position):
	var target_cell = map.global_to_map(target_global_position)
	if map.is_valid_cell(target_cell) and map.is_highlighted_cell(target_cell):
		var action_type = map.get_highlight_type(target_cell)
		if action_type == "move":
			var unit_cell = map.global_to_map(unit.global_position)
			set_cell_free(unit_cell)
			set_cell_occupied(target_cell, unit)
			unit.move_to(map.map_to_global(target_cell))
		elif action_type == "attack":
			var target_unit = get_unit_at_cell(target_cell)
			unit.attack_at(target_global_position)
			target_unit.is_attacked()
	unit.unselect()

func _on_unit_has_died(unit_global_position):
	var unit_cell = map.global_to_map(unit_global_position)
	set_cell_free(unit_cell)

func _on_child_entered_tree(child):
	var child_cell = map.global_to_map(child.global_position)
	set_cell_occupied(child_cell, child)
	child.connect("was_selected", _on_unit_was_selected)
	child.connect("was_deselected", _on_unit_was_unselected)
	child.connect("interact_with", _on_unit_interact_with)

func _on_card_container_card_was_released(card):
	var mouse_global_position = get_global_mouse_position()
	var mouse_hovered_cell = map.global_to_map(mouse_global_position)
	var is_valid_placement = map.is_valid_cell(mouse_hovered_cell)
	if not is_valid_placement:
		return
	
	var hovered_cell_global_position = map.map_to_global(mouse_hovered_cell)
	var unit = UnitScene.instantiate()
	unit.global_position = hovered_cell_global_position
	add_child(unit)
	
	card.queue_free()
