extends "res://Stations/StationScreen.gd"

var connecting = false
var lastConnected
var previousLastConnected
onready var lineConnection = get_node("LineConnection")
var connections = {}
onready var energyNode = get_node("EnergyNode")
var connectNodeScene = preload("res://Stations/TimerClickMinigame/ConnectNode.tscn")
onready var leftSide = get_node("LeftSide")
onready var rightSide = get_node("RightSide")

var leftNodes = []
var rightNodes = []

func _ready():
	energyNode.connect("canMoveAgain", self, "moveEnergyNode")
	
	disperseNodes()
	leftNodes = leftSide.get_children()
	rightNodes = rightSide.get_children()
	energyNode.moveNode(leftNodes[0], leftNodes[1])
	energyNode.currentIndex = 0

func disperseNodes():
	var spacingInterval = 50
	for i in range(5):
		var newConnectNodeLeft = connectNodeScene.instance()
		var newConnectNodeRight = connectNodeScene.instance()
		leftSide.add_child(newConnectNodeLeft)
		rightSide.add_child(newConnectNodeRight)
		newConnectNodeLeft.global_position = Vector2(leftSide.global_position.x, leftSide.global_position.y + spacingInterval)
		newConnectNodeRight.global_position = Vector2(rightSide.global_position.x, rightSide.global_position.y + spacingInterval)
		spacingInterval += 50


func moveEnergyNode():
	print("This is being called")
	if energyNode.currentIndex < leftNodes.size():
		energyNode.currentIndex += 1
		energyNode.moveNode(leftNodes[energyNode.currentIndex], leftNodes[energyNode.currentIndex+1])
	#make it so that if there's a connection it moves across it
		if leftNodes[energyNode.currentIndex].nodeConnectedTo == null:
			print("Moving again!")
			energyNode.currentIndex += 1
			energyNode.moveNode(leftNodes[energyNode.currentIndex], leftNodes[energyNode.currentIndex+1])
		else:
		#need to think of a way to pass from left to right
			pass

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
