extends "res://Stations/Station.gd"

# var appliedAttributeOnFailure = "Irradiated"
# var createdAttribute
# #this will actually be the 'engine' station. Like the temperature station, disabling can have one of two effects. 
# #one: Sublight Damage: The navigator screen will be covered in fog
# #Two: Jumping causes temporary irradiation effect

# func _ready():
#     ._ready()

# func disableStation():
#     .disableStation()
#     #when this station is disabled/non-fuctional, each jump will cause radiation leakage
#     SignalManager.connect("OnSpacetimeJumpDeparture", self, "emitRadiation")
#     SignalManager.connect("OnSpacetimeJumpArrival", self, "stopRadiation")

# func enableStation():
#     .enableStation()
#     SignalManager.disconnect("OnSpacetimeJumpDeparture", self, "emitRadiation")
#     SignalManager.disconnect("OnSpacetimeJumpArrival", self, "stopRadiation")
#    # get_tree().call_group("slots", "removeAttributeFromSlot", createdAttribute)

# func stopRadiation():
#     get_tree().call_group("slots", "removeAttributeFromSlot", createdAttribute)

# func emitRadiation():
#     if createdAttribute != null:
#         createdAttribute = AttributeJSONParser.fetchAndCreateAttribute(appliedAttributeOnFailure) 
#     get_tree().call_group("slots", "applyNewAttributeToSlot", createdAttribute)

# func fogNavigator():
#     pass