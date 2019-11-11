extends Button

var calledSignal
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var resultSets
var affectedObjectDictionary = {}
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func _on_EventChoice_pressed():

	#this method is just for reseting the timer on the event and anything else that should happen when an event is clicked or defaulted
	SignalManager.emit_signal("EventProgressed")
	if resultSets == null:
		#this method ends the event if there are no results
		SignalManager.emit_signal("EndEvent", null)
	else:
		#this method applies the results
		SignalManager.emit_signal("EventChoiceClicked", resultSets, affectedObjectDictionary)
	#SignalManager.emit_signal(calledSignal.calledSignalName, calledSignal.signalParameters)