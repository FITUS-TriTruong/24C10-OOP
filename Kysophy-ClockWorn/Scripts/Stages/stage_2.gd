extends StageTemplate

func _ready() -> void:
	# Set stage properties
	stage_name = "Stage 2"
	next_stage_path = "res://Class/Stage_3.tscn"
	previous_stage_path = "res://Class/Stage_1.tscn"
	
	# Call the parent's _ready function
	super._ready()

func stage_ready() -> void:
	# Stage 2 specific initialization
	print("Stage 2 loaded successfully!")

# Override transition events if needed
func on_next_level_entered(body: CharacterBody2D) -> void:
	print("Player entered the exit area of Stage 2 (going to Stage 3)")

func on_next_level_exited(body: CharacterBody2D) -> void:
	print("Player left the exit area of Stage 2")

func on_previous_level_entered(body: CharacterBody2D) -> void:
	print("Player entered the return area of Stage 2 (going back to Stage 1)")

func on_previous_level_exited(body: CharacterBody2D) -> void:
	print("Player left the return area of Stage 2")
