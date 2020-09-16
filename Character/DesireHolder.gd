extends Area2D

var handInZone = false
onready var anim = get_node("AnimationPlayer")

var currentDesire

signal desireRegistered(desire)

func processDroppedItem(desire):
	print("Dropped desire in me")
	if desire.global_position.distance_to(self.global_position) <= 70:
		desire.global_position = self.global_position
		anim.play("Signal")
		emit_signal("desireRegistered", desire)
		currentDesire = desire
	# if desire.has_method("shrink"):
	# 	desire.shrink()
	pass


func _on_DesireHolder_mouse_entered():
	handInZone = true
	pass # Replace with function body.


func _on_DesireHolder_mouse_exited():
	handInZone = false
	pass # Replace with function body.
