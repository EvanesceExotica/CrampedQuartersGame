extends "res://Stations/Station.gd"

func _ready():
    ._ready()
    appliedAttributeOnFailure = "Contaminated"


# func disableStation():
#     .disableStation()
#     get_tree().call_group("slots", "applyNewAttributeToSlot", AttributeJSONParser.fetchAndCreateAttribute(appliedAttributeOnFailure))