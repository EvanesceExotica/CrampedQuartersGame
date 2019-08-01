extends Control

export var event : Resource
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var eventText = get_node("Panel/MarginContainer/VBoxContainer2/RichTextLabel")
# Called when the node enters the scene tree for the first time.
func _ready():

	pass # Replace with function body.

func initializeEvent():
	#change this so that each event has multiple branches of text?
	eventText = event.eventDescriptionText
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
