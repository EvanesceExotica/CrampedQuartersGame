extends Node2D

var insanityEvents = WeightedObject.new()
onready var character = get_parent() #this will be a child of the character

#mashochistic -- harm self -- refuse healing/food
#cruel  - harm other 
#paranoid - refuse healing/food. Likely to go into vents and steal food for self. Will escape vents if landed. 
#selifsh
#hopeless -- harm self, space self, tell others going to die.
#irrational
#obessive would be interesting -- stalking another person


func getPossibleEvents():
    var possibleEvents 
    for attribute in character.characterAttributes:
        #look at all attributes on this character. If it has an event chance, add it to this list
           possibleEvents = attribute.characterEventTypeChance
    if possibleEvents > 0:
        for event in possibleEvents:
           insanityEvents.AddEntry(event["event"], event["chance"]) 
  
func Homicide():
    otherCharacter = GrabRandomCharacter()
    otherCharacter.Die(character, false)
    pass

func Suicide():
    pass
    character.Die(self, false)

func Stalk():
    #for 'obsessive'
    var target = character.relationshipModule.findBestRelationship()
    var slotToMoveTo = target.currentSlot.get_parent().returnClosestEmptySlot()
    #TODO: Complete this

func ExactRevenge():
    #for 'vengeful'
    #vengeful people will attack a specific target they hate. Cruel will attack anyone.
    var target = character.relationshipModule.findWorstRelationhip()
    AttackOther(target)

func HarmSelf():
    #TODO: maybe add some sort of 'attack' method to determine it was an attack
    character.changeStatValue(character.health, self, -10, false)

func AttackOther(otherCharacter):

    #maybe have this one only apply to characters who aren't already high health, or have it affect max hp too?
    if otherCharacter == null:
        otherCharacter = GrabRandomCharacter()
    otherCharacter.changeStatValue(character.health, self, -10, false)

    #have the other character hate this character immediately, unless masochistic
    otherCharacter.relationshipModule.AdjustRelationship(self, -100)

func GrabRandomCharacter():
    var randomCharacter = ChooseRandom.ChooseRandomFromList(get_tree().get_nodes_in_group("Characters"))
    return randomCharacter

signal ContaminateFood(poison)

func ContaminateFood():
    #on night
    emit_signal("ContaminateFood", self, AttributeJSONParser.fetchAndCreateAttribute("Contaminated"))

signal SabotageStation

func SabotageStation():
    #find a random station and disable it
    var stations = get_tree().get_nodes_in_group("Stations")
    var stationToSabotage = ChooseRandom.ChooseRandomFromList(stations)
    stationToSabotage.disableStation()
    pass

func SetFire():
    #find a random slot and set fire to it
    var allSlots = get_tree().get_nodes_in_group("slots")
    var randomSlot = ChooseRandom.ChooseRandomFromList(allSlots)
    randomSlot.applyNewAttributeToSlot(AttributeJSONParser.fetchAndCreateAttribute("OnFire"))


signal VentHermitAction

func HideInVents():
    #Description. "___" has disappeared. 
    #food will randomly go missing every few hours
    #will die if overheating or freezing happening
