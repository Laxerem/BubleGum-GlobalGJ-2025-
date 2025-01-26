extends Node2D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		get_tree().change_scene_to_file("res://Scenes/Forest/loca_3.tscn")


func _on_water_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		body.take_damage(100)
