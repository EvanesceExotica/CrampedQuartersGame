extends "res://Stations/StationScreen.gd"

var hexArray = [] 
var inactiveHexArray = []
var currentNode
# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	populateHexArray()
	activateRandomNode()
	for item in hexArray:
		item.connect("minigameNodeClicked", self, "activateRandomNode")
		item.connect("nodeTimedOut", self, "gameOver")
	pass # Replace with function body.



func populateHexArray():
	var testArray = get_children()
	#hexArray = testArray
	for child in testArray:
		if child is MinigameNode:
			hexArray.append(child)

func activateRandomNode():
	hexArray.erase(currentNode)
	if(hexArray.size() > 0):
		print("Clicked me!")
		var size = hexArray.size()
		print(str(size))
		var randomIndex = randi()%size
		var randomNode = hexArray[randomIndex]
		print(str(randomNode.name))
		randomNode.tweenTimerToZero()
		inactiveHexArray.append(randomNode)
		currentNode = randomNode
		#hexArray.erase(randomNode)
		print(str(hexArray.size()))


func resetEveryNode():
	for item in hexArray:
		item.changeHexColor(Color.white)
	populateHexArray()
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
