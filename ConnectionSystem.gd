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
var allNodes = []

func _ready():
	energyNode.connect("canMoveAgain", self, "moveEnergyNode")
	
	disperseNodes()
	leftNodes = leftSide.get_children()
	rightNodes = rightSide.get_children()
	energyNode.currentIndex = 0
	moveEnergyNode()
	#energyNode.moveNode(leftNodes[0], leftNodes[1])
	#energyNode.currentIndex = 0

func disperseNodes():
	var spacingInterval = 50
	for i in range(5):
		var newConnectNodeLeft = connectNodeScene.instance()
		var newConnectNodeRight = connectNodeScene.instance()
		leftSide.add_child(newConnectNodeLeft)
		rightSide.add_child(newConnectNodeRight)
		newConnectNodeLeft.global_position = Vector2(leftSide.global_position.x, leftSide.global_position.y + spacingInterval)
		newConnectNodeRight.global_position = Vector2(rightSide.global_position.x, rightSide.global_position.y + spacingInterval)
		allNodes = [] + leftSide.get_children()
		allNodes = allNodes + rightSide.get_children()
		spacingInterval += 50

func _moveEnergyNode():
	print("This is being called")
	if energyNode.currentIndex < leftNodes.size() - 1:
		#energyNode.currentIndex += 1
		print("Current Index is " + str(energyNode.currentIndex))
		print("Moving from " + leftNodes[energyNode.currentIndex].name + " to " + leftNodes[energyNode.currentIndex+1].name)
		#energyNode.moveNode(leftNodes[energyNode.currentIndex], leftNodes[energyNode.currentIndex+1])
	#make it so that if there's a connection it moves across it
		if leftNodes[energyNode.currentIndex].nodeConnectedTo == null:
			print("Moving again!")
			energyNode.currentIndex += 1
			energyNode.moveNode(leftNodes[energyNode.currentIndex], leftNodes[energyNode.currentIndex+1])
		else:
			pass


		#need to think of a way to pass from left to right
		pass

func moveEnergyNode():
	var connectedNode = allNodes[energyNode.currentIndex].nodeConnectedTo
	if connectedNode == null || connectedNode == energyNode.previousNode:
		#if there's no connect, or the connection is one we just travelled across/from (don't want to keep going back and forth, as the current node is still connected to the old node)
		#move the node to the next one in the list
		var nextIndex 
		if allNodes[energyNode.currentIndex] == leftNodes.back()  || allNodes[energyNode.currentIndex] == rightNodes.back():
			pass
		else:
		#if energyNode.currentIndex+1 < allNodes.size():
			#if the next index is beyond the array size
			energyNode.moveNode(allNodes[energyNode.currentIndex], allNodes[energyNode.currentIndex+1])
	else:
		#if there is a connection and it's not the same one, move along it
		var connection = allNodes[energyNode.currentIndex].nodeConnectedTo
		energyNode.moveNode(allNodes[energyNode.currentIndex], connection)
		#energyNode.currentIndex = allNodes.find(connection)


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
