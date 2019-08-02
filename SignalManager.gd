extends Node


signal GenerateNewCharacter#(character)
#for characters with random stats
signal generateRandomNewCharacter

#for characters with specific stats
signal generateStattedNewCharacter(characterAttributes)
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

