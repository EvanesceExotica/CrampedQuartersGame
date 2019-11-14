extends "res://Stations/Station.gd"

var appliedAttributeOnFailure = "Afraid"

func disableStation():
    .disableStation()
    get_tree().call_group("Lights", "TurnOff")
    get_tree().call_group("slots", "applyNewAttributeToSlot", AttributeJSONParser.fetchAndCreateAttribute(appliedAttributeOnFailure))
