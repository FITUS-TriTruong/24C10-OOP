extends StaticBody2D

@onready var interaction_area = $InteractionArea
@onready var collision_shape = $CollisionShape2D

func Door1():
	pass

func _ready():
	if interaction_area:
		interaction_area.interact = Callable(self, "_show_dialogue")
	
func _show_dialogue():
	DialogueManager.show_example_dialogue_balloon(load("res://Scripts/Dialogues/Doors1.dialogue"), "start")
