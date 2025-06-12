extends Node2D

func _process(delta):
	if global.found_tree_item == true:
		$Leaf.visible = false
