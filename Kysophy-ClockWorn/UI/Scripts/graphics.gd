extends TabBar

@onready var button_click: AudioStreamPlayer = $"../../ButtonClick"

func _ready():
	# Connect TabBar signals
	connect("tab_hovered", Callable(self, "_on_tab_hovered"))
	connect("tab_selected", Callable(self, "_on_tab_selected"))

func _on_tab_hovered(tab: int) -> void:
	button_click.play()

func _on_tab_selected(tab: int) -> void:
	button_click.play()
