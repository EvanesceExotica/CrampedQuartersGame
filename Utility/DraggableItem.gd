extends Node2D

var handInZone = false
var dragging = false
var parent

enum DropTypes{
	character,
	item,
	dreamDesire
}
export(DropTypes) var dropType = DropTypes.character

func _ready():
	parent = get_parent()
	parent.dropType = dropType

func _process(delta):

	if(handInZone && Input.is_action_pressed("left_click")):
		if(!dragging && !System.dragging && !parent.notDraggable):
			#if we're not already dragging ourselves, and the system isn't dragging another item, and our parent is allowing us to drag
			System.emit_signal("draggingItem", parent)
			dragging = true
			System.dragging = true
			System.draggedItem = parent

	if(dragging && Input.is_action_pressed("left_click")):
		pass
	else:
		if(dragging):
			dragging = false
			System.emit_signal("stoppedDraggingItem", parent)
			System.dragging = false
			System.draggedItem = parent

