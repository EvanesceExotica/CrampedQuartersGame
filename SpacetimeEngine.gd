extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var timer = get_node("Timer")
onready var tween = get_node("Tween")
onready var countdownCircle = get_node("CountdownCircle")
var cooldown 
var active = true

var engineRunTime = 3

func startCooldown():
	print("Cooldown started")
	SignalManager.emit_signal("OnSpacetimeEngineCooldown")
	timer.wait_time = cooldown
	timer.start()
	tween.interpolate_property(countdownCircle, "value", 100, 0, cooldown, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()

# Called when the node enters the scene tree for the first time.
func _ready():
	#SignalManager.connect("OnSpacetimeJumpArrival", self, "startCooldown")
	SignalManager.connect("OnSpacetimeJumpDeparture", self, "runEngine")
	cooldown = 5 #System.elapsedSecondsInHour * System.fullDayDuration
	#startCooldown()
	pass # Replace with function body.

func _on_Timer_timeout():
	print("Engine active now")
	active = true
	SignalManager.emit_signal("OnSpacetimeEngineActive")

func runEngine():
	timer.wait_time = engineRunTime
	timer.start()
	yield(timer, "timeout")
	SignalManager.emit_signal("OnSpacetimeJumpArrival")
	startCooldown()
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
