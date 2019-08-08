extends Node


signal OnArrival(destinationType) #Planet/Derelict Ship/Asteroid/Stranded Vessel/BEacon Vessel/Space Station/DerelictSpaceStation

#have different lists of events that depend on this
signal HourPassed(hour)

signal DayPassed

signal DayEventGenerated(delayTime)


#perhaps with this signal, reset lists and allow a new event to pop up
signal NewDayStarted

signal OnJump


signal OnSleep

signal GenerateNewCharacter(characterParameters)

signal EventChoiceClicked(whichOptions)
#for characters with random stats
signal generateRandomNewCharacter

signal EndEvent(parameters)


signal DamageStation(parameters)
#for characters with specific stats
signal generateStattedNewCharacter(characterAttributes)
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

