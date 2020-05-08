extends Node2D

var character = get_parent()
var friends = [] #characters this character is friends with 'near friends can cause sanity boost'
var neutral = [] #characters this character feels nothing about
var enemies = [] #characters this character hates
var relationships = {} #character 

#attributes like "forgiving means" they will remain neutral even if hates
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func AddNewRelationship(characterToAdd):
	relationships[characterToAdd] = 0

	pass

func AdjustRelationship(character, amount):
	if !relationships.has(character):
		#if this relationship doesn't already exist, add it
		AddNewRelationship(character)
	relationships[character] += amount

#func AdjustRelationship(character, amount):
#	character.relationship.currentValue += amount
