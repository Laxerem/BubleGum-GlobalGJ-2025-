extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var audio = $AudioStreamPlayer2D
	audio.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Forest/Start_location.tscn")

func _on_exit_pressed() -> void:
	get_tree().quit()
