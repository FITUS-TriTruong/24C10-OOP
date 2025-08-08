extends Node2D

const DialogueButoonPreload = preload("res://Class/dialogue_button.tscn")

@onready var DialogueLabel: RichTextLabel = $HBoxContainer/VBoxContainer/RichTextLabel
@onready var SpeakerSprite: Sprite2D = $HBoxContainer/speaker/Sprite2D

var dialogue: Array[DE]
var current_dialogue_item: int = 0
var next_item: bool = true

var player_node = CharacterBody2D

func _ready() -> void:
	visible = false
	$HBoxContainer/VBoxContainer/button.visible = false
	
	for i in get_tree().get_nodes_in_group("player"):
		player_node = i
		
func _process(delta: float) -> void:
	if current_dialogue_item == dialogue.size():
		if !player_node:
			for i in get_tree().get_nodes_in_group("player"):
				player_node = i
			return
		player_node.can_move = true
		queue_free()
		return

func _function_resource(1: DialogueFunction) -> void:
	
