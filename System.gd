extends Node2D


var selectedCharacter
var attributeScript = preload("res://Attribute.gd")
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

var elapsedSecondsInDay = 0
#warning-ignore:unused_class_variable
var totalSecondsInDay = 300

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

signal draggingItem(item, tag)
signal stoppedDraggingItem(item, tag)

var elapsedSecondsInPeriod = 0
var totalSecondsInPeriod = 75

const Slots = "slots"

var paused = false
func populateSlots(slot):
	for item in get_tree().get_nodes_in_group("slots"):
		allSlots[item] = slot.characterInSlot
	#allSlots.keys() = get_tree().get_nodes_in_group("slots")
	for slot in allSlots.keys():
		if slot.slotType == slotTypes.mainRoom:
			mainRoomSlots[slot] = slot.characterInSlot
		elif slot.slotType == slotTypes.closet:
			closetSlots[slot] = slot.characterInSlot

		elif slot.slotType == slotTypes.garden:
			gardenSlots[slot] = slot.characterInSlot

		elif slot.slotType == slotTypes.airLock:
			airlockSlots[slot] = slot.characterInSlot

		elif slot.slotType == slotTypes.engine:
			engineSlots[slot] = slot.characterInSlot

		elif slot.slotType == slotTypes.aquarium:
			aquariumSlots[slot] = slot.characterInSlot
	print(str(slot.slotType))

func updateSlots(slot, character):
	allSlots[slot] = character
	if slot.slotType == slotTypes.mainRoom:
		print("This is a main room slot!")
		mainRoomSlots[slot] = slot.characterInSlot
	elif slot.slotType == slotTypes.closet:
		closetSlots[slot] = slot.characterInSlot

	elif slot.slotType == slotTypes.garden:
		gardenSlots[slot] = slot.characterInSlot

	elif slot.slotType == slotTypes.airLock:
		print("This is an airlock slot!")
		airlockSlots[slot] = slot.characterInSlot

	elif slot.slotType == slotTypes.engine:
		engineSlots[slot] = slot.characterInSlot

	elif slot.slotType == slotTypes.aquarium:
		aquariumSlots[slot] = slot.characterInSlot

	print("Slot type + " + str(slot.slotType))#	for slot in allSlots.keys():
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
	print(character.name + " selected")

func clearDraggedCharacter(character):
	selectedCharacter = null
	print(character.name + " dropped")

func pause():
	paused = true
	pass

func tweenMainCameraToNewRoom(destinationPosition):
	#mainCamera.global_position = destinationPosition.global_position
	#mainCamera.position = destinationPosition.global_position
	#print(mainCamera.global_position)
	pass

func _ready():
	#mainCamera = get_node("Camera2D")
	pass

var dragging = true
func _process(delta):

	if Input.is_action_pressed("left_click"):
		dragging = true
	if dragging && Input.is_action_pressed("left_click"):
		pass
	else:
		dragging = false

	elapsedSecondsInPeriod += delta
	elapsedSecondsInDay += delta
	if elapsedSecondsInPeriod > totalSecondsInPeriod:
		elapsedSecondsInPeriod = 0
	pass
