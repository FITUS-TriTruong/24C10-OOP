extends Node2D
class_name StageTemplate

# Virtual properties
@export var stage_name: String = "Stage"
@export var next_stage_path: String = ""
@export var previous_stage_path: String = ""

# Pause Menu properties
@onready var pause_menu = $PauseMenu
var paused = false 

# Transition states
var can_go_to_next_level: bool = false
var can_go_to_previous_level: bool = false

# Optional references to stage elements
var next_level_area: Area2D
var previous_level_area: Area2D

func _ready() -> void:
	next_level_area = find_child("next_level") as Area2D
	previous_level_area = find_child("previous_level") as Area2D
	
	if next_level_area:
		if not next_level_area.body_entered.is_connected(_on_next_level_body_entered):
			next_level_area.body_entered.connect(_on_next_level_body_entered)
		if not next_level_area.body_exited.is_connected(_on_next_level_body_exited):
			next_level_area.body_exited.connect(_on_next_level_body_exited)
	
	if previous_level_area:
		if not previous_level_area.body_entered.is_connected(_on_previous_level_body_entered):
			previous_level_area.body_entered.connect(_on_previous_level_body_entered)
		if not previous_level_area.body_exited.is_connected(_on_previous_level_body_exited):
			previous_level_area.body_exited.connect(_on_previous_level_body_exited)
	
	var stage_manager = get_node_or_null("/root/StageManager")
	if stage_manager and stage_manager.has_method("register_stage"):
		stage_manager.register_stage(self)
	
	stage_ready()

func _process(delta: float) -> void:
	if can_go_to_next_level and next_stage_path != "":
		change_to_next_stage()
	elif can_go_to_previous_level and previous_stage_path != "":
		change_to_previous_stage()
	stage_process(delta)

func stage_ready() -> void:
	pass

func stage_process(delta: float) -> void:
	if(Input.is_action_just_pressed("pause")):
		pauseMenu()
	pass

func change_to_next_stage() -> void:
	print("Transitioning to next stage: " + next_stage_path)

	# 🔹 Unlock next stage before switching
	if next_stage_path != "":
		var regex = RegEx.new()
		if regex.compile("Stage_(\\d+)\\.tscn") == OK:
			var match = regex.search(next_stage_path)
			if match:
				var next_num = int(match.get_string(1))
				if Engine.has_singleton("Global"): # If Global is autoload
					Global.unlock_level(next_num)
					Global.save_game() # ✅ Save immediately after unlocking

	# 🔹 Load the next stage
	if FileAccess.file_exists(next_stage_path):
		get_tree().change_scene_to_file(next_stage_path)
	else:
		push_error("ERROR: Next stage file not found: " + next_stage_path)

func change_to_previous_stage() -> void:
	print("Transitioning to previous stage: " + previous_stage_path)
	if previous_stage_path != "" and FileAccess.file_exists(previous_stage_path):
		get_tree().change_scene_to_file(previous_stage_path)
	else:
		print("ERROR: Previous stage file not found: " + previous_stage_path)

# Signal handlers
func _on_next_level_body_entered(body: CharacterBody2D) -> void:
	if body.name == "Character" or body.is_in_group("player") or body.has_method("character"):
		can_go_to_next_level = true
		print("Player detected entering next level area: ", body.name)
		on_next_level_entered(body)

func _on_next_level_body_exited(body: CharacterBody2D) -> void:
	if body.name == "Character" or body.is_in_group("player") or body.has_method("character"):
		can_go_to_next_level = false
		print("Player detected exiting next level area: ", body.name)
		on_next_level_exited(body)

func _on_previous_level_body_entered(body: CharacterBody2D) -> void:
	if body.name == "Character" or body.is_in_group("player") or body.has_method("character"):
		can_go_to_previous_level = true
		print("Player detected entering previous level area: ", body.name)
		on_previous_level_entered(body)

func _on_previous_level_body_exited(body: CharacterBody2D) -> void:
	if body.name == "Character" or body.is_in_group("player") or body.has_method("character"):
		can_go_to_previous_level = false
		print("Player detected exiting previous level area: ", body.name)
		on_previous_level_exited(body)

# Virtual functions for level transition events
func on_next_level_entered(body: CharacterBody2D) -> void:
	pass

func on_next_level_exited(body: CharacterBody2D) -> void:
	pass

func on_previous_level_entered(body: CharacterBody2D) -> void:
	pass

func on_previous_level_exited(body: CharacterBody2D) -> void:
	pass

# Utility
func get_stage_info() -> Dictionary:
	return {
		"name": stage_name,
		"next_stage": next_stage_path,
		"previous_stage": previous_stage_path
	}

func set_stage_paths(next: String, previous: String = "") -> void:
	next_stage_path = next
	previous_stage_path = previous

# Pause Menu
func pauseMenu():
	paused = !paused
	if not paused:
		pause_menu.hide()
		Engine.time_scale = 1
	else:
		pause_menu.show()
		Engine.time_scale = 0
