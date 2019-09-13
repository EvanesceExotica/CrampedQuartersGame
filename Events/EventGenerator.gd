extends Node2D



export(Array) var eventArray = []

onready var eventContainer = get_node("EventContainer")

var randomEventDictionary = {}

var accumulatedChance = 0.0

var dayEventDelay 

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
		
func ChooseDayEvent():
	#choose a delay period when this event will happen
	dayEvent = randomDayEventObject.ChooseRandomFromDictionary()
	#dayEvent = "FIRE OH NO"

	#this multiplication will give the number of hours in the day "Full Day Duration" times seconds in the hour to get the  number of seconds in day
	var secondsInDay = System.totalSecondsInHour * System.fullDayDuration
	dayEventDelay = rand_range(0, secondsInDay)
	print("Choosing day event which will happen at " + str(dayEventDelay))

func _ready():
	SignalManager.connect("OnArrival", self, "StartArrivalEvent")
	SignalManager.connect("DayPassed", self, "ChooseDayEvent")
	#Should be 'new day started' for some delay
	randomize()
	randomDayEventObject = WeightedObject.new()
	#add and accumulate all the chances
	for item in eventArray:
		randomDayEventObject.AddEntryToDictionary(item)
		#AddEntry(item)

func TriggerEvent(dayEvent):
#	print("Event Triggered " + dayEvent)
	eventContainer.event = dayEvent
	eventContainer.initializeEvent
	pass

func _process(delta):
	#print(str(System.elapsedSecondsInDay) + "vs" + str(dayEventDelay))
	if(dayEvent != null):
		if(System.elapsedSecondsInDay == dayEventDelay):
			TriggerEvent(dayEvent)
		#if the current hour equals the delayed time for the event to trigger
