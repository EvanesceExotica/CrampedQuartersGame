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

export(int) var locationsMin = 3
export(int) var locationsMax = 7

var generatedLocations = {}
onready var area2d = get_node("Area2D")
onready var colshape2d = area2d.get_node("CollisionShape2D")


var startingLocation

var beaconLocation

# Called when the node enters the scene tree for the first time.
var locationNode = preload("res://LocationNode.tscn")

onready var lineHolder = get_node("LineHolder")

export(int) var lineWidth = 5
export(Color) var lineColor = Color("#a2b2ff")
onready var locationHolder = get_node("LocationHolder")

var connectionsMade = {}

func spawnInArea():
	var centerpos = colshape2d.position + area2d.position
	var size = colshape2d.shape.extents*2

	randomize()


	var numberOfLocations = floor(rand_range(locationsMin, locationsMax+1))
	print("We have this many locations" + str(numberOfLocations))
	for i in range(numberOfLocations):
		var star = locationNode.instance()
	
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

	
		star.position = to_local(spawnPosition) #spawnPositio

		locationHolder.add_child(star)
		generatedLocations[star] = []
	for location in generatedLocations.keys():
		findClosestNode(location)
	
func findClosestNode(node):

	var nearestLocation = generatedLocations.keys()[0]
	for location in generatedLocations.keys():
		if location == node:
			#make sure the same node as is 'node' isn't being chosen
			continue
		if generatedLocations[location].size() > 0 :
			#make sure the location doesn't already have a connection to it
			continue
		if location.global_position.distance_to(node.global_position) < nearestLocation.global_position.distance_to(node.global_position):
			#find the closest location that isn't already connected and isn't the same node
			nearestLocation = location
	
	#set these to demonstrate these two nodes already have a connection
	generatedLocations[node].append(nearestLocation)
	generatedLocations[nearestLocation].append(node)
			#TODO: ADD THESE LINES TO DETERMINE HOW LONG IT TAKES TO TRAVEL, WHICH DIRECTION TO GO WHICH YOU CAN JUMP TO AND SUCH
	#draw a new line, make it between the points, add it to the scene
	var newLine = Line2D.new()
	var point1 = node.global_position
	var point2 = nearestLocation.global_position
	#var point1 = to_local(node.position)
	#var point2 = to_local(nearestLocation.position)
	newLine.add_point(point1)
	newLine.add_point(point2)
	newLine.default_color = lineColor
	newLine.width = lineWidth

	#newLine.points = [Vector2(node.position.x, node.position.y), Vector2(nearestLocation.position.x, nearestLocation.position.y)]
	lineHolder.add_child(newLine)


func chooseRandomLocation():

	#choose a random index from random location
	var randomIndex = randi()%generatedLocations.keys().size()
	return generatedLocations.keys()[randomIndex]


# func make_2d_array():
# 	var array = []
# 	for i in width:
# 		array.append([]);
# 		for j in height:
# 			array[i].append(null)
# 	return array;

func _ready():
	

	randomize()
	spawnInArea()
	startingLocation = chooseRandomLocation()
	#allSpaces = make_2d_array()

func chooseRandomLocations():
	pass
	# var numberOfLocations = floor(rand_range(locationsMin, locationsMax+1))
	# #var row = floor(rand_range(x_start) + effect)
	# randi()%height+1
	# var column = randi()%width+1
	# for i in range(numberOfLocations):
	# 	row = randi()%width+1
	# 	column = randi()%height+1 
	# 	print(str(column) + " , " + str(row))
	# 	var newLocation = locationNode.instance()
	# 	newLocation.position = grid_to_pixel(column, row)
	# 	add_child(newLocation)



# func spawn_pieces():
# 	for i in width:
# 		for j in height:
# 			#choose a random number and store it
# 			var rand = floor((rand_range(0,)))
# Called every frame. 'delta' is the elapsed time since the previous frame.
func grid_to_pixel(column, row):
	pass#

func ArrivedAtNewLocation():
	SignalManager.emit_signal("OnArrival")

#func _process(delta):
#	pass
func _on_JumpButton_pressed():
	print("Jumped to new location")
	ArrivedAtNewLocation()

