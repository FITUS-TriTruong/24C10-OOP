# Stage Transition Debug Helper
# Add this to your stage_1.gd for debugging

extends StageTemplate

func _ready() -> void:
	# Set stage properties
	stage_name = "Stage 1"
	next_stage_path = "res://Class/Stage_2.tscn"
	previous_stage_path = ""  # No previous stage for Stage 1
	
	# Call the parent's _ready function
	super._ready()
	
	# Debug: Print area information
	print("=== STAGE 1 DEBUG INFO ===")
	print("Next level area found: ", next_level_area != null)
	if next_level_area:
		print("Next level area name: ", next_level_area.name)
		print("Next level area position: ", next_level_area.position)
	print("Stage path: ", next_stage_path)
	print("File exists: ", FileAccess.file_exists(next_stage_path))

func stage_ready() -> void:
	# Stage 1 specific initialization
	print("Stage 1 loaded successfully!")

func stage_process(delta: float) -> void:
	# Debug: Show transition state
	if can_go_to_next_level:
		print("Ready to transition! Path: ", next_stage_path)

# Override transition events if needed
func on_next_level_entered(body: CharacterBody2D) -> void:
	print("=== TRANSITION TRIGGERED ===")
	print("Player entered the exit area of Stage 1")
	print("Body name: ", body.name)
	print("Body groups: ", body.get_groups())
	print("Has character method: ", body.has_method("character"))
	print("Can go to next level: ", can_go_to_next_level)
	# Don't call change_scene_to_file here - let the parent template handle it

func on_next_level_exited(body: CharacterBody2D) -> void:
	print("Player left the exit area of Stage 1")
	print("Can go to next level: ", can_go_to_next_level)
