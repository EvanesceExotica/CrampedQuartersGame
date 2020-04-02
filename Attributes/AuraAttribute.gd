extends "res://Attribute.gd"

var specificAttributesToApplyAuraTo = [] #if this has any members, it only applies to these specific auras
var attributesImmuneToAura = [] #if this has any members, it applies to all *except* these

func checkPotentialNearbyAuraReceivers():
  if(specificAttributesToApplyAuraTo.size() > 0):
    #if this only applies to specific attributes, which it will if the count is greater than zero
    for slot in characterAttachedTo.currentSlot.adjacentSlots
    #look for all the slots that are nearby the character giving off this aura
      if(slot.occupied):
        #if the slot has a person inside of it
        for(specificAttribute in specificAttributesToApplyAuraTo):
          #cycle through the attributes that we want to apply this aura attribute to
          if slot.characterInSlot.characterAttributes.has(specificAttribute):
          #^^ If the character contains this specific attribute
          #WE want to apply this overarching aura attribute to the character
            slot.characterInSlot.applyNewAttribute(self)
  if(attributesImmuneToAura.size() > 0):
    #If this applies to everyone except individuals who are immune due to certain attributes
    for slot in characterAttachedTo.currentSlot.adjacentSlots
      #for all the slots nearby
      if(slot.occupied):
        #if there's a character in the slot
        #TODO: Perhaps later attach this to an 'awareness' stat for how many slots away one is aware, but maybe too complex?
        for(immuneAttribute in attributesImmuneToAura):
          #for the attributes that are immune to this aura
          #if the character has an attribute that they're immune to
          if slot.characterInSlot.characterAttributes.has(immuneAttribute):
            #ignore these characters
              continue
          else:
            #for everyone else apply the aura
            slot.characterInSlot.applyNewAttribute(self)
    if(characterAttachedTo.currentSlot)
  pass
func applyAura():
  pass
