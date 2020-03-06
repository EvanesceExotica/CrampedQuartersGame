extends Area2D

var handInZone = false
var dragging = false
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
enum ItemOptions{
	food,
	health
}
var dispensedItem

var maxAmountHeld = 3
var amountToDispense = 3

var initialRespawnWaitTime = 100
var respawnWaitTime = 100

var appliedAttributes = []

func removeDispensedItemFromDispenser(dispenser, character):
	if(dispenser == self):
		amountToDispense-= 1
	#	print("We have " + str(amountToDispense) + " left in " + self.name)
		if(amountToDispense <= 0):
			amountToDispense = 0
			respawnItem()


var dispensedItemValue = 50
#export(ItemOptions) var dispensedItem = ItemOptions.food
# Called when the node enters the scene tree for the first time.
func _ready():
	System.connect("dispensedItemConsumed", self, "removeDispensedItemFromDispenser")
	pass # Replace with function body.


func _process(delta):

	if(handInZone && Input.is_action_pressed("left_click")):
		if(!dragging):
			System.emit_signal("draggingItem", self)
			dragging = true

	if(dragging && Input.is_action_pressed("left_click")):
		pass
	else:
		if(dragging):
			dragging = false
			System.emit_signal("stoppedDraggingItem", self)


func respawnItem():
	var timer = Timer.new()
	timer.set_wait_time(respawnWaitTime)
	timer.connect("timeout", self, "onRespawnTimerTimeout")
	add_child(timer)
	timer.start()
	#this is for respawning item after certain amount of time is passed, can maybe manually work it to make new item appear?
	#make interactWith a "Station" thing, make this inherit from station. Add a "repair" too.
	pass

func onRespawnTimerTimeout():
	amountToDispense+= 1
	if(amountToDispense >= maxAmountHeld):
		amountToDispense = maxAmountHeld
	else:
		respawnItem()

func slowRespawnRate():
	respawnWaitTime = respawnWaitTime * 0.5;

func resetRespawnRate():
	respawnWaitTime = initialRespawnWaitTime

func haltRespawning():
	pass
	

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
