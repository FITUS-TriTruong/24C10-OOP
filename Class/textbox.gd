extends CanvasLayer

const CHAR_READ_RATE = 0.05

@onready var textbox_container = $MarginContainer
@onready var start = $MarginContainer/MarginContainer/HBoxContainer/start
@onready var end = $MarginContainer/MarginContainer/HBoxContainer/end
@onready var label = $MarginContainer/MarginContainer/HBoxContainer/Label2

enum State {
	READY,
	READING,
	FINISH
}

var current_state = State.READY
var text_queue = []

func _ready():
	print("Starting state: State.READY")
	hide_textbox()
	queue_text("You look inside.")
	queue_text("There's nothing but-")
	
func _process(delta):
	match current_state:
		State.READY:
			if !text_queue.empty():
				display_text()
		State.READING:
			if Input.is_action_just_pressed("ui_accept"):
				label.percent_visible = 1.0
				$Tween.remove_all()
				end.text = "v"
				change_state(State.FINISHED)
		State.FINISHED:
			if Input.is_action_just_pressed("ui_accept"):
				change_state(State.READY)
				hide_textbox()

func queue_text(next_text):
	text_queue.push_back(next_text)
	
func hide_textbox():
	start.text = ""
	end.text = ""
	label.text = ""
	textbox_container.hide()

func show_textbox():
	start.text = "*"
	textbox_container.show()
	
func display_text():
	var next_text = text_queue.pop_front()
	
	
func change_state(next_state):
	current_state = next_state
	match current_state:
		State.READY:
			print("State changed to ready")
		State.READING:
			print("State changed to reading")
		State.FINISH:
			print("State changed to finish")
			
func _tween_complete(object, key):
	end.text = "ENTER"
	change_state(State.FINISH)
	
