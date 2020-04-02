extends Node

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
func CreateWeightedDictionary(entry, accumulatedChance, dictionary):
	var accumChance = accumulatedChance
	var dict = dictionary

	#each entry will add up the chance of occuring
	accumChance += entry.chanceOfOccuring
	dict[theme] = accumChance

	return [accumChance, dict]

func ChooseRandomFromWeightedDictionary(accumulatedChance, dictionary):
	randomize()
	var accumChance = accumulatedChance
	var dict = dictionary
	var randomGeneratedNumber = randf() * accumChance
	for entry in dict.keys():
		#if the randomnumber is less than the event
		if(randomGeneratedNumber <= dict[entry]):
			return entry
			#generateLocations(theme, locations)
			pass

	pass
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
