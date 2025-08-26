extends OptionButton

@onready var button_click: AudioStreamPlayer = $"../../ButtonClick"

func _ready():
	connect("mouse_entered", Callable(self, "_on_hover"))
	connect("pressed", Callable(self, "_on_pressed"))

func _on_hover():
	button_click.play()

func _on_pressed():
	button_click.play()
