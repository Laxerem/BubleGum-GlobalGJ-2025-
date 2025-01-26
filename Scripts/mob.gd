extends CharacterBody2D

class_name Mob

var chase = false  # Флаг, указывающий, преследует ли моб игрока
var speed = 100  # Скорость движения моба
@onready var anim = $AnimatedSprite2D  # Ссылка на AnimatedSprite2D для анимации
@onready var player = $"../../Gum/Player"  # Ссылка на игрока (путь может отличаться)
var alive: bool = true
var health
var damage_zone = ""
var is_animation_locked = false

func _init(health: int = 100) -> void:
	self.health = health  # Задаем значение здоровья по умолчанию

func attach() -> void:
	pass
	
func chase_direction() -> void:
	pass

func death() -> void:
	alive = false
	velocity.x = 0
	velocity.y = 0
	await play_anim("Death")
	queue_free()

func play_anim(anim_name: String, lock: bool = false) -> void:
	is_animation_locked = lock
	anim.play(anim_name)
	if lock:
		await anim.animation_finished
		is_animation_locked = false

func _physics_process(delta: float) -> void:
	if alive == true:
		if not is_on_floor():
			velocity += get_gravity() * delta
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
				damage_zone.position.x = abs(damage_zone.position.x) * -1
				
			elif velocity.x > 0:
				anim.flip_h = false  # Переворачиваем спрайт в другую сторону
				damage_zone.position.x = abs(damage_zone.position.x) * 1
		else:
			velocity = Vector2.ZERO  # Если не преследуем, обнуляем скорость
			anim.play("Idle")  # Воспроизводим анимацию Idle

	# Перемещение с помощью физики
	move_and_slide()
