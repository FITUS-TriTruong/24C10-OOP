extends Node2D

var entered=false;

func _on_next_level_body_entered(body: CharacterBody2D) -> void:
	entered=true


func _on_next_level_body_exited(body) -> void:
	entered=false

func _process(delta) -> void:
	if entered==true:
			get_tree().change_scene_to_file("res://Class/Stage_2.tscn")
