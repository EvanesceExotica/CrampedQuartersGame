extends "res://Stations/Station.gd"

var appliedAttributeOnFailure = "Irradiated"

func disableStation():
    .disableStation()
    get_tree().call_group("slots", "applyNewAttributeToSlot", AttributeJSONParser.fetchAndCreateAttribute(appliedAttributeOnFailure))