extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_play_button_pressed() -> void:
	print("Start button pressed.")
	get_tree().change_scene_to_file("res://Class/Stage_1.tscn")

func _on_option_button_pressed() -> void:
	print("Option butotn pressed.")


func _on_quit_button_pressed() -> void:
	print("Quit button pressed.")
	get_tree().quit()
