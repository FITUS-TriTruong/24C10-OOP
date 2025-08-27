extends StaticBody2D

@onready var interaction_area = $InteractionArea
@onready var mem: AnimatedSprite2D = $AnimatedSprite2D

func _ready():
	# Check if memory was already collected
	if Global.memory2:
		queue_free()  # Remove the memory object if already collected
		return
	
	print("Ready called for memory")
	mem.play("default")
	print("Mem animation started")
	interaction_area.interact = Callable(self, "_memory_acquire")
	print("Interact assigned")
	
func _memory_acquire():
	print("Memory acquired triggered")
	DialogueManager.show_example_dialogue_balloon(load("res://Scripts/Dialogues/Mem2.dialogue"))
	mem.visible = false
	interaction_area.queue_free()
	Global.collect_memory("memory2")
