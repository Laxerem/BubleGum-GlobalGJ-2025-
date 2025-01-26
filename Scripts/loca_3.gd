extends Node2D

#@onready var player = $Player
# Called when the node enters the scene tree for the first time.
#func _ready() -> void:
	#if Global.player_position != Vector2.ZERO:
		#player.global_position = Global.player_position
		#Global.player_position = Vector2.ZERO  # Сбрасываем позицию после применения

func _ready() -> void:
	if Global.get_state_of_scene() == 1:
		var player = get_node("Player")
		player.position = Vector2(650, 250)  # Меняем позицию
	if Global.get_state_of_scene() == 2:
		var player = get_node("Player")
		player.position = Vector2(650, 350)  # Меняем позицию
	if Global.get_state_of_scene() == 3:
		var player = get_node("Player")
		player.position = Vector2(650, 0)  # Меняем позицию

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		get_tree().change_scene_to_file("res://Scenes/Forest/Start_location.tscn")


func _on_go_to_loc_3_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		Global.set_state_of_scene(2)
		get_tree().change_scene_to_file("res://Scenes/Forest/location_3.tscn")


func _on_area_2d_2_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		Global.set_state_of_scene(3)
		get_tree().change_scene_to_file("res://Scenes/Air/Air_location.tscn")
