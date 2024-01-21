extends TileMap

var map_size = Vector2(8, 5)
var interactable_cells = {}

var highlighted_cells = []

var terrain_layer = 0
var foliage_layer = 1
var effects_layer = 2

func _ready():
	var viewport_center = get_viewport().size / 2
	viewport_center -= (Vector2i(map_size) * tile_set.tile_size) / 2
	position = viewport_center
	
	# set background of map
	for col in map_size.x:
		for row in map_size.y:
			var map_cell = Vector2(col, row)
			_set_interactable_cell(map_cell, null)
			BetterTerrain.set_cell(self, terrain_layer, map_cell, 0)
			BetterTerrain.update_terrain_cell(self, terrain_layer, map_cell)
	
	# set map cliffs
	for col in map_size.x:
		BetterTerrain.set_cell(self, terrain_layer, Vector2(col, map_size.y), 1)
		BetterTerrain.update_terrain_cell(self, terrain_layer, Vector2(col, map_size.y))
	
	# set folliage of map
	for col in map_size.x:
		for row in map_size.y:
			var map_cell = Vector2(col, row)
			_set_interactable_cell(map_cell, null)
			BetterTerrain.set_cell(self, foliage_layer, map_cell, 2)
			BetterTerrain.update_terrain_cell(self, foliage_layer, map_cell)
	
	# set occupied cells
	for child in get_children():
		var child_cell = local_to_map(child.position)
		_set_interactable_cell(child_cell, child)
	
	connect("child_entered_tree", _on_child_entered_tree)

func _set_interactable_cell(cell, object):
	interactable_cells[str(cell)] = {"object": object, "cell": cell}

func _get_interactable_cell(cell):
	return interactable_cells.get(str(cell), null)

func global_to_map(input_global_position):
	var mouse_map_postion = to_local(input_global_position)
	return local_to_map(mouse_map_postion)

func map_to_global(cell):
	var hovered_cell_map_position = map_to_local(cell)
	return to_global(hovered_cell_map_position)

func is_valid_cell(cell):
	var cell_meta = _get_interactable_cell(cell)
	return cell_meta != null

func is_occupied_cell(cell):
	var cell_meta = _get_interactable_cell(cell)
	return cell_meta["object"] != null

func is_valid_placement(cell):
	# TODO: fix this
	return is_valid_cell(cell) and not is_occupied_cell(cell)

func highlight_cells(cells):
	for cell in cells:
		set_cell(effects_layer, cell, 2, Vector2.ZERO)

func unhilight_cells(cells):
	for cell in cells:
		erase_cell(effects_layer, cell)

func unhilight_all_cells():
	var cells = []
	for cell in interactable_cells.keys():
		var interactable_cell = _get_interactable_cell(cell)
		cells.append(interactable_cell["cell"])
	unhilight_cells(cells)

func _on_card_container_card_was_picked_up(_card):
	highlighted_cells = []
	for cell in interactable_cells.keys():
		var interactable_cell = _get_interactable_cell(cell)
		if interactable_cell["object"] == null:
			highlighted_cells.append(interactable_cell["cell"])
	highlight_cells(highlighted_cells)

func _on_card_container_card_was_released(card):
	unhilight_cells(highlighted_cells)
	highlighted_cells = []

func _on_unit_was_selected(unit):
	if unit.is_in_group("Unit"):
		var unit_cell = local_to_map(unit.position)
		for direction in unit.move_directions:
			var move_cell = unit_cell + direction
			if not is_occupied_cell(move_cell):
				highlighted_cells.append(move_cell)
		highlight_cells(highlighted_cells)

func _on_unit_was_unselected(_unit):
	unhilight_cells(highlighted_cells)
	highlighted_cells = []

func _on_unit_want_to_move(unit, target_global_position):
	var target_cell = global_to_map(target_global_position)
	if target_cell in highlighted_cells:
		var unit_cell = local_to_map(unit.position)
		_set_interactable_cell(unit_cell, null)
		_set_interactable_cell(target_cell, unit)
		unit.move_to(map_to_global(target_cell))
		

func _on_child_entered_tree(child):
	var child_cell = local_to_map(child.position)
	_set_interactable_cell(child_cell, child)
	child.connect("was_selected", _on_unit_was_selected)
	child.connect("was_deselected", _on_unit_was_unselected)
	child.connect("want_to_move", _on_unit_want_to_move)
