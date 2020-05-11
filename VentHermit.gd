extends Node2D

var playerCurrentRoom
var hoursUntilStealFoodMin = 3
var hoursUntilStealFoodMax = 5

var foodAmountStolenMin = 1
var foodAmountStolenMax = 2

func GenerateFoodStealing():
    #make sure there's food
   var random = randi () % hoursUntilStealFoodMax + hoursUntilStealFoodMin
   #make sure there's food avaliavble to steal

func _ready():
    SignalManager.connect("OnRoomSwitched", self, "SetPlayerNotInRoom")
    SignalManager.connect("HourPassed", self, "GenerateFoodStealing")
    pass

func SetPlayerNotInRoom(previousRoom, destinationRoom):
    if destinationRoom.name != "SupplyClosetRoom":

        #if this isn't the supply closet room
        pass
    pass
