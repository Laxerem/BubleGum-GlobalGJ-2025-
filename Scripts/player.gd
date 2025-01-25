extends CharacterBody2D

const SPEED = 200 # Скорость персонажа

@onready var anim = $AnimatedSprite2D

func _physics_process(delta):
	# Сбрасываем скорость перед вычислением
	velocity = Vector2.ZERO

	# Горизонтальное движение
	if Input.is_action_pressed("move_right"):
		velocity.x += SPEED
		anim.flip_h = false;
	if Input.is_action_pressed("move_left"):
		velocity.x -= SPEED
		anim.flip_h = true;

	# Вертикальное движение
	if Input.is_action_pressed("move_up"):
		velocity.y -= SPEED
	if Input.is_action_pressed("move_down"):
		velocity.y += SPEED

	# Нормализуем скорость и умножаем на константу SPEED
	if velocity != Vector2.ZERO:
		velocity = velocity.normalized() * SPEED
		
	var direction = Input.get_axis("move_left", "move_right")
	if direction:
		anim.play("Run")
	elif not direction:
		anim.play("Idle")

	# Перемещаем персонажа
	move_and_slide()
