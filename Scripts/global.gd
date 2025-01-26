extends Node

var states_scenes = {}

func _ready():
	pass

func get_state_of_scene():
	var current_scene = get_tree().get_current_scene()
	print(current_scene.name)
	print(states_scenes)
	if current_scene.name in states_scenes:
		return states_scenes[current_scene.name]
	else:
		return 0
		
func set_state_of_scene(value: int):
	var current_scene = get_tree().get_current_scene()
	states_scenes[current_scene.name] = value
