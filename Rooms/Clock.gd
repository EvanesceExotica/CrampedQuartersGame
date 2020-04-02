extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var label = get_node("Label")
onready var realtimeLabel = get_node("RealTimeLabel")
var currentHour = 0
var elapsedSecondsInHour = 0
#this stuff probably needs to be put in the "System" category

func _ready():
	SignalManager.connect("HourPassed", self, "SetClockHour")

func SetClockHour(hour):
	pass
	# print("Setting clock hour")
	# label.text = str(hour).pad_zeros(2)

func convertToClockTime(delta):
	elapsedSecondsInHour += delta
	if(elapsedSecondsInHour >= 12.5):
		currentHour+=1
		elapsedSecondsInHour = 0
#add 'skip' where can jump to 24 when asleep
	# if(currentHour == 24):
	# 	SignalManager.emit_signal("DayPassed")
	# 	print("Day passed")

	#label.text = str(currentHour) + " O'clock"


	#fix this part later to reflect real clock time
#	label.text = str(currentHour) + ":" + str(elapsedSecondsInHour)		
	pass

func _process(delta):
	label.text = str(TimeConverter.Hours()).pad_zeros(2) + ":" + str(TimeConverter.Minutes()).pad_zeros(2) + ":" + str(TimeConverter.Seconds()).pad_zeros(2)
	realtimeLabel.text = str(TimeConverter.RealSeconds()) #str(TimeConverter.Hours()/TimeConverter.timeRatio).pad_zeros(2) + ":" + str(TimeConverter.Minutes()/TimeConverter.timeRatio).pad_zeros(2)+ ":" + str(TimeConverter.Seconds()/TimeConverter.timeRatio).pad_zeros(2)
	#convertToClockTime(delta)#System.elapsedSecondsInDay)
	#label.text = str(System.elapsedSecondsInDay)

# Called every frame. 'delta' is the elapsed time since the previous frame.

