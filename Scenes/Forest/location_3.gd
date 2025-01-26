extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if Global.get_state_of_scene() == 1:
		var player = get_node("Player")
		player.position = Vector2(650, 250)  # Меняем позицию


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		global_position.x = 100
		get_tree().change_scene_to_file("res://Scenes/Forest/loca_3.tscn")
