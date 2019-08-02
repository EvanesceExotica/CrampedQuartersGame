extends Button

var eventFired
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func _on_EventChoice_pressed():
	#pass a character through here rather than the list of parameters 
	SignalManager.emit_signal(eventFired)