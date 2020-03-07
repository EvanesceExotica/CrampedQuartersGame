extends "res://Stations/Dispenser/Dispenser.gd"
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	dispensedItem = ItemOptions.food
	dispensedItemValue = 100
	SignalManager.connect("FoodHarvested", self, "CalculateFoodValue")
	pass # Replace with function body.

func CalculateFoodValue(amount):
	dispensedItemValue = amount
	pass
func ReduceFoodValue(amount):
	pass
	#Have it calculate from the health of the plants when the item is produced 
	#that might end up inconsistent though
	#or not if healing plants up takes a while
	#but if it's producing the food from the plants over time... 
	#maybe there should be a 'harvest' time, and a production time? 

func slowProduction():
	pass

func contaminate(attributes):
	
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
