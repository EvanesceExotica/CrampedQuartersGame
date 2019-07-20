extends "res://Stations/StationScreen.gd"

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var field = get_node("Field")
onready var scannerArea = get_node("ScannerArea")

var currentChosenSlice

var sliceArray = [] 
var inactiveSliceArray = []
# Called when the node enters the scene tree for the first time.
func _ready():
	sliceArray = field.get_children()
	scannerArea.connect("interactPressed", self, "markSuccess")
	pass # Replace with function body.


func activateRandomSlice(): 
	
	if(currentChosenSlice != null):
		#here we're deleting the current node from the hex array so it's not called upon anew
		inactiveSliceArray.append(currentChosenSlice)
		sliceArray.erase(currentChosenSlice)

	if(sliceArray.size() > 0):

		var size = sliceArray.size()
		var randomIndex = randi()%size
		var randomSlice = sliceArray[randomIndex]
		randomSlice.get_child()
		currentChosenSlice = randomSlice
	else:
		gameSuccess()


	pass

func markSuccess(array):
	print("Clicked on overlap")
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
