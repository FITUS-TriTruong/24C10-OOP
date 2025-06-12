extends CharacterBody2D

const WALK_SPEED = 75.0
const RUN_SPEED = 150.0
const JUMP_VELOCITY = -200.0
const TILE_SIZE = 16
const FALL_LMT = 3 * TILE_SIZE

var tree_in_range = false 
var in_leaf_dec = false 

@onready var animated_sprite = $AnimatedSprite2D

var SPEED = WALK_SPEED
var alive = true
var ground_height = 0
var sitting_status = 0
var direction = 0
var falling = false

func _physics_process(delta: float) -> void:
	if not alive:
		animated_sprite.play("ded")
		return
	
	_fall_damage()

	_gravity(delta)
	_movement()
	_action()
	
	move_and_slide()

func _gravity(delta):
	if not is_on_floor():
		velocity += get_gravity() * delta
	if in_leaf_dec == true:
		if Input.is_action_just_pressed("ui_accept"):
			global.found_tree_item = true
			return 
	
	if tree_in_range == true:
		if Input.is_action_just_pressed("ui_accept"):
			DialogueManager.show_example_dialogue_balloon(load("res://main.dialogue"), "main")
			return
	
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	direction = Input.get_axis("Move_left", "Move_right")

	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	if not is_on_floor() and ground_height == 0:
		ground_height = global_position.y

func _movement():
	if is_on_floor():
		if direction == 0:
			if sitting_status == 0:
				animated_sprite.play("Idle")
			else:
				animated_sprite.play("Seatted")
		else:
			if Input.is_action_pressed("Shift"):
				SPEED = RUN_SPEED
				animated_sprite.play("Run")
			else:
				SPEED = WALK_SPEED
				animated_sprite.play("Walk")
	else:
		animated_sprite.play("Jump")
	
	if direction > 0:
		animated_sprite.flip_h = false
	elif direction < 0:
		animated_sprite.flip_h = true

func _action():
	if sitting_status == 1 and not Input.is_anything_pressed():
		return
	else:
		sitting_status = 0

	if Input.is_action_pressed("Sit") and sitting_status == 0:
		animated_sprite.play("Sitting")
		sitting_status = 1

func _fall_damage():
	if falling and is_on_floor():
		var cur_height = global_position.y
		var fall_distance = abs(ground_height - cur_height)

		if fall_distance >= FALL_LMT:
			print("Taken fall damage!")
			animated_sprite.play("Dying")
			#await get_tree().create_timer(0.5).timeout
			alive = false

		ground_height = 0
	falling = not is_on_floor()

func _on_detection_area_body_entered(body: Node2D) -> void:
	if body.has_method("Tree"):
		tree_in_range = true


func _on_detection_area_body_exited(body: Node2D) -> void:
	if body.has_method("Tree"):
		tree_in_range = false

func character():
	pass 

func _on_leafdetection_body_entered(body: Node2D) -> void:
	if body.has_method("character"):
		in_leaf_dec = true 


func _on_leafdetection_body_exited(body: Node2D) -> void:
	if body.has_method("character"):
		in_leaf_dec = false
