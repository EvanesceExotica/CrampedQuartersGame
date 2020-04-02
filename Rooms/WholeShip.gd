extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var tags = []
var hullPoints = 30 
var stations  = []
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func ChangeHullPoints(amount):
	hullPoints += amount

func checkAllTags(requirement):

	var meetsRequirements = true
	if requirement["requiredtraits"].size() > 0:
			#remove all that don't have the required traits
		meetsRequirements = checkIfHasRequiredTags(requirement["requiredtraits"])
	if requirement["excludedtraits"].size() > 0:
			#remove all that have the included traits
		meetsRequirements = checkIfHasExcludedTags(requirement["excludedtraits"])
	if requirement["requiredtraits"].size() == 0 && requirement["excludedtraits"].size() == 0:
			#remove none and go on to choose a random character
		print("This had no requirements, so just affect the ship")
	return meetsRequirements
	# if meetsRequirements == false:
	# 	return false



func checkIfHasRequiredTags(requiredTags):
	var hasAll = true
	for tag in requiredTags:
		if !tags.has(tag):
			hasAll = false
	return hasAll

func checkIfHasExcludedTags(requiredTags):
	var doesntHaveTag = true
	for tag in requiredTags:
		if tags.has(tag):
			doesntHaveTag = false
	return doesntHaveTag
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
