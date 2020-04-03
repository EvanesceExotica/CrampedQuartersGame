extends Area2D
var mouseIn = false

onready var parent = get_parent()

enum directions{
	vertical,
	horizontal
}
export (directions) var direction

func _on_CircuitNode_mouse_entered():
	mouseIn = true

func _on_CircuitNode_mouse_exited():
	mouseIn = false
	


func _on_CircuitNode_area_entered(area):
	pass # Replace with function body.
	parent.addPoint(self)


func _on_CircuitNode_area_exited(area):
	pass # Replace with function body.
