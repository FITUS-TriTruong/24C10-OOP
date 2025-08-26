extends Control

@onready var play_button: Button = $MarginContainer/VBoxContainer/PlayButton
@onready var option_button: Button = $MarginContainer/VBoxContainer/OptionButton
@onready var quit_button: Button = $MarginContainer/VBoxContainer/QuitButton

@export var level_selector = preload("res://Class/level_select.tscn")

@onready var margin_container: MarginContainer = $MarginContainer
@onready var option_menu: OptionsMenu = $OptionMenu

# background
@onready var background: Panel = $BackgroundPanel
var parallax_factor: float = 0.05
var smoothness: float = 0.1
var background_initial_pos: Vector2
var current_offset: Vector2 = Vector2()

# buttons
@onready var v_box_container: VBoxContainer = $MarginContainer/VBoxContainer
@onready var button_click: AudioStreamPlayer = $ButtonClick

# intro
var skipped = false
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var bg_music: AudioStreamPlayer = $BgMusic
@onready var ding: AudioStreamPlayer = $Ding
@onready var color_rect: ColorRect = $ColorRect
@onready var team_clockworn: Sprite2D = $teamClockworn

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	background_initial_pos = background.position
	if GlobalMenu.alreadyPlayed:
		bg_music.play()
		color_rect.queue_free()
		team_clockworn.queue_free()
	else:
		GlobalMenu.alreadyPlayed = true
		introSequence()
	
	for child in v_box_container.get_children():
		if child is Button:  # make sure it's a button
			child.connect("mouse_entered", Callable(self, "_on_button_hover"))
			child.connect("pressed", Callable(self, "_on_button_pressed"))
		
	play_button.button_down.connect(press_play)
	option_button.button_down.connect(press_option)
	quit_button.button_down.connect(press_quit)
	option_menu.exit_option_menu.connect(press_option_exit)
	
func _process(_delta):
	var mouse_pos = get_viewport().get_mouse_position()
	var screen_center = Vector2(get_viewport().size.x, get_viewport().size.y) / 2
	var target_offset = (mouse_pos - screen_center) * parallax_factor
	current_offset = current_offset.lerp(target_offset, smoothness)
	background.position = background_initial_pos + current_offset
	
	if Input.is_action_just_pressed("skip_intro") and not skipped:
		skipped = true
		_skip_intro()
	
func introSequence():
	animation_player.play("Intro")
	await get_tree().create_timer(1.8).timeout
	ding.play()
	await get_tree().create_timer(0.3).timeout
	bg_music.play()
	
	await animation_player.animation_finished 
	color_rect.queue_free()
	team_clockworn.queue_free()
	
func _skip_intro():
	animation_player.stop()
	bg_music.play()
	color_rect.queue_free()
	team_clockworn.queue_free()
	GlobalMenu.alreadyPlayed = true
	
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
	
func _on_button_hover():
	button_click.play()
	
func _on_button_pressed():
	button_click.play()
