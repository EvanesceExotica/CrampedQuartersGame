extends Node2D

# Declare member variables here. Examples:
# var a = 2

var areaName = "Cursor"

onready var anim = get_node("AnimationPlayer")
# var b = "text"
func onHoverOverInteractable():
	anim.play("TargetInteractable")
	pass
	
func onInteractWith():
	anim.play("Hold")
	

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	self.global_position = get_global_mouse_position()