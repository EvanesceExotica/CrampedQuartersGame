extends Node2D

onready var parent = get_parent()
var handInZone = false
export var acceptedDrops = []

#TODO: Find a way around this later
enum AcceptedDropTypes{
	character,
	item,
	dreamDesire
}
export (AcceptedDropTypes) var acceptedDropType = AcceptedDropTypes.character

func _ready():
	System.connect("stoppedDraggingItem", self, "checkWhatDropped")
	pass


func checkWhatDropped(droppedObject):
	if handInZone:	
		if droppedObject.dropType == acceptedDropType:
			parent.processDroppedItem(droppedObject)
	#for acceptableItem in acceptedDrops:
		#print(droppedObject.get_class() + " vs " + acceptableItem.get_class())
		#parent.processDroppedItem(droppedObject)
		#if droppedObject is Character:
		#	parent.processDroppedItem(droppedObject)
	#if parent.has_method("processDroppedObject"):
		#parent.processDroppedItem(droppedObject)
