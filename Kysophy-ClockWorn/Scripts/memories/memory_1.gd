extends StaticBody2D

@onready var interaction_area = $InteractionArea
@onready var mem = $Sprite2D

func _ready():
	mem.play("default")
	interaction_area.interact = Callable(self, "_key_acquire")
	
func _key_acquire():
	DialogueManager.show_example_dialogue_balloon(load("res://Scripts/Dialogues/Mem1.dialogue"))
	mem.visible = false
	interaction_area.queue_free()
	Global.memory1 = true
