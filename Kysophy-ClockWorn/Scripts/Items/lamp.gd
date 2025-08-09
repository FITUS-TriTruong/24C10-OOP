extends StaticBody2D

@onready var interaction_area = $InteractionArea
@onready var sprite = $Sprite2D2

var is_on = false

func _ready():
	interaction_area.interact = Callable(self, "_toggle_lamp")
	
func _toggle_lamp():
	is_on = not is_on
	if is_on:
		sprite.visible = 1
	else:
		sprite.visible = 0
