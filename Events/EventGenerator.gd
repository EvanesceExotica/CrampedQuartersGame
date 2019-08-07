extends Node

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var eventContainer = get_node("EventContainer")

export(Array) var eventArray = []

var randomEventDictionary = {}

var accumulatedChance = 0.0

var dayEventDelay 

var dayEvent

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


func ChooseArrivalEvent():
	#choose an event from the 'onArrival' event array	
	print("Arrival event chosen")
	pass
		
func ChooseDayEvent():
	#choose a delay period when this event will happen
	var dayEvent = null
	dayEventDelay = rand_range(0, System.fullDayDuration)

func _ready():
	SignalManager.connect("OnArrival", self, "ChooseArrivalEvent")
	SignalManager.connect("NewDayStarted", self, "ChooseDayEvent")
	randomize()

	#add and accumulate all the chances
	for item in eventArray:
		AddEntry(item)

func TriggerEvent():
	print("Event Triggered")
	pass

func _process(delta):
	if(dayEvent != null):
		if(System.currentHour == (int)dayEventDelay):
			TriggerEvent(dayEvent)
		#if the current hour equals the delayed time for the event to trigger
