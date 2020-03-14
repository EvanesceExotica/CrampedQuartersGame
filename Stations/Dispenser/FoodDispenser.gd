extends "res://Stations/Dispenser/Dispenser.gd"
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var foodValues = [100]

#this will apply attributes to the charcter when they eat the food. For when the garden is contaminated, or perhaps super-charged.
var givenAttributes = []
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

func intervalReached(interval):
	pass

func contaminate(attributes):
	#might be a list?
	givenAttributes.append(attributes)	
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
