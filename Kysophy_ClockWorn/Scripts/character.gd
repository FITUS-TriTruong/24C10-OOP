extends CharacterBody2D
#class_name Character

# === CONSTANTS ===
const WALK_SPEED: float = 90.0
const RUN_SPEED: float = 120.0
const JUMP_VELOCITY: float = -200.0
const TILE_SIZE: int = 16
const FALL_DAMAGE_THRESHOLD: float = 3 * TILE_SIZE
const PUSH_COOLDOWN: float = 0.6

# === STAMINA CONSTANTS ===
const STAMINA_RUN_COST: float = 8.0
const STAMINA_JUMP_COST: float = 12.0
const STAMINA_KICK_COST: float = 15.0
const STAMINA_ATTACK_COST: float = 10.0

# === ENUMS ===
enum CharacterState {
	IDLE,
	WALKING,
	RUNNING,
	JUMPING,
	SITTING,
	ATTACKING,
	KICKING,
	PUSHING,
	PULLING,
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

# Movement flags
var _facing_right: bool = true
var _is_action: bool = false
var _is_pushing: bool = false
var _push_cooldown_timer: float = 0.0
var _on_ladder: bool = false

# Interaction flags
var _tree_in_range: bool = false
var _leaf_item_in_range: bool = false

# === NODE REFERENCES ===
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var stamina_system: Node2D = $StaminaSystem
@onready var progress_bar: ProgressBar = $CanvasLayer/ProgressBar

# === SIGNALS ===
signal health_changed(new_health: int)
signal state_changed(new_state: CharacterState)
signal died()

func _ready() -> void:
	# Ensure we have the character name for identification
	name = "Character"
	add_to_group("player")
	
	# Connect stamina system if available
	if stamina_system:
		# Connect any stamina-related signals here if needed
		pass
	
	# Connect animation finished signal
	if animated_sprite:
		animated_sprite.connect("animation_finished", Callable(self, "_on_animation_finished"))

func _physics_process(delta: float) -> void:
	progress_bar.value = get_stamina_percent() * 100
	if is_stamina_exhausted() :
		pass
	
	if not _is_alive:
		_handle_death_state()
		return
	
	_handle_fall_damage()
	_apply_gravity(delta)
	_handle_push_cooldown(delta)
	_handle_input()
	_update_movement()
	_update_animations()
	
	move_and_slide()

# === GRAVITY & PHYSICS ===
func _apply_gravity(delta: float) -> void:
	if not is_on_floor():
		if not _on_ladder:
			velocity += get_gravity() * delta
	
	# Track ground height for fall damage
	if not is_on_floor() and _ground_height == 0.0:
		_ground_height = global_position.y

func _handle_push_cooldown(delta: float) -> void:
	if _push_cooldown_timer > 0:
		_push_cooldown_timer -= delta
		if _push_cooldown_timer <= 0:
			_push_cooldown_timer = 0
			_is_pushing = false

# === INPUT HANDLING ===
func _handle_input() -> void:
	# Handle dialogue interactions
	if Input.is_action_just_pressed("ui_accept"):
		if _leaf_item_in_range:
			_interact_with_leaf_item()
			return
		#elif _tree_in_range:
			#_interact_with_tree()
			#return
	
	# Handle sitting
	if Input.is_action_just_pressed("Sit") and is_on_floor():
		if not _is_sitting:
			_start_sitting()
		else:
			_stop_sitting()
		return
	
	# Exit sitting if any other input is pressed
	if _is_sitting and Input.is_anything_pressed() and not Input.is_action_pressed("Sit"):
		_stop_sitting()
	
	# Action lock for attacks/kicks
	if _is_action:
		return
	
	# Handle attacks
	if Input.is_action_just_pressed("Attack"):
		if _can_perform_action(STAMINA_ATTACK_COST):
			_is_action = true
			animated_sprite.play("Attack")
		return
	
	if Input.is_action_just_pressed("Kick"):
		if _can_perform_action(STAMINA_KICK_COST):
			_is_action = true
			animated_sprite.play("Kick")
		return
	
	# Handle jumping
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		if _can_perform_action(STAMINA_JUMP_COST):
			_jump()
	
