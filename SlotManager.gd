extends Node2D

export var slotArrangement = [] #this is left to right

func _ready():
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

func spreadToAdjacentSlots(originSlot):
    pass

