extends Node2D

# Declare member variables here. Examples:
# var a = 2

var areaName = "Cursor"
var dragging
onready var anim = get_node("AnimationPlayer")
# var b = "text"
func onHoverOverInteractable():
	anim.stop()
	anim.play("TargetInteractable")
	pass
	
func onInteractWith():
	anim.stop()
	anim.play("Hold")
	
func onDraggingCharacter(character):
	anim.stop()
	anim.play("Hold")
	pass
func onDraggingItem(item, tag):
	anim.stop()
	anim.play("Hold")
	pass
func onReleaseCharacter(character):
	anim.stop()
	anim.play("release")

func onReleaseItem(item, tag):
	anim.stop()
	anim.play("release")

func release():
	anim.stop()
	anim.play("release")

# Called when the node enters the scene tree for the first time.
func _ready():
	System.connect("draggingCharacter", self, "onDraggingCharacter")
	System.connect("draggingItem", self, "onDraggingItem")
	System.connect("HoveringOverInteractibleZone", self, "onHoverOverInteractable")
	System.connect("stoppedDraggingCharacter", self, "onReleaseCharacter")
	System.connect("stoppedDraggingItem", self, "onReleaseItem")
	System.connect("StoppedHoveringOverInteractibleZone", self, "release")
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	self.global_position = get_global_mouse_position()