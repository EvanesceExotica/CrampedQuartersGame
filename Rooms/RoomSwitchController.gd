extends Node2D

var currentRoom
var currentCamera
var previousCamera
var paused
var roomSwitched = false
export (NodePath) var debugCamera

func _input(event):

	var destinationRoom
	#unassigned, these nodepaths will default to the current node
	if event.is_action_pressed("ui_right"):
		if currentRoom.roomToRight != NodePath():
			destinationRoom = currentRoom.roomToRight;
			roomSwitched = true

	elif event.is_action_pressed("ui_left"):
		if currentRoom.roomToLeft != NodePath():
			destinationRoom = currentRoom.roomToLeft;
			roomSwitched = true

	elif event.is_action_pressed("ui_up"):
		if currentRoom.roomAbove != NodePath():
			destinationRoom = currentRoom.roomAbove;
			roomSwitched = true

	elif event.is_action_pressed("ui_down"):
		if currentRoom.roomBelow != NodePath():
			destinationRoom = currentRoom.roomBelow;
			roomSwitched = true
	elif event.is_action_pressed("ui_pause"):
		if !paused:
			paused = true
			debugCamera.pauseAndMakeCurrentCamera()
		elif paused:
			paused = true
			SetToPreviousCamera()
			#SetDefaultCamera()
	else:
		roomSwitched = false
	if(roomSwitched && destinationRoom != NodePath()):
		#if you switched the room and there is a destination room, send out this signal and switch everything
		SignalManager.emit_signal("OnRoomSwitched", currentRoom, get_node(destinationRoom))
		currentRoom = get_node(destinationRoom)
		currentRoom.camera.current = true
		previousCamera = currentCamera
		currentCamera = currentRoom.camera
		roomSwitched = false

func SetToPreviousCamera():
	#for the purpose of pausing and unpaausing while debugging, jump back to the last camera that was being used
	previousCamera.current = true
	currentCamera = previousCamera

func SetDefaultCamera():
	currentRoom = get_parent().get_node("PassengerRoom")
	currentRoom.camera.current = true

func SetExternalCamera(whichCamera):
	previousCamera = currentCamera
	whichCamera.current = true
	currentCamera = whichCamera


func _ready():
	currentRoom = get_parent().get_node("PassengerRoom")
	SignalManager.connect("CameraSwitched", self, "SetExternalCamera")
	SignalManager.connect("ViewInsideShip", self, "SetDefaultCamera")
	#SignalManager.connect("ArrivedAtBlackHole", self, )
	pass
