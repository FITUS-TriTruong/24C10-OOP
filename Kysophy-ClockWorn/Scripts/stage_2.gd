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
	# Handle multiple areas if they exist in the scene
	setup_stage_2_areas()

func stage_process(delta: float) -> void:
	# Stage 2 specific per-frame logic (if needed)
	pass

func setup_stage_2_areas() -> void:
	# Stage 2 has two areas: Area2D (next level) and Area2D2 (previous level)
	# We need to find them and set them up properly
	var area_2d = find_child("Area2D") as Area2D
	var area_2d_2 = find_child("Area2D2") as Area2D
	
	if area_2d:
		# This is the next level area
		next_level_area = area_2d
		if not area_2d.body_entered.is_connected(_on_next_level_body_entered):
			area_2d.body_entered.connect(_on_next_level_body_entered)
		if not area_2d.body_exited.is_connected(_on_next_level_body_exited):
			area_2d.body_exited.connect(_on_next_level_body_exited)
	
	if area_2d_2:
		# This is the previous level area
		previous_level_area = area_2d_2
		if not area_2d_2.body_entered.is_connected(_on_previous_level_body_entered):
			area_2d_2.body_entered.connect(_on_previous_level_body_entered)
		if not area_2d_2.body_exited.is_connected(_on_previous_level_body_exited):
			area_2d_2.body_exited.connect(_on_previous_level_body_exited)

# Override transition events if needed
func on_next_level_entered(body: CharacterBody2D) -> void:
	print("Player entered the exit area of Stage 2 (going to Stage 3)")

func on_next_level_exited(body: CharacterBody2D) -> void:
	print("Player left the exit area of Stage 2")

func on_previous_level_entered(body: CharacterBody2D) -> void:
	print("Player entered the return area of Stage 2 (going back to Stage 1)")

func on_previous_level_exited(body: CharacterBody2D) -> void:
	print("Player left the return area of Stage 2")
