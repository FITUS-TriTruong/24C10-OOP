extends Node2D

@onready var dialogue = $Dialogue
@onready var black_screen = $BlackScreen

var lines = [
	"You submitted the package.",
	"All the robots are once again awakened.",
	"War broke out, no one knows which side won.",
	"But screams, cries, guns and the clanking sounds echoed in your head.",
	"You excellently finished your mission.",
	"For your own kind, would you choose this all over again?"
]

var current_line = 0
var current_index = 0
var typing_speed = 0.05
var typing = false
var timer : Timer

func _ready():
	dialogue.text = ""
	black_screen.modulate.a = 0.0
	timer = Timer.new()
	timer.one_shot = false
	add_child(timer)
	timer.timeout.connect(_on_timer_timeout)
	_start_typing()

func _start_typing():
	dialogue.text = ""
	current_index = 0
	typing = true
	timer.start(typing_speed)

func _on_timer_timeout():
	var full_text = lines[current_line]
	if current_index < full_text.length():
		dialogue.text += full_text[current_index]
		current_index += 1
	else:
		typing = false
		timer.stop()
		set_process_unhandled_input(true)

func _unhandled_input(event):
	if event.is_action_pressed("ui_accept"):
		if typing:
			dialogue.text = lines[current_line]
			typing = false
			timer.stop()
		else:
			current_line += 1
			if current_line < lines.size():
				_start_typing()
			else:
				set_process_unhandled_input(false)
				_fade_to_black()

func _fade_to_black():
	var tween = create_tween()
	tween.tween_property(black_screen, "modulate:a", 1.0, 2.0)
