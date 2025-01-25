extends CharacterBody2D

var chase = false  # Флаг, указывающий, преследует ли моб игрока
var speed = 20  # Скорость движения моба

@onready var anim = $AnimatedSprite2D  # Ссылка на AnimatedSprite2D для анимации

# Called every physics frame
func _physics_process(delta: float) -> void:
	var player = $"../../Gum/Player"  # Ссылка на игрока (путь может отличаться)
	var direction = (player.position - self.position).normalized()  # Направление к игроку
	
	# Если моб не преследует игрока, то он остаётся в состоянии Idle
	if chase:
		anim.play("Idle")  # Запускаем анимацию бега
		velocity.x = direction.x * speed  # Горизонтальное движение
		velocity.y = direction.y * speed  # Вертикальное движение

		# Изменение направления взгляда (переворот спрайта)
		if velocity.x < 0:
			anim.flip_h = true  # Переворачиваем спрайт
		elif velocity.x > 0:
			anim.flip_h = false  # Переворачиваем спрайт в другую сторону
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
