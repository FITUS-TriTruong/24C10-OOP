extends StaticBody2D

@onready var interaction_area = $InteractionArea
@onready var collision_shape = $CollisionShape2D

func com():
	pass

func _ready():
	if interaction_area:
		interaction_area.interact = Callable(self, "_show_dialogue")
	DialogueManager.dialogue_ended.connect(_on_conversation_end)
	
func _show_dialogue():
	if Global.memory0 and Global.memory1 and Global.memory2 and Global.memory3 and Global.memory4 and Global.memory5 and Global.memory6 and Global.memory7 and Global.memory8:
		DialogueManager.show_example_dialogue_balloon(load("res://Scripts/Dialogues/bigCom.dialogue"), "start")
	DialogueManager.show_example_dialogue_balloon(load("res://Scripts/Dialogues/error.dialogue"), "start")

func _on_conversation_end(resource):
	if Global.package == true:
		print("Dialogue ended! Resource was: ", resource)
	if Global.package == true:
		Global.ending = "ending1"
		Global.conversation_finished_1.emit()
		get_tree().change_scene_to_file("res://Class/ending1.tscn")
	else:
		Global.ending = "ending2"
		Global.conversation_finished_2.emit()
		get_tree().change_scene_to_file("res://Class/ending2.tscn")
