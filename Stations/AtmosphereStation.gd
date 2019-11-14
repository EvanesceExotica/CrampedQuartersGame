extends "res://Stations/Station.gd"

var appliedAttributeOnFailure = "Asphixiating"

func disableStation():
    .disableStation()
    get_tree().call_group("slots", "applyNewAttributeToSlot", AttributeJSONParser.fetchAndCreateAttribute(appliedAttributeOnFailure))