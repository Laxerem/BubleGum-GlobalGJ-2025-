extends CharacterBody2D

class_name Player

# Свойства
@export var bullet: PackedScene  # Пуля
@onready var anim = $AnimatedSprite2D
const SPEED = 200  # Скорость персонажа
var health: int
var alive: bool = true
var is_animation_locked: bool = false
@onready var sounds = $Sounds

func _init() -> void:
	# Инициализация значений
	health = 100  # Задаем значение здоровья по умолчанию

func shoot() -> void:
	# Воспроизводим анимацию атаки
	sounds.play_sound("Shoot")
	play_anim("Atack", true)
	await get_tree().create_timer(0.35).timeout
	# Создаем экземпляр пули
	var bul = bullet.instantiate()
	# Добавляем пулю в дерево сцены
	get_tree().root.add_child(bul)  
	# Устанавливаем начальную позицию пули
	bul.global_position = $Node2D/Marker2D.global_position
	# Определяем направление пули в зависимости от взгляда персонажа
	var direction = Vector2.RIGHT if not anim.flip_h else Vector2.LEFT
	# Устанавливаем направление для пули
	bul.shoot(direction)

func take_damage(count: int) -> void:
	sounds.play_sound("Damage")
	health -= count
	if health <= 0:
		death()
	else:
		play_anim("Damage", true)

func death() -> void:
	alive = false
	sounds.play_sound("Death")
	await play_anim("Death", true)
	Global.reset_states()
	queue_free()  # Удаляем объект после смерти
	MusicManager.stop_music()
	get_tree().call_deferred("change_scene_to_file", "res://Scenes/menu/menu.tscn")

func play_anim(anim_name: String, lock: bool = false) -> void:
	is_animation_locked = lock
	anim.play(anim_name)
	if lock:
		await anim.animation_finished
		is_animation_locked = false

func _physics_process(delta: float) -> void:
	if not alive:
		return  # Если персонаж мертв, не обрабатываем физику
	
	# Управление движением
	velocity = Vector2.ZERO
	if not is_animation_locked:  # Блокируем управление во время важной анимации
		if Input.is_action_pressed("move_right"):
			velocity.x += SPEED
			anim.flip_h = false
		if Input.is_action_pressed("move_left"):
			velocity.x -= SPEED
			anim.flip_h = true
			
		if Input.is_action_pressed("move_up"):
			velocity.y -= SPEED
		if Input.is_action_pressed("move_down"):
			velocity.y += SPEED
		
		# Если нажата кнопка стрельбы
		if Input.is_action_pressed("Left_click"):
			shoot()

	# Обновление анимации движения
	if velocity != Vector2.ZERO and not is_animation_locked:
		velocity = velocity.normalized() * SPEED
		play_anim("Run")
	elif not is_animation_locked:
		play_anim("Idle")

	# Перемещение
	move_and_slide()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		Global.set_state_of_scene(3)
		get_tree().change_scene_to_file("res://Scenes/Forest/loca_3.tscn")
