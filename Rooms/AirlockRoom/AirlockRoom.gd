extends "res://Rooms/Room.gd"

onready var slotManager = get_node("SlotManager")
func _on_Button_pressed():
	slotManager.killAllInSlots()
