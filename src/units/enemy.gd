extends Node2D

signal hover_start(unit)
signal hover_end(unit)
signal was_selected(unit)


func _on_selection_area_mouse_entered():
	emit_signal("hover_start", self)

func _on_selection_area_mouse_exited():
	emit_signal("hover_end", self)
