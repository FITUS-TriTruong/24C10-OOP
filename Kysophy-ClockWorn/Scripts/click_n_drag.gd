extends CharacterBody2D

var selected := false
var rest_point
var rest_nodes = []

@onready var sprite = $Sprite2D
var max_drag_distance := 150
var mouse_detecttion_Range := 50

func _ready():
	rest_nodes = get_tree().get_nodes_in_group("Zone")
	rest_point = rest_nodes[0].global_position
	rest_nodes[0].select()
	$Area2D.body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if body.is_in_group("player"):
		print("Player touched me!")

func _physics_process(delta):
	if selected:
		var mouse_pos = get_global_mouse_position()
		var dist = rest_point.distance_to(mouse_pos)

		if dist > max_drag_distance:
			# Clamp the position to the max distance
			var dir = (mouse_pos - rest_point).normalized()
			var target_pos = rest_point + dir * max_drag_distance
			global_position = lerp(global_position, target_pos, 25 * delta)
		else:
			# Within allowed range
			global_position = lerp(global_position, mouse_pos, 25 * delta)
	else:
		global_position = lerp(global_position, rest_point, 10 * delta)

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				# Only allow selecting when mouse is close
				if global_position.distance_to(get_global_mouse_position()) < mouse_detecttion_Range:
					selected = true
			else:
				selected = false
				var shortest_dist = 10
				for child in rest_nodes:
					var dist = global_position.distance_to(child.global_position)
					if dist < shortest_dist:
						child.select()
						rest_point = child.global_position
						shortest_dist = dist
