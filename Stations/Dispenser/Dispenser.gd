extends Area2D

var handInZone = false
var dragging = false
onready var label = get_node("QuantityLabel")
export (Texture)var dragSprite
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
enum ItemOptions{
	food,
	health
}
var dispensedItem

var maxAmountHeld = 3
var amountToDispense = 1

onready var respawnHours = 2
var initialRespawnWaitTime = 100
var respawnWaitTime = 100

var appliedAttributes = []

func removeDispensedItemFromDispenser(dispenser, character):
	if(dispenser == self):
		amountToDispense-= 1
	#	print("We have " + str(amountToDispense) + " left in " + self.name)
		if(amountToDispense <= 0):
			amountToDispense = 0
		SetItemAmountLabel()
			#respawnItem()


var dispensedItemValue = 50
#export(ItemOptions) var dispensedItem = ItemOptions.food
# Called when the node enters the scene tree for the first time.
func _ready():
	if !System.is_connected("dispensedItemConsumed", self, "removeDispensedItemFromDispenser"):
		System.connect("dispensedItemConsumed", self, "removeDispensedItemFromDispenser")
	SetItemAmountLabel()
	pass # Replace with function body.


func _process(delta):

	if(handInZone && Input.is_action_pressed("left_click")):
		if amountToDispense != 0:
			#if there's actually something to drag
			if(!dragging):
				print("Dragging now")
				System.emit_signal("draggingItem", self)
				dragging = true
		else:
			print("Dispenser is empty or processing! Nothing to drag")


	if(dragging && Input.is_action_pressed("left_click")):
		pass
	else:
		if(dragging):
			dragging = false
			System.emit_signal("stoppedDraggingItem", self)


func respawnItem():
	$Timer.set_wait_time(TimeConverter.GameHoursToSeconds(respawnHours))
	$Timer.connect("timeout", self, "onRespawnTimerTimeout")
	$Timer.start()
	#this is for respawning item after certain amount of time is passed, can maybe manually work it to make new item appear?
	#make interactWith a "Station" thing, make this inherit from station. Add a "repair" too.
	pass

func onRespawnTimerTimeout():
	print("Item produced! Ready to be dispensed")
	amountToDispense+= 1
	if(amountToDispense >= maxAmountHeld):
		amountToDispense = maxAmountHeld
	SetItemAmountLabel()
	#else:
	#	respawnItem()

func slowRespawnRate():
	respawnWaitTime = respawnWaitTime * 0.5;

func resetRespawnRate():
	respawnWaitTime = initialRespawnWaitTime

func haltRespawning():
	pass

func SetItemAmountLabel():
	label.text = str(amountToDispense) + " / " + str(maxAmountHeld)

func _on_Dispenser_area_entered(area):
	if(area.name == "Hand"):
		#print("Hand entered " + self.name)
		handInZone = true
	pass # Replace with function body.


func _on_Dispenser_area_exited(area):
	if(area.name == "Hand"):
		#print("Hand exited " + self.name) 
		handInZone = false
	pass # Replace with function body.

func _on_Dispenser_mouse_entered():
	handInZone = true
	System.emit_signal("HoveringOverInteractibleZone")

func _on_Dispenser_mouse_exited():
	handInZone = false
	System.emit_signal("StoppedHoveringOverInteractibleZone")