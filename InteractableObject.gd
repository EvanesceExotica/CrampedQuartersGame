
extends "res://Utility/AreaInputHandler.gd"

var handInZone = false

signal interactedWith
func _ready():
#	parent = get_parent()
	pass

func _input(event):
	if mouseHovering:
		if parent.has_method("displayHoverInfo"):
			parent.displayHoverInfo()
	if event.is_action_pressed("ui_interact") && mouseHovering: #parent.get("handInZone") && parent.handInZone:
		#if hand in zone exists on our parent, we pressed the interact button, and handInZone is true on our parent
		#emit_signal(interactedWith)
		if parent.has_method("processInteraction"):
			parent.processInteraction()




