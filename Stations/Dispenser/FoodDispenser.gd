extends "res://Stations/Dispenser/Dispenser.gd"
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var foodValues = [100]
# Called when the node enters the scene tree for the first time.
func _ready():
	._ready()
	dispensedItem = ItemOptions.food
	dispensedItemValue = 100
	SignalManager.connect("FoodHarvested", self, "CalculateFoodValue")
	pass # Replace with function body.

func CalculateFoodValue(gardenHealth):
	#this sets the value of the dispensed item to the health of the garden food
	if hasRoom():
		foodValues.append(gardenHealth)
		print("Garden health is " + str(gardenHealth) + " so food value is the same")
		#dispensedItemValue = gardenHealth
		startProducingFood()

func startProducingFood():
	print("Harvest complete. Food being produced")
	$Timer.set_wait_time(TimeConverter.GameHoursToSeconds(1))
	#$Timer.connect("timeout", self, "onProcutionTimerTimeout")
	$Timer.connect("timeout", self, "onRespawnTimerTimeout")

	$Timer.start()
	pass

func hasRoom():
	if amountToDispense < maxAmountHeld: 
		#if there's still room in the dispenser for new food to be producted
		return true
	else:
		return false

# func onProductionTimerTimeout():
# 	amountToDispense+=1
# 	if(amountToDispense >= maxAmountHeld):
# 		amountToDispense = maxAmountHeld

func storeHarvest():
	#for storing food to make later?
	#not sure if this is necessary, or if the harvest should be ignored
	pass

func ReduceFoodValue(amount):
	pass
	#Have it calculate from the health of the plants when the item is produced 
	#that might end up inconsistent though
	#or not if healing plants up takes a while
	#but if it's producing the food from the plants over time... 
	#maybe there should be a 'harvest' time, and a production time? 

func intervalReached(interval):
	pass

func slowProduction():
	pass

func contaminate(attributes):
	
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
