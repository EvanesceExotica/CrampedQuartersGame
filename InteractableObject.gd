extends Node2D


var handInZone = false

var parent

signal interactedWith
func _ready():
	parent = get_parent()
    
func _input(event):
    if event.is_action_pressed("ui_interact") && handInZone:
        parent.processInteraction()




