extends Node2D

var dreamTemplate = preload("res://Character/Dream.tscn")
var dreams = {}
onready var area2d = get_node("Area2D")
onready var colshape2d = area2d.get_node("CollisionShape2D")

func _ready():
	#SignalManager.connect("") -- connect with a certain character being chosen
	$Timer.connect("timeout", self, "spawnDreams")
	#timeDreamSpawn()

func spawnDreams():
	var centerpos = colshape2d.position + area2d.position
	var size = colshape2d.shape.extents*2

	randomize()

	for i in range(3):
		var dream = dreamTemplate.instance()
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

		
		dream.position = spawnPosition #spawnPositio

		add_child(dream)

func timeDreamSpawn():
	$Timer.set_wait_time(1)
	$Timer.start()

