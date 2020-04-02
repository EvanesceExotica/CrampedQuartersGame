
onready var character = get_node("Character")

func attackOtherCharacter(otherCharacter):
  #to scale to character values
  var amount = character.damageDealt * 25
  otherCharacter.changeStatValue(System.DynamicStats.health, amount, false)
  pass

func compareSpecies(otherCharacter):
  var sameSpecies = true
  var ourSpecies
  var theirSpecies
  for attribute in otherCharacter.characterAttributes:
    #for all of the attributes they have
    if(attribute.attributeType == System.attributeType.species):
      #if one of them is their species, set theirspecis to this attribute.
      var theirSpecies = attribute
  for attribute in character.characterAttributes:
    #for all the attributes wew have
    if attribute.attributeType = System.attributeType.species):
      #if one of them is sour species, set ourSpecies to this attribute
      var ourSpecies = attribute

  if(ourSpecies != null && theirSpecies != null):
    #if both of us have a species and they've been set to these vars

    if ourSpecies.attributeName != theirSpecies.attributeName
    #if the spcies aren't equal, we're not the same species
      sameSpecies = false
  return sameSpecies

func damageStation(station):
  #amount in this case would be 'damage dealt from the character'
  var amount = character.damageDealt
  station.changeHealthAmount(amount)
  pass
func repairStation(station):
  var amount = 1 #change this later
  station.changeHealthAmount(amount)

func stealFromDispenser(dispenser):
  #character goes nuts and steals food or hp
  dispenser.removeDispensedItemFromDispenser(dispenser, character)
  pass

func communicateWithOtherCharacter(otherCharacter):
  
  #maybe have a simple 2, 1, 0, -1, -2 for relationships?
  #perhaps have a little side-bar of info on the side showing conversations
  pass
