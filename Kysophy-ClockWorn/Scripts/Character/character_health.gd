class_name CharacterHealth
extends Node

# === SIGNALS ===
signal health_changed(new_health: int)
signal died()

# === PRIVATE VARIABLES ===
var _character: CharacterBody2D
var _is_alive: bool = true
var _ground_height: float = 0.0
var _was_on_floor_last_frame: bool = true

# === EXPORTED VARIABLES ===
@export var fall_damage_enabled: bool = true

# === NODE REFERENCES ===
var animation_controller: CharacterAnimationController

func initialize(character: CharacterBody2D, anim_controller: CharacterAnimationController) -> void:
	_character = character
	animation_controller = anim_controller

func handle_fall_damage() -> void:
	if not fall_damage_enabled:
		return
	
	var is_on_floor_now = _character.is_on_floor()
	
	# Check if we just landed
	if not _was_on_floor_last_frame and is_on_floor_now:
		_check_fall_damage()
	
	_was_on_floor_last_frame = _character.is_on_floor()

func track_fall_height() -> void:
	# Track ground height for fall damage
	if not _character.is_on_floor() and _ground_height == 0.0:
		_ground_height = _character.global_position.y

func _check_fall_damage() -> void:
	if _ground_height == 0.0:
		return
	
	var current_height = _character.global_position.y
	var fall_distance = abs(_ground_height - current_height)
	
	if fall_distance >= CharacterConstants.FALL_DAMAGE_THRESHOLD:
		await _take_fall_damage()
	
	_ground_height = 0.0

func _take_fall_damage() -> void:
	die()
	print("Taken fall damage!")
	
	if animation_controller:
		animation_controller.play_dying_animation()
		# Wait for animation then die
		await animation_controller.animation_finished

func die() -> void:
	_is_alive = false
	died.emit()

func handle_death_state() -> void:
	if animation_controller:
		animation_controller.play_dead_animation()
	# Could add respawn logic here

# === PUBLIC API ===
func is_alive() -> bool:
	return _is_alive

func set_alive(alive: bool) -> void:
	_is_alive = alive
	if not _is_alive:
		die()
