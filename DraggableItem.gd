extends Node2D

var handInZone = false
var dragging = false

func _process(delta):

	if(handInZone && Input.is_action_pressed("left_click")):
		if(!dragging):
			System.emit_signal("draggingCharacter", self)
			dragging = true

	if(dragging && Input.is_action_pressed("left_click")):
		pass
	else:
		if(dragging):
			dragging = false
			System.emit_signal("stoppedDraggingCharacter", self)

