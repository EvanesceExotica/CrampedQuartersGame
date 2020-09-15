extends Node2D

# Declare member variables here. Examples:
# var a = 2
onready var dragSprite = get_node("DragSprite")
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

func onDragging(object):
	dragSprite.texture = object.dragSprite
	dragSprite.visible = true
	anim.stop()
	anim.play("Hold")

	
func onDraggingCharacter(character):
	print(character.name + " being dragged")
	dragSprite.texture = character.dragSprite
	dragSprite.visible = true
	anim.stop()
	anim.play("Hold")
	pass
func onDraggingItem(item):
	print("Hand dragging item!")
	dragSprite.texture = item.dragSprite
	dragSprite.visible = true
	anim.stop()
	anim.play("Hold")
	pass

func onDraggingDream(dreamSprite):
	dragSprite.texture = dreamSprite.thoughtSprite
	dragSprite.visible = true
	anim.stop()
	anim.play("Hold")

#TODO: You really shouldn't ahve to repeat these, they're doing the same thing VVV
func onReleaseDream(dreamSprite):
	dragSprite.visible = false
	anim.stop()
	anim.play("Release")
func onReleaseCharacter(character):
	dragSprite.visible = false
	anim.stop()
	anim.play("Release")

func onReleaseItem(item):
	dragSprite.visible = false
	anim.stop()
	anim.play("Release")

func release():
	anim.stop()
	anim.play("Release")

# Called when the node enters the scene tree for the first time.
func _ready():
	anim.play("Release")
	System.connect("dragging", self, "onDragging")
	System.connect("draggingCharacter", self, "onDraggingCharacter")
	System.connect("draggingItem", self, "onDraggingItem")
	#System.connect("HoveringOverInteractibleZone", self, "onHoverOverInteractable")
	System.connect("stoppedDraggingCharacter", self, "onReleaseCharacter")
	System.connect("stoppedDraggingItem", self, "onReleaseItem")
	#System.connect("StoppedHoveringOverInteractibleZone", self, "release")
	dragSprite.visible = false
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	self.global_position = get_global_mouse_position()
