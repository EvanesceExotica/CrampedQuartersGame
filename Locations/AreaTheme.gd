extends Resource

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export(int) var chanceOfOccurring

export(Array) var backgroundLocations = []

var backgroundLocationObject
var primaryLocationObject

var randomBackgroundLocations = []

var backgroundLocationChance

export(Array) var primaryLocations = []

var randomPrimaryLocations = []
# Called when the node enters the scene tree for the first time.

func chooseRandomBackgroundLocation():
	var randomBackgroundLocation = backgroundLocationObject.ChooseRandomFromDictionary()

func chooseRandomPrimaryLocation():
	var randomPrimaryLocation = primaryLocationObject.ChooseRandomFromDictionary()

func _ready():

	#two objects with dictionary and accumulated chance are created
	backgroundLocationObject = WeightedObject.new()
	primaryLocationObject = WeightedObject.new()	
	for item in backgroundLocations:
		backgroundLocationObject.AddEntryToDictionary(item)


	for item in primaryLocations:
		primaryLocationObject.AddEntryToDictionary(item)



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
