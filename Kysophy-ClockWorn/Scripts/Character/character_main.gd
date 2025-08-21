extends CharacterBody2D
class_name Character

# === EXPORTED VARIABLES ===
@export var fall_damage_enabled: bool = true

# === COMPONENT REFERENCES ===
var movement_controller: CharacterMovement
var animation_controller: CharacterAnimationController
var health_controller: CharacterHealth
var interaction_controller: CharacterInteraction

# === NODE REFERENCES ===
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var stamina_system: Node2D = $StaminaSystem
@onready var progress_bar: ProgressBar = $CanvasLayer/ProgressBar

# === SIGNALS ===
signal health_changed(new_health: int)
signal state_changed(new_state: CharacterState.State)
signal died()

func _ready() -> void:
	# Ensure we have the character name for identification
	name = "Character"
	add_to_group("player")
	
	# Initialize all components
	_setup_components()
	_connect_signals()

func _setup_components() -> void:
	# Create and initialize movement controller
	movement_controller = CharacterMovement.new()
	add_child(movement_controller)
	movement_controller.initialize(self, stamina_system)
	
	# Create and initialize animation controller
	animation_controller = CharacterAnimationController.new()
	add_child(animation_controller)
	animation_controller.initialize(animated_sprite, movement_controller)
	
	# Create and initialize health controller
	health_controller = CharacterHealth.new()
	add_child(health_controller)
	health_controller.fall_damage_enabled = fall_damage_enabled
	health_controller.initialize(self, animation_controller)
	
	# Create and initialize interaction controller
	interaction_controller = CharacterInteraction.new()
	add_child(interaction_controller)
	interaction_controller.initialize(self, stamina_system, movement_controller)

func _connect_signals() -> void:
	# Connect movement signals
	if movement_controller:
		movement_controller.state_changed.connect(_on_state_changed)
	
	# Connect health signals
	if health_controller:
		health_controller.health_changed.connect(_on_health_changed)
		health_controller.died.connect(_on_died)
	
	# Connect interaction signals
	if interaction_controller:
		interaction_controller.interaction_performed.connect(_on_interaction_performed)

func _physics_process(delta: float) -> void:
	# Update stamina UI
	if progress_bar:
		progress_bar.value = get_stamina_percent() * 500
	
	if is_stamina_exhausted():
		pass
	
	# Handle death state
	if not health_controller.is_alive():
		health_controller.handle_death_state()
		return
	
	# Handle fall damage and physics
	health_controller.handle_fall_damage()
	health_controller.track_fall_height()
	movement_controller.apply_gravity(delta)
	
	# Handle movement and interactions
	movement_controller.handle_push_cooldown(delta)
	_handle_input()
	movement_controller.update_movement()
	animation_controller.update_animations()
	
	move_and_slide()

func _handle_input() -> void:
	# Let both controllers handle their respective inputs
	interaction_controller.handle_input()
	movement_controller.handle_input()

# === SIGNAL HANDLERS ===
func _on_state_changed(new_state: CharacterState.State) -> void:
	state_changed.emit(new_state)

func _on_health_changed(new_health: int) -> void:
	health_changed.emit(new_health)

func _on_died() -> void:
	"""Handle character death signal"""
	# Save current stamina before death
	if stamina_system and stamina_system.has_method("save_current_stamina"):
		stamina_system.save_current_stamina()
	
	# Emit died signal for other systems
	died.emit()
	get_tree().change_scene_to_file("res://UI/Class/death_screen.tscn")

func respawn() -> void:
	"""Handle character respawn after death"""
	# Save current stamina before respawning
	if stamina_system and stamina_system.has_method("save_current_stamina"):
		stamina_system.save_current_stamina()
	
	get_tree().change_scene_to_file("res://Class/level_select.tscn")

func _on_interaction_performed(interaction_type: String) -> void:
	print("Interaction performed: ", interaction_type)

# === AREA SIGNAL HANDLERS (Connect these in the scene) ===
func _on_detection_area_body_entered(body: Node2D) -> void:
	if interaction_controller:
		interaction_controller._on_detection_area_body_entered(body)

func _on_detection_area_body_exited(body: Node2D) -> void:
	if interaction_controller:
		interaction_controller._on_detection_area_body_exited(body)

func _on_leaf_detection_body_entered(body: Node2D) -> void:
	if interaction_controller:
		interaction_controller._on_leaf_detection_body_entered(body)

func _on_leaf_detection_body_exited(body: Node2D) -> void:
	if interaction_controller:
		interaction_controller._on_leaf_detection_body_exited(body)

func _on_area_2d_body_entered(body: Node2D) -> void:
	if interaction_controller:
		interaction_controller._on_area_2d_body_entered(body)

func _on_area_2d_body_exited(body: Node2D) -> void:
	if interaction_controller:
		interaction_controller._on_area_2d_body_exited(body)

# === LADDER SYSTEM HANDLERS ===
func _on_ladder_body_entered(body: CharacterBody2D) -> void:
	if movement_controller:
		movement_controller._on_ladder_body_entered(body)

func _on_ladder_body_exited(body: CharacterBody2D) -> void:
	if movement_controller:
		movement_controller._on_ladder_body_exited(body)

# === PUBLIC API ===
func get_character_state() -> CharacterState.State:
	if movement_controller:
		return movement_controller.get_current_state()
	return CharacterState.State.IDLE

func is_alive() -> bool:
	if health_controller:
		return health_controller.is_alive()
	return true

func set_alive(alive: bool) -> void:
	if health_controller:
		health_controller.set_alive(alive)

func get_stamina_percent() -> float:
	if stamina_system:
		return stamina_system.get_stamina_percent()
	return 1.0

func is_stamina_exhausted() -> bool:
	if stamina_system:
		return stamina_system.exhausted
	return false

func is_facing_right() -> bool:
	if movement_controller:
		return movement_controller.get_facing_right()
	return true

func is_on_ladder() -> bool:
	if movement_controller:
		return movement_controller.is_on_ladder()
	return false

# Required for identification in other scripts
func character() -> void:
	pass
