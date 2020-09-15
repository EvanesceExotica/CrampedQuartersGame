extends Node2D

onready var parent = get_parent()
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
	if parent.handInZone:	
		print("Dropped?")
		for i in acceptedDrops:
			if acceptedDrops.has(droppedObject.get_class()):
				if parent.has_method("processDroppedItem"):
					parent.processDroppedItem(droppedObject)
	
