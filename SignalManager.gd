extends Node

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

