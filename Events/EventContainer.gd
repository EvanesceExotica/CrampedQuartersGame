extends Control

export var event : Resource
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var eventText = get_node("Panel/MarginContainer/VBoxContainer2/RichTextLabel")
var eventChoice = preload("res://Events/EventChoice.tscn")
onready var choiceContainer = get_node("Panel/MarginContainer/VBoxContainer2")
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

func showEvent(eventParameters):
	eventText.text = eventParameters["description"]
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
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
