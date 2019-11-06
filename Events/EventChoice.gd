extends Button

var calledSignal
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var resultSets
var affectedObjectDictionary = []
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func _on_EventChoice_pressed():
	#pass a character through here rather than the list of parameters 
	if resultSets == null:
		SignalManager.emit_signal("EndEvent", null)
	else:
		SignalManager.emit_signal("EventChoiceClicked", resultSets, affectedObjects)
	#SignalManager.emit_signal(calledSignal.calledSignalName, calledSignal.signalParameters)