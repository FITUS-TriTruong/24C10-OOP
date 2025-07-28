extends CharacterBody2D
class_name Character

# === CONSTANTS ===
const WALK_SPEED: float = 75.0
const RUN_SPEED: float = 150.0
const JUMP_VELOCITY: float = -200.0
const TILE_SIZE: int = 16
const FALL_DAMAGE_THRESHOLD: float = 3 * TILE_SIZE

# === ENUMS ===
enum CharacterState {
	IDLE,
	WALKING,
	RUNNING,
	JUMPING,
	SITTING,
	DYING,
	DEAD
}

# === EXPORTED VARIABLES ===
@export var fall_damage_enabled: bool = true
#@export var dialogue_resource: DialogueResource

# === PRIVATE VARIABLES ===
var _current_speed: float = WALK_SPEED
var _is_alive: bool = true
var _ground_height: float = 0.0
var _is_sitting: bool = false
var _direction: float = 0.0
var _was_on_floor_last_frame: bool = true
var _current_state: CharacterState = CharacterState.IDLE

# Interaction flags
var _tree_in_range: bool = false
var _leaf_item_in_range: bool = false

# === NODE REFERENCES ===
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

# === SIGNALS ===
signal health_changed(new_health: int)
signal state_changed(new_state: CharacterState)
signal died()

func _ready() -> void:
	# Ensure we have the character name for identification
	name = "Character"

func _physics_process(delta: float) -> void:
	if not _is_alive:
		_handle_death_state()
		return
	
	_handle_fall_damage()
	_apply_gravity(delta)
	_handle_input()
	_update_movement()
	_update_animations()
	
	move_and_slide()

# === GRAVITY & PHYSICS ===
func _apply_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	# Track ground height for fall damage
	if not is_on_floor() and _ground_height == 0.0:
		_ground_height = global_position.y

# === INPUT HANDLING ===
func _handle_input() -> void:
	# Handle dialogue interactions
	if Input.is_action_just_pressed("ui_accept"):
		if _leaf_item_in_range:
			_interact_with_leaf_item()
			return
		elif _tree_in_range:
			_interact_with_tree()
			return
	
	# Handle jumping
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		_jump()
	
	# Handle movement input
	_direction = Input.get_axis("Move_left", "Move_right")
	
	# Handle sitting
	if Input.is_action_just_pressed("Sit") and is_on_floor() and not _is_sitting:
		_start_sitting()
	elif _is_sitting and Input.is_anything_pressed() and not Input.is_action_pressed("Sit"):
		_stop_sitting()

# === MOVEMENT ===
func _update_movement() -> void:
	if _is_sitting:
		velocity.x = move_toward(velocity.x, 0, _current_speed)
		return
	
	# Update speed based on run input
	if Input.is_action_pressed("Shift") and _direction != 0:
		_current_speed = RUN_SPEED
	else:
		_current_speed = WALK_SPEED
	
	# Apply movement
	if _direction != 0:
		velocity.x = _direction * _current_speed
	else:
		velocity.x = move_toward(velocity.x, 0, _current_speed)

# === ANIMATIONS ===
func _update_animations() -> void:
	# Update sprite direction
	if _direction > 0:
		animated_sprite.flip_h = false
	elif _direction < 0:
		animated_sprite.flip_h = true
	
	# Determine and set animation based on state
	var new_state = _determine_character_state()
	if new_state != _current_state:
		_current_state = new_state
		state_changed.emit(_current_state)
		_play_state_animation(_current_state)

func _determine_character_state() -> CharacterState:
	if not _is_alive:
		return CharacterState.DEAD
	
	if not is_on_floor():
		return CharacterState.JUMPING
	
	if _is_sitting:
		return CharacterState.SITTING
	
	if _direction == 0:
		return CharacterState.IDLE
	elif _current_speed == RUN_SPEED:
		return CharacterState.RUNNING
	else:
		return CharacterState.WALKING

func _play_state_animation(state: CharacterState) -> void:
	match state:
		CharacterState.IDLE:
			animated_sprite.play("Idle")
		CharacterState.WALKING:
			animated_sprite.play("Walk")
		CharacterState.RUNNING:
			animated_sprite.play("Run")
		CharacterState.JUMPING:
			animated_sprite.play("Jump")
		CharacterState.SITTING:
			animated_sprite.play("Seatted")  # Note: keeping original spelling
		CharacterState.DYING:
			animated_sprite.play("Dying")
		CharacterState.DEAD:
			animated_sprite.play("ded")

# === ACTIONS ===
func _jump() -> void:
	velocity.y = JUMP_VELOCITY

func _start_sitting() -> void:
	_is_sitting = true
	animated_sprite.play("Sitting")

func _stop_sitting() -> void:
	_is_sitting = false

# === INTERACTIONS ===
func _interact_with_leaf_item() -> void:
	if has_node("/root/global"):
		get_node("/root/global").found_tree_item = true
	print("Found leaf item!")

#func _interact_with_tree() -> void:
	#if dialogue_resource:
		#DialogueManager.show_example_dialogue_balloon(dialogue_resource, "main")
	#else:
		## Fallback to loading the resource
		#var resource = load("res://main.dialogue")
		#if resource:
			#DialogueManager.show_example_dialogue_balloon(resource, "main")

# === DAMAGE SYSTEM ===
func _handle_fall_damage() -> void:
	if not fall_damage_enabled:
		return
	
	var is_on_floor_now = is_on_floor()
	
	# Check if we just landed
	if not _was_on_floor_last_frame and is_on_floor_now:
		_check_fall_damage()
	
	_was_on_floor_last_frame = is_on_floor_now

func _check_fall_damage() -> void:
	if _ground_height == 0.0:
		return
	
	var current_height = global_position.y
	var fall_distance = abs(_ground_height - current_height)
	
	if fall_distance >= FALL_DAMAGE_THRESHOLD:
		_take_fall_damage()
	
	_ground_height = 0.0

func _take_fall_damage() -> void:
	print("Taken fall damage!")
	_current_state = CharacterState.DYING
	animated_sprite.play("Dying")
	
	# Wait for animation then die
	await animated_sprite.animation_finished
	_die()

func _die() -> void:
	_is_alive = false
	_current_state = CharacterState.DEAD
	died.emit()

func _handle_death_state() -> void:
	animated_sprite.play("ded")
	# Could add respawn logic here

# === SIGNAL HANDLERS ===
func _on_detection_area_body_entered(body: Node2D) -> void:
	if body.has_method("Tree"):
		_tree_in_range = true

func _on_detection_area_body_exited(body: Node2D) -> void:
	if body.has_method("Tree"):
		_tree_in_range = false

func _on_leaf_detection_body_entered(body: Node2D) -> void:
	if body.has_method("character"):
		_leaf_item_in_range = true

func _on_leaf_detection_body_exited(body: Node2D) -> void:
	if body.has_method("character"):
		_leaf_item_in_range = false

# === PUBLIC API ===
func get_character_state() -> CharacterState:
	return _current_state

func is_alive() -> bool:
	return _is_alive

func set_alive(alive: bool) -> void:
	_is_alive = alive
	if not _is_alive:
		_die()

# Required for identification in other scripts
func character() -> void:
	pass
