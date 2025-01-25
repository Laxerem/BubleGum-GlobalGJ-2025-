extends CharacterBody2D

const SPEED = 200 # Скорость персонажа
@export var bullet : PackedScene

@onready var anim = $AnimatedSprite2D
var last_health = 100
var health = 100
var alive = true
var damage_animation = false

func shoot():
	damage_animation = true
	anim.play("Atack")
	var bul = bullet.instantiate()
	get_tree().root.add_child(bul)
	await anim.animation_finished
	damage_animation = false

func _physics_process(delta):
	if alive:
		# Управление движением
		velocity = Vector2.ZERO
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
		if Input.is_action_pressed("Left_click") and damage_animation == false:
			shoot()
		if velocity != Vector2.ZERO:
			velocity = velocity.normalized() * SPEED
			if damage_animation == false:
				anim.play("Run")
		else:
			if damage_animation == false:
				anim.play("Idle")

	move_and_slide()

func death():
	alive = false
	velocity = Vector2.ZERO
	anim.play("Death")
	await anim.animation_finished
	queue_free()
	get_tree().call_deferred("change_scene_to_file", "res://Scenes/menu.tscn")

func _process(delta):
	if health < last_health and health > 0:
		damage_animation = true
		anim.play("Damage")
		await anim.animation_finished
		last_health = health
		damage_animation = false
		
	if health <= 0:
		death()
