extends Node
class_name StageManager

# Singleton for managing stages globally
# Add this as an AutoLoad if you want global stage management

# Stage information storage
var current_stage: StageTemplate
var stage_history: Array[String] = []
var stage_start_time: float = 0.0

# Signals for stage events
signal stage_changed(from_stage: String, to_stage: String)
signal stage_completed(stage_name: String, completion_time: float)

func _ready() -> void:
	# Connect to scene changes
	get_tree().node_added.connect(_on_node_added)

func _on_node_added(node: Node) -> void:
	# Check if the added node is a stage
	if node is StageTemplate:
		register_stage(node as StageTemplate)

func register_stage(stage: StageTemplate) -> void:
	# Register a new stage
	var previous_stage_name = ""
	if current_stage:
		previous_stage_name = current_stage.stage_name
		var completion_time = Time.get_time_dict_from_system()["hour"] * 3600 + Time.get_time_dict_from_system()["minute"] * 60 + Time.get_time_dict_from_system()["second"] - stage_start_time
		stage_completed.emit(current_stage.stage_name, completion_time)
	
	current_stage = stage
	stage_start_time = Time.get_time_dict_from_system()["hour"] * 3600 + Time.get_time_dict_from_system()["minute"] * 60 + Time.get_time_dict_from_system()["second"]
	
	# Add to history
	stage_history.append(stage.stage_name)
	
	# Emit signal
	stage_changed.emit(previous_stage_name, stage.stage_name)
	
	print("Stage Manager: Registered stage - " + stage.stage_name)

func get_current_stage() -> StageTemplate:
	return current_stage

func get_stage_history() -> Array[String]:
	return stage_history.duplicate()

func get_stage_info() -> Dictionary:
	if not current_stage:
		return {}
	
	return {
		"current_stage": current_stage.stage_name,
		"stage_history": stage_history,
		"time_in_stage": get_time_in_current_stage(),
		"total_stages_completed": stage_history.size() - 1
	}

func get_time_in_current_stage() -> float:
	if not current_stage:
		return 0.0
	
	var current_time = Time.get_time_dict_from_system()["hour"] * 3600 + Time.get_time_dict_from_system()["minute"] * 60 + Time.get_time_dict_from_system()["second"]
	return current_time - stage_start_time

# Debug functions
func print_stage_info() -> void:
	var info = get_stage_info()
	print("=== Stage Manager Info ===")
	print("Current Stage: ", info.get("current_stage", "None"))
	print("Time in Stage: ", info.get("time_in_stage", 0.0), " seconds")
	print("Total Stages Completed: ", info.get("total_stages_completed", 0))
	print("Stage History: ", info.get("stage_history", []))
	print("========================")

func reset_stage_history() -> void:
	stage_history.clear()
	stage_start_time = Time.get_time_dict_from_system()["hour"] * 3600 + Time.get_time_dict_from_system()["minute"] * 60 + Time.get_time_dict_from_system()["second"]
	print("Stage Manager: History reset")
