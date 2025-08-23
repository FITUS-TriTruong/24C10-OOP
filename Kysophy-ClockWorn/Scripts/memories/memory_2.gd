extends StaticBody2D

@onready var interaction_area = $InteractionArea
@onready var mem: AnimatedSprite2D = $AnimatedSprite2D

func _ready():
	print("Ready called for memory")
	mem.play("default")
	print("Mem animation started")
	interaction_area.interact = Callable(self, "_key_acquire")
	print("Interact assigned")
	
func _key_acquire():
	print("Key acquired triggered")
	DialogueManager.show_example_dialogue_balloon(load("res://Scripts/Dialogues/Mem2.dialogue"))
	mem.visible = false
	interaction_area.queue_free()
	Global.memory2 = true
