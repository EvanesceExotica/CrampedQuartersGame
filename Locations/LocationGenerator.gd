extends Node

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export(Array) randomThemeDictionary
export(Array) var themes = []
var accumulatedChance

func AddEntry(theme):
	accumulatedChance+= theme.chanceOfOccuring
	randomThemeDictionary[theme] = accumulatedChance
#maybe have unique locations remove once they've appeared ("Like battlefield probably only needs to show up once")
func chooseRandomTheme(locations):
	var randomGeneratedNumber = randf() * accumulatedChance
	for theme in randomThemeDictionary.keys():
		#if the randomnumber is less than the event
		if(randomGeneratedNumber <= randomThemeDictionary[theme]):
			generateLocations(theme, locations)
			pass



func generateTheme(locations):
	
	#generates a theme for the system
	#have specific location types that can appear inside this theme
	pass

func generateLocations(theme, locations):
	
	
	for location in locations:
		location.backgroundLocation =  theme.chooseRandomBackgroundLocation()
	#for potentialLocation in theme.backgroundLocations:
	#	pass


		

# Called when the node enters the scene tree for the first time.
func _ready():
	SignalManager.connect("LocationNodesGenerated", self, "generateTheme")
	for item in themes:
		AddEntry(item)
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
