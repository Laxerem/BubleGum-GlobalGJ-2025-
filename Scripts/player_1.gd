extends Player

const JUMP_VELOCITY = -400.0


func _init() -> void:
	anim = $AnimatedSprite2D
	health = 100
	
func _physics_process(delta: float) -> void:
	if not alive:
		return  # Если персонаж мертв, не обрабатываем физику
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		if not is_animation_locked:
			play_anim("Jump", true)

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	if Input.is_action_pressed("move_left"):
		anim.flip_h = true
	if Input.is_action_pressed("move_right"):
		anim.flip_h = false
		
	var direction := Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * SPEED
		if not is_animation_locked and is_on_floor():
			play_anim("Run")
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		if not is_animation_locked:
			play_anim("Idle")
		

	move_and_slide()
