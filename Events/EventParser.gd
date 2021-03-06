extends Node2D


var eventData
var eventArray = []
var eventDictionary = {}

onready var scopeFlag = BitFlag.new(scope, true)
onready var eventTypeFlag = BitFlag.new(eventType, true)

const ON_ARRIVAL = 1
const RANDOM = 2

enum eventType{
	onArrival,
	random,
	distress

}
enum scope{
	ship,
	character,
	station,
	slot
}
const SHIP = 1
const CHARACTER = 2
const STATION = 4
const SLOT = 8

var arrivalEventsWeighted = WeightedObject.new()
var distressEventsWeighted = WeightedObject.new()
var randomEventsWeighted = WeightedObject.new()

var distressSignalEvents = {}
var onArrivalEvents = {}
var randomEvents = {} #the 'travelling, not travelling' can be handled by the events requirements

#put events that have already been triggered here
var alreadyTriggeredEvents = []
func _ready():
	randomize()
	#when the user clicks on a result, calculate that result
	SignalManager.connect("EventChoiceClicked", self, "calculateResultSet")
	generateAllEvents()

func load_json():
	#load the json file and set the sheets as a dictionary
	var file = File.new()
	file.open("res://RelevantJSON/GameEvents.JSON", file.READ)
	var entireFile = parse_json(file.get_as_text())
	eventData = entireFile["sheets"][0]["lines"]

func _load_json():
	var file = File.new()
	#assert file.file_exists( "res://Events/Events.json")
	file.open("res://Events/Events.json", file.READ)
	eventData = parse_json(file.get_as_text())
	#return eventData
   
func generateAllEvents():
	#get the events from the json
	load_json()
	#check what the type of the event is, whether it's an arrival event after you arrive at a location, a random event during the day, or a distress beacon event
	for event in eventData:
		checkEventType(event)

func checkScope(flagValue):
	scopeFlag.set_flags(flagValue)
	if scopeFlag.check(scopeFlag.ship):
		pass
	if scopeFlag.check(scopeFlag.character):
		pass
	if scopeFlag.check(scopeFlag.station):
		pass
	if scopeFlag.check(scopeFlag.slot):
		pass

func checkEventType(event):
	#set the flag to the value of the flag from castleDB
	eventDictionary[event["id"]] = event
	var type = int(event["eventType"])
	eventTypeFlag.set_flags(type)

	if eventTypeFlag.check(eventTypeFlag.onArrival):
		#check if this bit in the flag is true
		onArrivalEvents[event["id"]] = event
		#onArrivalEvents.append(event)
		arrivalEventsWeighted.AddEntry(event["id"], event["weight"])

	if eventTypeFlag.check(eventTypeFlag.random):
		#randomEvents.append(event)
		randomEvents[event["id"]] = event
		randomEventsWeighted.AddEntry(event["id"], event["weight"])

	if eventTypeFlag.check(eventTypeFlag.distress):
		#distressSignalEvents.append(event)
		distressSignalEvents[event["id"]] = event
		distressEventsWeighted.AddEntry(event["id"], event["weight"])

func _chooseRandomEvent():
	var validEvents = []
	for event in randomEvents.keys():
		if event["id"] == "empty":
			continue
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
	elif validEvents.size() == 0:
		print("No valid random events")



func chooseRandomEvent():
	#add some sort of queue so that the events don't override each other
	#change to non-random later
	eventArray = eventData #["events"]
	#createEvent(eventArray[randomNumber])
	var validEvents = []
	for event in eventArray:

		#if all the requirements fit, append this event to an array
		if event["id"] == 0:
			#if this is the first event, the empty one
			continue
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
	#have locationNodes call for the number of a randomEvent, then return it.
	#eventArray = eventData#["events"]
	createEvent(eventDictionary[id])
	# if typeOfEvent == eventType.OnArrival:
	# 	createEvent(onArrivalEvents[id])
	# #	createEvent(onArrivalEvents
	# 	pass
	# elif typeOfEvent == eventType.distress:
	# 	createEvent(distressSignalEvents[id])
	# 	pass
	#might need to change event array to a dictionary if that would make this more efficient (using the key instead of a for loop)
	# for event in eventArray:
	# 	if event["id"] == id:
	# 		createEvent(event)
func returnRandomEventByType(typeOfEvent):
	var randomEventID
	var list
	if typeOfEvent == eventType.onArrival:
		list = arrivalEventsWeighted
	elif typeOfEvent == eventType.distress:
		list = distressEventsWeighted
	elif typeOfEvent == eventType.random:
		list = randomEventsWeighted

	if list.Size() > 0:
		randomEventID = list.ChooseRandomFromDictionary()
#		randomEventID = ChooseRandom.ChooseRandomFromList(list)
	return randomEventID

func _returnRandomEventByType(typeOfEvent):
	var randomEventID
	var list
	if typeOfEvent == eventType.onArrival:
		list = onArrivalEvents.keys()
	elif typeOfEvent == eventType.distress:
		list = distressSignalEvents.keys()
	elif typeOfEvent == eventType.random:
		list = randomEvents.keys()
	if list.size() > 0:
		randomEventID = ChooseRandom.ChooseRandomFromList(list)
	else:
		#throw some sort of exception here
		pass
	return randomEventID


func chooseArrivalEvent(id):
	pass
func _chooseSpecificEvent(id):
	pass

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

				if potentialCharacters.size() == 0:
					#if there are no potential characters to match, then it's obviously false
					allTrue = false

				else:
					#if there are some potential charcters, find a random one
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
			object.removeAttribute(AttributeJSONParser.fetchAndCreateAttribute(trait))
			#object.removeAttributeByName(trait)
		pass

func showResult(chosenResultSet):
	#if this will update to another event, check (if the 'linked event' value is greater than zero, it will)
	#else, just show the results of the current event
	#if chosenResultSet["linkedEvent"] > 0:
	if chosenResultSet["linkedEvent"] != "empty":
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
		if !result.has("scope"):
			#if there is no particular scope
			checkActions(result["actions"])
		else:
			#if there is a scope, like a specific character
			affectObjects(result["scope"], result, affectedObjects)
		# if result["scope"] == "":
		# 	#if there is no particular scope
		# 	checkActions(result["actions"])
		# else:
		# 	affectObjects(result["scope"], result, affectedObjects)
			
		# 	#if there is a scope, like a specific character
		# 	pass

