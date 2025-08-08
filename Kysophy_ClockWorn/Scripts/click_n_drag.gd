extends CharacterBody2D

var selected := false
var rest_point: Vector2
var rest_nodes := []

@onready var sprite = $Sprite2D

func _ready():
	rest_nodes = get_tree().get_nodes_in_group("Zone")
	if rest_nodes.size() > 0:
		rest_point = rest_nodes[0].global_position
		if rest_nodes[0].has_method("select"):
			rest_nodes[0].select()
	$Area2D.body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if body.is_in_group("player"):
		print("Player touched me!")

func _physics_process(delta):
	if selected:
		global_position = lerp(global_position, get_global_mouse_position(), 25 * delta)
	else:
		global_position = lerp(global_position, rest_point, 10 * delta)

func _unhandled_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			selected = true
		else:
			selected = false
			var closest_node = null
			var shortest_dist = INF
			for child in rest_nodes:
				var dist = global_position.distance_to(child.global_position)
				if dist < shortest_dist:
					shortest_dist = dist
					closest_node = child
			if closest_node:
				if closest_node.has_method("select"):
					closest_node.select()
				rest_point = closest_node.global_position
