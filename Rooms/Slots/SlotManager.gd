extends Node2D

var slotArrangement = [] #this is left to right #oooooh this is another case of the export var issue being shared between instances
onready var room = get_parent()

func _ready():
	randomize()
	set_process_input(true)
	var slotChildrenNames = " "
	for item in get_children():
		slotChildrenNames += item.name + " , "
		if item.get_class() == "Slot":
			slotArrangement.append(item)
	#print(room.name + " slot manager has these children " + slotChildrenNames)





	# if get_children().size() > 0:

	#     for slot in get_children():
	#         slotArrangement.append(slot)
	SignalManager.connect("emittingAura", self, "applyToAdjacentSlots")
	SignalManager.connect("stoppedEmittingAura", self, "removeAuraFromAdjacentSlots")
	print("In  " + get_parent().name + " we have this many slots: " + str(slotArrangement.size()))

func removeAuraFromAdjacentSlots(slot, attribute, howManyAdjacent):
	print(attribute.attributeName + " should be being removed from this slot " + str(slot.name))
	if slotArrangement.has(slot):
		var originSlotIndex = slotArrangement.find(slot)
		for i in range(1, howManyAdjacent):
			if originSlotIndex+i < slotArrangement.size():
				slotArrangement[originSlotIndex+i].removeAttributeFromSlot(attribute)
			if originSlotIndex-i >= 0:
				slotArrangement[originSlotIndex-i].removeAttributeFromSlot(attribute)


func applyToAdjacentSlots(slot, attribute, howManyAdjacent):
	#this is for auras
	if slotArrangement.has(slot):
		var originSlotIndex = slotArrangement.find(slot)
		for i in range(1, howManyAdjacent):
			if originSlotIndex+i < slotArrangement.size():
				slotArrangement[originSlotIndex+i].applyNewAttributeToSlot(attribute)
			if originSlotIndex-i >= 0:
				slotArrangement[originSlotIndex-i].applyNewAttributeToSlot(attribute)

func spreadToAdjacentSlots(originSlot, attribute):
	if slotArrangement.size() <= 1:
		#only one slot in this room, can't spread
		return
	var originSlotIndex = slotArrangement.find(originSlot)
	var list = [-1, 1]
	var choice = list[randi()%list.size()]
	#var choice = ChooseRandom.ChooseRandomFromList([-1, 1])
	if originSlotIndex+choice >= slotArrangement.size() || originSlotIndex+choice < 0:
		#should be greater than or equal than size, or less than zero. 0 is an index. the size isn't.
		#if it goes out of bounds, flip the value to go the other way
		choice = (-1) * choice
	# if originSlotIndex+1 < slotArrangement.size():
	# 	#to make ssure this doesn't go over the ending index of the slotArray
	# 	slotArrangement[originSlotIndex+1].applyNewAttributeToSlot(attribute)
	# 	#apply spread to slot to right of this one
	# if originSlotIndex-1 >= 0:
	# 	#to make sure this doesn't go before the beginning index of the slotArray
	# 	slotArrangement[originSlotIndex-1].applyNewAttributeToSlot(attribute)
	# 	#apply spread to slot to left of this one
	var index = originSlotIndex + choice
	slotArrangement[originSlotIndex + choice].applyNewAttributeToSlot(attribute)

func getRandomCharacterFromAdjacent(originSlot, attribute):
	if slotArrangement.size() <= 1:
		#only one slot in this room, can't spread
		return
	var originSlotIndex = slotArrangement.find(originSlot)
	var list = [-1, 1]
	var choice = list[randi()%list.size()]
	if originSlotIndex+choice >= slotArrangement.size() || originSlotIndex+choice < 0:
		#should be greater than or equal than size, or less than zero. 0 is an index. the size isn't.
		#if it goes out of bounds, flip the value to go the other way
		choice = (-1) * choice
	var index = originSlotIndex + choice
	#slotArrangement[originSlotIndex + choice].
	pass

