extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.

func ArrivedAtNewLocation():
	SignalManager.emit_signal("OnArrival")

#func _process(delta):
#	pass
func _on_JumpButton_pressed():
	print("Jumped to new location")
	ArrivedAtNewLocation()

