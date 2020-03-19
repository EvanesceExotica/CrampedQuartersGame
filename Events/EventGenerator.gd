extends Node2D



var distressSignalEvents = []
var onArrivalEvents = []
var randomEvents = [] #the 'travelling, not travelling' can be handled by the events requirements


export(Array) var eventArray = []

onready var eventContainer = get_parent().get_node("CanvasLayer").get_node("EventContainer")

var randomEventDictionary = {}

var accumulatedChance = 0.0

var dayEventDelay = 12 

var dayEvent

var dayEventTriggered = false

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
	
func StartArrivalEvent(locationNode):
	print("We've arrived at a location and are triggering an event")
	TriggerSpecificEvent(locationNode.arrivalEventID)
	#eventContainer.event = locationNode.event
	#eventContainer.initializeEvent()

# func ChooseArrivalEvent(event):
# 	#choose an event from the 'onArrival' event array	
# 	print("Arrival event chosen")

# 	#chooseRandomEvent()
# 	pass
	
func ChooseDayEventDelay():
	#setting this to false to restart day and let a new day event be triggered V
	dayEventTriggered = false
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
	#EventParser.scopeFlag.ship = true
	#EventParser.scopeFlag.character = true
	#EventParser.scopeFlag.station = true
	#EventParser.scopeFlag.slot = true
	EventParser.scopeFlag.set_flags(3)
	print("Ship is " + str(EventParser.scopeFlag.check(EventParser.scopeFlag.ship)))
	print("Character is " + str(EventParser.scopeFlag.check(EventParser.scopeFlag.character)))
	print("Station is " + str(EventParser.scopeFlag.check(EventParser.scopeFlag.station)))
	#print("Station is " + str(EventParser.scopeFlag.station))
	print("Scope flag is " + str(EventParser.scopeFlag.get_flags()))
	print("Constant test " + str(EventParser.SHIP | EventParser.CHARACTER))
	print("Enum test " + str(EventParser.scope.ship | EventParser.scope.character))
	
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
	#TODO #put this back in
	#EventParser.chooseRandomEvent()
	# eventContainer.event = dayEvent
	# eventContainer.initializeEvent
	pass
func TriggerSpecificEvent(id):
	EventParser.chooseSpecificEvent(id)

func _input(event):
	pass
	# if event.is_action_pressed("ui_accept"):
	# 	TriggerEvent(null)


func _process(delta):
	#print(str(System.elapsedSecondsInDay) + "vs" + str(dayEventDelay))
	#if(dayEvent != null):
		#print(str(System.elapsedSecondsInDay))
		if(System.elapsedSecondsInDay >= dayEventDelay && !dayEventTriggered):
			TriggerEvent(dayEvent)
			dayEventTriggered = true
		#if the current hour equals the delayed time for the event to trigger
