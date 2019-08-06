extends Node

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export(Array) var eventArray = []

var randomEventDictionary = {}

var accumulatedChance = 0.0

func chooseRandomEvent():
	var randomGeneratedNumber = randf() * accumulatedChance
	for event in randomEventDictionary.keys():
		#if the randomnumber is less than the event
		if(randomGeneratedNumber <= randomEventDictionary[event]):
			pass

func AddEntry(event):
	accumulatedChance+= event.chanceOfOccuring
	randomEventDictionary[event] = accumulatedChance



		

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()

	#add and accumulate all the chances
	for item in eventArray:
		AddEntry(item)

