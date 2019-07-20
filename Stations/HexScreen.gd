extends "res://Stations/StationScreen.gd"

var hexArray = [] 
var inactiveHexArray = []
var currentNode
# Called when the node enters the scene tree for the first time.
func _ready():
	#This is only called once -- can reset to initialize every other time
	randomize()
	populateHexArray()

	for item in hexArray:
		#this only needs to be done once, so is done in 'ready'
		item.connect("minigameNodeClicked", self, "activateRandomNode")
		item.connect("nodeTimedOut", self, "gameOver")
	pass # Replace with function body.

func initializeGame():
	randomize()
	.initializeGame()
	activateRandomNode()

func populateHexArray():
	#this should only need to be called once in the 'ready' function
	var testArray = get_children()
	#hexArray = testArray
	for child in testArray:
		if child is MinigameNode:
			hexArray.append(child)
	print("Hex array size " + str(hexArray.size()))

func activateRandomNode():

	if(currentNode != null):
		#here we're deleting the current node from the hex array so it's not called upon anew
		inactiveHexArray.append(currentNode)
		hexArray.erase(currentNode)

	if(hexArray.size() > 0):

		var size = hexArray.size()
		var randomIndex = randi()%size
		var randomNode = hexArray[randomIndex]
		randomNode.tweenTimerToZero()
		currentNode = randomNode
	else:
		gameSuccess()

func gameSuccess():
	resetEveryNode()
	.gameSuccess()

func gameOver():
	resetEveryNode()
	.gameOver()

func resetEveryNode():
	currentNode = null
	#reset the current node to nothing so that it's not being erased at the activation method
	print("Resetting " + str(hexArray.size()) + "= Hex Size" + str(inactiveHexArray.size()) + "= Inactive Size")
	hexArray = hexArray + inactiveHexArray
	#set the hex array to equal all of the inactive hex nodes
	inactiveHexArray.clear()
	#clear out the inactive hex array for next time
	for item in hexArray:
		#change the colors back to white
		item.changeHexColor(Color.white)
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
