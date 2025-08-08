extends StageTemplate

@onready var pause_menu = $PauseMenu
var paused = false 

func _ready() -> void:
	# Set stage properties
	stage_name = "Stage 1"
	next_stage_path = "res://Class/Stage_2.tscn"
	previous_stage_path = ""  # No previous stage for Stage 1
	
	# Call the parent's _ready function
	super._ready()

func stage_ready() -> void:
	# Stage 1 specific initialization
	print("Stage 1 loaded successfully!")

func stage_process(delta: float) -> void:
	# Stage 1 specific per-frame logic (if needed)
	pass

# Override transition events if needed
func on_next_level_entered(body: CharacterBody2D) -> void:
	print("Player entered the exit area of Stage 1")
	can_go_to_next_level = true

func on_next_level_exited(body: CharacterBody2D) -> void:
	print("Player left the exit area of Stage 1")
	can_go_to_next_level = false

func _process(delta):
	if Input.is_action_just_pressed("pause"):
		pauseMenu()

func pauseMenu():
	paused = !paused
	if not paused:
		pause_menu.hide()
		Engine.time_scale = 1
	else: 
		pause_menu.show()
		Engine.time_scale = 0
