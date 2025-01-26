extends CharacterBody2D

var chase = false  # Флаг, указывающий, преследует ли моб игрока
var speed = 150  # Скорость движения моба
var is_animation_locked = false
@onready var anim = $AnimatedSprite2D  # Ссылка на AnimatedSprite2D для анимации
@onready var head = $CollisionShape2D
@onready var player = $"../Player"  # Ссылка на игрока (путь может отличаться)
@onready var alive = true
var health = 100

func take_damage(count: int):
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
		if not is_on_floor():
			velocity += get_gravity() * delta
		var direction = (player.position - self.position).normalized()  # Направление к игроку
		if chase:
			if not is_animation_locked:
				play_anim("Idle")  # Воспроизводим анимацию Idle
			velocity.x = direction.x * speed  # Горизонтальное движение

			# Изменение направления взгляда (переворот спрайта)
			if velocity.x < 0:
				anim.flip_h = true  # Переворачиваем спрайт
				head.position.x = abs(head.position.x) * -1
				
			elif velocity.x > 0:
				anim.flip_h = false  # Переворачиваем спрайт в другую сторону
				head.position.x = abs(head.position.x) * 1
		else:
			velocity = Vector2.ZERO  # Если не преследуем, обнуляем скорость
			if not is_animation_locked:
				play_anim("Idle")  # Воспроизводим анимацию Idle

	# Перемещение с помощью физики
	move_and_slide()

func death():
	alive = false
	velocity.x = 0
	velocity.y = 0
	await play_anim("Death", true)
	queue_free()

func _on_damage_zone_body_entered(body: Node2D) -> void:
	if alive:
		print(body.name)
		if body.name == "Player":
			play_anim("Atack", true)
			body.take_damage(90)
			speed = 0
			await get_tree().create_timer(1.0).timeout # Задержка на 1 секунду
			speed = 100

func _on_danger_zone_body_entered(body: Node2D) -> void:
	if body.name == "Player":  # Проверяем, что это игрок
		chase = true  # Начинаем преследование

func _on_danger_zone_body_exited(body: Node2D) -> void:
	if body.name == "Player":  # Проверяем, что это игрок
		chase = false  # Прекращаем преследование
