extends Node2D



export(Array) var eventArray = []

onready var eventContainer = get_node("EventContainer")

var randomEventDictionary = {}

var accumulatedChance = 0.0

var dayEventDelay = 12 

var dayEvent

var randomDayEventObject

func chooseRandomEvent():
	var randomGeneratedNumber = randf() * accumulatedChance
	for event in randomEventDictionary.keys():
		#if the randomnumber is less than the event
		if(randomGeneratedNumber <= randomEventDictionary[event]):
			eventContainer.event = event
			eventContainer.initializeEvent()
			pass

func AddEntry(event):
	accumulatedChance+= event.chanceOfOccuring
	randomEventDictionary[event] = accumulatedChance


#func populateSpecificEventArray(array):
	
func StartArrivalEvent(event):
	eventContainer.event = event
	eventContainer.initializeEvent()

# func ChooseArrivalEvent(event):
# 	#choose an event from the 'onArrival' event array	
# 	print("Arrival event chosen")

# 	#chooseRandomEvent()
# 	pass
	
func ChooseDayEventDelay():
	var secondsInDay = System.totalSecondsInHour * System.fullDayDuration
	dayEventDelay = rand_range(0, secondsInDay)
	print("Event delay chosen " + str(dayEventDelay))

func ChooseDayEvent():
	#choose a delay period when this event will happen
	#dayEvent = randomDayEventObject.ChooseRandomFromDictionary()
	dayEvent = "FIRE OH NO"
	#dayEvent = EventParser.

	#this multiplication will give the number of hours in the day "Full Day Duration" times seconds in the hour to get the  number of seconds in day
	var secondsInDay = System.totalSecondsInHour * System.fullDayDuration
	dayEventDelay = rand_range(0, secondsInDay)
	#print("Choosing day event which will happen at " + str(dayEventDelay))

func _ready():
	SignalManager.connect("OnArrival", self, "StartArrivalEvent")
	#TODO: #Put this back in
	SignalManager.connect("DayPassed", self, "ChooseDayEventDelay")
	#Should be 'new day started' for some delay
	randomize()
	# randomDayEventObject = WeightedObject.new()
	# #add and accumulate all the chances
	# for item in eventArray:
	# 	randomDayEventObject.AddEntryToDictionary(item)
	# 	#AddEntry(item)

func TriggerEvent(dayEvent):
#	print("Event Triggered " + dayEvent)
	EventParser.chooseRandomEvent()
	# eventContainer.event = dayEvent
	# eventContainer.initializeEvent
	pass

func _input(event):
	if event.is_action_pressed("ui_accept"):
		TriggerEvent(null)


func _process(delta):
	#print(str(System.elapsedSecondsInDay) + "vs" + str(dayEventDelay))
	#if(dayEvent != null):
		#print(str(System.elapsedSecondsInDay))
		if(int(System.elapsedSecondsInDay) == int(dayEventDelay)):
			print("Event triggered")
			TriggerEvent(dayEvent)
		#if the current hour equals the delayed time for the event to trigger
