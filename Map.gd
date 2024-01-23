extends TileMap

var map_size = Vector2(8, 5)
var interactable_cells = []
var highlighted_cells = []

var terrain_layer = 0
var foliage_layer = 1
var effects_layer = 2

var highlight_colors = {
	"move": "green",
	"attack": "red"
}


func _ready():
	var viewport_center = get_viewport().size / 2
	viewport_center -= (Vector2i(map_size) * tile_set.tile_size) / 2
	position = viewport_center
	
	# set background of map
	for col in map_size.x:
		for row in map_size.y:
			var map_cell = Vector2i(col, row)
			interactable_cells.append(map_cell)
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
			BetterTerrain.set_cell(self, foliage_layer, map_cell, 2)
			BetterTerrain.update_terrain_cell(self, foliage_layer, map_cell)

func global_to_map(input_global_position):
	var mouse_map_postion = to_local(input_global_position)
	return local_to_map(mouse_map_postion)

func map_to_global(cell):
	var hovered_cell_map_position = map_to_local(cell)
	return to_global(hovered_cell_map_position)

func is_valid_cell(cell):
	return cell in interactable_cells

func is_highlighted_cell(cell):
	return cell in highlighted_cells

func highlight_cells(cells, action_type="move"):
	var alternative_tile
	alternative_tile = highlight_colors.values().find(highlight_colors[action_type])
	
	for cell in cells:
		highlighted_cells.append(cell)
		set_cell(effects_layer, cell, 2, Vector2.ZERO, alternative_tile)

func unhilight_cells(cells):
	for cell in cells:
		highlighted_cells.erase(cell)
		erase_cell(effects_layer, cell)

func unhilight_all_cells():
	unhilight_cells(interactable_cells)

func get_highlight_type(cell):
	var action_index = get_cell_alternative_tile(effects_layer, cell)
	return highlight_colors.keys()[action_index]
