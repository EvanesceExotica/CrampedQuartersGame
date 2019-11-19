extends Node2D

export var slotArrangement = [] #this is left to right

func _ready():
    if get_children().size() > 0:
        for slot in get_children():
            slotArrangement.append(slot)
    SignalManager.connect("emittingAura", self, "applyToAdjacentSlots")
    SignalManager.connect("stoppedEmittingAura", self, "apply")

func removeAuraFromAdjacentSlots(slot, attribute, howManyAdjacent):
    var originSlotIndex = slotArrangement.find(slot)
    for i in range(1, howManyAdjacent):
        if originSlotIndex+i < slotArrangement.size():
            slotArrangement[originSlotIndex+i].removeAttributeFromSlot(attribute)
        if originSlotIndex-i >= 0:
            slotArrangement[originSlotIndex-i].removeAttributeFromSlot(attribute)


func applyToAdjacentSlots(slot, attribute, howManyAdjacent):
    #this is for auras

    var originSlotIndex = slotArrangement.find(slot)
    for i in range(1, howManyAdjacent):
        if originSlotIndex+i < slotArrangement.size():
            slotArrangement[originSlotIndex+i].applyNewAttributeToSlot(attribute)
        if originSlotIndex-i >= 0:
            slotArrangement[originSlotIndex-i].applyNewAttributeToSlot(attribute)

func spreadToAdjacentSlots(originSlot):
    pass

