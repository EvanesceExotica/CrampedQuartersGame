extends Node2D

export var slotArrangement = [] #this is left to right

func _ready():
    if get_children().size() > 0:
        for slot in get_children():
            slotArrangement.append()
    SignalManager.connect("emittingAura", self, "applyToAdjacentSlots")

func applyToAdjacentSlots(slot, attribute, howManyAdjacent):
    print("Applying aura!")
    #this is for auras

    var originSlotIndex = slotArrangement.find(slot)
    for i in range howManyAdjacent:
        print(i)
        slotArrangement[originSlotIndex+i].applyNewAttributeToSlot(attribute)
        slotArrangement[originSlotIndex-i].applyNewAttributeToSlot(attribute)

func spreadToAdjacentSlots(originSlot):
    pass

