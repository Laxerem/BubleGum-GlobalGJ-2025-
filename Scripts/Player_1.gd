extends Player

var GRAVITY = 1000.0
var JUMP_FORCE = 400  # Сила прыжка
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _init() -> void:
	# Инициализация значений
	self.health = 100  # Задаем значение здоровья по умолчанию
	self.anim = $AnimatedSprite2D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += GRAVITY * delta  # Учитываем delta для плавности
	else:
		velocity.y = 0  # Обнуляем вертикальную скорость на полу

	if Input.is_action_pressed("move_right"):
		velocity.x += SPEED
		anim.flip_h = false
	elif Input.is_action_pressed("move_left"):
		velocity.x -= SPEED
		anim.flip_h = true
	else:
		velocity.x = 0
		
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y -= 400
	
	# Если нажата кнопка стрельбы
	if Input.is_action_pressed("Left_click"):
		pass

	# Обновление анимации движения
	if velocity.x != 0 and not is_animation_locked:
		velocity = velocity.normalized() * SPEED
		play_anim("Run")
	elif not is_animation_locked:
		play_anim("Idle")

	# Перемещение
	move_and_slide()
