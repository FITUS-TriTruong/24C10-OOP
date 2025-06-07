extends Node2D

var entered=false;
var entered2=false;

func _on_area_2d_body_entered(body: CharacterBody2D) -> void:
	entered=true;
	
func _on_area_2d_body_exited(body: Node2D) -> void:
	entered=false;

func _on_area_2d_2_body_exited(body: CharacterBody2D) -> void:
	entered2=true;

func _on_area_2d_2_body_entered(body: Node2D) -> void:
	entered2=false;

func _process(delta) -> void:
	if entered==true:
			get_tree().change_scene_to_file("res://Class/Stage_3.tscn")
	if entered2==true:
			get_tree().change_scene_to_file("res://Class/Stage_1.tscn")
