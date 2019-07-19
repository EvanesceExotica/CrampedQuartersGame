extends Node2D
class_name MinigameNode

onready var countdownCircle = get_node("CountdownCircle")
onready var hex = get_node("Hex")
onready var tween = get_node("Tween")
onready var clickSpace = get_node("ClickSpace")

signal minigameNodeClicked
signal nodeTimedOut
# Called when the node enters the scene tree for the first time.
func _ready():
	#tweenTimerToZero()
	pass # Replace with function body.

func changeHexColor(var color):
	hex.modulate = color 

func tweenTimerToZero():
	tween.interpolate_property(countdownCircle, "value", 100, 0, 2.0, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.interpolate_property(hex, "modulate", Color.white, Color.red, 2.0, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.interpolate_property(countdownCircle, "modulate", countdownCircle.modulate, Color.red, 2.0, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()

func _on_ClickSpace_input_event(viewport, event, shape_idx):
	if (event is InputEventMouseButton && event.pressed):
		print("YOYOYO")
# Called every frame. 'delta' is the elapsed time since the previous frame.
	pass


func _on_Hex_pressed():
	print("Yoyoyo")
	#tween.stop(countdownCircle, "value")
	tween.stop_all()
	changeHexColor(Color.aquamarine)
	countdownCircle.value = 0
	emit_signal("minigameNodeClicked")
	pass # Replace with function body.


func _on_Tween_tween_completed(object, key):
	emit_signal("nodeTimedOut")
	pass # Replace with function body.
