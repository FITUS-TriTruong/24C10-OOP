extends Control

@onready var play_button: Button = $MarginContainer/VBoxContainer/PlayButton
@onready var option_button: Button = $MarginContainer/VBoxContainer/OptionButton
@onready var quit_button: Button = $MarginContainer/VBoxContainer/QuitButton

@export var level_selector = preload("res://Class/level_select.tscn")

@onready var margin_container: MarginContainer = $MarginContainer
@onready var option_menu: OptionsMenu = $OptionMenu

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	play_button.button_down.connect(press_play)
	option_button.button_down.connect(press_option)
	quit_button.button_down.connect(press_quit)
	option_menu.exit_option_menu.connect(press_option_exit)


func press_play() -> void:
	print("Start button pressed.")
	get_tree().change_scene_to_packed(level_selector)

func press_option() -> void:
	print("Option button pressed.")
	set_process(true)
	margin_container.visible = false
	option_menu.visible = true

func press_option_exit() -> void:
	print("Option exit button pressed.")
	set_process(true)
	margin_container.visible = true
	option_menu.visible = false

func press_quit() -> void:
	print("Quit button pressed.")
	get_tree().quit()
