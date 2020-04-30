extends Node2D

#this dictionary will contain the sprites for the different types of death
#maybe play a different animation too
var potentialDeathSources = {

}

var corpseDictionary = {

}
var corpse = preload("res://Character/Corpse/Corpse.tscn")

#right after death, the corpse will apply the 'shaken' effect, which drains sanity. After that, it will apply the 'diseased' affect if not gotten rid of.
var applyAura
enum deathType{
	none,
	bloodless,
	bloody,
	burning,
	freezing,
	airLock,
}

func addPotentialDeathSource(drainSource, newDrainPerSecond):
	#add a drain source and its value to the dictionary, for determining which drain killed the character (highest drain wins out, or random if multiple highest)
	potentialDeathSources[drainSource] = newDrainPerSecond

func removePotentialDeathSource(drainSource):
	#removes a drain source and its value from the dictionary, as no longer needed for determining which drain killed the character 
	potentialDeathSources.erase(drainSource)
	pass

func determineCauseOfDeath():
	#maybe in 'character' store source and amount
	#this is for if there were multiple health drain sources at the time the character died. We'll take the one with the biggest value. If multiple with same value, choose random 
	var highestDrainSource = potentialDeathSources.keys()[0]
	for source in potentialDeathSources:
		if source == highestDrainSource:
			#if the source is the self, skip it
			continue
		if potentialDeathSources[source] > potentialDeathSources[highestDrainSource]:
			#if this source's value is higher, set the higher one to the new highest drain source
			highestDrainSource = source
		if potentialDeathSources[source] == potentialDeathSources[highestDrainSource]:
			#if they're equal, maybe choose a random one?
			var randomList = []
			randomList.append(source)
			randomList.append(highestDrainSource)
			highestDrainSource = ChooseRandom.ChooseRandomFromList(randomList)
	#TODO: Once you have sprites for different deaths, PUT THIS BAKC IN
	#return highestDrainSource
	return highestDrainSource.deathType


func handleDeath(character, source, deathCausedByDrain):
	#instance the corpse, and add it to the tree, then delete the character
	#TODO: Find some way to determine the death type from attribute? Maybe add that too the actual attribute
	#TODO: find way to get deathType from non-attributes
	#var typeOfDeath = source.deathType
	var typeOfDeath = deathType.bloodless 
	#TODO: 
	if source == 5:
		typeOfDeath = deathType.airLock
		print("Sucked out airlock")

	if(deathCausedByDrain):
		#if caused by drain instead of an event or a straight hit 
		typeOfDeath = determineCauseOfDeath()

	if typeOfDeath != deathType.airLock:
		#spacing does not leave a corpse behind
		var newCorpse = corpse.instance()
		character.get_parent().add_child(newCorpse)
		#newCorpse.position = character.position
		character.currentSlot.removeCharacterFromSlot(character)
		character.currentSlot.addCharacterToSlot(newCorpse)
		#character.previousSlot.addCharacterToSlot(newCorpse)
		#TODO: Set sprite to whatever texture matches the death type
		#newCorpse.SetSprite(null)

	#handle the character being removed from slot so typical auras are turned off
	removeCharacter(character)


func removeCharacter(character):
	#this literally just deletes the character
	#maybe put something somewhere where the death type is tracked
	character.remove_from_group("Characters")
	character.queue_free()

func disembarkCharacter(character):
	character.remove_from_group("Characters")
	character.queue_free()

func determineCorpseType(typeOfDeath):
	#not implementing this now, but later
	#corpseSprite.texture = corpseDictionary[typeOfDeath]
	#
	pass

