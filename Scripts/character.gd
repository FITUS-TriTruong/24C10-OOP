extends CharacterBody2D

var SPEED = 75.0
const JUMP_VELOCITY = -200.0
var tree_in_range = false 
var in_leaf_dec = false 
@onready var animated_sprite = $AnimatedSprite2D
var sitting_status = 0

func _physics_process(delta: float) -> void:
	
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
