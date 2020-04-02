extends "res://Stations/Station.gd"

func _ready():
    ._ready()
    appliedAttributeOnFailure = "Afraid"

func disableStation():
    .disableStation()
    get_tree().call_group("Lights", "TurnOff")
    #get_tree().call_group("slots", "applyNewAttributeToSlot", AttributeJSONParser.fetchAndCreateAttribute(appliedAttributeOnFailure))
    #TODO: Change this to be an attribute on the plants
    SignalManager.emit_signal("GardenBolsteringStationDown", self, 3)