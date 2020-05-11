extends Node


signal SomeoneEnteredSlot(whichSlot, whichCharacter)
signal SomeoneVacatedSlot(whichSlot, whichCharacter)

signal DreamTimeStarted
signal DreamTimeEnded
signal DreamTimeSkipped

signal Overheating
signal Freezing

signal Paused

signal MovingToFuture
signal ArrivedAtBlackHole
signal WentBackThroughPortal

signal ViewInsideShip
signal ViewOutsideShip

signal CameraSwitched(camera) #for camera switches happening at the black hole station, until I put rooms there
signal OnRoomSwitched(oldRoom, newRoom)

signal AddTrait(parameters)
signal RemoveTrait(parameters)

signal GardenBolsteringStationDown(station, damageToGarden)
signal FoodHarvested(amount)
signal ChangeFoodProductionRate(amount)

signal SelectedLocationNode(node)

signal DeselectedLocationNode(node)

signal LocationNodesGenerated(locationNodes)

signal OnArrival(destinationType) #Planet/Derelict Ship/Asteroid/Stranded Vessel/BEacon Vessel/Space Station/DerelictSpaceStation
signal OnDeparture

#have different lists of events that depend on this
signal HourPassed(hour)

signal DayPassed

signal DayEventGenerated(delayTime)


#perhaps with this signal, reset lists and allow a new event to pop up
signal NewDayStarted

signal OnSpacetimeJumpDeparture

signal OnSpacetimeJumpArrival

signal OnSpacetimeEngineCooldown

signal OnSpacetimeEngineActive


signal OnSleep

signal GenerateNewCharacter(characterParameters)

signal emittingAura(currentSlot, attribute, howManyAdjacentSlotsAffected)
signal stoppedEmittingAura(currentSlot, attribute, howManyAdjacentSlotsAffected)

signal EventProgressed

signal EventChoiceClicked(whichOptions, affectedObjects)
#for characters with random stats
signal generateRandomNewCharacter

signal NewEventLaunched(parameters)

signal EndEvent(parameters)

signal UpdateEvent(parameters)

signal DamageStation(parameters)
#for characters with specific stats
signal generateStattedNewCharacter(characterAttributes)
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

