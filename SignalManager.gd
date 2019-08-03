extends Node


signal GenerateNewCharacter(characterParameters)
#for characters with random stats
signal generateRandomNewCharacter

signal EndEvent(parameters)

#for characters with specific stats
signal generateStattedNewCharacter(characterAttributes)
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

