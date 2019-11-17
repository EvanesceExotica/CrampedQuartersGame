extends "res://Stations/Station.gd"


var appliedAttributeOnFailure = "Contaminated"

func disableStation():
    .disableStation()
    get_tree().call_group("slots", "applyNewAttributeToSlot", AttributeJSONParser.fetchAndCreateAttribute(appliedAttributeOnFailure))