extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var countdownCircle = get_node("CountdownCircle")
onready var hex = get_node("Hex")
onready var tween = get_node("Tween")
onready var clickSpace = get_node("ClickSpace")

# Called when the node enters the scene tree for the first time.
func _ready():
	tweenTimerToZero()
	pass # Replace with function body.

func changeHexColor(var color):
	hex.modulate = color 

func tweenTimerToZero():
	tween.interpolate_property(countdownCircle, "value", 100, 0, 3.0, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()

func _on_ClickSpace_input_event():
	print("YOYOYO")
# Called every frame. 'delta' is the elapsed time since the previous frame.
	pass
