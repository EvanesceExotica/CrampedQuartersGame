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
var availableAttributeNames = []
var attributesDictionary = {}
var speciesAttributes
var availableCharacterAttributes = []

var maxNumberOfStartingAttributes = 3 #change this later
#perhaps separate into attributes that can only apply to characters

func separateOutAttributes():
	allAttributes = AttributeJSONParser.attributeData.keys()
	attributesDictionary = AttributeJSONParser.attributeData
	for attribute in attributesDictionary.keys():
		var tempDictionary = attributesDictionary[attribute]
		print("Generating attributes " + tempDictionary["attributeName"])
		if tempDictionary["entitiesCanApplyTo"].has("character") && tempDictionary["attributeTypes"].has("inherentAttribute"):
			availableAttributeNames.append(attribute)
			availableCharacterAttributes.append(tempDictionary)
			print("Available attribute " + tempDictionary["attributeName"])
	# 	for applicableEntity in attribute["entitiesCanApplyTo"]:
	# 		if(applicableEntity == System.entitiesAppliedTo.character):
	# 			availableCharacterAttributes.append(attribute):
	# 	for attributeType in attribute["attributeTypes"]:
	# 		if attributeType == System.attributeType.inherentAttribute:
	# 			availableCharacterAttributes.append(attribute)
	#
	# for attribute in allAttributes:
	# 	for applicableEntity in attribute.entitiesCanApplyTo:
	#
	# 		if(applicableEntity == System.entitiesAppliedTo.character):
	# 			#if this attribute can apply to characters
	# 			#append it to the availableCharacterAttributes
	# 			availableCharacterAttributes.append(attribute)
	# 	for attributeType in attribute.attributeTypes:
	# 		#for the type of attribute this is
	# 		if attributeType == System.attributeType.inherentAttribute:
	# 			#make 'species' not an inherent attribute just to keep them separate for gen
	# 			#if the attributeType is an inherentOne (like a personality trait)
	# 			availableCharacterAttributes.append(attribute)
	# 		if attributeType == System.attributeType.species:
	# 			speciesAttributes.append(attribute)


func _ready():
	separateOutAttributes()
	randomize()

func generateNewCharacter():

	#events the character goes through before being added to the ship can cause extra attribute
	#such as "injured" or "diseased"

	var potentialCharacterAttributes = [] + availableCharacterAttributes
	var potentialCharacterAttributeNames = [] + availableAttributeNames
	#randomize the number of starting attributes
	#var numberOfStartingAttributes = rand_range(2, maxNumberOfStartingAttributes+1)
	var numberOfStartingAttributes = range(2,maxNumberOfStartingAttributes + 1)[randi()%range(2,maxNumberOfStartingAttributes+1).size()]
	var attributes = []
#TODO: PUT THIS BACK IN generate a random species from the spcies list
# #TODO: Put this back in
# 	var randomSpeciesNumber = rand_range(0, speciesAttributes.size())
# 	var species = generateSpecies(randomSpeciesNumber)
#
# 	#
# 	# #this deletes any attributes in the availableList that would conflict
# 	# #with the chosen species -- robot, aquatic, etc.
# 	# for conflictingAttibute in species.conflictingAttibutes:
# 	# 	if availableCharacterAttributes.has(conflictingAttibute):
# 	# 		availableCharacterAttributes.erase(conflictingAttibute)

# for conflictingAttibute in species.conflictingAttibutes:
# 		if availableCharacterAttributes.has(conflictingAttibute):
# 			availableCharacterAttributes.erase(conflictingAttibute)

	for i in range(numberOfStartingAttributes):
		#generate new attributes from the cleaned list,
		#up to the random generated number of starting attributes they can have
		attributes.append(AttributeJSONParser.fetchAndCreateAttribute(generateNewAttribute(potentialCharacterAttributes, potentialCharacterAttributeNames)))
		#attributes.append(generateNewAttribute())

	var characterInstance = characterTemplate.instance()
	add_child(characterInstance)

	for item in attributes:
		characterInstance.applyNewAttribute(item)
	var slot = chooseRandomSlot()
	slot.addCharacterToSlot(characterInstance)

func generateSpecies(randomNumber):
	var species = speciesAttributes[randomNumber]
	return species

func generateNewAttribute(generalList, nameList):

	#generate a random number
	#var randomInherentAttributeNumber = #rand_range(0, availableCharacterAttributes.size())
	var randomInherentAttributeNumber = range(0,generalList.size())[randi()%range(0,generalList.size()).size()]
	#grab a random attribute using this index from the possible ones
	var newAttribute = generalList[randomInherentAttributeNumber]
	var newAttributeName = nameList[randomInherentAttributeNumber]
	for possibleConflict in newAttribute["ConflictingAttributes"]:
		#remove attributes that conflict from the total list
			if nameList.has(possibleConflict):
				#if this conflict exists, remove from both lists
				#"Find" finds the index of the conflict
				var removeableIndex = nameList.find(possibleConflict)
				#remove removes the object at a specific index
				nameList.remove(removeableIndex)
				generalList.remove(removeableIndex)

	#removing from the list so no duplicates -- erase just erases a specific object in list
	nameList.erase(newAttributeName)
	generalList.erase(newAttribute)
	return newAttributeName

func chooseRandomSlot():
	#for testing until I get the species working
	var randomNumber = range(0,System.allSlots.size())[randi()%range(0,System.allSlots.size()).size()]
	var randomKey = System.allSlots.keys()[randomNumber]

	return randomKey #System.allSlots[randomNumber]

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

func _on_Button_button_down():
	print("Generating new character")
	generateNewCharacter()

func printWarning():
	#This individual will be extremely uncomfortable in this slotType
	print("No safe slot types remain for this individual -- force into uncomfortable slot?")
#	for conflictingAttibute in species.conflictingAttibutes:
#			if(availableCharacterAttributes[randomNumber]) == conflictingAttibute:

# Called when the node enters the scene tree for the first time.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
