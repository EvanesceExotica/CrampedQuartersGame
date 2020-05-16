extends Node2D

var insanityEvents = WeightedObject.new()
onready var character = get_parent() #this will be a child of the character
var ventHermitClass = preload("res://Character/VentHermit.tscn")
#mashochistic -- harm self -- refuse healing/food
#cruel  - harm other 
#paranoid - refuse healing/food. Likely to go into vents and steal food for self. Will escape vents if landed. 
#selifsh
#hopeless -- harm self, space self, tell others going to die.
#irrational
#obessive would be interesting -- stalking another person
var homicide = funcref(self, "Homicide")
var killRandom = funcref(self, "KillRandom")
var killTarget = funcref(self, "KillTarget")
var suicide = funcref(self, "Suicide")
var stalk = funcref(self, "Stalk")
var exactRevenge = funcref(self, "ExactRevenge")
var harmSelf = funcref(self, "HarmSelf")
var attackOther = funcref(self, "AttackRandom")
var contaminateFood = funcref(self, "ContaminateFood")
var sabotageStation = funcref(self, "SabotageStation")
var setFire = funcref(self, "SabotageStation")
var hideInVents = funcref(self, "HideInVents") #for this one, add a separate node that handles the food stealing and such

func _ready():
	pass
#the different arrays here represent the 'escelalation level' of the event. Going from harm to murder, for example
var breakdownEvents = {
	 "Irrational" : [[setFire], []]
	#"Masochistic" : [[harmSelf], [suicide]],
	#"Cruel" : [[attackOther, contaminateFood], [killRandom]]#,
	 #"Paranoid2" : [[sabotageStation], [hideInVents]]#,
	 #"Selfish" : [[], []],
	# "Hopeless" : [[],[]],
	# "Irrational" : [[harmSelf, attackOther, startFire, sabotageStation], []]
	# "Obsessive" : [[stalk]]
	# "Vengeful" : [[exactRevenge], [killTarget]]
}
var breakdownEventList : Array = []
var escelationValue = 0
func SetParanoid():
	pass

func SetSelfish():
	pass
func HaveMentalBreak():
	#add a qualifier/parameter here to make certain traits more likely to have certain breakdown types
	print("Having mental break!")
	var possibleBreakdowns = breakdownEvents.keys().duplicate(true)
	#copy the keys of the breakdownEvents list
	if character.relationshipModule.friends.size() == 0:
		possibleBreakdowns.erase("Obsessive")
		pass
	if character.relationshipModule.enemies.size() == 0:
		#if has no enemies, take away 'vengeful' as an option
		possibleBreakdowns.erase("Vengeful")

#choose a random breakdown type from the list of possible ones
	var randomBreakdown = ChooseRandom.ChooseRandomFromList(possibleBreakdowns)
	print("Our breakdown type is " + str(randomBreakdown))
	#add the attribute itself which might affect dialogue and some stats on the character
	character.applyNewAttribute(AttributeJSONParser.fetchAndCreateAttribute(randomBreakdown))

	#get the list of esceleating func-refs from the dictionary
	breakdownEventList = breakdownEvents[randomBreakdown]
	SignalManager.connect("DayPassed", self, "HandleEscelation")


func RecoverFromMentalBreak():
	SignalManager.disconnect("DayPassed", self, "HandleEscelation")

func HandleEscelation():

	#find the list of optinos that matches the escelation value of today
	var potentialActions = breakdownEventList[escelationValue]

	#choose a random action from that list of actions and call it
	if potentialActions.size() > 0:
		var chosenAction = ChooseRandom.ChooseRandomFromList(potentialActions)
		chosenAction.call_func()
	#escelationValue+=1


func getPossibleEvents():
	var possibleEvents 
	for attribute in character.characterAttributes:
		#look at all attributes on this character. If it has an event chance, add it to this list
		   possibleEvents = attribute.characterEventTypeChance
	if possibleEvents > 0:
		for event in possibleEvents:
		   insanityEvents.AddEntry(event["event"], event["chance"]) 
  
func KillRandom():
	var otherCharacter = GrabRandomCharacter()
	print("going to kill " + otherCharacter.characterName)
	otherCharacter.Die(6, false)

func KillTarget():
	var target = character.relationshipModule.findWorstRelationhip()
	target.Die(6, false)

func Homicide():
	var otherCharacter = GrabRandomCharacter()
	print("going to kill " + otherCharacter.characterName)
	otherCharacter.Die(6, false)
	pass

func Suicide():
	pass
	character.Die(6, false)

func Stalk():
	#for 'obsessive'
	var target = character.relationshipModule.findBestRelationship()
	var slotToMoveTo = target.currentSlot.get_parent().returnClosestEmptySlot(target.currentSlot)
	if slotToMoveTo == null:
		#if there are no empty slots in the same room, harm yourself out of not being able to reach your obessession
		HarmSelf()
	else:
		#else, move close to obsession
		slotToMoveTo.processDroppedItem(character)
		target.applyNewAttribute(AttributeJSONParser.fetchAndCreateAttribute("BeingStalked")) #find one that removes this when character is moved

func ExactRevenge():
	#for 'vengeful'
	#vengeful people will attack a specific target they hate. Cruel will attack anyone.
	var target = character.relationshipModule.findWorstRelationhip()
	AttackOther(target)

func HarmSelf():
	print("HURTING MYSELF!")
	#TODO: maybe add some sort of 'attack' method to determine it was an attack
	character.changeStatValue(character.health, self, -10, false)

func AttackRandom():
	var otherCharacter = GrabRandomCharacter()
	AttackOther(otherCharacter)

func AttackOther(otherCharacter):

	print("HURTING ANOTHER")
	#maybe have this one only apply to characters who aren't already high health, or have it affect max hp too?
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
	var ventHermit = ventHermitClass.instance()
	character.add_child(ventHermit)
	pass
	#Description. "___" has disappeared. 
	#food will randomly go missing every few hours
	#will die if overheating or freezing happening
