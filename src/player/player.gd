extends CharacterBody2D

@onready var selected_effect = $SelectedEffect


func _on_selection_area_input_event(viewport, event, shape_idx):
	if event.is_action_pressed("LeftMouseClick"):
		GameState.is_unit_selected = true
		GameState.selected_unit = self
		selected_effect.visible = true

func unselect():
	GameState.is_unit_selected = false
	GameState.selected_unit = null
	selected_effect.visible = false
