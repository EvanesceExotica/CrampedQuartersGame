extends Resource

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
class_name AreaTheme
#These themes are supposed to randomly generate locations for the nodes, mix and matching primary and secondary based on a unified theme

export(int) var chanceOfOccurring

export(Array) var backgroundLocations = []


var backgroundLocationObject
var primaryLocationObject

export(Array) var primaryLocations = []


# func matchBackgroundToPrimary(backgroundLocation):
# 	for item in backgroundLocation.possiblePrimaryLocations 

# Called when the node enters the scene tree for the first time.

func chooseRandomBackgroundLocation():
	#background locations are more open spaces 'in orbit around X, Y'
	var randomBackgroundLocation = backgroundLocationObject.ChooseRandomFromDictionary()
	if randomBackgroundLocation.occuringOnce:
		#if this is a location that should be unique
		backgroundLocationObject.RemoveEntryFromDictionary(randomBackgroundLocation)

func chooseRandomPrimaryLocation():
	#primary locations are specific things like stations and such
	var randomPrimaryLocation = primaryLocationObject.ChooseRandomFromDictionary()
	if randomPrimaryLocation.occuringOnce:
		#if this is a location that should be unique in a system
		primaryLocationObject.RemoveEntryFromDictionary(randomPrimaryLocation)

func initializeAreaTheme():

	#two objects with dictionary and accumulated chance are created
	backgroundLocationObject = WeightedObject.new()
	primaryLocationObject = WeightedObject.new()	

	#you could put the qualifiers here
	#nvm won't be necessary. Just put the ones it would have in there
	for item in backgroundLocations:
		#for all the background locations, add and weight them
		backgroundLocationObject.AddEntryToDictionary(item)


	for item in primaryLocations:
		#for all the primary locations, add and weight them
		primaryLocationObject.AddEntryToDictionary(item)

	if backgroundLocationObject == null:
		print("locationObjectNull")
	else:
		print("Not null")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
