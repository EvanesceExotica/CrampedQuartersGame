extends Node2D

var dreamTemplate = preload("res://Character/Dream.tscn")
var desireHolderTemplate = preload("res://Character/DesireHolder.tscn")
var dreams = {}
onready var area2d = get_node("Area2D")
onready var colshape2d = area2d.get_node("CollisionShape2D")
onready var desireHolderArea = get_node("DesireHolderArea")
onready var desireHolderColShape = desireHolderArea.get_node("DesireHolderCollisionShape")

func _ready():
	#SignalManager.connect("") -- connect with a certain character being chosen
	$Timer.connect("timeout", self, "spawnDreams")
	$DesireTimer.connect("timeout", self, "spawnDesireHolders")
	#TODO:  Put these back in when you can
	#timeDreamSpawn()
	#timeDesireHolderSpawn()

func spawnDreams():
	spawn(area2d, colshape2d, dreamTemplate, 3)
	

func timeDreamSpawn():
	$Timer.set_wait_time(1)
	$Timer.start()

func timeDesireHolderSpawn():
	var desireSpawnTime = rand_range(5, 10)
	$DesireTimer.set_wait_time(desireSpawnTime)
	$DesireTimer.start()

func spawn(area, collisionShape, objectToSpawn, amountAtOnce):
	var centerpos = collisionShape.position + area.position
	var size = collisionShape.shape.extents*2

	randomize()

	for i in range(amountAtOnce):
		var spawnedObject = objectToSpawn.instance()
		#initialize the location
	
		var spawnPosition = Vector2(0, 0)
	#var testX = randi() % int(size.x)

		var lowestPositionX = int(size.x/2) * area.global_scale.x
		var lowestPositionY = int(size.y/2) * area.global_scale.y
		var lowestPosition = Vector2(lowestPositionX, lowestPositionY)
	
		var highestPositionX = int(-size.x/2) * area.global_scale.x
		var highestPositionY = int(-size.y/2) * area.global_scale.y
		var highestPosition = Vector2(highestPositionX, highestPositionY)

		spawnPosition.x = ((randi()% int(size.x) - (size.x/2)) * area.global_scale.x) + centerpos.x

		spawnPosition.y = ((randi()% int(size.y) - (size.y/2)) * area.global_scale.y) + centerpos.y 

		#find random position for location^

		
		spawnedObject.position = spawnPosition 

		add_child(spawnedObject)

func spawnDesireHolders():
	spawn(desireHolderArea, desireHolderColShape, desireHolderTemplate, 1)
	
