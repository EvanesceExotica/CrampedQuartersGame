extends Area2D

onready var parent = get_parent()

func _on_Trace_mouse_entered():
	parent.outOfBounds = false
	pass

func _on_Trace_mouse_exited():
	parent.outOfBounds = true
	pass
