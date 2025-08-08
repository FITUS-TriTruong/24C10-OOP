class_name CharacterInteraction
extends Node

# === SIGNALS ===
signal interaction_performed(interaction_type: String)

# === PRIVATE VARIABLES ===
var _character: CharacterBody2D
var _tree_in_range: bool = false
var _leaf_item_in_range: bool = false

# === NODE REFERENCES ===
var stamina_system: Node2D
var movement_controller: CharacterMovement

func initialize(character: CharacterBody2D, stamina_ref: Node2D, movement: CharacterMovement) -> void:
	_character = character
	stamina_system = stamina_ref
	movement_controller = movement

func handle_input() -> void:
	# Handle dialogue interactions
	if Input.is_action_just_pressed("ui_accept"):
		if _leaf_item_in_range:
			_interact_with_leaf_item()
			return
		#elif _tree_in_range:
			#_interact_with_tree()
			#return
	
	# Handle jumping
	if Input.is_action_just_pressed("Jump") and _character.is_on_floor():
		if _can_perform_action(CharacterConstants.STAMINA_JUMP_COST):
			movement_controller.jump()

func _can_perform_action(stamina_cost: float) -> bool:
	if stamina_system:
		return stamina_system.use_stamina(stamina_cost)
	return true  # If no stamina system, allow all actions

func _interact_with_leaf_item() -> void:
	if has_node("/root/global"):
		get_node("/root/global").found_tree_item = true
	print("Found leaf item!")
	interaction_performed.emit("leaf_item")

#func _interact_with_tree() -> void:
	#if dialogue_resource:
		#DialogueManager.show_example_dialogue_balloon(dialogue_resource, "main")
	#else:
		## Fallback to loading the resource
		#var resource = load("res://main.dialogue")
		#if resource:
			#DialogueManager.show_example_dialogue_balloon(resource, "main")

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
		var delta_y = _character.global_position.y - body.global_position.y
		if abs(delta_y) < 10:
			movement_controller.set_pushing(true)
		else:
			movement_controller.set_pushing(false)
			body.collision_layer = 1
			body.collision_mask = 1

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("RigidBody"):
		movement_controller.set_push_cooldown()
		body.collision_layer = 2
		body.collision_mask = 2

# === GETTERS ===
func is_tree_in_range() -> bool:
	return _tree_in_range

func is_leaf_item_in_range() -> bool:
	return _leaf_item_in_range
