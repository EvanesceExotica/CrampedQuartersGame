extends Area2D
var mouseIn = false
onready var parent = get_parent()

func _on_CircuitNode_mouse_entered():
	mouseIn = true
	parent.addPoint(self)

func _on_CircuitNode_mouse_exited():
	mouseIn = false
	
