extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export(int) var width;
export(int) var height;
export(int) var x_start;
export(int) var y_start;
export(int) var offset;
var allSpaces = []
var stars = preload("res://Stars.tscn")
var starInstance 
export(int) var locationsMin = 3
export(int) var locationsMax = 7

var generatedLocations = {}
onready var area2d = get_node("Area2D")
onready var colshape2d = area2d.get_node("CollisionShape2D")
onready var spacetimeJumpButton = get_node("HSplitContainer/SpacetimeJump")


onready var timer = get_node("Timer")
var startingLocation
var currentLocation
var beaconLocation
var selectedNextLocation
var previousLocation
# Called when the node enters the scene tree for the first time.
var locationNode = preload("res://LocationNode.tscn")

onready var lineHolder = get_node("LineHolder")

export(int) var lineWidth = 5
export(Color) var lineColor = Color("#a2b2ff")
onready var locationHolder = get_node("LocationHolder")

var currentlyTravelling = false
var travelStartTime = 0
var timeToDestination = 0

var connectionsMade = {}

func spawnInArea():
	var centerpos = colshape2d.position + area2d.position
	var size = colshape2d.shape.extents*2

	randomize()


	var numberOfLocations = floor(rand_range(locationsMin, locationsMax+1))
	#find a random numer of locations between min and max
	for i in range(numberOfLocations):
		var star = locationNode.instance()
		#initialize the location
	
		var spawnPosition = Vector2(0, 0)
	#var testX = randi() % int(size.x)

		var lowestPositionX = int(size.x/2) * area2d.global_scale.x
		var lowestPositionY = int(size.y/2) * area2d.global_scale.y
		var lowestPosition = Vector2(lowestPositionX, lowestPositionY)
	
		var highestPositionX = int(-size.x/2) * area2d.global_scale.x
		var highestPositionY = int(-size.y/2) * area2d.global_scale.y
		var highestPosition = Vector2(highestPositionX, highestPositionY)
	
		spawnPosition.x = ((randi()% int(size.x) - (size.x/2)) * area2d.global_scale.x) + centerpos.x

		spawnPosition.y = ((randi()% int(size.y) - (size.y/2)) * area2d.global_scale.y) + centerpos.y 

		#find random position for location^

		
		star.position = spawnPosition #spawnPositio

		locationHolder.add_child(star)

		#add to holder in scene for organization 
		star.label.text = str(i)

		#add to dictionary where we'll register the connections with other locations V
		generatedLocations[star] = []
		#SignalManager.emit_signal("LocationNodesGenerated", generatedLocations.keys())
		connectionsMade[star] = []
	for location in generatedLocations.keys():
		location.z_index = 50
		findClosestNode(location)

func printConnections():
	for location in generatedLocations.keys():
		var s = " "
		for connection in generatedLocations[location]:
			s += connection.label.text + " , "
		print(location.label.text + " is connected to " + s)

func findClosestNode(node):

	var nearestLocation = generatedLocations.keys()[0]
	var secondNearestLocation
	for location in generatedLocations.keys():
		if location == node:
			#make sure the same node as is 'node' isn't being chosen
			continue
		if generatedLocations[location].size() > 0 :

			#the ggeneratedLocations stores the location and the ones it's connected to
			#this will skip the first node with a connection, but the last node that doesn't have one can connect to any before
			#make sure the location doesn't already have a connection to it
			continue
		if location.position.distance_to(node.position) < 80:
			#print(location.label.text + " too close to " + node.label.text)
			#if too close to another node, push it out a bit
			#THIS DOESN'T GARUNTEE IT'LL BE FARTHER AWAY 
			var position = location.position
			location.position = Vector2(position.x + 80, position.y+80)

		if location.position.distance_to(node.position) < nearestLocation.position.distance_to(node.position):
			#find the closest location that isn't already connected and isn't the same node

			#store the location that's the second closest
			secondNearestLocation = nearestLocation
			nearestLocation = location
	
	#set these to demonstrate these two nodes already have a connection
	generatedLocations[node].append(nearestLocation)
	generatedLocations[nearestLocation].append(node)
			#TODO: ADD THESE LINES TO DETERMINE HOW LONG IT TAKES TO TRAVEL, WHICH DIRECTION TO GO WHICH YOU CAN JUMP TO AND SUCH
	#draw a new line, make it between the points, add it to the scene
	var newLine = Line2D.new()
	var point1 = node.position
	var point2 = nearestLocation.position
	#var point1 = to_local(node.position)
	#var point2 = to_local(nearestLocation.position)
	newLine.add_point(point1)
	newLine.add_point(point2)
	newLine.default_color = lineColor
	newLine.width = lineWidth
	connectionsMade[node].append(newLine) #figure out while all lines aren't being connected back
	connectionsMade[nearestLocation].append(newLine)

	#newLine.points = [Vector2(node.position.x, node.position.y), Vector2(nearestLocation.position.x, nearestLocation.position.y)]
	lineHolder.add_child(newLine)
	newLine.z_index = 50

func CalculateTravelDistance():
	var distanceToTravel = currentLocation.position.distance_to(selectedNextLocation.position)
	#each 50 units takes 1 minute of travel. --Tweak this unit
	var timeToTravel = int(round(distanceToTravel/50))
	return timeToTravel
	



