extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var label = get_node("Label")

var currentHour = 0
var elapsedSecondsInHour = 0

func convertToClockTime(elapsedSecondsInDay):
	elapsedSecondsInHour += elapsedSecondsInDay
	if(elapsedSecondsInHour >= 12.5):
		currentHour+=1
		elapsedSecondsInHour = 0


	#	if(currentHour == 24):
	label.text = str(currentHour) + " O'clock"
	#label.text = str(currentHour) + ":" + str(elapsedSecondsInHour)		
	pass

func _process(delta):
	convertToClockTime(System.elapsedSecondsInDay)
	#label.text = str(System.elapsedSecondsInDay)

# Called every frame. 'delta' is the elapsed time since the previous frame.

