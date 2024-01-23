extends Node


func instance_scene_on_main(scene, location, init_params := {}):
	var main = get_tree().current_scene
	var instance = scene.instantiate()
	
	if init_params != {}:
		instance.init(init_params)
	
	main.add_child(instance)
	instance.global_position = location
	return instance
