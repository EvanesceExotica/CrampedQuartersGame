extends Node2D

onready var scanner = get_node("Scanner")
onready var lever = get_node("Lever2")

func _ready():
	lever.connect("flushReleased", self, "rotateScanner")
	pass


func rotateScanner():
	$Tween.interpolate_property(scanner, "rotation_degrees", 0, 360, 1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()
	$Tween.set_repeat(true)

func tweenToRightPosition():
	var currentDegrees = scanner.rotation_degrees
	$Tween.interpolate_property(scanner, "rotation_degrees", currentDegrees, 0, 0.1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
func stopScanner():
	$Tween.stop_all()
	if scanner.rotation_degrees <= 10 && scanner.rotation_degrees >= -10:
		print("We connected!")
		tweenToRightPosition()
	else:
		print("We're off ")

func _input(event):
	if event.is_action_pressed("ui_interact"):
		stopScanner()

