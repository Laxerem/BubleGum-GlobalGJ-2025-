extends Node

@onready var menu_music = $Menu
@onready var forest_music = $Forest
@onready var air_music = $Air

func play_music(num: int):
	if num == 1:
		menu_music.play()
	elif num == 2:
		forest_music.play()
	elif num == 3:
		air_music.play()

func stop_music():
	menu_music.stop()
	forest_music.stop()
	air_music.stop()
