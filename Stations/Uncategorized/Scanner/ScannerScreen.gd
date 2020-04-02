extends "res://Stations/StationScreen.gd"

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var field = get_node("Field")
onready var scannerArea = get_node("ScannerArea")

var currentChosenSlice
var currentSliceSprite

var sliceArray = [] 
var inactiveSliceArray = []
# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	sliceArray = field.get_children()

	#when the scannerArea has the interact button pressed, note it here
	get_node("Meter").connect("barMaxedOut", self, "gameOver")
	scannerArea.connect("interactPressed", self, "clickedOnOverlap")
	activateRandomSlice()

func initializeGame():
	randomize()
	.initializeGame()
	activateRandomSlice()

func activateRandomSlice(): 
	
	if(currentChosenSlice != null):
		#here we're deleting the current node from the hex array so it's not called upon anew
		inactiveSliceArray.append(currentChosenSlice)
		sliceArray.erase(currentChosenSlice)
		currentSliceSprite = null

	if(sliceArray.size() > 0):

		var size = sliceArray.size()
		var randomIndex = randi()%size
		var randomSlice = sliceArray[randomIndex]
		#pick random slice from array of slices
		for child in randomSlice.get_children():
			if child is Sprite:
				currentSliceSprite = child
				child.get_material().set_shader_param("width", 6.4)
				child.get_material().set_shader_param("outline_color", Color.green)
		currentChosenSlice = randomSlice
	else:
		gameSuccess()


	pass

func clickedOnOverlap(array):
	#if array.has(currentChosenSlice):
		#if one of the overlapped clicked on was the chosen sprite, activate a new one
	emit_signal("meterEffected", -20)
	currentSliceSprite.get_material().set_shader_param("outline_color", Color.red)
	activateRandomSlice()


func gameSuccess():
	resetEverySlice()
	.gameSuccess()

func gameOver():
	resetEverySlice()
	.gameOver()

func resetEverySlice():
	pass
	# currentNode = null
	# #reset the current node to nothing so that it's not being erased at the activation method
	# hexArray = hexArray + inactiveHexArray
	# #set the hex array to equal all of the inactive hex nodes
	# inactiveHexArray.clear()
	# #clear out the inactive hex array for next time
	# for item in hexArray:
	# 	#change the colors back to white
	# 	item.changeHexColor(Color.white)