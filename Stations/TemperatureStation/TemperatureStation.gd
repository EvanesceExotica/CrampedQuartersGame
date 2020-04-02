extends "res://Stations/Station.gd"


func _ready():
    ._ready()

func disableStation():
    randomize()
    var randomValue = randf()
    if randomValue > 0.5:
        appliedAttributeOnFailure = "Overheating"
    elif randomValue <= 0.5:
        appliedAttributeOnFailure = "Freezing"
    .disableStation()
    #get_tree().call_group("slots", "applyNewAttributeToSlot", AttributeJSONParser.fetchAndCreateAttribute(appliedAttributeOnFailure))