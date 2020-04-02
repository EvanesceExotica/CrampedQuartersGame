extends Node2D
#test

var selectedCharacter
var attributeScript = preload("res://Attributes/Attribute.gd")
enum attributeTypes  {inherentAttribute, condition}
enum entities {character, station, slot}

var dragging = false
var draggedItem
var bf 
var entitiesFlag

var fields = {
	"isTraveling" : false,


}

var SlotsByType = {

}
var enumToSlotTypeDictionary = {

}

var SlotTypeOccupiedDictionary = {

}
# DynamicStats = { "health" : 0, "sustenance" : 1, "sanity" : 2, "relationship" : 3}
#
# attributeType = {"temporaryCondition" : 0, "auraCondition" : 1, "removeableCondition" : 2, "inherentAttribute" : 3}
#
# StaticStats = {"damageDealt" : 0, "spaceRequirement" : 1}
#
# entitiesAppliedTo {"character" : 0, "station": 1, "slot": 2}
#
enum attributeType{
	temporaryCondition,
	auraCondition,
	removeableCondition,
	inherentAttribute,
	species
}

enum DynamicStats{
	health,
	sustenance,
	sanity,
	relationship

	}


enum StaticStats{
	damageDealt,
	spaceRequirement
	}

enum entitiesAppliedTo{
	character,
	station,
	slot
}

#normal air seating, normal comfort level
#uncomfortableSeating - closet, garden
#dangerousSeating -- airlock, engineRoom
#deadlySeating --
# enum seatingTypes{
# 	normalAirSeating,
# 	uncomfortableSeating,
# 	dangerousSeating,
# 	airLock,
# 	underwater
#
# }

enum slotTypes{
	mainRoom,
	closet,
	garden,
	airLock,
	engine,
	aquarium

}
#onready var mainCamera = get_node("Camera2D")
#warning-ignore:unused_signal
signal morningStarted
#warning-ignore:unused_signal
signal afternoonStarted
#warning-ignore:unused_signal
signal eveningStarted
#warning-ignore:unused_signal
signal nightStarted

#warning-ignore:unused_signal
signal dayEnded

# var elapsedSecondsInDay = 0
# #warning-ignore:unused_class_variable
# var totalSecondsInDay = 300

#1 day = 5 minutes
#1 day = 300 seconds
#300/4 = 75
#each 6 hour period = 75 seconds
#each hour = 12.5 seconds

var allSlots = { }
var mainRoomSlots = { }
var gardenSlots = { }
var closetSlots = { }
var airlockSlots = { }
var aquariumSlots = { }
var engineSlots = { }

#var uncomfortableAirSlots = { }
#var dangerousAirSlots = { }
#var aquaticSlots = { }

signal dispensedItemConsumed(dispenser, character)
signal draggingCharacter(character)
signal stoppedDraggingCharacter(character)

signal HoveringOverInteractibleZone
signal StoppedHoveringOverInteractibleZone

signal draggingItem(item)
signal stoppedDraggingItem(item)

var elapsedSecondsInPeriod = 0
var totalSecondsInPeriod = 75

const Slots = "slots"

var paused = false
func populateSlots(slot):
	for item in get_tree().get_nodes_in_group("slots"):
		allSlots[item] = slot.characterInSlot
	#allSlots.keys() = get_tree().get_nodes_in_group("slots")
	# for slot in allSlots.keys():
	# 	if slot.slotType == slotTypes.mainRoom:
	# 		mainRoomSlots[slot] = slot.characterInSlot
	# 	elif slot.slotType == slotTypes.closet:
	# 		closetSlots[slot] = slot.characterInSlot

	# 	elif slot.slotType == slotTypes.garden:
	# 		gardenSlots[slot] = slot.characterInSlot

	# 	elif slot.slotType == slotTypes.airLock:
	# 		airlockSlots[slot] = slot.characterInSlot

	# 	elif slot.slotType == slotTypes.engine:
	# 		engineSlots[slot] = slot.characterInSlot

	# 	elif slot.slotType == slotTypes.aquarium:
	# 		aquariumSlots[slot] = slot.characterInSlot
	# print(str(slot.slotType))

