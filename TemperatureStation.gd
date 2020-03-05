extends "res://Stations/Station.gd"

var appliedAttributeOnFailure;


func disableStation():
    .disableStation()
    randomize()
    var randomValue = randf()
    if randomValue > 0.5:
        appliedAttributeOnFailure = "Overheating"
    elif randomValue <= 0.5:
        appliedAttributeOnFailure = "Freezing"
    get_tree().call_group("slots", "applyNewAttributeToSlot", AttributeJSONParser.fetchAndCreateAttribute(appliedAttributeOnFailure))