extends Node2D

onready var bar = get_node("Bar")

func buildUp():
    animateBar(bar.value, 100, 6, Tween.TRANS_LINEAR, TWEEN.EASE_OUT)

func animateBar(startValue, targetValue, rate):
	if(!isTweenRunning):
		isTweenRunning = true
	else:
		tween.stop_all()
	
	tween.interpolate_property(bar, 'value', startValue, targetValue, rate, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	tween.start()