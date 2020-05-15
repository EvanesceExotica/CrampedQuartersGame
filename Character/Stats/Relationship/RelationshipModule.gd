extends Node2D

var ourCharacter
var friends = [] #characters this character is friends with 'near friends can cause sanity boost'
var applyingAuras = {}
var neutral = [] #characters this character feels nothing about
var enemies = [] #characters this character hates
var relationships = {} #character 
var slotManager 
#attributes like "forgiving means" they will remain neutral even if hates
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	ourCharacter = get_parent()
#	slotManager = ourCharacter.currentSlot.get_parent()
	SignalManager.connect("SomeoneEnteredSlot", self, "determineIfFriendOrEnemyNearby")
	SignalManager.connect("SomeoneVacatedSlot", self, "determineAuraRemoval")

func findBestRelationship():
	#this is for finding the person (or random of multiple people) who this character has the best relationship with

	# for relationships whose values are over 1
	var positiveRelationships = [] 

	#for relationships whose values are the highest
	var bestRelationships = []

	for character in relationships.keys():
		#check all relationships
		if relationships[character] > 0:
			#if this is one or higher, so a neutral or good relationship
			positiveRelationships.append(character)

	var greatestRelationship = positiveRelationships[0] #get first one in list of positives as placeholder

	for character in positiveRelationships:
		#for each character you have a positive relationship with
		if relationships[character] > relationships[greatestRelationship]:
			#if your relationship with this character is greater than the one you first found
			greatestRelationship = character

			#add greatest relationship to the bestRelationships list in case there are multiple
	bestRelationships.append(greatestRelationship)
	for character in positiveRelationships:
		#look through all positive relationships again
		if relationships[character] == relationships[greatestRelationship]:
		#if there is the same relationship value as the greatest
			bestRelationships.append(character) #add it to the best relationships list

	#choose random if there are multiple best ones that have the same value (like all at 100 positive), or just grab the
	return ChooseRandom.ChooseRandomFromList(bestRelationships)


func findWorstRelationhip():
	#this is for finding the person (or random of multiple people) who this character has the worset relationship with

	# for relationships whose values are less than 1
	var negativeRelationships = [] 

	#for relationships whose values are the lowest
	var worstRelationships = []

	for character in relationships.keys():
		#check all relationships
		if relationships[character] > 0:
			#if this is negative one or lower, so a low neutral or bad relationship
			negativeRelationships.append(character)

	var worstRelationship = negativeRelationships[0] #get first one in list of positives as placeholder

	for character in negativeRelationships:
		#for each character you have a positive relationship with
		if relationships[character] < relationships[worstRelationship]:
			#if your relationship with this character is greater than the one you first found
			worstRelationship = character

			#add worswt relationship to the worstRelationships list in case there are multiple
		worstRelationships.append(worstRelationship)

	for character in negativeRelationships:
		#look through all negative relationships again
		if relationships[character] == relationships[worstRelationship]:
		#if there is the same relationship value as the greatest
			worstRelationships.append(character) #add it to the best relationships list

	#choose random if there are multiple best ones that have the same value (like all at 100 positive), or just grab the
	return ChooseRandom.ChooseRandomFromList(worstRelationships)

func determineAuraApplication(slot, character):
	if slot.slotManager == ourCharacter.currentSlot.slotManager:
		#if they were moved into the room we're in room
		if friends.has(character):
			#and this character is our friend
			var friendAttribute = AttributeJSONParser.fetchAndCreateAttribute("NearFriend")
			ourCharacter.applyNewAttribute(friendAttribute)
			applyingAuras[character] = friendAttribute #applyingAuras adds the friend and the attribute name
		elif enemies.has(character):
			var enemyAttribute = AttributeJSONParser.fetchAndCreateAttribute("NearEnemy")
			ourCharacter.applyNewAttribute(AttributeJSONParser.fetchAndCreateAttribute("NearEnemy"))
			applyingAuras[character] = enemyAttribute #applyingAuras adds the enemy character and the attribute name
	
func determineAuraRemoval(slot, character):
	if slot.slotManager == ourCharacter.currentSlot.slotManager: #slotManager:
		#if this /was/ OUR room that someone was moved from
		if applyingAuras.has(character):
			#if this character was in our room giving us an aura before moving, remove the aura from our character 
			ourCharacter.removeAtttribute(applyingAuras[character])
			#remove them from the dictionary that keeps track of that
			applyingAuras.erase(character)

#TODO: being near a friend causes a sanity increase while being away causes a sanity drain
#add a 'mental break' state


func AddNewRelationship(characterToAdd):
	relationships[characterToAdd] = 0


func AdjustRelationship(character, amount):
	if !relationships.has(character):
		#if this relationship doesn't already exist, add it
		AddNewRelationship(character)
	relationships[character] += amount

	#to keep it within a certain range (100 - -100)
	if relationships[character] > 100:
		relationships[character] == 100
	if relationships[character] < -100:
		relationships[character] = - 100

		#designating enemies and friends below
	if relationships[character] <= -20:
		#if relationship with this character is bad, add to enemies, who will give mood penalty if nearby
		enemies.append(character)
	if relationships[character] >= 20:
		#if the relationship with this character is good, add to friends, who will give mood bonus if nearby
		friends.append(character)

	if relationships[character] > -20 && enemies.has(character):
		#if this relationship is no longer below negative twenty, and they were an enemy
		enemies.erase(character)
		applyingAuras.erase(character) #remove them from applying an enemy aura

	if relationships[character] < 20 && friends.has(character):
		#if this relationship is no longer above twenty, and they were a friend
		friends.erase(character)
		applyingAuras.erase(character) #remove them from applying a friend aura
		

#func AdjustRelationship(character, amount):
#	character.relationship.currentValue += amount
