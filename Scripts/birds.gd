extends CharacterBody2D

var chase = false  # Флаг, указывающий, преследует ли моб игрока
var speed = 100  # Скорость движения моба
var is_animation_locked = false
@onready var anim = $AnimatedSprite2D  # Ссылка на AnimatedSprite2D для анимации
@onready var head = $Death/CollisionShape2D
@onready var player = $"../../Gum/Player"  # Ссылка на игрока (путь может отличаться)
@onready var alive = true
@onready var sounds = $Sounds
var health = 100

func take_damage(count: int):
	sounds.play_sound("Bird_damage")
	health -= count
	if health <= 0:
		death()
	else:
		play_anim("Damage", true)

func play_anim(anim_name: String, lock: bool = false) -> void:
	if not is_animation_locked:
		anim.play(anim_name)
	is_animation_locked = lock
	if lock:
		await anim.animation_finished
		is_animation_locked = false

# Called every physics frame
func _physics_process(delta: float) -> void:
	# Если моб не преследует игрока, то он остаётся в состоянии Idle
	if alive == true:
		if player == null:
			return
		var direction = (player.position - self.position).normalized()  # Направление к игроку
		if chase:
			play_anim("Idle")  # Запускаем анимацию бега
			velocity.x = direction.x * speed  # Горизонтальное движение
			velocity.y = direction.y * speed  # Вертикальное движение

			# Изменение направления взгляда (переворот спрайта)
			if velocity.x < 0:
				anim.flip_h = true  # Переворачиваем спрайт
				head.position.x = abs(head.position.x) * -1
				
			elif velocity.x > 0:
				anim.flip_h = false  # Переворачиваем спрайт в другую сторону
				head.position.x = abs(head.position.x) * 1
		else:
			velocity = Vector2.ZERO  # Если не преследуем, обнуляем скорость
			play_anim("Idle")  # Воспроизводим анимацию Idle

	# Перемещение с помощью физики
	move_and_slide()

# Сигнал, когда игрок входит в зону преследования
func _on_detector_body_entered(body: Node2D) -> void:
	if body.name == "Player":  # Проверяем, что это игрок
		chase = true  # Начинаем преследование

# Сигнал, когда игрок выходит из зоны преследования
func _on_detector_body_exited(body: Node2D) -> void:
	if body.name == "Player":  # Проверяем, что это игрок
		chase = false  # Прекращаем преследование

func death():
	alive = false
	velocity.x = 0
	velocity.y = 0
	await play_anim("Death", true)
	queue_free()

func _on_death_body_entered(body: Node2D) -> void:
	if alive:
		print(body.name)
		if body.name == "Player":
			body.take_damage(20)
			speed = 0
			await get_tree().create_timer(1.0).timeout # Задержка на 1 секунду
			speed = 100
