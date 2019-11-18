extends Area2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
#1 is normal comfort. zero is none. -1 is actively causing sanity drain
#var attributeScript = preload("res://Attribute.gd")
var comfortLevel = 1
var characterInSlot
var occupied = false
export var onLeftOfRoom = true

export(int) var prioritySeatingLevel  #as the ship is auto-filled up, seats will go here first
# Airlock should be second to last maybe after underwater, perhaps if > 5, dangerous, do not auto-fill

export(Array) var adjacentSlots = []

#Examples of inherent attributes would be "Underwater" for tank, "Terrifying" for airlock
#Examples of non-inherent attributes would be "Poisoned" for tank


var slotAttributes = []
var inherentAttributes = []
var temporaryOrRemoveableAttributes = []
signal newAttributeAdded
signal attributeRemoved


signal someoneEnteredSlot(whichSlot, whichChar)

signal someoneVacatedSlot(whichSlot, whichChar)

export(int, "mainRoom", "closet", "garden", "airlock", "engine", "aquarium") var slotType
#export (slotSlotTypes) var slotType = slotSlotTypes.mainRoom

var handInZone
enum slotSlotTypes{
	mainRoom,
	closet,
	garden,
	airLock,
	engine,
	aquarium

}
func applyNewAttributeToSlot(attribute):
	#when a brand new attribute is applied, apply it to the character as well
	slotAttributes.append(attribute)
	if(occupied):
		print("We have a character here and we're going to add this attribute")
		print(characterInSlot.characterName)
		characterInSlot.applyNewAttribute(attribute)
		for attribute in characterInSlot.characterAttributes:
			print("Charcter has these : " + attribute.attributeName)
	emit_signal("newAttributeAdded")

	pass
func removeAttributeFromSlot(attribute):
	#when an attribute is removed (such as a fire extenguished
	slotAttributes.remove(attribute)
	if(occupied):
		#if there is a character in this slot, remove the attribute from the character as well
		removeAttributeFromCharacter(attribute)
	emit_signal("attributeRemoved")

func removeAttributeFromCharacter(attribute):
	#used when an attribute is timed out or removed from the slot
	characterInSlot.removeAttribute(attribute)

func removeAllExitingAttributesFromCharacter():
	#USED WHEN CHARACTER IS MOVED
	if slotAttributes.size() > 0:
		for attribute in slotAttributes:
			removeAttributeFromCharacter(attribute)

func applyNewAttributeToCharacter(attribute):
	#used when a new attribute is added to the slot
	characterInSlot.applyNewAttribute(attribute)

func applyExistingAttributesToCharacter():
	#if the slot has existing on inherent attributes, apply these to character
	if slotAttributes.size() > 0:
		for attribute in slotAttributes:
			applyNewAttributeToCharacter(attribute)

func checkIfCharacterDontLikeInAdjacentSlot():
	#this function is to check the adjacent slots for a character this character may have problems with
	#(if they're a diff species as a xenophobe, or insane, or something)
	pass

func addCharacterToSlot(character):
	characterInSlot = character
	character.currentSlot = self
	character.global_position = self.global_position
	applyExistingAttributesToCharacter()
	emit_signal("someoneEnteredSlot", self, character)
	System.updateSlots(self, character)
	occupied = true
	if(onLeftOfRoom):
		#if the slot is on the left of this room
		character.characterStats.SetToRightFacingPosition()
	elif(!onLeftOfRoom):
		#if this slot is on the right of this orom
		character.characterStats.SetToLeftFacingPosition()

func removeCharacterFromSlot(character):
	#TODO ADD SOMETHING THAT TRIGGERS THIS
	characterInSlot = null
	removeAllExitingAttributesFromCharacter()
	emit_signal("someoneVacatedSlot", self, character)
	System.updateSlots(self, null)
	occupied = false

func checkIfCharacterDropped(character):
	if(handInZone && !occupied):
		addCharacterToSlot(character)

func checkIfCharacterMovedToDifferentSlot(character, slot):
	if character == characterInSlot:
		if slot != self:
			removeCharacterFromSlot(character)
	pass
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

	add_to_group("slots")
# 	var testAttribute = System.attributeScript.new("Underwater")
# #	testAttribute.attributeType = System.attributeType.auraCondition
# 	testAttribute.DrainingDynamicStats = {System.DynamicStats.health: 10}
# 	applyNewAttributeToSlot(testAttribute)
	System.connect("stoppedDraggingCharacter", self, "checkIfCharacterDropped")
	for item in System.allSlots:
		item.connect("someoneVacatedSlot", self, "checkIfCharacterMovedToDifferentSlot")
	if(adjacentSlots.size() > 0):
		for item in adjacentSlots:
			item.connect("someoneEnteredSlot", self, "checkIfAdjacentSlotsFull")
			item.connect("someoneVacatedSlot", self, "checkIfAdjacentSlotsFull")
	pass # Replace with function body.
	System.updateSlots(self, characterInSlot)


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
