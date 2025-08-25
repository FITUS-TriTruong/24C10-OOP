extends StaticBody2D

@onready var interaction_area = $InteractionArea
@onready var collision_shape = $CollisionShape2D

func smolCom():
	pass

func _ready():
	if interaction_area:
		interaction_area.interact = Callable(self, "_show_dialogue")
	
func _show_dialogue():
	if Global.memory0 and Global.memory1 and Global.memory2 and Global.memory3 and Global.memory4 and Global.memory5 and Global.memory6 and Global.memory7 and Global.memory8:
		DialogueManager.show_example_dialogue_balloon(load("res://Scripts/Dialogues/smallCom.dialogue"), "start")
	DialogueManager.show_example_dialogue_balloon(load("res://Scripts/Dialogues/error.dialogue"), "start")
