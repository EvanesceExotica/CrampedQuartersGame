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
var coolingDown = false
var jumping = false

func startCooldown():
	jumping = false #we're not jumping, we've arrived, we're on cooldonw
	coolingDown = true #we're on cooldown
	print("Cooldown started")
	SignalManager.emit_signal("OnSpacetimeEngineCooldown")
	timer.wait_time = cooldown
	timer.one_shot = true
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
	#print("Engine active now")
	if(coolingDown):
		#if the timer timed out after a cooldown
		active = true #we're not jumping or on cooldown, engine is active again
		SignalManager.emit_signal("OnSpacetimeEngineActive")
		coolingDown = false #no longer on cooldown now that timed out

func runEngine():
	jumping = true #engine is running, meaning we're jumping through spacetime
	active = false #engine can't be activated whiel we're already jumping through spacetime
	timer.wait_time = engineRunTime
	timer.one_shot = true
	timer.start()
	yield(timer, "timeout")
	SignalManager.emit_signal("OnSpacetimeJumpArrival")
	startCooldown()
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
