extends Resource

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
#var export(backgroundLocation)
class_name Location
# Called when the node enters the scene tree for the first time.
# Called every frame. 'delta' is the elapsed time since the previous frame.
export(Texture) var locationImage
export(String) var description #maybe make this a string of random descriptions?
export(int) var chanceOfOccurring
export(bool) var occuringOnce #this is for locations that should only occur once in an area
export(Array) var possiblePrimaryLocations #locations that this object can appear above
#func _process(delta):
#	pass
