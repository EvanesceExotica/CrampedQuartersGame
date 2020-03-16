extends Node2D

export var slotArrangement = [] #this is left to right

func _ready():
	randomize()
	set_process_input(true)
	slotArrangement = get_children()
	# for item in get_children():
	#     if item is Slot:

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

func getRandomFromAdjacent():
	pass

func killAllInSlots():
	for slot in slotArrangement:
		if slot.occupied:
			if slot.characterInSlot.has_method("Die"):
				slot.characterInSlot.Die(5, false)
			elif slot.characterInSlot.has_method("Destroy"):
				slot.characterInSlot.Destroy()

func _input(event):
	if(Input.is_action_just_pressed("ui_fire")):
		StartAFire()
	# if event.is_action_pressed("ui_fire") && !event.is_echo():
	# 	print("This fired many times ")

func StartAFire():
	print("Setting fire to " + str(slotArrangement[0]))
	slotArrangement[0].applyNewAttributeToSlot(AttributeJSONParser.fetchAndCreateAttribute("OnFire"))