func updateSlots(slot, character):
	#updates whether or not a slot is occupied

	# print("Slot updated!" + str(slot) + str(character))
	#put the character in the dictionary to show which character occupies this slot
	var temp = SlotsByType[slot.slotType]
	allSlots[slot] = character
	if slot.slotType == slotTypes.mainRoom:
		# print("This is a main room slot!")
		mainRoomSlots[slot] = slot.characterInSlot
		if mainRoomSlots.values().has(null):
			#if one of them has no character in it
			#set "fully occupied dictionary" to false
			SlotTypeOccupiedDictionary[slotTypes.mainRoom] = false;
		else:
			SlotTypeOccupiedDictionary[slotTypes.mainRoom] = true

	elif slot.slotType == slotTypes.closet:
		closetSlots[slot] = slot.characterInSlot
		if closetSlots.values().has(null):
			SlotTypeOccupiedDictionary[slotTypes.closet] = false;

	elif slot.slotType == slotTypes.garden:
		gardenSlots[slot] = slot.characterInSlot
		if gardenSlots.values().has(null):
			SlotTypeOccupiedDictionary[slotTypes.garden] = false;
	elif slot.slotType == slotTypes.airLock:
		airlockSlots[slot] = slot.characterInSlot
		if gardenSlots.values().has(null):
			SlotTypeOccupiedDictionary[slotTypes.garden] = false;

	elif slot.slotType == slotTypes.engine:
		engineSlots[slot] = slot.characterInSlot

		if engineSlots.values().has(null):
			SlotTypeOccupiedDictionary[slotTypes.engine] = false;

	elif slot.slotType == slotTypes.aquarium:
		aquariumSlots[slot] = slot.characterInSlot

		if aquariumSlots.values().has(null):
			SlotTypeOccupiedDictionary[slotTypes.aquariumSlots] = false;


	# print("Slot type + " + str(slot.slotType))#	for slot in allSlots.keys():
		# if slot == whichSlot:
		# 	allSlots[slot] = character
		# if whichSlot.slotType == slotTypes.mainRoom:
		# 	pass
		# elif whichSlot.slotType == slotTypes.closet:
		# 	pass
		# elif whichSlot.slotType == slotTypes.garden:
		# 	pass
		# elif whichSlot.slotType == slotTypes.airLock:
		# 	pass
		# elif whichSlot.slotType == slotTypes.engine:
		# 	pass
		# elif whichSlot.slotType == slotTypes.underwater:
		# 	pass

	# mainRoom,
	# closet,
	# garden,
	# airLock,
	# engine,
	# underwater


func setDraggedCharacter(character):
	selectedCharacter = character
	#print(character.name + " selected")

func clearDraggedCharacter(character):
	selectedCharacter = null
	#print(character.name + " dropped")

func pause():
	paused = true
	pass

func tweenMainCameraToNewRoom(destinationPosition):
	#mainCamera.global_position = destinationPosition.global_position
	#mainCamera.position = destinationPosition.global_position
	#print(mainCamera.global_position)
	pass

func _ready():
	SlotTypeOccupiedDictionary = {
		slotTypes.mainRoom : false,
		slotTypes.closet : false,
		slotTypes.garden : false,
		slotTypes.airLock : false,
		slotTypes.engine : false,
		slotTypes.aquarium : false
	}
	SlotsByType = {
		slotTypes.mainRoom : [],
		slotTypes.closet : [],
		slotTypes.garden : [],
		slotTypes.airLock : [],
		slotTypes.engine : [],
		slotTypes.aquarium : []
	}
	# var totalSlots = get_tree().get_nodes_in_group("slots")
	# for slot in totalSlots:
	# 	#for all the slots in the game
	# 	for slotType in SlotsByType.keys():
	# 		#search through the keys for one that matches the slot type of the slot 
	# 		if slot.slotType == slotType:
	# 			print("Slot matches!")
	# 			#if the slot's type matches the type of this particular key in the dictionary
	# 			#add this slot to the 'array'/'list' that is the value paired with the key
	# 			SlotsByType[slotType].append(slot)
	# 			print(slot.name)
	# 		else:
	# 			print("slot doesn't match")


	# enumToSlotTypeDictionary = {
	# 	slotTypes.mainroom : mainRoomSlots,
	# 	slotTypes.closet : closetslots,
	# 	slotTypes.garden : gardenslots,
	# 	slotTypes.airlock : airlockslots,
	# 	slotTypes.engine : engineslots,
	# 	slotTypes.aquarium : aquariumslots
	# }

	#mainCamera = get_node("Camera2D")

var fullDayDuration = 2 # Change back to 24

var currentHour = 0
var elapsedSecondsInHour = 0
var currentDayInRun = 1 
var totalSecondsInHour = 12.5
var elapsedSecondsInDay = 0


var gameSecondsSinceBeginningOfDay = 0
var gameHours
var gameMinutes
var gameSeconds

func WrapClockTime():
	pass
	

func convertToClockTime(delta):

	elapsedSecondsInHour += delta
	elapsedSecondsInDay+= delta

	if(elapsedSecondsInHour >= totalSecondsInHour):
		currentHour+=1
		SignalManager.emit_signal("HourPassed", currentHour)
		elapsedSecondsInHour = 0

#add 'skip' where can jump to 24 when asleep
	if(currentHour == fullDayDuration):
		SignalManager.emit_signal("DayPassed")
		currentDayInRun+=1
		currentHour = 0
		elapsedSecondsInDay = 0

func _process(delta):
	pass
	# if Input.is_action_pressed("left_click"):
	# 	dragging = true
	# if dragging && Input.is_action_pressed("left_click"):
	# 	pass
	# else:
	# 	dragging = false

	#convertToClockTime(delta)
	# elapsedSecondsInPeriod += delta
	# elapsedSecondsInDay += delta
	# if elapsedSecondsInPeriod > totalSecondsInPeriod:
	# 	elapsedSecondsInPeriod = 0
	pass
