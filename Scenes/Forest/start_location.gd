extends Node2D

func _ready() -> void:
	if Global.get_state_of_scene() == 1:
		var player = get_node("Player")
		player.position = Vector2(650, 250)  # Меняем позицию
	else:
		MusicManager.play_music(2)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		Global.set_state_of_scene(1)
		get_tree().call_deferred("change_scene_to_file", "res://Scenes/Forest/loca_3.tscn")


func _on_water_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		body.take_damage(100)
