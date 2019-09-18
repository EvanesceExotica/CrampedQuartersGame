extends Control

export var event : Resource
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var eventText = get_node("Panel/MarginContainer/VBoxContainer2/RichTextLabel")
var eventChoice = preload("res://Events/EventChoice.tscn")
onready var choiceContainer = get_node("Panel/MarginContainer/VBoxContainer2/ChoiceContainer")
# Called when the node enters the scene tree for the first time.
func _ready():
	SignalManager.connect("UpdateEvent", self, "updateEvent")
	SignalManager.connect("EndEvent", self, "hideEventContainer")
	SignalManager.connect("NewEventLaunched", self, "showEvent")
	#initializeEvent()
	pass # Replace with function body.
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

func showEvent(eventParameters):
	self.show()
	resetOptions()
	eventText.text = chooseRandomDescription(eventParameters["description"])
	for option in eventParameters["options"]:
		#array of options
		var newChoice = eventChoice.instance()
		newChoice.text = option["text"]
		newChoice.resultSets = option["resultSets"]
		choiceContainer.add_child(newChoice)
	##NOTE FOR MORNING, TRYING TO GET EVENT OPTIONS CONNECTED -- SHOULD WE MAKE IT AN OBJECT?	

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
