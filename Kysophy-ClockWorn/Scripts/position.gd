extends Marker2D

var show_hint := false        # toggled by the drag script
@export var hint_radius := 6.0
@export var hint_color := Color(0.3, 0.6, 1.0, 0.9)  # blue-ish

func _draw():
	if show_hint:
		# draw one small circle at the zone's position (center of this Marker2D)
		draw_circle(Vector2.ZERO, hint_radius, hint_color)

func select():
	for child in get_tree().get_nodes_in_group("Zone"):
		child.deselect()

func deselect():
	# nothing visual here for now
	pass
