extends Node2D

@onready var map = $Map

@onready var arrow_effect = $CanvasLayer/UnitPlaceEffect
@onready var select_effect = $CanvasLayer/SelectedEffect

func _input(event):
	if event.is_action_pressed("LeftMouseClick"):
		if GameState.is_unit_selected:
			GameState.selected_unit.unselect()

	if event is InputEventMouseMotion:
		if GameState.is_holding_card:
			var mouse_global_position = get_global_mouse_position()
			var mouse_map_postion = map.to_local(mouse_global_position)
			var mouse_hovered_cell = map.local_to_map(mouse_map_postion)
			
			var is_valid_placement = map.is_valid_cell(mouse_hovered_cell) and not map.is_occupied_cell(mouse_hovered_cell)
			var hovered_cell_map_position = map.map_to_local(mouse_hovered_cell)
			var hovered_cell_global_position = map.to_global(hovered_cell_map_position)
			
			arrow_effect.visible = true
			arrow_effect.update(GameState.held_card.get_global_center(), mouse_global_position)
			
			if is_valid_placement:
				select_effect.visible = true
				select_effect.update(hovered_cell_global_position)
			else:
				select_effect.visible = false
		else:
			arrow_effect.visible = false
			select_effect.visible = false
