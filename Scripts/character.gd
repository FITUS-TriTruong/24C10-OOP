extends CharacterBody2D

var SPEED = 75.0
const JUMP_VELOCITY = -200.0

@onready var animated_sprite = $AnimatedSprite2D
var sitting_status = 0
var on_ladder:bool = false
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var can_move: bool = true

func _ready() -> void:
	add_to_group("player")

func _physics_process(delta: float) -> void:
	
	if not is_on_floor():
		if !on_ladder:
			velocity.y += gravity * delta
		else:
			velocity += get_gravity() * delta
	
	if on_ladder:
		if Input.is_action_just_pressed("Jump") and is_on_floor():
			velocity.y = SPEED*delta*20
		elif Input.is_action_just_pressed("Move down") and is_on_floor():
			velocity.y = SPEED*delta*20
		else:
			velocity.y = 0

	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var direction := Input.get_axis("Move_left", "Move_right")
	
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	
	if sitting_status == 1 and not Input.is_anything_pressed():
		return
	else:
		sitting_status = 0
	
	# Action animations
	if Input.is_action_pressed("Attack"):
		animated_sprite.play("Attack")
	elif Input.is_action_pressed("Kick"):
		animated_sprite.play("Kick")
		return
	elif Input.is_action_pressed("Sit") and sitting_status == 0:
		animated_sprite.play("Sitting")
		sitting_status = 1

	# Moving animations
	if is_on_floor():
		# Idle - Walk - Run
		if direction == 0:
			if sitting_status == 0:
				animated_sprite.play("Idle")
			else:
				animated_sprite.play("Seatted")
		else:
			if Input.is_action_pressed("Shift") == true:
				SPEED = 150
				animated_sprite.play("Run")
			else: 
				SPEED = 75
				animated_sprite.play("Walk")
	else:
		# Jump
		animated_sprite.play("Jump")
		
	# Flipping directions
	if direction > 0: 
		animated_sprite.flip_h = false
	elif direction < 0:
		animated_sprite.flip_h = true
	

func _on_ladd_er_body_entered(body: CharacterBody2D) -> void:
	if "animated_sprite" in body.name:
		on_ladder = true

func _on_ladd_er_body_exited(body: CharacterBody2D) -> void:
	if "animated_sprite" in body.name:
		on_ladder = false
