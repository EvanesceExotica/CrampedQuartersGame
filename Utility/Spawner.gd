extends Node

func spawn(area, collisionShape, objectToSpawn, amountAtOnce, parent):
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

		parent.add_child(spawnedObject)