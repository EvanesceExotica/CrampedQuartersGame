extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

#humanoid
#mammalian
#reptilian
#avian
#arthopoid
#molluscoid
#fungoid
#plantoid
#machine

var allAttributes = []
var speciesAttributes
var availableCharacterAttributes

var maxNumberOfStartingAttributes = 5
#perhaps separate into attributes that can only apply to characters

func separateOutAttributes():
	for attribute in allAttributes:
		for applicableEntity in attribute.entitiesCanApplyTo:
			if(applicableEntity == System.entitiesAppliedTo.character):
				#if this attribute can apply to characters
				#append it to the availableCharacterAttributes
				availableCharacterAttributes.append(attribute)
		for attributeType in attribute.attributeTypes:
			#for the type of attribute this is
			if attributeType == System.attributeType.inherentAttribute:
				#make 'species' not an inherent attribute just to keep them separate for gen
				#if the attributeType is an inherentOne (like a personality trait)
				availableCharacterAttributes.append(attribute)
			if attributeType == System.attributeType.species:
				speciesAttributes.append(attribute)



func generateNewCharacter():

	#events the character goes through before being added to the ship can cause extra attribute
	#such as "injured" or "diseased"
	var character

	#randomize the number of starting attributes
	var numberOfStartingAttributes = rand_range(2, maxNumberOfStartingAttributes+1)


	var randomSpeciesNumber = rand_range(0, speciesAttributes.size())
	var species = generateSpecies(randomNumber)


	#this deletes any attributes in the availableList that would conflict
	#with the chosen species -- robot, aquatic, etc.
	for conflictingAttibute in species.conflictingAttibutes:
		availableCharacterAttributes.erase(conflictingAttibute)


	for i in range(numberOfStartingAttributes):
		attributes.append(generateNewAttribute())

	for attribute in availableCharacterAttributes:

func generateSpecies(randomNumber):
	var species = speciesAttributes[randomNumber]
	return species

func generateNewAttribute(species)
	var randomInherentAttributeNumber = rand_range(0, availableCharacterAttributes.size())
	for conflictingAttibute in species.conflictingAttibutes:
			if(availableCharacterAttributes[randomNumber]) == conflictingAttibute:

# Called when the node enters the scene tree for the first time.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