func SpreadToCharacterInAdjacentSlot(slot, attribute, howManyAdjacent):

	#set an empty array to put the characters found
	var nearbyCharacters = []
	if slotArrangement.has(slot):
		#if this slot exists in the arrangement
		var originSlotIndex = slotArrangement.find(slot)
		for i in range(1, howManyAdjacent+1):
			print("this searches " + str(i) + " times")
			if originSlotIndex+i < slotArrangement.size():
				#if it's not going over the range of the slots
				var index = originSlotIndex+i
				print("Checking slot at index" + str(index))
				if slotArrangement[index].occupied:
					#if this particular slot is occupied
					#TODO:make sure it's not a corpse -- or maybe corpses can spread disease?
					#add the character to the list
					nearbyCharacters.append(slotArrangement[index].characterInSlot)

			if originSlotIndex-i >= 0:
				var index = originSlotIndex-i
				print(str("Checking slot at index" + str(index)))
				if slotArrangement[index].occupied:
				#	print("Checking slot " + slotArrangement[index].name)
					nearbyCharacters.append(slotArrangement[index].characterInSlot)
				#slotArrangement[originSlotIndex-i].applyNewAttributeToSlot(attribute)
	for character in nearbyCharacters:
		#if the character already has the disease
		if character.characterAttributes.has(attribute):
			print(character.characterName + " is already " + attribute.attributeName)
			#if every nearby character has this attribute already
			nearbyCharacters.erase(character)
	if nearbyCharacters.size() > 0:
		var randomIndex = randi()%nearbyCharacters.size()
		nearbyCharacters[randomIndex].applyNewAttribute(attribute)
	#return nearbyCharacters[randomIndex]

func returnNearbyCharacters():
	var nearbyCharacters = []
	for slot in slotArrangement:
		if slot.occupied:
			nearbyCharacters.append(slot.characterInSlot)
	return nearbyCharacters


func returnAdjacentSlots(startSlot):
	var adjacentSlots = []
	var originSlotIndex = slotArrangement.find(startSlot)
	if originSlotIndex+1 < slotArrangement.size():
		adjacentSlots.append(slotArrangement[originSlotIndex+1])
	if originSlotIndex-1 < slotArrangement.size():
		adjacentSlots.append(slotArrangement[originSlotIndex-1])
	return adjacentSlots

func returnClosestEmptySlot(startSlot):
	#find the slot you're trying to search from
	var originSlotIndex = slotArrangement.find(startSlot)

	#look through all of the slots in this room
	for i in range(slotArrangement.size() - 1):
		#if (searching forward) it isn't going over the range of the slots in this room
		if originSlotIndex+i < slotArrangement.size():
			#check if the slot is empty
			if checkIfEmpty(slotArrangement[originSlotIndex+i]) == true:
				#if it is, this is what we're looking for, return
				return slotArrangement[originSlotIndex+i]
		#if (searching backward) it isn't going over the range of the slots in this room
		if originSlotIndex-i >= 0:
			#check if the slot is empty
			if checkIfEmpty(slotArrangement[originSlotIndex-i]) == true:
				#if it is, this is what we're looking for, return
				return slotArrangement[originSlotIndex-i]
	#if none could be found in this room, return null
	return null


func checkIfEmpty(slot):
	if !slot.occupied:
		return true
	else:
		return false

func returnEmptySlots():
	var emptySlots = []
	for slot in slotArrangement:
		if !slot.occupied:
			emptySlots.append(slot)
	return emptySlots

func killAllInSlots():
	for slot in slotArrangement:
		if slot.occupied:
			if slot.characterInSlot.has_method("Die"):
				# a living character
				slot.characterInSlot.Die(5, false)
			elif slot.characterInSlot.has_method("Destroy"):
				#a corpse
				slot.characterInSlot.Destroy()

func _input(event):
	if(Input.is_action_just_pressed("ui_fire")):
		StartAFire()
	# if event.is_action_pressed("ui_fire") && !event.is_echo():
	# 	print("This fired many times ")

func StartAFire():
	print("Setting fire to " + str(slotArrangement[0]))
	slotArrangement[0].applyNewAttributeToSlot(AttributeJSONParser.fetchAndCreateAttribute("OnFire"))
