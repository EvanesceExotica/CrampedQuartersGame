extends Control

export var event : Resource
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var eventText = get_node("Panel/MarginContainer/VBoxContainer2/RichTextLabel")
var eventChoice = preload("res://Events/EventChoice.tscn")
onready var choiceContainer = get_node("Panel/MarginContainer/VBoxContainer2/ChoiceContainer")

onready var timer = get_node("Timer")
onready var tween = get_node("Tween")

onready var countdownCircle = get_node("CountdownCircle")
var waitingForChoice 

var availableChoices = []
func _ready():
	SignalManager.connect("UpdateEvent", self, "updateEvent")
	SignalManager.connect("EndEvent", self, "hideEventContainer")
	SignalManager.connect("NewEventLaunched", self, "showEvent")
	SignalManager.connect("EventProgressed", self, "resetTimerAndTween")
	#initializeEvent()
	pass # Replace with function body.


func resetTimerAndTween():
	timer.stop()
	tween.stop_all()

func pauseTime():
	get_tree().paused = true
	waitingForChoice = true
	timer.wait_time = 5
	timer.start()
	tween.interpolate_property(countdownCircle, "value", 100, 0, 5.0, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()
	#yield(timer, "timeout")
	#do this to have the game paused behind the event
	pass

func _on_Timer_timeout():
	waitingForChoice = false
	print("CHOICE TIME IS OVER")
	get_tree().paused = false

	#maybe make a separate "Eve"
	EventDefaulted()

func EventDefaulted():
	SignalManager.emit_signal("EventChoiceClicked", availableChoices[0].resultSets, availableChoices[0].affectedObjectDictionary)

func updateEvent(updateParameters):
	#this will be a result set
	eventText.text = updateParameters["description"]
	#CHECK IF THERE'S A LINKED EVENT
	resetOptions()
	setContinueOption()

func chooseRandomDescription(descriptionParameters):
	#for variety in event description, have multiple descriptions of same event
	var description = descriptionParameters[0]
	var randomNumber = randi()%descriptionParameters.size()
	description = descriptionParameters[randomNumber]
	return description


func resetOptions():
	
	for child in choiceContainer.get_children():
		child.queue_free()

func setContinueOption():
	#this will reset to default, meaning nothing will happen but the event ending
	var newChoice = eventChoice.instance()
	choiceContainer.add_child(newChoice)


func checkOptionRequirements(option):
	var objectHolderDictionary = []
	if option["applyResultsToObject"] == true:
		#if the results are going to be applied to an object
		var validatedRequirements = EventParser.validateRequirements(option["requirements"], true)   
		if validatedRequirements[0] == true:
			#if all of the requirements were true, collect the objects that are to be affeccted in a dictionary
			var newChoice = eventChoice.instance()
			newChoice.text = option["text"]
			newChoice.resultSets = option["resultSets"]
			newChoice.affectedObjectDictionary = validatedRequirements[1]
			choiceContainer.add_child(newChoice)
			availableChoices.append(newChoice)
			#if all of the requirements were true
	else:
		var validatedRequirements = EventParser.validateRequirements(option["requirements"], false)   
		if validatedRequirements[0] == true:
			var newChoice = eventChoice.instance()
			newChoice.text = option["text"]
			newChoice.resultSets = option["resultSets"]
			newChoice.affectedObjectDictionary = validatedRequirements[1]
			choiceContainer.add_child(newChoice)
			availableChoices.append(newChoice)


func showEvent(eventParameters):
	pauseTime()
	self.show()
	resetOptions()
	eventText.text = chooseRandomDescription(eventParameters["description"])
	for option in eventParameters["options"]:
		#array of options
		checkOptionRequirements(option)
		# var newChoice = eventChoice.instance()
		# newChoice.text = option["text"]
		# newChoice.resultSets = option["resultSets"]
		# choiceContainer.add_child(newChoice)

func initializeEvent():
	#change this so that each event has multiple branches of text?
	eventText.text = event.eventDescriptionText
	for item in event.eventChoices.keys():
		var newChoice = eventChoice.instance() 
		newChoice.text = item
		newChoice.calledSignal = event.eventChoices[item]
		choiceContainer.add_child(newChoice)

func hideEventContainer(param):
	self.hide()
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
