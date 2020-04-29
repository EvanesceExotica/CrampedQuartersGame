extends Node2D

export(int) var daysPassed = 0
export(int) var maxDays = 5

var beholdingTheTruth = "BeholdingTheTruth"
signal ReachedMaximumDays

func _ready():
    SignalManager.connect("DayPassed", self, "AddToDayCounter")

func AddToDayCounter():
    daysPassed+=1
    if daysPassed == maxDays:
        emit_signal("ReachedMaximumDays")
        ReturnToFuture()
    
func ReturnToFuture():
    #this will activate a timer that returns the group to the space station
    #every passenger must be checked for health
    get_tree().call_group("Characters","travelToFuture", beholdingTheTruth)#AttributeJSONParser.fetchAndCreateAttribute(beholdingTheTruth))
    pass
# func _process(delta):
#     if Input.is_action_pressed("ui_interact"):
#         print("Should be returning to future")
#         ReturnToFuture()

func _input(event):
    if event.is_action_pressed("ui_interact"):
        print("Should be returning to future")
        ReturnToFuture()


