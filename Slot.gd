extends Area2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
#1 is normal comfort. zero is none. -1 is actively causing sanity drain
var comfortLevel = 1
var characterInSlot
var occupied = false

export(Array) var adjacentSlots = []

signal someoneEnteredSlot

signal someoneVacatedSlot

var handInZone

func checkIfCharacterDontLikeInAdjacentSlot():
	#this function is to check the adjacent slots for a character this character may have problems with
	#(if they're a diff species as a xenophobe, or insane, or something)
	pass

func checkIfCharacterDropped(character):
	if(handInZone && !occupied):
		characterInSlot = character
	#	print("Dragged " + character.name + " In Here");
		character.global_position = self.global_position
		emit_signal("someoneEnteredSlot")

func checkIfAdjacentSlotsFull():
	var allFull = true
	for item in adjacentSlots:
		if(item.occupied == false):
			allFull  = false
	if(allFull):
		#Tweak this to consider the character's space requirements
		comfortLevel-=1
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	System.connect("stoppedDraggingCharacter", self, "checkIfCharacterDropped")
	if(adjacentSlots.size() > 0):
		for item in adjacentSlots:
			item.connect("someoneEnteredSlot", self, "checkIfAdjacentSlotsFull")
			item.connect("someoneVacatedSlot", self, "checkIfAdjacentSlotsFull")
	pass # Replace with function body.



func _on_Slot_area_entered(area):
	if(area.name == "Hand"):
	#	print("Hand entered " + self.name)
		handInZone = true
	pass

func _on_Slot_area_exited(area):
	if(area.name == "Hand"):
	#	print("Hand exited " + self.name)
		handInZone = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
