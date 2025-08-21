class_name OptionsMenu
extends Control

@onready var exit_button: Button = $MarginContainer/exit_button

signal exit_option_menu

# Called when the node enters the scene tree for the first time.
func _ready() -> void: 
	exit_button.button_down.connect(press_option_exit)
	set_process(false)

func press_option_exit() -> void:
	emit_signal("exit_option_menu")
