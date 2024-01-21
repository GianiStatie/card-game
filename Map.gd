extends TileMap

var map_size = Vector2(8, 5)
var interactable_cells = {}

func _ready():
	var viewport_center = get_viewport().size / 2
	viewport_center -= (Vector2i(map_size) * tile_set.tile_size) / 2
	position = viewport_center
	
	# set background of map
	for col in map_size.x:
		for row in map_size.y:
			var map_cell = Vector2(col, row)
			_set_interactable_cell(map_cell, null)
			BetterTerrain.set_cell(self, 0, map_cell, 0)
			BetterTerrain.update_terrain_cell(self, 0, map_cell)
	
	# set map cliffs
	for col in map_size.x:
		BetterTerrain.set_cell(self, 0, Vector2(col, map_size.y), 1)
		BetterTerrain.update_terrain_cell(self, 0, Vector2(col, map_size.y))
	
	# set occupied cells
	for child in get_children():
		var child_cell = local_to_map(child.position)
		_set_interactable_cell(child_cell, child)

func _input(event):
	if event is InputEventMouseMotion:
		if GameState.is_holding_card:
			var empty_cells = []
			for cell in interactable_cells.keys():
				var interactable_cell = _get_interactable_cell(cell)
				if interactable_cell["object"] == null:
					empty_cells.append(interactable_cell["cell"])
			highlight_cells(empty_cells)
		else:
			var empty_cells = []
			for cell in interactable_cells.keys():
				var interactable_cell = _get_interactable_cell(cell)
				if interactable_cell["object"] == null:
					empty_cells.append(interactable_cell["cell"])
			unhilight_cells(empty_cells) 

func _set_interactable_cell(cell, object):
	interactable_cells[str(cell)] = {"object": object, "cell": cell}

func _get_interactable_cell(cell):
	return interactable_cells.get(str(cell), null)

func is_valid_cell(cell):
	var cell_meta = _get_interactable_cell(cell)
	return cell_meta != null

func is_occupied_cell(cell):
	var cell_meta = _get_interactable_cell(cell)
	return cell_meta["object"] != null

func highlight_cells(cells):
	for cell in cells:
		set_cell(1, cell, 2, Vector2.ZERO)

func unhilight_cells(cells):
	for cell in cells:
		erase_cell(1, cell)
