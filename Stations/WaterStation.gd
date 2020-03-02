extends "res://Stations/Station.gd"

#Here, add affects to other station. 'Contaminate Food' in the 'food dispenser'
func disableStation():
    .disableStation()
    get_tree().call_group("slots", "applyNewAttributeToSlot", AttributeJSONParser.fetchAndCreateAttribute(appliedAttributeOnFailure))