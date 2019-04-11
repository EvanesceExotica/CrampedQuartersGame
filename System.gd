extends Node2D


var selectedCharacter

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
signal dispensedItemConsumed(dispenser, character)
signal draggingCharacter(character)
signal stoppedDraggingCharacter(character)

signal draggingItem(item, tag)
signal stoppedDraggingItem(item, tag)

var elapsedSecondsInPeriod = 0
var totalSecondsInPeriod = 75

var paused = false

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
