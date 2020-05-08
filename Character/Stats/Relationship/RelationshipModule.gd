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

#TODO: being near a friend causes a sanity increase while being away causes a sanity drain
#add a 'mental break' state
func AddNewRelationship(characterToAdd):
	relationships[characterToAdd] = 0

	pass

	#

func AdjustRelationship(character, amount):
	if !relationships.has(character):
		#if this relationship doesn't already exist, add it
		AddNewRelationship(character)
	relationships[character] += amount
	if relationships[character] <= -20:
		#if relationship with this character is bad, add to enemies, who will give mood penalty if nearby
		enemies.append(character)
	if relationships[character] >= 20:
		#if the relationship with this character is good, add to friends, who will give mood bonus if nearby
		friends.append(character)

#func AdjustRelationship(character, amount):
#	character.relationship.currentValue += amount
