
onready var character = get_node("Character")

func attackOtherCharacter(otherCharacter):
  #to scale to character values
  var amount = character.damageDealt * 25
  otherCharacter.changeStatValue(System.DynamicStats.health, amount, false)
  pass

func damageStation(station):
  #amount in this case would be 'damage dealt from the character'
  var amount = character.damageDealt
  station.changeHealthAmount(amount)
  pass

func stealFromDispenser(dispenser):
  #character goes nuts and steals food or hp
  dispenser.removeDispensedItemFromDispenser(dispenser, character)
  pass

func communicateWithOtherCharacter(otherCharacter):
  #perhaps have a little side-bar of info on the side showing conversations
  pass
