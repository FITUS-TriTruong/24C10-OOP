extends StageTemplate

func _ready() -> void:
	# Set stage properties
	stage_name = "Stage 3"
	next_stage_path = "res://Class/final_stage.tscn"
	previous_stage_path = "res://Class/Stage_2.tscn"
	
	# Call the parent's _ready function
	super._ready()

func stage_ready() -> void:
	# Stage 2 specific initialization
	print("Stage 2 loaded successfully!")

# Override transition events if needed
func on_next_level_entered(body: CharacterBody2D) -> void:
	print("Player entered the exit area of Stage 3 (going to final stage)")

func on_next_level_exited(body: CharacterBody2D) -> void:
	print("Player left the exit area of Stage 3")

func on_previous_level_entered(body: CharacterBody2D) -> void:
	print("Player entered the return area of Stage 3 (going back to Stage 2)")

func on_previous_level_exited(body: CharacterBody2D) -> void:
	print("Player left the return area of Stage 3")
