extends "res://Stations/Station.gd"

#var appliedAttributeOnFailure = 

func disableStation():
    .disableStation()
#    get_tree().call_group("slots", "applyNewAttributeToSlot", AttributeJSONParser.fetchAndCreateAttribute(appliedAttributeOnFailure))
    SignalManager.emit_signal("GardenBolsteringStationDown", self, 3)