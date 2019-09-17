extends Node2D


var eventData

func _ready():
	randomize()
	SignalManager.connect("EventChoiceClicked", calculateResultSet)

func load_json():
	var file = File.new()
	assert file.file_exists( "res://Events/Events.json")
	file.open("res://Events/Events.json", file.READ)
	eventData = parse_json(file.get_as_text())
    return eventData
    
func sendEventSignals():
	var eventArray  = []
	eventArray = eventData[events]
    pass

func checkScope(scope):

	#random station
	#random character
	#character with specific stats
	#station with specific stats
	pass

func checkRequirements():
	pass

func createEvent():
	#here we add the event to the object and add the choices along with it, maybe have a countdown?
	pass

func checkActions(actions):
	#these are events that are fired by the results
	for action in actions:
		#action should be a dictionary, 'actions' should be a list of dictionaries
		SignalManager.emit_signal(action[name], action[parameters])
	pass
func showResult(chosenResultSet):
	SignalManager.emit_signal("UpdateEvent", chosenResultSet)		
	pass

func calculateResultSet(resultSets):
	#when an event choice is clicked, roll weighted results to see which one appears
	var chosenResultSet = null
	var randomNumber = randf()
	for item in resultSets:
		if item[weight] >= randomNumber:
			item = chosenResultSet
	showResult(chosenResultSet)
	for item in chosenResultSet[result]:
		checkActions()
