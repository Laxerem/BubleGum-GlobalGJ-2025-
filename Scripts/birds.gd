extends CharacterBody2D

var chase = false  # Флаг, указывающий, преследует ли моб игрока
var speed = 100  # Скорость движения моба

@onready var anim = $AnimatedSprite2D  # Ссылка на AnimatedSprite2D для анимации
@onready var head = $Death/CollisionShape2D
@onready var player = $"../../Gum/Player"  # Ссылка на игрока (путь может отличаться)
@onready var alive = true

# Called every physics frame
func _physics_process(delta: float) -> void:
	# Если моб не преследует игрока, то он остаётся в состоянии Idle
	if alive == true:
		if player == null:
			return
		var direction = (player.position - self.position).normalized()  # Направление к игроку
		if chase:
			anim.play("Idle")  # Запускаем анимацию бега
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
			anim.play("Idle")  # Воспроизводим анимацию Idle

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
	anim.play("Death")
	await anim.animation_finished
	queue_free()

func _on_death_body_entered(body: Node2D) -> void:
	print(body.name)
	if body.name == "Player":
		body.health -= 20
