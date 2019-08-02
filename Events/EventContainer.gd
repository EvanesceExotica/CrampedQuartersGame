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
	initializeEvent()
	pass # Replace with function body.

func initializeEvent():
	#change this so that each event has multiple branches of text?
	eventText.text = event.eventDescriptionText
	for item in event.eventChoices.keys():
		var newChoice = eventChoice.instance() 
		newChoice.text = item
		newChoice.eventFired = event.eventChoices[item]
		choiceContainer.add_child(newChoice)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
