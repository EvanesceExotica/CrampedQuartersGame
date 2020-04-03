extends Node2D

onready var lineConnection = get_node("LineConnection")
onready var mouseFollow = get_node("MouseFollow")
var outOfBounds = false
var followPosition
var lastNodeTouched
enum directions{
	vertical,
	horizontal
}
func _ready():
	lastNodeTouched = get_node("CircuitNode")
	Input.warp_mouse_position(lastNodeTouched.global_position)
	mouseFollow.global_position = get_global_mouse_position()

func addPoint(node):
	#connect to the last dot and then add the mouse position to continue trace
	lastNodeTouched = node
	lineConnection.add_point(node.global_position)
	lineConnection.add_point(node.global_position)

	#lineConnection.add_point(get_global_mouse_position())

func _process(delta):    
	var mousePosition = get_global_mouse_position()
	followPosition = mousePosition
	if lastNodeTouched.direction == directions.horizontal:
		#have it only move along the horizotal parallel to the last node
		followPosition.y = clamp(followPosition.y, lastNodeTouched.global_position.y, lastNodeTouched.global_position.y)
		#have it only move to the right of the horizontal node, not to the left of it
		followPosition.x = clamp(followPosition.x, lastNodeTouched.global_position.x, get_viewport_rect().size.x)

	elif lastNodeTouched.direction == directions.vertical:
		#have it only move along the vertical, parallel to the last node
		followPosition.x = clamp(followPosition.x, lastNodeTouched.global_position.x, lastNodeTouched.global_position.x)
		#have it only move to the south of the vertical node, not to the north of it
		followPosition.y = clamp(followPosition.y, lastNodeTouched.global_position.y, get_viewport_rect().size.y)
	mouseFollow.global_position = followPosition

	if !outOfBounds:
		lineConnection.points[lineConnection.points.size()-1] = followPosition
