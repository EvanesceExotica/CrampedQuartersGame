extends Area2D
var currentRadius 
var collisionShape
var startRadius 
var parent
signal leftBounds
signal backInBounds
onready var tween = get_parent().get_node("Tween")

func _ready():
	parent = get_parent()
	collisionShape = get_child(0)
	#collisionShape = get_node("Col")
	startRadius = collisionShape.get_shape().radius #shape.radius
	currentRadius = startRadius
	ShrinkRadius()
	moveToNewPosition(Vector2(0, 0))


func ShrinkRadius():
	var startValue = currentRadius
	tween.interpolate_property(self, "currentRadius", startValue, 0, 10, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()

func moveToNewPosition(newPosition):
	var startValue = self.global_position
	tween.interpolate_property(self, "global_position", startValue, newPosition, 3, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()

func _on_Tween_tween_step(object, key, elapsed, value):
	if key == ":currentRadius":
		collisionShape.shape.radius = value

func _on_Tween_tween_completed(object, key):
	print("KEY IS " + key)
	if key == ":global_position":
		moveToNewPosition(parent.getRandomPosition())

func _on_BoundsArea_mouse_entered():
	print("Back in bounds")
	emit_signal("backInBounds")
	pass

func _on_BoundsArea_mouse_exited():
	#print("Out of bounds")
	emit_signal("leftBounds")
	pass

