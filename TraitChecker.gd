extends Node2D

var traits = []

func _ready():
    get_parent().connect("newAttributeAdded", self, "addAndConvert")
    get_parent().connect("attributeRemoved", self, "remove")

func addAndConvert(attribute):
    traits.append(attribute.attributeName)
    print("Trait checker added " + attribute.attributeName)

func remove(attribute):
    traits.remove(attribute.attributeName)


func checkAllTags(requirement):

	var meetsRequirements = true

	var anyTraits = requirement["anyOfTheseTraits"]
	var requiredTraits = requirement["requiredTraits"]
	var excludedTraits = requirement["excludedTraits"] 
	#should we have an 'any traits' list as well?
	if requiredTraits.size() == 0 && excludedTraits.size() == 0 && anyTraits.size() == 0:
			#remove none and go on to choose a random character
		print("This had no requirements, so just affect this object")
		return meetsRequirements

	if anyTraits.size() > 0:
		meetsRequirements = checkIfHasAnyTags(anyTraits)
	if requiredTraits.size() > 0:
			#remove all that don't have the required traits
		meetsRequirements = checkIfHasRequiredTags(requiredTraits)
	if excludedTraits.size() > 0:
			#remove all that have the included traits
		meetsRequirements = checkIfHasExcludedTags(excludedTraits)

	return meetsRequirements


func checkIfHasAnyTags(anyTraits):
	var hasAny = false
	for trait in anyTraits:
		if traits.has(trait):
			hasAny = true
	return hasAny

func checkIfHasRequiredTags(requiredTraits):
	var hasAll = true
	for trait in requiredTraits:
		if !traits.has(trait):
			hasAll = false
	return hasAll

func checkIfHasExcludedTags(excludedTraits):
	var hasNone = true
	for trait in excludedTraits:
		if traits.has(trait):
			hasNone = false
	return hasNone