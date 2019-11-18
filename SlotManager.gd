extends Node2D

export var slotArrangement = [] #this is left to right

func _ready():
    if get_children().size() > 0:
        for slot in get_children():
            slotArrangement.append(slot)
    SignalManager.connect("emittingAura", self, "applyToAdjacentSlots")

func applyToAdjacentSlots(slot, attribute, howManyAdjacent):
    print("Applying aura!")
    #this is for auras

    var originSlotIndex = slotArrangement.find(slot)
    for i in range(1, howManyAdjacent):
        print("Index of slot is " + str(originSlotIndex) + " applying to slot " + str(originSlotIndex+1) + " and " + str(originSlotIndex-1))
        if originSlotIndex+i < slotArrangement.size():
            slotArrangement[originSlotIndex+i].applyNewAttributeToSlot(attribute)
        if originSlotIndex-i >= 0:
            slotArrangement[originSlotIndex-i].applyNewAttributeToSlot(attribute)

func spreadToAdjacentSlots(originSlot):
    pass

