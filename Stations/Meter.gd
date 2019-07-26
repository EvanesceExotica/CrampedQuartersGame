extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var bar = get_node("Bar")
onready var tween = get_node("Tween")
var decreaseValue = 10
var originalTimeValue = 5.0

var isTweenRunning = false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	tweenBarUp(originalTimeValue)

func animateBar(startValue, targetValue, rate):
	if(!isTweenRunning):
		isTweenRunning = true
	else:
		tween.stop_all()
	
	tween.interpolate_property(bar, 'value', startValue, targetValue, rate, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	tween.start()

func tweenBarUp(timeValue):
	var currentValue = bar.value
	#You want it to tween at the same rate regardless of how much bar yo uhave left
	animateBar(currentValue, 100, timeValue)
	# tween.interpolate_property(bar, "value", currentValue, 100, 2.5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	# tween.start()
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
func _input(event):
	if(event.is_action_pressed("ui_interact")):
		var currentValue = bar.value
		var newValue = currentValue - decreaseValue
		animateBar(currentValue, newValue, 0.1)
		
func calculateRemainingTimePercentage():
	var remainingValue = bar.max_value - bar.value
	var percentage = (remainingValue/bar.max_value)
	return originalTimeValue * percentage


#	pass
func _on_Tween_tween_completed(object, key):
	if bar.value < bar.max_value:
		#this means this was a setback tween that was getting restarted; ignore and restart the tween back to maximum
		tweenBarUp(calculateRemainingTimePercentage())
	elif bar.value == bar.max_value:
		print("ON NO WE HIT THE MAXIMUM")

		
