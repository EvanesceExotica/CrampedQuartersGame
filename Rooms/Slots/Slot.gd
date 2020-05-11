extends Area2D

onready var droppableZone = get_node("DroppableZone")
var notDroppable = false
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
#1 is normal comfort. zero is none. -1 is actively causing sanity drain
#var attributeScript = preload("res://Attribute.gd")
const Character = preload("res://Character/Character.gd")
var comfortLevel = 1
var characterInSlot
var occupied = false
export var onLeftOfRoom = true
onready var slotManager = get_parent()

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

func get_class():
	return "Slot"

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
	emit_signal("newAttributeAdded", attribute)

	pass
func removeAttributeFromSlot(attribute):
	#when an attribute is removed (such as a fire extenguished
	slotAttributes.erase(attribute)
	if(occupied):
		#if there is a character in this slot, remove the attribute from the character as well
		print("Removing attribute from slot and character: " + attribute.attributeName)
		removeAttributeFromCharacter(attribute)
	emit_signal("attributeRemoved", attribute)

func removeAttributeFromCharacter(attribute):
	#used when an attribute is timed out or removed from the slot
	characterInSlot.removeAttribute(attribute)

func removeAllExitingAttributesFromCharacter():
	#USED WHEN CHARACTER IS MOVED
	var i = 0
	if slotAttributes.size() > 0:
		for attribute in slotAttributes:
			removeAttributeFromCharacter(attribute)
			i+=1

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
	removeAllExitingAttributesFromCharacter()
	characterInSlot = null
	emit_signal("someoneVacatedSlot", self, character)
	SignalManager.emit_signal("SomeoneVacatedSlot", self, character)
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
	#this is for removing the character from the last slot they were in once they're moved to a new slot
	if character == characterInSlot:
		#if this character is the chracter who was in our slot
		if slot != self:
			#and this slot isn't us, they must've moved, so remove them
			removeCharacterFromSlot(character)
			#emit a signal so other sources can know about this
			SignalManager.emit_signal("SomeoneEnteredSlot", slot, character)

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

func SpreadFromCharacter(attribute):
	#get_parent().SpreadToCharacterInAdjacentSlot(self, attribute, attribute.spreadVariables["range"])
	get_parent().SpreadToCharacterInAdjacentSlot(self, attribute, attribute.spreadRange)
	pass

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
