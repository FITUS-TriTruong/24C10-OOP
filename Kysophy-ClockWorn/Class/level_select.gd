# 
extends Control

@onready var grid_container := $LevelMenu/ClipControl/HBoxContainer

var num_grids = 1
var current_grid = 1
var grid_width = 387

func _ready():
	# The 'Global' script is autoloaded, so we can access it directly.
	num_grids = grid_container.get_child_count()
	grid_width = grid_container.custom_minimum_size.x
	setup_level_box()
	connect_level_selected_to_level_box()

func setup_level_box():
	# This function now correctly sets the locked status based on global progress.
	for grid_index in range(grid_container.get_child_count()):
		var grid = grid_container.get_child(grid_index)
		for box_index in range(grid.get_child_count()):
			var box = grid.get_child(box_index)
			# Calculate the level number for the button
			box.level_num = box_index + 1 + (grid.get_child_count() * grid_index)
			box.get_node("Label").text = str(box.level_num)
			# Lock the level if its number is greater than the highest unlocked level
			box.locked = box.level_num > Global.game_data.unlocked_level


func connect_level_selected_to_level_box():
	for grid in grid_container.get_children():
		for box in grid.get_children():
			box.connect("level_selected", change_to_scene)
			
func change_to_scene(level_num: int):
	var next_level: String = "res://Class/Stage_" + str(level_num) + ".tscn"
	if FileAccess.file_exists(next_level):
		get_tree().change_scene_to_file(next_level)
	
func _on_back_button_pressed() -> void:
	if current_grid > 1:
		current_grid -=1
		animateGridPosition(grid_container.position.x + grid_width)

func _on_next_button_pressed() -> void:
	if current_grid < num_grids:
		current_grid +=1
		animateGridPosition(grid_container.position.x - grid_width)

func animateGridPosition(finalValue):
	create_tween().set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT).tween_property(
		grid_container, "position:x", finalValue, 0.5
		)


func _on_texture_button_pressed() -> void:
	get_tree().change_scene_to_file("res://UI/Class/MainMenu.tscn")
