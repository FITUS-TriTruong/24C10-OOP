extends StaticBody2D

@onready var interaction_area = $InteractionArea
@onready var kEy = $Key

func key():
	pass

func _ready():
	interaction_area.interact = Callable(self, "_key_acquire")
	
func _key_acquire():
	kEy.visible = false
	Global.found_key = true
