class_name CharacterMovement
extends Node

# === SIGNALS ===
signal state_changed(new_state: CharacterState.State)

# === PRIVATE VARIABLES ===
var _character: CharacterBody2D
var _current_speed: float = CharacterConstants.WALK_SPEED
var _direction: float = 0.0
var _facing_right: bool = true
var _is_sitting: bool = false
var _is_action: bool = false
var _is_pushing: bool = false
var _push_cooldown_timer: float = 0.0
var _current_state: CharacterState.State = CharacterState.State.IDLE
var _on_ladder: bool = false

# === NODE REFERENCES ===
var stamina_system: Node2D

func initialize(character: CharacterBody2D, stamina_ref: Node2D) -> void:
	_character = character
	stamina_system = stamina_ref

func _ready() -> void:
	set_physics_process(false)  # Will be enabled by parent

func handle_push_cooldown(delta: float) -> void:
	if _push_cooldown_timer > 0:
		_push_cooldown_timer -= delta
		if _push_cooldown_timer <= 0:
			_push_cooldown_timer = 0
			_is_pushing = false

func handle_input() -> void:
	# Handle sitting
	if Input.is_action_just_pressed("Sit") and _character.is_on_floor():
		if not _is_sitting:
			start_sitting()
		else:
			stop_sitting()
		return
	
	# Exit sitting if any other input is pressed
	if _is_sitting and Input.is_anything_pressed() and not Input.is_action_pressed("Sit"):
		stop_sitting()
	
	# Action lock for attacks/kicks
	if _is_action:
		return
	
	# Handle movement input
	_direction = Input.get_axis("Move_left", "Move_right")
	if _direction == 0:
		_direction = Input.get_axis("ui_left", "ui_right")  # Fallback support

func update_movement() -> void:
	if _is_sitting or _is_action:
		_character.velocity.x = move_toward(_character.velocity.x, 0, _current_speed)
		return
	
	if _direction != 0:
		if _is_pushing:
			_character.velocity.x = _direction * (CharacterConstants.WALK_SPEED * 0.1)
		else:
			# Update speed based on run input and stamina
			if Input.is_action_pressed("Shift"):
				if stamina_system and not stamina_system.exhausted:
					_current_speed = CharacterConstants.RUN_SPEED
					# Continuous stamina drain while running
					stamina_system.use_stamina(CharacterConstants.STAMINA_RUN_COST * _character.get_physics_process_delta_time())
				else:
					# Fall back to walking if exhausted
					_current_speed = CharacterConstants.WALK_SPEED
			else:
				_current_speed = CharacterConstants.WALK_SPEED
			
			_character.velocity.x = _direction * _current_speed
	else:
		_character.velocity.x = move_toward(_character.velocity.x, 0, _current_speed)

func apply_gravity(delta: float) -> void:
	if not _character.is_on_floor():
		if not _on_ladder:
			_character.velocity += _character.get_gravity() * delta

func jump() -> void:
	_character.velocity.y = CharacterConstants.JUMP_VELOCITY

func start_sitting() -> void:
	_is_sitting = true

func stop_sitting() -> void:
	_is_sitting = false

func determine_character_state() -> CharacterState.State:
	if not _character.is_on_floor():
		return CharacterState.State.JUMPING
	
	if _is_sitting:
		return CharacterState.State.SITTING
	
	if _is_pushing and _direction != 0:
		return CharacterState.State.PUSHING if _direction > 0 else CharacterState.State.PULLING
	
	if _direction == 0:
		return CharacterState.State.IDLE
	elif _current_speed == CharacterConstants.RUN_SPEED:
		return CharacterState.State.RUNNING
	else:
		return CharacterState.State.WALKING

func update_state() -> void:
	var new_state = determine_character_state()
	if new_state != _current_state:
		_current_state = new_state
		state_changed.emit(_current_state)

# === LADDER SYSTEM ===
func _on_ladder_body_entered(body: CharacterBody2D) -> void:
	if body == _character or body.name == "Character":
		_on_ladder = true

func _on_ladder_body_exited(body: CharacterBody2D) -> void:
	if body == _character or body.name == "Character":
		_on_ladder = false

# === GETTERS ===
func get_direction() -> float:
	return _direction

func get_facing_right() -> bool:
	return _facing_right

func get_current_state() -> CharacterState.State:
	return _current_state

func is_sitting() -> bool:
	return _is_sitting

func is_action() -> bool:
	return _is_action

func is_pushing() -> bool:
	return _is_pushing

func is_on_ladder() -> bool:
	return _on_ladder

# === SETTERS ===
func set_facing_right(value: bool) -> void:
	_facing_right = value

func set_action(value: bool) -> void:
	_is_action = value

func set_pushing(value: bool) -> void:
	_is_pushing = value

func set_push_cooldown() -> void:
	_push_cooldown_timer = CharacterConstants.PUSH_COOLDOWN