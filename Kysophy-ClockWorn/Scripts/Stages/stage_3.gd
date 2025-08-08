extends StageTemplate

func _ready() -> void:
	# Set stage properties
	stage_name = "Stage 3"
	next_stage_path = ""  # No next stage for Stage 3 (final stage)
	previous_stage_path = "res://Class/Stage_2.tscn"
	
	# Call the parent's _ready function
	super._ready()

func stage_ready() -> void:
	# Stage 3 specific initialization
	print("Stage 3 loaded successfully!")

# Override transition events if needed
func on_previous_level_entered(body: CharacterBody2D) -> void:
	print("Player entered the return area of Stage 3 (going back to Stage 2)")

func on_previous_level_exited(body: CharacterBody2D) -> void:
	print("Player left the return area of Stage 3")

# Stage 3 might have specific end-game logic
func complete_game() -> void:
	print("Congratulations! You've completed all stages!")
	# Add any end-game logic here
