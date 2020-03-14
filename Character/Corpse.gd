extends Area2D

var currentSlot
var previousSlot
onready var corpseSprite = get_node("CorpseSprite")
onready var dragSprite = corpseSprite.texture
onready var dropType
onready var draggableItem = get_node("DraggableItem")

var handInZone = false
var dragging = false
var auraSlotRange = {}
var shakenAttribute
var diseasedAttribute

func _ready():
	shakenAttribute = AttributeJSONParser.fetchAndCreateAttribute("Shaken")
	auraSlotRange[shakenAttribute] = 3 
	diseasedAttribute = AttributeJSONParser.fetchAndCreateAttribute("Diseased")
	#set the wait time to 24 in-game hours for the timer to start giving off the 'diseased' aura
	$Timer.set_wait_time(TimeConverter.GameHoursToSeconds(24))
	$Timer.connect("timeout", self, "SetDiseased")
	$Timer.start()

func _on_Corpse_area_entered(area):
	if(area.name == "Hand"):
		handInZone = true

func _on_Corpse_area_exited(area):
	if(area.name == "Hand"):
	   handInZone = false

func _on_Corpse_mouse_entered():
	handInZone = true
	draggableItem.handInZone = true	
	System.emit_signal("HoveringOverInteractibleZone")

func _on_Corpse_mouse_exited():
	handInZone = false
	draggableItem.handInZone = false	
	System.emit_signal("StoppedHoveringOverInteractibleZone")

func SetSprite(texture):
	corpseSprite.texture = texture

func applyNewAttribute(attribute):
	#apply just the effect here, if any
	pass

func removeAttribute(attribute):
	#remove just the effect here, if any
	pass

func turnOffAuras():
	for aura in auraSlotRange.keys():
		print("Stopping aura " + aura.attributeName)
		SignalManager.emit_signal("stoppedEmittingAura", previousSlot, aura, auraSlotRange[aura])


func turnOnAuras():
	for aura in auraSlotRange.keys():
		SignalManager.emit_signal("emittingAura", currentSlot, aura, auraSlotRange[aura])

func SetDiseased():
	turnOffAuras()
	auraSlotRange[diseasedAttribute] = 3
	turnOnAuras()


	

func Destroy():
	#destroy this object
	turnOffAuras()
	self.queue_free()