	# Handle movement input
	_direction = Input.get_axis("Move_left", "Move_right")
	if _direction == 0:
		_direction = Input.get_axis("ui_left", "ui_right")  # Fallback support

# === MOVEMENT ===
func _update_movement() -> void:
	if _is_sitting or _is_action:
		velocity.x = move_toward(velocity.x, 0, _current_speed)
		return
	
	if _direction != 0:
		if _is_pushing:
			velocity.x = _direction * (WALK_SPEED * 0.1)
		else:
			# Update speed based on run input and stamina
			if Input.is_action_pressed("Shift"):
				if stamina_system and not stamina_system.exhausted:
					_current_speed = RUN_SPEED
					# Continuous stamina drain while running
					stamina_system.use_stamina(STAMINA_RUN_COST * get_physics_process_delta_time())
				else:
					# Fall back to walking if exhausted
					_current_speed = WALK_SPEED
			else:
				_current_speed = WALK_SPEED
			
			velocity.x = _direction * _current_speed
	else:
		velocity.x = move_toward(velocity.x, 0, _current_speed)

# === ANIMATIONS ===
func _update_animations() -> void:
	# Update sprite direction
	if _direction > 0:
		animated_sprite.flip_h = false
		_facing_right = true
	elif _direction < 0:
		animated_sprite.flip_h = true
		_facing_right = false
	
	# Determine and set animation based on state
	var new_state = _determine_character_state()
	if new_state != _current_state:
		_current_state = new_state
		state_changed.emit(_current_state)
		_play_state_animation(_current_state)

func _determine_character_state() -> CharacterState:
	if not _is_alive:
		return CharacterState.DEAD
	
	if _is_action and animated_sprite.animation == "Attack":
		return CharacterState.ATTACKING
	
	if _is_action and animated_sprite.animation == "Kick":
		return CharacterState.KICKING
	
	if not is_on_floor():
		return CharacterState.JUMPING
	
	if _is_sitting:
		return CharacterState.SITTING
	
	if _is_pushing and _direction != 0:
		return CharacterState.PUSHING if _direction > 0 else CharacterState.PULLING
	
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
		CharacterState.ATTACKING:
			animated_sprite.play("Attack")
		CharacterState.KICKING:
			animated_sprite.play("Kick")
		CharacterState.PUSHING:
			animated_sprite.play("Push")
		CharacterState.PULLING:
			animated_sprite.play("Pull")
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

# === STAMINA SYSTEM ===
func _can_perform_action(stamina_cost: float) -> bool:
	if stamina_system:
		return stamina_system.use_stamina(stamina_cost)
	return true  # If no stamina system, allow all actions

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

# === PUSH SYSTEM HANDLERS ===
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("RigidBody"):
		var delta_y = global_position.y - body.global_position.y
		if abs(delta_y) < 10:
			_is_pushing = true
			_push_cooldown_timer = 0.0
		else:
			_is_pushing = false
			body.collision_layer = 1
			body.collision_mask = 1

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("RigidBody"):
		_push_cooldown_timer = PUSH_COOLDOWN
		body.collision_layer = 2
		body.collision_mask = 2

# === LADDER SYSTEM HANDLERS ===
func _on_ladder_body_entered(body: CharacterBody2D) -> void:
	if body == self or body.name == "Character":
		_on_ladder = true

func _on_ladder_body_exited(body: CharacterBody2D) -> void:
	if body == self or body.name == "Character":
		_on_ladder = false

# === ANIMATION HANDLERS ===
func _on_animation_finished() -> void:
	if animated_sprite.animation == "Kick" or animated_sprite.animation == "Attack":
		_is_action = false
		_play_idle_animation()

func _play_idle_animation() -> void:
	if _is_sitting:
		animated_sprite.play("Seatted")
	else:
		animated_sprite.play("Idle")

# === PUBLIC API ===
func get_character_state() -> CharacterState:
	return _current_state

func is_alive() -> bool:
	return _is_alive

func set_alive(alive: bool) -> void:
	_is_alive = alive
	if not _is_alive:
		_die()

func get_stamina_percent() -> float:
	if stamina_system:
		return stamina_system.get_stamina_percent()
	return 1.0

func is_stamina_exhausted() -> bool:
	if stamina_system:
		return stamina_system.exhausted
	return false

func is_facing_right() -> bool:
	return _facing_right

func is_on_ladder() -> bool:
	return _on_ladder

# Required for identification in other scripts
func character() -> void:
	pass
