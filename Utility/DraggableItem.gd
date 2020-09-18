extends "res://Utility/AreaInputHandler.gd"

var handInZone = false
var dragging = false

var dragWholeItem = false #dragging the item along with the sprite rather than just the 
# enum DropTypes{
# 	character,
# 	item,
# 	dreamDesire
# }
# export(DropTypes) var dropType = DropTypes.character

func _ready():
	pass
	#parent = get_parent()
	#parent.dropType = dropType

func _process(delta):

	#$if(parent.handInZone != null && parent.handInZone && Input.is_action_pressed("left_click")):
	if(mouseHovering && Input.is_action_pressed("left_click")):
		if(!dragging && !System.dragging && !parent.notDraggable):
			#if we're not already dragging ourselves, and the system isn't dragging another item, and our parent is allowing us to drag
			System.emit_signal("draggingItem", parent)
			dragging = true
			System.dragging = true
			System.draggedItem = parent
			if parent.has_method("setBeingDragged"):
				parent.setBeingDragged(dragging)

	if(dragging && Input.is_action_pressed("left_click")):
		pass
	else:
		if(dragging):
			dragging = false
			System.emit_signal("stoppedDraggingItem", parent)
			System.dragging = false
			System.draggedItem = parent
			if parent.has_method("setBeingDragged"):
				parent.setBeingDragged(dragging)
