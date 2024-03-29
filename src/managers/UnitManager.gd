extends Node2D

@export var map: TileMap
@onready var ally_manager = $AllyManager
@onready var enemy_manager = $EnemyManager

var occupied_cells = {}

var init_ally_units = [
	{
		"object": "res://src/units/unit.tscn",
		"type": "king",
		"map_position": Vector2i(0, 2)
	}
]

var init_enemy_units = [
	{
		"object": "res://src/units/unit.tscn",
		"type": "king",
		"map_position": Vector2i(7, 2)
	},
	{
		"object": "res://src/units/unit.tscn",
		"type": "pawn",
		"map_position": Vector2i(6, 1)
	},
	{
		"object": "res://src/units/unit.tscn",
		"type": "pawn",
		"map_position": Vector2i(6, 3)
	}
]

func _ready():
	ally_manager.map = map
	ally_manager.init_units(init_ally_units)
	
	enemy_manager.map = map
	enemy_manager.init_units(init_enemy_units)
	
	# set occupied cells
	for child in get_children():
		var child_cell = map.global_to_map(child.global_position)
		set_cell_occupied(child_cell, child)

func set_cell_occupied(cell, object):
	occupied_cells[str(cell)] = {"object": object, "cell": cell}

func set_cell_free(cell):
	occupied_cells.erase(str(cell))

func get_unit_at_cell(cell):
	var fetched_cell = occupied_cells.get(str(cell), {})
	return fetched_cell.get("object", null)

func get_ally_units_overlapping_cells(cells):
	var ally_units = []
	var ally_cells = []
	for ally in ally_manager.get_children():
		var ally_cell = map.global_to_map(ally.global_position)
		if ally_cell in cells:
			ally_units.append(ally)
			ally_cells.append(ally_cell)
	return {"ally_units": ally_units, "ally_cells": ally_cells}

func get_ally_distances_to_cell(cell):
	var ally_distances = []
	for ally in ally_manager.get_children():
		var ally_cell = map.global_to_map(ally.global_position)
		ally_distances.append((cell-ally_cell).length_squared())
	return ally_distances

func is_occupied_cell(cell):
	return get_unit_at_cell(cell) != null

func _on_unit_has_died(unit_global_position):
	var unit_cell = map.global_to_map(unit_global_position)
	set_cell_free(unit_cell)

func _on_end_turn_button_pressed():
	GameState.is_enemy_turn = true
	enemy_manager.start_turn()
