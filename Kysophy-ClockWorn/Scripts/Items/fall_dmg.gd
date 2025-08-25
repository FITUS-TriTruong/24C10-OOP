extends StageTemplate

@onready var interaction_area = $InteractionArea
@onready var collision_shape = $CollisionShape2D
@onready var next_level: Area2D = $next_level

# Stage-specific initialization
func stage_ready() -> void:
	if interaction_area:
		interaction_area.interact = Callable(self, "_show_dialogue")
		
# Your custom logic
func fallDmg():
	pass

func _show_dialogue():
	DialogueManager.show_example_dialogue_balloon(
		load("res://Scripts/Dialogues/warnFalldmg.dialogue"), "start"
	)

func on_next_level_entered(_body: CharacterBody2D) -> void:
	get_tree().change_scene_to_file("res://Class/Stage_2.tscn")
