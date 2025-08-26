extends Control

@onready var audio_name: Label = $HBoxContainer/Audio_name
@onready var audio_num: Label = $HBoxContainer/Audio_num
@onready var h_slider: HSlider = $HBoxContainer/HSlider

@export_enum("Master", "Music", "Sfx") var bus_name : String

var bus_index : int = 0

func _ready():
	h_slider.value_changed.connect(on_value_changed)
	get_bus_name_by_index()
	
	set_name_label_text()
	set_slider_value()
	
func set_name_label_text():
	audio_name.text = str(bus_name)  + " Volume" 

func set_audio_num_text():
	audio_num.text = str(int(h_slider.value * 100)) + "%"

func get_bus_name_by_index():
	bus_index = AudioServer.get_bus_index(bus_name)

func set_slider_value():
	h_slider.value = db_to_linear(AudioServer.get_bus_volume_db(bus_index))
	set_audio_num_text()

func on_value_changed(value : float):
	AudioServer.set_bus_volume_db(bus_index, linear_to_db(value))
	set_audio_num_text()
