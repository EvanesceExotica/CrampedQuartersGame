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
var homicide = funcref(self, "Homicide")
var suicide = funcref(self, "Suicide")
var stalk = funcref(self, "Stalk")
var exactRevenge = funcref(self, "ExactRevenge")
var harmSelf = funcref(self, "HarmSelf")
var attackOther = funcref(self, "AttackOther")
var contaminateFood = funcref(self, "ContaminateFood")
var sabotageStation = funcref(self, "SabotageStation")
var setFire = funcref(self, "SabotageStation")
var hideInVents = funcref(self, "HideInVents") #for this one, add a separate node that handles the food stealing and such


#the different arrays here represent the 'escelalation level' of the event. Going from harm to murder, for example
var breakdownEvents = {
	"mashocistic" : [[harmSelf], [suicide]],
	"cruel" : [[attackOther, sabotageStation], [homicide]],
	"paranoid" : [[], [hideInVents]],
	"selfish" : [],
	"hopeless" : [],
	"irrational" : [],
	"obsessive" : [[stalk]],
	"vengeful" : [[exactRevenge]]
}
var breakdownEventList : Array = []
var escelationValue = 0
func SetParanoid():
	pass

func SetSelfish():
	pass
func HaveMentalBreak():
	#add a qualifier/parameter here to make certain traits more likely to have certain breakdown types

	var possibleBreakdowns = breakdownEvents.keys().duplicate(true)
	#copy the keys of the breakdownEvents list
	if character.relationshipModule.friends.size() == 0:
		possibleBreakdowns.erase("obsessive")
		pass
	if character.relationshipModule.enemies.size() == 0:
		#if has no enemies, take away 'vengeful' as an option
		possibleBreakdowns.erase("vengeful")

#choose a random breakdown type from the list of possible ones
	var randomBreakdown = ChooseRandom.ChooseRandomFromList(possibleBreakdowns)
	print("Our breakdown type is " + str(randomBreakdown))

	#get the list of esceleating func-refs from the dictionary
	breakdownEventList = breakdownEvents[randomBreakdown]

func HandleEscelation():

	#find the list of optinos that matches the escelation value of today
	var potentialActions = breakdownEventList[escelationValue]

	#choose a random action from that list of actions and call it
	var chosenAction = ChooseRandom.ChooseRandomFromList(potentialActions)
	chosenAction.call_func()


func getPossibleEvents():
	var possibleEvents 
	for attribute in character.characterAttributes:
		#look at all attributes on this character. If it has an event chance, add it to this list
		   possibleEvents = attribute.characterEventTypeChance
	if possibleEvents > 0:
		for event in possibleEvents:
		   insanityEvents.AddEntry(event["event"], event["chance"]) 
  
func Homicide():
	var otherCharacter = GrabRandomCharacter()
	otherCharacter.Die(character, false)
	pass

func Suicide():
	pass
	character.Die(self, false)

func Stalk():
	#for 'obsessive'
	var target = character.relationshipModule.findBestRelationship()
	var slotToMoveTo = target.currentSlot.get_parent().returnClosestEmptySlot()
	if slotToMoveTo == null:
		#if there are no empty slots in the same room, harm yourself out of not being able to reach your obessession
		HarmSelf()
	else:
		#else, move close to obsession
		slotToMoveTo.processDroppedItem(character)

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
	pass
	#Description. "___" has disappeared. 
	#food will randomly go missing every few hours
	#will die if overheating or freezing happening
