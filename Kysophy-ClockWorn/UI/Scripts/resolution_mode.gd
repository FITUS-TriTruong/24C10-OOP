extends Control

@onready var option_button: OptionButton = $HBoxContainer/OptionButton

const RESOLUTION_D : Dictionary = {
	"1280 x 720"  : Vector2i(1280, 720),
	"960 x 540" : Vector2i(960, 540),
	"640 x 360" : Vector2i(640 , 360)
}

func _ready() ->void:
	option_button.item_selected.connect(on_resolution_selected)
	add_resolution_item()
	
func add_resolution_item() -> void:
	for resolution_size_text in RESOLUTION_D:
		option_button.add_item(resolution_size_text)

func on_resolution_selected(index: int) -> void:
	DisplayServer.window_set_size(RESOLUTION_D.values()[index])
