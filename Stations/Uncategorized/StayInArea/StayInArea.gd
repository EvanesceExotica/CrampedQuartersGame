extends Node2D

var area2d #= get_child(3)
var colshape2d #= area2d.get_child(0)
onready var boundsArea = get_node("BoundsArea")
onready var meter = get_node("Meter")



signal meterEffected(amount)

func _ready():
	boundsArea.connect("leftBounds", self, "buildUpMeter")
	boundsArea.connect("backInBounds", self, "cancelMeterBuildup")

func buildUpMeter():
	meter.tweenBarUp(meter._calculateRemainingTimePercentage(2))

func cancelMeterBuildup():
	meter.cancelBarTween()


func getRandomPosition():
	area2d = get_node("MovementArea")
	colshape2d = area2d.get_child(0)
	var centerpos = colshape2d.position + area2d.position
	var size = colshape2d.shape.extents*2

	randomize()


	
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
	
	return spawnPosition

		#find random position for location^

		
