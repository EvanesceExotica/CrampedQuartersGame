extends "res://Utility/AreaInputHandler.gd" 

var handInZone = false
export var acceptedDrops = []

#TODO: Find a way around this later
# enum AcceptedDropTypes{
# 	character,
# 	item,
# 	dreamDesire
# }
# export (AcceptedDropTypes) var acceptedDropType = AcceptedDropTypes.character

func _ready():
	System.connect("stoppedDraggingItem", self, "checkWhatDropped")
# 	parent.connect("", self, "setHandInZone")
# 	pass

# func setHandInZone(ishandInZone):
# 	handInZone = ishandInZone


func checkWhatDropped(droppedObject):
	if mouseHovering: # parent.handInZone:	
		for i in acceptedDrops:
			if acceptedDrops.has(droppedObject.get_class()):
				if parent.has_method("processDroppedItem"):
					parent.processDroppedItem(droppedObject)
	
