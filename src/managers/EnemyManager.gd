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

func _on_child_entered_tree(child):
	var child_cell = map.global_to_map(child.global_position)
	parent.set_cell_occupied(child_cell, child)
	child.connect("has_died", parent._on_unit_has_died)
