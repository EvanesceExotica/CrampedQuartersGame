extends Node2D


var eventData
var eventArray = []


#put events that have already been triggered here
var alreadyTriggeredEvents = []
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
	#add some sort of queue so that the events don't override each other
	#change to non-random later
	eventArray = eventData["events"]
	#createEvent(eventArray[randomNumber])
	var validEvents = []
	for event in eventArray:

		#if all the requirements fit, append this event to an array
		if validateRequirements(event["requirements"], false):
			validEvents.append(event)

	#choose a random number that fits within the size of the valid events array
	var randomNumber = randi()%validEvents.size()

	if validEvents.size() > 1:
		#if the array has more than one event in it, choose a random one
		createEvent(validEvents[randomNumber])
	elif validEvents.size() == 1:
		#if there's only one event that fits
		createEvent(validEvents[0])


func chooseSpecificEvent(id):
	eventArray = eventData["events"]
	createEvent(eventArray[id])
	#might need to change event array to a dictionary if that would make this more efficient (using the key instead of a for loop)
	# for event in eventArray:
	# 	if event["id"] == id:
	# 		createEvent(event)
			



func validateRequirements(requirements, returnObject):

	#this validateRequirements is to check if something exists and return true, not to return that object itself, though maybe it could do both
	var allTrue = true
	var affectedObjectDictionary = {}
	for requirement in requirements:
		#check all the requirements for this event, regardless of if they're from a character, station, etc. Make sure they're all true
		var scope = requirement["scope"]
		if scope == "ship":
			#WholeShip.checkAllTags(requirement)
			pass

		elif scope == "character":
			#TODO FIDDLE WITH THIS
			var potentialCharacters = []
			var meetsRequirements
			for character in get_tree().get_nodes_in_group("Characters"):
				#find all of he characters in the game, and check their tags
				meetsRequirements = character.get_node("TraitChecker").checkAllTags(requirement)
				#if this particular character meets all the requirements, add them to a list
				if meetsRequirements:
					potentialCharacters.append(character)

			if !returnObject:
				#if we're not looking for a specific object, but instead seeing if all of these are true
				if potentialCharacters.size() == 0:
					#if there's nothing in this array, all the requirements aren't true
					allTrue = false 
					print("No character matches these requirements")
				else:
					print("Found character that matches requirements")

			if returnObject:
				#if we're returning the object here to apply effects to, and not just seeing if this exists for the event to trigger in the first place
				 var randomNumber = randi()%potentialCharacters.size()

				 #this should put the affected object under the stored name in a dictionary, and the scope of the result will grab it
				 affectedObjectDictionary[requirement["storedName"]] = potentialCharacters[randomNumber]
			 	#return potentialCharacters[randomNumber]

		elif scope == "station":
			pass

		elif scope == "slot":
			pass

	return [allTrue, affectedObjectDictionary]
	# if !returnObject:
	# 	#if we're not looking for a specific object, but instead seeing if all of these are true
	# 	return allTrue
	# else:
	# 	#if we're returning the object here to apply effects to, and not just seeing if this exists for the event to trigger in the first place
	# 	return affectedObjectDictionary

func checkRequirements(requirements):
	#for a character
	return CharacterTracker.FindFittingCharacter(requirements)
	
	pass

func createEvent(event):
	#here we add the event to the object and add the choices along with it, maybe have a countdown?
	# var character = checkRequirements(event["requirements"])
	# if character == null:
	# 	print("Couldn't find character")
	# else:
	# 	print(character.characterName)
	SignalManager.emit_signal("NewEventLaunched", event)

func checkActions(actions):
	#these are events that are fired by the results
	for action in actions.keys():
		#action should be a key value pair, 'actions' should be a dictionary, actions[action] is choosing the parameter set value for the particular action which is a string to call a event
		SignalManager.emit_signal(action, actions[action])

func affectObjects(scope, result, affectedObjects):

	#the scope should equal the key to the dictionary that was the 'stored name' of the found object
	var object = affectedObjects[scope]
	print(object.name)
	
	if(result["actions"]).size() > 0:
		checkActions(result["actions"])
		pass
	if(result["addedTraits"]).size() > 0: 
		for trait in result["addedTraits"]:
			#trait = attributeName
			object.applyNewAttribute(AttributeJSONParser.fetchAndCreateAttribute(trait))
		pass
	if(result["removedTraits"]).size() > 0:
		for trait in result["removedTraits"]:
			print("Removing this trait " + trait)
			object.removeAttributeByName(trait)
		pass

func showResult(chosenResultSet):
	#if this will update to another event, check (if the 'linked event' value is greater than zero, it will)
	#else, just show the results of the current event
	if chosenResultSet["linkedEvent"] > 0:
		#if the ID for this is greater than zero, which is the 'blank' event
		chooseSpecificEvent(chosenResultSet["linkedEvent"])
	else:
		SignalManager.emit_signal("UpdateEvent", chosenResultSet)		



func calculateResultSet(resultSets, affectedObjects):
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
#clearing the dictionary on the object isn't necessary since it's a new object each time you calculate the result

	#update the event with this result
	for result in chosenResultSet["results"]:
		if result["scope"] == "":
			#if there is no particular scope
			checkActions(result["actions"])
		else:
			affectObjects(result["scope"], result, affectedObjects)
			
			#if there is a scope, like a specific character
			pass

