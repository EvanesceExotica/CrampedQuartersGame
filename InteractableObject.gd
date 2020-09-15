extends Node2D


var handInZone = false

var parent

signal interactedWith
func _ready():
	parent = get_parent()
	
func _input(event):
	if event.is_action_pressed("ui_interact") && parent.get("handInZone") && parent.handInZone:
		#if hand in zone exists on our parent, we pressed the interact button, and handInZone is true on our parent
		#emit_signal(interactedWith)
		parent.processInteraction()




