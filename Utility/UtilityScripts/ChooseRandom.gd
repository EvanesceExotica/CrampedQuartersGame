extends Node

func ChooseRandomFromList(list):
	#will choose a random value from a list, no matter if it only has two values
	return list[randi()%list.size()]

func DetermineIfEventHappens(chanceValue):
	var random = randf()
	if random <= chanceValue:
		return true
	else:
		return false
