# Stage Creation Template
# This is a template for creating new stages in the game
# Copy this template and modify it for each new stage

extends StageTemplate

func _ready() -> void:
	# Set stage properties - MODIFY THESE VALUES
	stage_name = "New Stage"  # Change this to your stage name
	next_stage_path = "res://Class/NextStage.tscn"  # Path to next stage or "" if final
	previous_stage_path = "res://Class/PreviousStage.tscn"  # Path to previous stage or "" if first
	
	# Call the parent's _ready function - DON'T CHANGE THIS
	super._ready()

func stage_ready() -> void:
	# Stage-specific initialization code goes here
	print(stage_name + " loaded successfully!")
	
	# Add any stage-specific setup here:
	# - Initialize stage-specific variables
	# - Setup special mechanics
	# - Configure stage elements
	
	# Example:
	# setup_special_mechanics()
	# initialize_stage_variables()

func stage_process(delta: float) -> void:
	# Stage-specific per-frame logic goes here
	# This is called every frame after the template's _process
	
	# Example:
	# update_stage_mechanics(delta)
	# check_win_conditions()
	pass

# Override transition events if you need custom behavior
func on_next_level_entered(body: CharacterBody2D) -> void:
	# Called when player enters the area to go to next level
	print("Player entered the exit area of " + stage_name)
	
	# Add custom logic here if needed:
	# - Play sound effects
	# - Show transition animations
	# - Check if player met requirements to advance

func on_next_level_exited(body: CharacterBody2D) -> void:
	# Called when player leaves the area to go to next level
	print("Player left the exit area of " + stage_name)

func on_previous_level_entered(body: CharacterBody2D) -> void:
	# Called when player enters the area to go to previous level
	print("Player entered the return area of " + stage_name)

func on_previous_level_exited(body: CharacterBody2D) -> void:
	# Called when player leaves the area to go to previous level
	print("Player left the return area of " + stage_name)

# Add your custom stage methods here
# Examples:

# func setup_special_mechanics() -> void:
#     # Setup any special mechanics for this stage
#     pass

# func initialize_stage_variables() -> void:
#     # Initialize any stage-specific variables
#     pass

# func update_stage_mechanics(delta: float) -> void:
#     # Update stage-specific mechanics each frame
#     pass

# func check_win_conditions() -> bool:
#     # Check if the player has met win conditions for this stage
#     return false
