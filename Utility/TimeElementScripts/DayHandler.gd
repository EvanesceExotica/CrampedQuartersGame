extends Node2D

export(int) var daysPassed = 0
#TODO: max days is being set to one automatically, think of way to fix
export(int) var maxDays = 2

var atFuture = false 
var beholdingTheTruth = "BeholdingTheTruth"
signal ReachedMaximumDays
onready var blackHole = get_parent().get_node("BlackHole")

func _ready():
	SignalManager.connect("DayPassed", self, "AddToDayCounter")
	$Timer.connect("timeout", self, "ArrivedAtFuture")

func AddToDayCounter():
	daysPassed+=1
	if daysPassed == maxDays:
		emit_signal("ReachedMaximumDays")
		ReturnToFuture()
	
func ReturnToFuture():
	#this will activate a timer that returns the group to the space station
	#every passenger must be checked for health
	get_tree().call_group("Characters","travelToFuture", beholdingTheTruth)#AttributeJSONParser.fetchAndCreateAttribute(beholdingTheTruth))
	#set the timer for the amount of time it'll take to arrive in the future
	SignalManager.emit_signal("MovingToFuture")
	SetFutureJumpTimer()
	pass

func ArrivedAtFuture():
	get_tree().call_group("Characters","arrivedAtFuture", beholdingTheTruth)#AttributeJSONParser.fetchAndCreateAttribute(beholdingTheTruth))
	blackHole.setCurrentCamera()
	SignalManager.emit_signal("ArrivedAtBlackHole")
	atFuture = true
	#print("ARRIVED AT FUTURE ONCE")
	
# func _process(delta):
#     if Input.is_action_pressed("ui_interact"):
#         print("Should be returning to future")
#         ReturnToFuture()

func SetFutureJumpTimer():
	$Timer.wait_time = 1
	$Timer.start()

func _input(event):
	if event.is_action_pressed("ui_accept") && !atFuture:
		print("Should be returning to future")
		ReturnToFuture()


