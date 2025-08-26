extends StageTemplate

func _ready() -> void:
	# Set stage properties
	stage_name = "Final Stage"
	next_stage_path = ""  # No next stage - this is the end
	previous_stage_path = "res://Class/Stage_3.tscn"
	
	# Call the parent's _ready function
	super._ready()

func stage_ready() -> void:
	# Final stage specific initialization
	print("Final Stage loaded successfully!")

# Override transition events if needed
func on_next_level_entered(body: CharacterBody2D) -> void:
	print("Player completed the game!")
	# Could trigger ending sequence here

func on_next_level_exited(body: CharacterBody2D) -> void:
	pass

func on_previous_level_entered(body: CharacterBody2D) -> void:
	print("Player entered the return area of Final Stage (going back to Stage 3)")

func on_previous_level_exited(body: CharacterBody2D) -> void:
	print("Player left the return area of Final Stage")
