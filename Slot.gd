extends Area2D

onready var droppableZone = get_node("DroppableZone")
var notDroppable = false
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
#1 is normal comfort. zero is none. -1 is actively causing sanity drain
#var attributeScript = preload("res://Attribute.gd")
const Character = preload("res://Character.gd")
var comfortLevel = 1
var characterInSlot
var occupied = false
export var onLeftOfRoom = true

export(int) var prioritySeatingLevel  #as the ship is auto-filled up, seats will go here first
# Airlock should be second to last maybe after underwater, perhaps if > 5, dangerous, do not auto-fill

export(Array) var adjacentSlots = []

#Examples of inherent attributes would be "Underwater" for tank, "Terrifying" for airlock
#Examples of non-inherent attributes would be "Poisoned" for tank


export var slotAttributes = []
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
	if attribute.spreadChancePerHalfHour > 0:
		#if this attribute can spread
		var timer = Timer.new()
		timer.wait_time = TimeConverter.GameMinutesToSeconds(30)
		timer.connect("timeout",self,"SpreadContagiousAttribute", [attribute]) 
		add_child(timer) #to process
		timer.start() #to sta
	if(occupied):
		characterInSlot.applyNewAttribute(attribute)
	emit_signal("newAttributeAdded")

	pass
func removeAttributeFromSlot(attribute):
	#when an attribute is removed (such as a fire extenguished
	slotAttributes.erase(attribute)
	if(occupied):
		#if there is a character in this slot, remove the attribute from the character as well
		print("Removing attribute from slot and character: " + attribute.attributeName)
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

# func addCorpseToSlot(corpse):
# 	characterInSlot = corpse
# 	corpse.currentSlot = self
# 	corpse.global_position = self.global_position
# 	emit_signal("someoneEnteredSlot", self, corpse)
# 	System.updateSlots(self, corpse)
# 	corpse.turnOnAuras()
# 	pass
# func removeCorpseFromSlot(corpse):
# 	characterInSlot = null
# 	emit_signal("someoneVacatedSlot", self, corpse)
# 	System.updateSlots(self, null)
# 	corpse.previousSlot = self
# 	occupied = false
# 	corpse.turnOffAuras()
# 	pass

func addCharacterToSlot(character):
#	print("Character added to slot " + character.name)
	characterInSlot = character
	character.currentSlot = self
	character.global_position = self.global_position
	applyExistingAttributesToCharacter()
	emit_signal("someoneEnteredSlot", self, character)
	System.updateSlots(self, character)
	occupied = true
	if character is Character:
		#if this is a character and not a corpse
		if(onLeftOfRoom):
			#if the slot is on the left of this room
			character.characterStats.SetToRightFacingPosition()
		elif(!onLeftOfRoom):
			#if this slot is on the right of this orom
			character.characterStats.SetToLeftFacingPosition()
	character.turnOnAuras()
	print(character.name + " current slot is " + self.name)

func removeCharacterFromSlot(character):
	print("Character removed from slot")
	removeAllExitingAttributesFromCharacter()
	characterInSlot = null
	emit_signal("someoneVacatedSlot", self, character)
	System.updateSlots(self, null)
	character.previousSlot = self
	print("")
	occupied = false
	character.turnOffAuras()
	print(character.name + " previous slot is " + self.name)

func processDroppedItem(character):
	if(!occupied):
		if character.currentSlot != self:
			character.currentSlot.removeCharacterFromSlot(character)
			addCharacterToSlot(character)

func checkIfCharacterDropped(character):
	if(handInZone && !occupied):
		print("Checking if character dropped")
		if character.currentSlot != self:
			character.currentSlot.removeCharacterFromSlot(character)
			addCharacterToSlot(character)

func checkIfCharacterMovedToDifferentSlot(slot, character):
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

func _ready():

	add_to_group("slots")
	#System.connect("stoppedDraggingCharacter", self, "checkIfCharacterDropped")
	for item in get_tree().get_nodes_in_group("slots"):#System.allSlots:
		#if any slot received a "CharacterMoved" signal, check if it moved to a different slot
		item.connect("someoneEnteredSlot", self, "checkIfCharacterMovedToDifferentSlot")
	if(adjacentSlots.size() > 0):
		for item in adjacentSlots:
			item.connect("someoneEnteredSlot", self, "checkIfAdjacentSlotsFull")
			item.connect("someoneVacatedSlot", self, "checkIfAdjacentSlotsFull")
	pass # Replace with function body.
	System.updateSlots(self, characterInSlot)

	if slotAttributes.size() > 0:
		#if this has a preset attribute, apply that attribute
		for attributeName in slotAttributes:
			var attribute =	AttributeJSONParser.fetchAndCreateAttribute(attributeName)
			applyNewAttributeToSlot(attribute)
	System.SlotsByType[slotType].append(self)

func SpreadContagiousAttribute(attribute):
	var randomValue = randf()
	if randomValue <= attribute.spreadChancePerHalfHour:
		#if the chance is rolled, apply the attribute
		print("Attribute has spread!" + attribute.attributeName)
		get_parent().spreadToAdjacentSlots(self, attribute)
	else:
		#if not, restart the timer for each time it checks
		print("Check again  for spread of " + attribute.attributeName)
		var timer = Timer.new()
		timer.wait_time = TimeConverter.GameMinutesToSeconds(30)
		timer.connect("timeout",self,"SpreadContagiousAttribute", [attribute]) 
		add_child(timer) #to process
		timer.start() #to sta



func _on_Slot_area_entered(area):
	if(area.name == "Hand"):
		handInZone = true
	pass

func _on_Slot_area_exited(area):
	if(area.name == "Hand"):
		handInZone = false

func _on_Slot_mouse_entered():
	handInZone = true
	droppableZone.handInZone = true
	System.emit_signal("HoveringOverInteractibleZone")

func _on_Slot_mouse_exited():
	handInZone = false
	droppableZone.handInZone = false
	System.emit_signal("StoppedHoveringOverInteractibleZone")