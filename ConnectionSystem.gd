extends "res://Stations/StationScreen.gd"

var connecting = false
var lastConnected
var previousLastConnected
onready var lineConnection = get_node("LineConnection")
var connections = {}

func changeLastConnected(newNode):
	previousLastConnected = lastConnected
	lastConnected = newNode

func createConnection(newNode):
	connections[lastConnected] = newNode
	lineConnection.points[1] = newNode.global_position
	lastConnected.nodeConnectedTo = newNode
	newNode.nodeConnectedTo = lastConnected
	lineConnection = Line2D.new()
	add_child(lineConnection)
	lineConnection.add_point(Vector2())
	lineConnection.add_point(Vector2())
	connecting = false
	lastConnected = null

func _process(delta):
	if lastConnected != null && connecting:
		var mousePosition = get_global_mouse_position()
		lineConnection.points[0] = lastConnected.global_position
		lineConnection.points[1] = mousePosition
		#Input.
