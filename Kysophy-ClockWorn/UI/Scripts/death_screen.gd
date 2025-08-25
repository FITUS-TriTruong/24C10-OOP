extends CanvasLayer

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var death_sound: AudioStreamPlayer = $DeathSound

func _ready() -> void:
	death_sound.play()
	animation_player.play("fade_to_black")

func _on_retry_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Class/level_select.tscn")

func _on_quit_button_pressed() -> void:
	get_tree().change_scene_to_file("res://UI/Class/main_menu.tscn")
