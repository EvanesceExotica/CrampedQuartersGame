extends "res://Stations/Station.gd"


func _ready():
    ._ready()
    appliedAttributeOnFailure = "Asphixiating"



# func disableStation():
#     .disableStation()
#     get_tree().call_group("slots", "applyNewAttributeToSlot", AttributeJSONParser.fetchAndCreateAttribute(appliedAttributeOnFailure))