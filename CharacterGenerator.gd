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
var slotStringToEnum = {}

var allAttributes = []
var availableAttributeNames = []
var attributesDictionary = []
var speciesAttributes
var availableCharacterAttributes = []
export var speciesOptions : Array = []

var maxNumberOfStartingAttributes = 3 #change this later
#perhaps separate into attributes that can only apply to characters

func separateOutAttributes():
	#allAttributes = AttributeJSONParser.attributeData.keys()
	attributesDictionary = AttributeJSONParser.attributeData
	for attribute in attributesDictionary:
		if attribute["inherentAttribute"] == true:
			availableAttributeNames.append(attribute["attributeName"])
			availableCharacterAttributes.append(attribute)
	# for attribute in attributesDictionary.keys():
	# 	var tempDictionary = attributesDictionary[attribute]
	# 	if tempDictionary["inherentAttribute"] == true:
	# 		#if this is a trait that can be randomly generated on a character, rather than a condition
	# 		availableAttributeNames.append(attribute)
	# 		availableCharacterAttributes.append(tempDictionary)
	#	print("Generating attributes " + tempDictionary["attributeName"])
		# if tempDictionary["entitiesCanApplyTo"].has("character") && tempDictionary["attributeTypes"].has("inherentAttribute"):
		# 	#this means this attribute applies to characters and is an attribute that arises naturally (rather than a condition)
		# 	availableAttributeNames.append(attribute)
		# 	availableCharacterAttributes.append(tempDictionary)
		#	print("Available attribute " + tempDictionary["attributeName"])
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
	slotStringToEnum = {
		"mainRoom" : System.slotTypes.mainRoom,
		"closet" : System.slotTypes.closet,
		"garden" : System.slotTypes.garden,
		"airLock" : System.slotTypes.airLock,
		"engine" : System.slotTypes.engine,
		"aquarium" : System.slotTypes.aquarium
	}
	SignalManager.connect("GenerateNewCharacter", self, "TestCharacterGen")
	#SignalManager.connect("GenerateNewCharacter", self, "generateNewCharacter")
func TestCharacterGen(parameters):
	print(parameters)
	if(parameters.size() == 0):
		print("Create random character")
		generateNewCharacter()
	else:
		print("Generate statted character")
	#print("Character generated")
	pass


func generatePremadeCharacter(attributeNames):
	var createdAttributes = []
	for name in attributeNames:
		createdAttributes.append(AttributeJSONParser.fetchAndCreateAttribute(name))

	var characterInstance = characterTemplate.instance()
	characterInstance.characterName = NameGenerator.generateName()
	add_child(characterInstance)

	for item in createdAttributes:
		characterInstance.applyNewAttribute(item)
		
	var slot = chooseCharacterSlot(null)#chooseRandomSlot()
	slot.addCharacterToSlot(characterInstance)
	CharacterTracker.AddCharacter(characterInstance)
	characterInstance.add_to_group("Characters")

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
	characterInstance.characterName = NameGenerator.generateName()
	add_child(characterInstance)

	for item in attributes:
		characterInstance.applyNewAttribute(item)


	var randomSpeciesNumber = rand_range(0, speciesOptions.size())
	var species = generateSpecies(randomSpeciesNumber)
	#var slot = chooseCharacterSlot(species)
	var slot = chooseCharacterSlot(null) #chooseRandomSlot() Can use random slot for AI Insanity effects maybe

	#TODO: Put this back in
	if slot != null:
		slot.addCharacterToSlot(characterInstance)
		CharacterTracker.AddCharacter(characterInstance)
		characterInstance.add_to_group("Characters")
	else:
		print("All slots occupied, couldn't add character")

func generateSpecies(randomNumber):
	var species = speciesOptions[randomNumber]
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
	var unoccupiedSlots = []
	for slot in System.allSlots.keys():
		if System.allSlots[slot] == null:
			#if there's no character in this slot, character being the value to the key
			unoccupiedSlots.append(slot)


	var randomKey
	if unoccupiedSlots.size() > 0:
		var randomNumber = randi()%unoccupiedSlots.size()
		#var randomNumber = range(0,unoccupiedSlots.size()))[randi()%range(0,System.allSlots.size()).size()]
		randomKey = unoccupiedSlots[randomNumber]
	else:
		randomKey = null
	
	return randomKey #System.allSlots[randomNumber]

func chooseCharacterSlot(species):
	pass
	#calculate species into this
	# var levelToSearchFor = 0
	# #var slotToChoose
	# var foundSlot = false
	# var rankingIndex = 0

	var slotRank = [
		System.slotTypes.mainRoom, 
		System.slotTypes.garden,
		System.slotTypes.garden,
		System.slotTypes.engine,
		System.slotTypes.aquarium,
		System.slotTypes.airLock
	]
	#maybe have a separate if statement to see if the thing breathes water or not
	var foundSlot
	for slotType in slotRank:
		#for each slotType ordered in preference of what we like
		var slotsOfThisType = System.SlotsByType[slotType]
		print(System.SlotsByType[slotType])
		#find the array of slots that matches this type
		for slot in slotsOfThisType:
			#look through this array of slots, find one that's unoccupied, and set it to 'found slot' to return later
			#also break out of the loop
			if !slot.occupied:
				print(str(slotType) + " type is unoccupied")
				foundSlot = slot
				print(foundSlot)
				break 
		if foundSlot != null:
			break
	return foundSlot
	

func _on_Button_button_down():
	#print("Generating new character")
	generatePremadeCharacter(["Paranoid", "Frail", "BigStomach"])
	#generateNewCharacter()

func printWarning():
	#This individual will be extremely uncomfortable in this slotType
	print("No safe slot types remain for this individual -- force into uncomfortable slot?")
#	for conflictingAttibute in species.conflictingAttibutes:
#			if(availableCharacterAttributes[randomNumber]) == conflictingAttibute:

# Called when the node enters the scene tree for the first time.
func _input(event):
	if event.is_action_pressed("ui_accept"):
		generatePremadeCharacter(["Paranoid", "Frail", "Strong"])

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
