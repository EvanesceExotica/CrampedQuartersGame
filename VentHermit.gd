extends Node2D

onready var character = get_parent()
var playerCurrentRoomName
var hoursUntilStealFoodMin = 3
var hoursUntilStealFoodMax = 5

var foodAmountStolenMin = 1
var foodAmountStolenMax = 2
var fleeChance = 0.15
var ventPosition = Vector2(-684.579, -486.226)#get_owner().get_node("VentPosition")

func GenerateFoodStealing():
	#make sure there's food
	var random = randi () % hoursUntilStealFoodMax + hoursUntilStealFoodMin
	#choose a random value of hours to grab food, and generate food stealing
	print("Waiting for " + str(random) + " hours")
	$Timer.set_wait_time(random)
	$Timer.start()
	yield($Timer, "timeout")

	print("Player current room is " + playerCurrentRoomName)
	if playerCurrentRoomName == "SupplyClosetRoom":
		#if the player is in this room, wait until they leave
		#need to also handle there being food
		yield(self, "PlayerNotLooking")
		StealFood()
	else:
		StealFood()
	GenerateFoodStealing()
   #make sure there's food avaliavble to steal
signal PlayerNotLooking

func _ready():

	SignalManager.connect("OnRoomSwitched", self, "SetPlayerNotInRoom")
	#SignalManager.connect("HourPassed", self, "GenerateFoodStealing")
	SignalManager.connect("Overheating", self, "Die")
	SignalManager.connect("Freezing", self, "Die")
	SignalManager.connect("OnArrival", self, "DecideToFlee")
	#this method removes the character from slot and group
	character.deathHandler.disembarkCharacter(character)
	character.global_position = ventPosition
	playerCurrentRoomName == "PassengerRoom"
	GenerateFoodStealing()
	pass

func SetPlayerNotInRoom(previousRoom, destinationRoom):
	#set the current room that the player is in to the 'destination room' on the roomSwitched signal
	playerCurrentRoomName == destinationRoom.name
	if destinationRoom.name != "SupplyClosetRoom":
		emit_signal("PlayerNotLooking")
		#if the AI's view isn't the supply closet room
		pass
	#pass

func Die():
	#being in the vents when the ship overheats or freezes will kill a vent hermit
	print("I was in the vents and it got too hot/cold! OUCH")
	character.Die(0, false)

func StealFood():
	print("STEALING FOOD!!!!")
	#character.processD
	SignalManager.emit_signal("FoodStolen")

func DecideToFlee():
	var random = randf()
	if random <= fleeChance:
		Flee()

func Flee():
	#add some qualifier here where it has to be a terrestrial place
	print(character.characterName + " has left the building!")
	character.queue_free()
	pass
