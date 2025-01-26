extends Node2D

@onready var player = $Player
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if Global.player_position != Vector2.ZERO:
		player.global_position = Global.player_position
		Global.player_position = Vector2.ZERO  # Сбрасываем позицию после применения


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		get_tree().change_scene_to_file("res://Scenes/Forest/Start_location.tscn")


func _on_go_to_loc_3_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		get_tree().change_scene_to_file("res://Scenes/Forest/location_3.tscn")


func _on_area_2d_2_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		get_tree().change_scene_to_file("res://Scenes/Air/Air_location.tscn")
