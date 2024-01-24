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
		var closest_target = parent.get_closest_ally_unit(child_cell)
		var closest_target_cell = map.global_to_map(closest_target.global_position)
		
		var attack_cells = get_attack_cells(child, child_cell)
		if closest_target_cell in attack_cells:
			var target_global_position = map.map_to_global(closest_target_cell)
			child.attack_at(target_global_position)
			closest_target.is_attacked()
		else:
			var movable_directions = get_movable_directions(child)
			var best_direction = get_direction_to_attack_target_cell(attack_cells, movable_directions, closest_target_cell)
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

func get_direction_to_attack_target_cell(attack_cells, directions, target_cell):
	var closest_attack_cell = get_closest_cell_to_target_cell(attack_cells, target_cell)
	var post_move_attack = []
	for direction in directions:
		post_move_attack.append(closest_attack_cell + direction)
	var closest_post_move_attack = get_closest_cell_to_target_cell(post_move_attack, target_cell)
	return closest_post_move_attack - closest_attack_cell

func get_movable_directions(unit):
	var movable_directions = []
	var unit_cell = map.global_to_map(unit.global_position)
	for direction in unit.move_directions:
		var move_cell = unit_cell + direction
		if map.is_valid_cell(move_cell) and not parent.is_occupied_cell(move_cell):
			movable_directions.append(direction)
	return movable_directions
