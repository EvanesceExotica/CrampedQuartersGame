extends Node2D

onready var dragSprite = get_node("Sprite")

var notDraggable = false
var beingDragged = false
var handInZone = false

func get_class():
	.get_class()
	return "Desire"

func setBeingDragged(_beingDragged):
	beingDragged = _beingDragged

func _process(delta):
	if beingDragged:
		updateDragPosition()

func updateDragPosition():
	self.global_position = get_global_mouse_position()

func _on_Area2D_mouse_entered():
	handInZone = true

func _on_Area2D_mouse_exited():
	handInZone = false


func shrink():
	$Tween.stop_all()
	var startScale = self.scale
	var endScale = Vector2(0, 0)
	$Tween.interpolate_property(self, "scale", startScale, endScale, 0.3, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()

