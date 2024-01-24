extends Node2D

var map: TileMap = null
var parent: Node2D = null


func _ready():
	parent = get_parent()
	connect("child_entered_tree", _on_child_entered_tree)

func init_units(init_enemy_units):
	for unit_info in init_enemy_units:
		var unit = load(unit_info["object"]).instantiate()
		unit.global_position = map.map_to_global(unit_info["map_position"])
		add_child(unit)

func start_turn():
	for child in get_children():
		var child_cell = map.global_to_map(child.global_position)
		var attack_cells = get_attack_cells(child, child_cell)
		var tragets_in_attack_range = parent.get_ally_units_overlapping_cells(attack_cells)
		
		if len(tragets_in_attack_range["ally_units"]) > 0:
			var closest_unit_cell = get_closest_cell_to_target_cell(tragets_in_attack_range["ally_cells"], child_cell)
			var target_unit = parent.get_unit_at_cell(closest_unit_cell)
			child.attack_at(target_unit.global_position)
			target_unit.is_attacked()
		else:
			var best_direction = get_direction_to_attack_target_cell(child, attack_cells)
			var target_cell = child_cell + best_direction
			parent.set_cell_free(child_cell)
			parent.set_cell_occupied(target_cell, child)
			child.move_to(map.map_to_global(target_cell))

func _on_child_entered_tree(child):
	child.unit_aggresion = "Enemy"
	var child_cell = map.global_to_map(child.global_position)
	parent.set_cell_occupied(child_cell, child)
	child.connect("has_died", parent._on_unit_has_died)

func get_attack_cells(unit, unit_cell):
	var attack_cells = []
	for direction in unit.attack_directions:
		attack_cells.append(unit_cell + direction)
	return attack_cells

func get_closest_cell_to_target_cell(cells, target_cell):
	var min_distance = INF
	var closest_cell = null
	for cell in cells:
		var distance = (cell - target_cell).length_squared()
		if distance < min_distance:
			closest_cell = cell
			min_distance = distance
	return closest_cell

func get_direction_to_attack_target_cell(unit, attack_cells):
	var min_distance = INF
	var best_direction = null
	var seen_cells = []
	
	var movable_directions = get_movable_directions(unit)
	
	for attack_cell in attack_cells:
		for move_direction in movable_directions:
			var target_cell = attack_cell + move_direction
			
			if target_cell in seen_cells:
				continue
			seen_cells.append(target_cell)
			
			var distances_to_targets = parent.get_ally_distances_to_cell(target_cell)
			var min_distance_to_targets = distances_to_targets.min()
			if min_distance_to_targets < min_distance:
				best_direction = move_direction
				min_distance = min_distance_to_targets
	
	return best_direction

func get_movable_directions(unit):
	var movable_directions = []
	var unit_cell = map.global_to_map(unit.global_position)
	for direction in unit.move_directions:
		var move_cell = unit_cell + direction
		if map.is_valid_cell(move_cell) and not parent.is_occupied_cell(move_cell):
			movable_directions.append(direction)
	return movable_directions
