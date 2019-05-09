extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var characterTemplate = preload("res://Character.tscn")
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
	var characterInstance = characterTemplate.instance()
	add_child(instance)

	#randomize the number of starting attributes
	var numberOfStartingAttributes = rand_range(3, maxNumberOfStartingAttributes+1)

#generate a random species from the spcies list
	var randomSpeciesNumber = rand_range(0, speciesAttributes.size())
	var species = generateSpecies(randomSpeciesNumber)


	#this deletes any attributes in the availableList that would conflict
	#with the chosen species -- robot, aquatic, etc.
	for conflictingAttibute in species.conflictingAttibutes:
		if availableCharacterAttributes.has(conflictingAttibute):
			availableCharacterAttributes.erase(conflictingAttibute)

	for i in range(numberOfStartingAttributes):
		#generate new attributes from the cleaned list,
		#up to the random generated number of starting attributes they can have
		attributes.append(generateNewAttribute())
	character

func generateSpecies(randomNumber):
	var species = speciesAttributes[randomNumber]
	return species

func generateNewAttribute():

	#generate a random number
	var randomInherentAttributeNumber = rand_range(0, availableCharacterAttributes.size())

	#grab a random attribute using this index from the possible ones
	var newAttribute = availableCharacterAttributes[randomInherentAttributeNumber]

	for possibleConflict in newAttribute.conflictingAttibutes:
		#remove attributes that conflict from the total list
			if availableCharacterAttributes.has(possibleConflict)
				availableCharacterAttributes.erase(possibleConflict)

	return newAttribute

func chooseCharacterSlot(species):
	#calculate species into this
	var levelToSearchFor = 0
	#var slotToChoose
	var foundSlot = false
	var rankingIndex = 0

	var unoccupiedSlots = []
	for slot in System.allSlots.keys():
		#run through all the slots in the game
		if System.allSlots[slot] == null:
			#if the slot is unoccupied
			unoccupiedSlots.append(slot)
	for slot in unoccupiedSlots:
		#run through all the unoccupied slots in the game
		if species.slotTypeComfortRanking[rankingIndex].has(slot.slotType):
			foundSlot = true
		else:
			rankingIndex+=1
		# 	#if the species's slot ranking for this type of slot has a type
		# 	for slotType in species.slotTypeComfortRanking[rankingIndex]:
		# 		#for each slot type in this ranking
		# 		if(slot.slotType == slotType && slot.occupied == false):
		# 			#if it meets the slot type of the slot
		# 			foundSlot = true
		# 			break
		# 	if !foundSlot:
		#
		# if slot.prioritySeatingLevel == levelToSearchFor:
		# 	#might be better to separate into lists based on level
		# 	if slot.occupied == false:
		# 		slotToChoose = false


func printWarning():
	#This individual will be extremely uncomfortable in this slotType
	print("No safe slot types remain for this individual -- force into uncomfortable slot?")
#	for conflictingAttibute in species.conflictingAttibutes:
#			if(availableCharacterAttributes[randomNumber]) == conflictingAttibute:

# Called when the node enters the scene tree for the first time.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
