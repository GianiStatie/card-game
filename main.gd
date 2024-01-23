extends Node2D

@onready var map = $Map
@onready var unit_manager = $UnitManager

@onready var arrow_effect = $CanvasLayer/UnitPlaceEffect
@onready var select_effect = $CanvasLayer/SelectedEffect

func _input(event):
	if event is InputEventMouse:
		if GameState.is_holding_card:
			var mouse_global_position = get_global_mouse_position()
			var mouse_hovered_cell = map.global_to_map(mouse_global_position)

			arrow_effect.update(GameState.held_card.get_global_center(), mouse_global_position)
			_show_selected_cell(mouse_hovered_cell)

func _show_selected_cell(mouse_hovered_cell):
	var is_valid_cell = map.is_valid_cell(mouse_hovered_cell)
	var is_occupied_cell = unit_manager.is_occupied_cell(mouse_hovered_cell)
	
	if is_valid_cell and not is_occupied_cell:
		var hovered_cell_global_position = map.map_to_global(mouse_hovered_cell)
		select_effect.update(hovered_cell_global_position)
		select_effect.visible = true
	else:
		select_effect.visible = false

func _on_card_container_card_was_picked_up(_card):
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	arrow_effect.visible = true

func _on_card_container_card_was_released(card):
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	arrow_effect.visible = false
	select_effect.visible = false
