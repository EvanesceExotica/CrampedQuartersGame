extends Node2D

onready var lineConnection = get_node("LineConnection")

func addPoint(node):
	#connect to the last dot and then add the mouse position to continue trace
	lineConnection.add_point(node.global_position)
	lineConnection.add_point(node.global_position)
	#lineConnection.add_point(get_global_mouse_position())

func _process(delta):    
	var mousePosition = get_global_mouse_position()
	lineConnection.points[lineConnection.points.size()-1] = mousePosition
