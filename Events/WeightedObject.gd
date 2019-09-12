extends Object

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
class_name WeightedObject

var accumulatedChance = 0

var randomChanceDictionary = {}

func AddEntryToDictionary(entry):
	#each entry will add up the chance of occuring
	accumulatedChance += entry.chanceOfOccuring
	randomChanceDictionary[entry] = accumulatedChance

	#return [accumChance, dict]
func RemoveEntryFromDictionary(entry):
	accumulatedChance -= entry.chanceOfOccurring
	randomChanceDictionary.erase(entry)

func ChooseRandomFromDictionary():
	var randomGeneratedNumber = randf() * accumulatedChance
	for entry in randomChanceDictionary.keys():
		#if the randomnumber is less than the event
		if(randomGeneratedNumber <= randomChanceDictionary[entry]):
			return entry

func _init():
	pass
