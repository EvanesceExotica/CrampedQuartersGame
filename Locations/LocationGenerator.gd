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

 	var randomPrimaryLocations = []
	# var randomBackgroundLocations = []
	 for i in range(locations.size()):
		 randomPrimaryLocations.append(newTheme.chooseRandomPrimaryLocation())


	for location in locations:
		#assign a generated background to each location
		randomBackgroundLocations.append(newTheme.chooseRandomBackgroundLocation())

		location.backgroundLocation =  newTheme.chooseRandomBackgroundLocation()
		for possiblePrimaryLocation in location.backgroundLocation.possiblePrimaryLocations:
			#for the locations that can appear above this background location
			if randomPrimaryLocations.has(possiblePrimaryLocation):
				#if the generated primary locations fit with this background
				location.primaryLocation = possiblePrimaryLocation
				randomPrimaryLocations.erase(possiblePrimaryLocation)
	#for potentialLocation in theme.backgroundLocation
	#	pass

func generateLocationPairs(location):
	location.backgroundLocation =  newTheme.chooseRandomBackgroundLocation()
		

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
