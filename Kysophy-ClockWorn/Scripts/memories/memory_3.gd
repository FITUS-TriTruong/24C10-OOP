extends StaticBody2D

@onready var interaction_area = $InteractionArea
@onready var mem = $AnimatedSprite2D

func _ready():
	# Check if memory was already collected
	if Global.memory3:
		queue_free()  # Remove the memory object if already collected
		return
	
	mem.play("default")
	interaction_area.interact = Callable(self, "_memory_acquire")
	
func _memory_acquire():
	DialogueManager.show_example_dialogue_balloon(load("res://Scripts/Dialogues/Mem3.dialogue"))
	mem.visible = false
	interaction_area.queue_free()
	Global.collect_memory("memory3")
