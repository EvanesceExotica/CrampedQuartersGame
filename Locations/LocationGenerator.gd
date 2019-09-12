extends Node

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


export(Array) randomThemeDictionary
export(Array) var themes = []
var accumulatedChance

var themeObject

# func AddEntry(theme):
# 	accumulatedChance+= theme.chanceOfOccuring
# 	randomThemeDictionary[theme] = accumulatedChance
# #maybe have unique locations remove once they've appeared ("Like battlefield probably only needs to show up once")
# func chooseRandomTheme(locations):
# 	var randomGeneratedNumber = randf() * accumulatedChance
# 	for theme in randomThemeDictionary.keys():
# 		#if the randomnumber is less than the event
# 		if(randomGeneratedNumber <= randomThemeDictionary[theme]):
# 			#this initializes the weighted backgrounds V
# 			theme.initializeAreaTheme()
# 			generateLocations(theme, locations)
# 			pass



func generateTheme():
	var randomTheme = themeObject.ChooseRandomFromDictionary()	
	#generates a theme for the system
	#have specific location types that can appear inside this theme
	return randomTheme
	pass

func generateLocations(locations):
	
	#generate a random theme
	var newTheme = generateTheme()	
	for location in locations:
		#assign a generated background to each location
		location.backgroundLocation =  newTheme.chooseRandomBackgroundLocation()
	#for potentialLocation in theme.backgroundLocations:
	#	pass


		

# Called when the node enters the scene tree for the first time.
func _ready():
	SignalManager.connect("LocationNodesGenerated", self, "generateLocations")
	themeObject = WeightedObject.new()
	for item in themes:
		themeObject.AddEntryToDictionary(item)
		#AddEntry(item)
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