func InitiateTravel():
	var timeToTravel = CalculateTravelDistance()
	currentlyTravelling = true
	var timer = Timer.new()
	timer.set_wait_time(timeToTravel)
	timer.one_shot = true
	timer.connect("timeout", self, "TravelTimeOver")
	add_child(timer)
	timer.start()

func TravelTimeOver():
	setNewLocation(selectedNextLocation)


func InitalizeNodes():
	#this generates new ones, filling the connections dictionaries
	spawnInArea()

	#this chooses a random location to start in
	startingLocation = chooseRandomLocation()
	#startingLocation.modulate = Color.cornflower

	#setting the current location to the starting location
	currentLocation = startingLocation
	previousLocation = null
	#this activates the nodes that are reachable from the starting location
	activateReachableNodes()

	#this colors the lines from the startinng location
	showTraversibleLines()

	currentLocation.setCurrentLocationDressing()


func ResetNodesUponArrival():
	remove_child(starInstance)
	#this gets rid of the nodes and lines before
	ClearOldNodes()

	#this generates new ones, filling the connections dictionaries
	spawnInArea()

	#this chooses a random location to start in
	startingLocation = chooseRandomLocation()
	#startingLocation.modulate = Color.cornflower

	#setting the current location to the starting location
	currentLocation = startingLocation
	previousLocation = null
	#this activates the nodes that are reachable from the starting location
	activateReachableNodes()

	#this colors the lines from the startinng location
	showTraversibleLines()

	SignalManager.emit_signal("OnArrival", currentLocation)
	printConnections()

func ClearOldNodes():
	#cleaner way to do this where you don't delete
	for child in lineHolder.get_children():
		lineHolder.remove_child(child)
		connectionsMade.clear()
	for child in locationHolder.get_children():
		locationHolder.remove_child(child)
		generatedLocations.clear()
	
func chooseRandomLocation():

	#choose a random index from random location
	var randomIndex = randi()%generatedLocations.keys().size()
	return generatedLocations.keys()[randomIndex]


func DeselectLocation(node):
	selectedNextLocation = null
	print("Deselected " + str(node.label.text))
	print("Selected location is " + str(selectedNextLocation))

func SelectLocation(node):
	#if one of the location nodes is clicked on, selected this as the potential next location
	#selected new node
	selectedNextLocation = node
	print("Selected new location " + str(node.label.text))
#	print(node.backgroundLocation.description)

	pass

func SetSpacetimeJumpInactive():
	spacetimeJumpButton.disabled = true

func SetSpacetimeJumpActive():
	spacetimeJumpButton.disabled = false


var menuJustOpened = false

func _ready():
	
	SignalManager.connect("SelectedLocationNode", self, "SelectLocation")
	SignalManager.connect("DeselectedLocationNode", self, "DeselectLocation")

	#when the ship is currently jumping through warp, don't let player click button, set it inactive
	SignalManager.connect("OnSpacetimeJumpDeparture", self, "SetSpacetimeJumpInactive")

	#when the ship's engines have cooled down, set the button active again
	SignalManager.connect("OnSpacetimeEngineActive", self, "SetSpacetimeJumpActive")

	SignalManager.connect("OnSpacetimeJumpArrival", self, "ResetNodesUponArrival")
	randomize()

	InitalizeNodes()
	#ResetNodesUponArrival()
	# spawnInArea()
	# startingLocation = chooseRandomLocation()
	# #startingLocation.modulate = Color.cornflower
	# currentLocation = startingLocation
	# activateReachableNodes()
	# showTraversibleLines()
	# printConnections()
	# ArrivedAtNewLocation(startingLocation)
	#allSpaces = make_2d_array()


func activateReachableNodes():
	for location in generatedLocations.keys():
		#for all the generated locations
		if location == currentLocation:
			#if the location is the current one, make it unpickable so it's not picked again
			location.setUnpickable()
			continue
		if generatedLocations[currentLocation].has(location):
			#if this is a reachable location from this node, make it selectable
			if location != currentLocation:
				location.setPickable()
		else:
			#else, make it unselectable
			location.setUnpickable()

func showTraversibleLines():

	#this is for connections that can be made from this current node
	for connection in connectionsMade[currentLocation]:
		connection.default_color = Color.green
#	for location in generatedLocations[currentLocation]: 
		#for all the ones this is connected with
	if previousLocation !=null:
		for connection in connectionsMade[previousLocation]:
			connection.default_color = Color.white
		
func setNewLocation(location):

	previousLocation = currentLocation
	currentLocation = location

	#now that it's the new location, remove the selection
	DeselectLocation(location)
	location.removeSelectionDressing()
	#deselectCurretNode()
	showTraversibleLines()
	activateReachableNodes()
	SignalManager.emit_signal("OnArrival", currentLocation)


#  func ArrivedAtNewLocation():
#  	SignalManager.emit_signal("OnArrival")

func _on_SpacetimeJump_pressed():
	print("Jumping through spacetime")
	SignalManager.emit_signal("OnSpacetimeJumpDeparture")
	if starInstance == null:
		starInstance = stars.instance()
	add_child(starInstance)
	#SignalManager.emit_signal("OnSpacetimeJumpArrival")

func _input(event):
	if event.is_action_pressed("ui_interact"):
		InitiateTravel()
		#setNewLocation(selectedNextLocation)

func _on_JumpButton_pressed():
	InitiateTravel()
	#setNewLocation(selectedNextLocation)
	print("Jumped to new location")
	#ArrivedAtNewLocation()

