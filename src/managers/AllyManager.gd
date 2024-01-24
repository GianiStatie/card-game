extends Node2D

const UnitScene = preload("res://src/units/unit.tscn")

var map: TileMap = null
var parent: Node2D = null


func _ready():
	parent = get_parent()
	connect("child_entered_tree", _on_child_entered_tree)

func init_units(init_ally_units):
	for unit_info in init_ally_units:
		var unit = load(unit_info["object"]).instantiate()
		unit.unit_type = unit_info["type"]
		unit.global_position = map.map_to_global(unit_info["map_position"])
		add_child(unit)

func _on_unit_was_selected(unit):
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
			parent.set_cell_free(unit_cell)
			parent.set_cell_occupied(target_cell, unit)
			unit.move_to(map.map_to_global(target_cell))
		elif action_type == "attack":
			var target_unit = parent.get_unit_at_cell(target_cell)
			unit.attack_at(target_global_position)
			target_unit.is_attacked()
	unit.unselect()

func _on_child_entered_tree(child):
	var child_cell = map.global_to_map(child.global_position)
	parent.set_cell_occupied(child_cell, child)
	child.connect("was_selected", _on_unit_was_selected)
	child.connect("was_deselected", _on_unit_was_unselected)
	child.connect("interact_with", _on_unit_interact_with)

func _on_card_container_card_was_picked_up(_card):
	var ally_placement_cells = get_ally_placement_cells()
	map.highlight_cells(ally_placement_cells, "move")

func _on_card_container_card_was_released(card):
	var mouse_global_position = get_global_mouse_position()
	var mouse_hovered_cell = map.global_to_map(mouse_global_position)
	var is_valid_cell = map.is_valid_cell(mouse_hovered_cell)
	var is_highlighted = map.is_highlighted_cell(mouse_hovered_cell)
	
	map.unhilight_all_cells()
	if not (is_valid_cell and is_highlighted):
		return
	
	var hovered_cell_global_position = map.map_to_global(mouse_hovered_cell)
	# TODO: Store unit info on card
	var unit = UnitScene.instantiate()
	unit.global_position = hovered_cell_global_position
	add_child(unit)
	
	card.queue_free()

func get_ally_placement_cells():
	var ally_placement_cells = []
	for child in get_children():
		var child_cell = map.global_to_map(child.global_position)
		for cell in map.get_surrounding_cells_around(child_cell):
			if map.is_valid_cell(cell) and not parent.is_occupied_cell(cell):
				if cell not in ally_placement_cells:
					ally_placement_cells.append(cell)
	return ally_placement_cells

func highlight_unit_move_cells(unit):
	var to_be_highlighted = []
	var unit_cell = map.global_to_map(unit.global_position)
	for direction in unit.move_directions:
		var move_cell = unit_cell + direction
		if map.is_valid_cell(move_cell) and not parent.is_occupied_cell(move_cell):
			to_be_highlighted.append(move_cell)
	map.highlight_cells(to_be_highlighted, "move")

func highlight_unit_attack_cells(unit):
	var to_be_highlighted = []
	var unit_cell = map.global_to_map(unit.global_position)
	for direction in unit.attack_directions:
		var attack_cell = unit_cell + direction
		if map.is_valid_cell(attack_cell) and parent.is_occupied_cell(attack_cell):
			var unit_at_cell = parent.get_unit_at_cell(attack_cell)
			if unit_at_cell.is_in_group("Enemy"):
				to_be_highlighted.append(attack_cell)
	map.highlight_cells(to_be_highlighted, "attack")
