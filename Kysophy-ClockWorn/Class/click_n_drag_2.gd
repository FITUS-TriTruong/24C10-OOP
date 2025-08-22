extends CharacterBody2D

var selected := false
var rest_point
var rest_nodes = []

# Ellipse drag limits
var ellipse_a := 100   # horizontal radius
var ellipse_b := 190   # vertical radius
var mouse_detection_range := 20

func _ready():
	rest_nodes = get_tree().get_nodes_in_group("Zone")

	var closest_dist = INF
	var closest_zone = null
	for z in rest_nodes:
		var d = global_position.distance_to(z.global_position)
		if d < closest_dist:
			closest_dist = d
			closest_zone = z
	
	if closest_zone:
		rest_point = closest_zone.global_position
		closest_zone.select()
	else:
		rest_point = global_position

func _physics_process(delta):
	if selected:
		var mouse_pos = get_global_mouse_position()
		var relative = mouse_pos - rest_point

		var ellipse_value = pow(relative.x / ellipse_a, 2) + pow(relative.y / ellipse_b, 2)

		var target_pos = mouse_pos
		if ellipse_value > 1:
			var angle = atan2(relative.y / ellipse_b, relative.x / ellipse_a)
			target_pos = rest_point + Vector2(cos(angle) * ellipse_a, sin(angle) * ellipse_b)

		global_position = lerp(global_position, target_pos, 25 * delta)
	else:
		global_position = lerp(global_position, rest_point, 10 * delta)

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				# Only allow selecting when mouse is close
				if global_position.distance_to(get_global_mouse_position()) < mouse_detection_range:
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
