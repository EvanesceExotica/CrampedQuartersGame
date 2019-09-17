extends Node2D


var eventData

func _ready():
	randomize()
	SignalManager.connect("EventChoiceClicked", self, "calculateResultSet")
	generateAllEvents()

func load_json():
	var file = File.new()
	assert file.file_exists( "res://Events/Events.json")
	file.open("res://Events/Events.json", file.READ)
	eventData = parse_json(file.get_as_text())
	#return eventData
   
func generateAllEvents():
	load_json()

func chooseRandomEvent():
	#change to non-random later
	var eventArray  = []
	eventArray = eventData["events"]
	var randomNumber = randi()%eventArray.size()
	#createEvent(eventArray[randomNumber])
	createEvent(eventArray[1])


# func sendEventSignals():
# 	var eventArray  = []
# 	eventArray = eventData[events]
# 	pass

func checkScope(scope):

	#random station
	#random character
	#character with specific stats
	#station with specific stats
	pass

func checkRequirements():
	pass

func createEvent(event):
	#here we add the event to the object and add the choices along with it, maybe have a countdown?
	SignalManager.emit_signal("NewEventLaunched", event)
	pass

func checkActions(actions):
	#these are events that are fired by the results
	for action in actions.keys():
		#action should be a key value pair, 'actions' should be a dictionary
		SignalManager.emit_signal(action, actions[action])
	pass
func showResult(chosenResultSet):
	SignalManager.emit_signal("UpdateEvent", chosenResultSet)		
	pass

func calculateResultSet(resultSets):
	print("Calculating result!")
	#when an event choice is clicked, roll weighted results to see which one appears
	var chosenResultSet = null
	#var randomNumber = randf()
	var weightedResultObject = WeightedObject.new()
	for item in resultSets:
		weightedResultObject.AddEntry(item, item["weight"])

	chosenResultSet = weightedResultObject.ChooseRandomFromDictionary()
	# for item in resultSets:
	# 	#each of these items is a dictionary
	# 	if item["weight"] >= randomNumber:
	# 		#if the dictionary key named 'weight' is less than or equal to the rolled number
	# 		chosenResultSet = item
	# 		#choose this dictionary

	showResult(chosenResultSet)
	#update the event with this result
	for result in chosenResultSet["results"]:
		checkActions(result["actions"])
