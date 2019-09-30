extends Node2D


var eventData
var eventArray = []
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
	eventArray = eventData["events"]
	var randomNumber = randi()%eventArray.size()
	#createEvent(eventArray[randomNumber])
	createEvent(eventArray[1])

func chooseSpecificEvent(id):
	#might need to change event array to a dictionary if that would make this more efficient (using the key instead of a for loop)
	for event in eventArray:
		if event["id"] == id:
			createEvent(event)
			
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

func validateRequirements(requirements):
	var allTrue = true
	for requirement in requirements:
		var scope = requirement["scope"]
		if scope == "ship":
			#WholeShip.checkAllTags(requirement)
			pass

		elif scope == "character":
			for item in get_tree().get_nodes_in_group("Characters"):
				item.get_child("TraitChecker").FindFittingCharacter(requirement)
			#CharacterTracker.FindFittingCharacter(requirement)

		elif scope == "station":
			pass

		elif scope == "slot":
			pass

func checkRequirements(requirements):
	#for a character
	return CharacterTracker.FindFittingCharacter(requirements)
	
	pass

func createEvent(event):
	#here we add the event to the object and add the choices along with it, maybe have a countdown?
	var character = checkRequirements(event["requirements"])
	if character == null:
		print("Couldn't find character")
	else:
		print(character.characterName)
	SignalManager.emit_signal("NewEventLaunched", event)
	pass

func checkActions(actions):
	#these are events that are fired by the results
	for action in actions.keys():
		#action should be a key value pair, 'actions' should be a dictionary
		SignalManager.emit_signal(action, actions[action])

func showResult(chosenResultSet):
	if chosenResultSet["linkedEvent"] > 0:
		#if the ID for this is greater than zero, which is the 'blank' event
		chooseSpecificEvent(chosenResultSet["linkedEvent"])
	else:
		SignalManager.emit_signal("UpdateEvent", chosenResultSet)		

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
