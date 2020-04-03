extends Node2D

signal barMaxedOut

onready var bar = get_node("Bar")
onready var tween = get_node("Tween")
var decreaseValue = 10
var originalTimeValue = 5.0
#fix this later to be more specific -- maybe it won't always eb the parent
onready var stationScreen = get_parent()

var isTweenRunning = false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	stationScreen.connect("meterEffected", self, "changeBarAmount")
	tweenBarUp(originalTimeValue)

func changeBarAmount(amount):
	var currentValue = bar.value
	var newValue = currentValue + amount
	animateBar(currentValue, newValue, 0.1)

func animateBar(startValue, targetValue, rate):
	if(!isTweenRunning):
		isTweenRunning = true
	else:
		tween.stop_all()
	
	tween.interpolate_property(bar, 'value', startValue, targetValue, rate, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	tween.start()

func cancelBarTween():
	tween.stop_all()

func tweenBarUp(timeValue):
	var currentValue = bar.value
	#You want it to tween at the same rate regardless of how much bar yo uhave left
	animateBar(currentValue, 100, timeValue)
	
func _input(event):
	pass
	# if(event.is_action_pressed("ui_interact")):
	# 	var currentValue = bar.value
	# 	var newValue = currentValue - decreaseValue
	# 	animateBar(currentValue, newValue, 0.1)
		
func calculateRemainingTimePercentage():
	var remainingValue = bar.max_value - bar.value
	var percentage = (remainingValue/bar.max_value)
	return originalTimeValue * percentage

func _calculateRemainingTimePercentage(timeValue):
	var remainingValue = bar.max_value - bar.value
	var percentage = (remainingValue/bar.max_value)
	return timeValue * percentage
#	pass
func _on_Tween_tween_completed(object, key):
	if bar.value < bar.max_value:
		#this means this was a setback tween that was getting restarted; ignore and restart the tween back to maximum
		tweenBarUp(calculateRemainingTimePercentage())
	elif bar.value == bar.max_value:
		emit_signal("barMaxedOut")
		print("ON NO WE HIT THE MAXIMUM")

		
