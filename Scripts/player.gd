extends CharacterBody2D

class_name Player

# Свойства
@export var bullet: PackedScene  # Пуля
@onready var anim = $AnimatedSprite2D
const SPEED = 200  # Скорость персонажа
var health: int
var alive: bool = true
var is_animation_locked: bool = false

func _init() -> void:
	# Инициализация значений
	health = 100  # Задаем значение здоровья по умолчанию

func shoot() -> void:
	# Воспроизводим анимацию атаки
	play_anim("Atack", true)
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
	health -= count
	if health <= 0:
		death()
	else:
		play_anim("Damage", true)

func death() -> void:
	alive = false
	await play_anim("Death", true)
	queue_free()  # Удаляем объект после смерти
	get_tree().call_deferred("change_scene_to_file", "res://Scenes/menu.tscn")

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
