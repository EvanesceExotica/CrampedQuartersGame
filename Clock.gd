extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var label = get_node("Label")

var currentHour = 0
var elapsedSecondsInHour = 0
#this stuff probably needs to be put in the "System" category
func convertToClockTime(delta):
	elapsedSecondsInHour += delta
	if(elapsedSecondsInHour >= 12.5):
		currentHour+=1
		elapsedSecondsInHour = 0
#add 'skip' where can jump to 24 when asleep
	if(currentHour == 24):
		SignalManager.emit_signal("DayPassed")
		print("Day passed")

	#label.text = str(currentHour) + " O'clock"


	#fix this part later to reflect real clock time
	label.text = str(currentHour) + ":" + str(elapsedSecondsInHour)		
	pass

func _process(delta):
	convertToClockTime(delta)#System.elapsedSecondsInDay)
	#label.text = str(System.elapsedSecondsInDay)

# Called every frame. 'delta' is the elapsed time since the previous frame.

