extends Node2D


var handInZone = false

var viewingCharacterDetail = false
var dragging = true

signal draggingCharacter(character)
signal stoppedDraggingCharacter(character)
#warning-ignore:unused_class_variable
var characterName

var currentSlot
#warning-ignore:unused_class_variable
var characterAttributes = [ ]

onready var rightFacingPosition = get_node("RightPosition")
onready var leftFacingPosition = get_node("LeftPosition")

onready var characterStats = get_node("CharacterStats")

#TODO ADD SOMETHING IN ATTRIBUTES THAT AFFECTS DRAIN RATES
signal MouseHover

const _DynamicStats = {
	health = "currentHealth",
	sanity = "currentSanity",
	sustenance = "currentSustenance",
	relationship = "currentRelationship"
}

const _MaxStats = {
	health = "maxHealth",
	sanity = "maxSanity",
	sustenance = "maxSustenance",
	relationship = "maxRelationship"
}

var health 
var sustenance 
var sanity 
var relationship 

var tempHealthValue
var tempSustenanceValue
var tempSanityValue
var tempRelationshipValue

var spaceRequirement = 2
var damageDealt = 2

enum DynamicStats{
	health,
	sustenance,
	sanity,
	relationship

	}

enum StaticStats{
	damageDealt,
	spaceRequirement
	}

enum Conditions{

	injured, #lowers health over time
	diseased,
	insane, #increased likelyhood of insanty event, locked in for one day without curing
	hungry,
	impaired,
	debilitated, #cannot move or be moved, health lowers over time
	disabled,
	starving, #health begins to lower
	}

#Here you can spend time training the characters to use stations,
#there are 3 levels, and on level three the character will auto-handle things for you. Level two they'll warn you.
#warning-ignore:unused_class_variable
var stationTraining = { }


#[Dynamic Stats]
#warning-ignore:unused_class_variable
var maxHealth = 100
var currentHealth = 100
#warning-ignore:unused_class_variable
var healthDraining = false

var healthLossRate = 3
var healthGainRate = 3

signal statAtZero(whichStat)
signal statAtMax(whichStat)
signal healedOverMax(whichStat) #this one would apply to being overfed or being overhealed, which removes injuries

onready var healthBar = get_node("CharacterStats/Panel/HealthBar")
onready var healthTween = healthBar.get_node("HealthTween")

func applyNewAttribute(newAttribute):
	var newTrait = newAttribute
	for oldTrait in characterAttributes:
		for possibleConflictingTrait in newTrait.ConflictingAttributes:
			if oldTrait.attributeName == possibleConflictingTrait:
				print("Conflicting trait existed")
				return #this Return statement should pop the player out of this method
		if(newAttribute.canCombineWith.size() > 0):
			#if traits in this dictionary do exist
			for possibleCombineableTrait in newTrait.canCombineWith.keys():
				#for each trait that can combine with this current trait
				if oldTrait.attributeName == possibleCombineableTrait:
					#if we find one of them already applied to the character, apply it
					#TODO: FIND A WAY TO REMOVE IT AS WELL
					var combinedAttribute = AttributeJSONParser.fetchAndCreateAttribute(newTrait.canCombineWithn[possibleCombineableTrait])
					applyNewAttribute(combinedAttribute)

	if(newTrait.AffectedDynamicStatsCurrent.size() > 0):
		#for immediate "chunks" of damage
		for currentDynamicStatName in newTrait.AffectedDynamicStatsCurrent.keys():
			#
			#var affectedStat = determineStat(currentDynamicStat)
			#this passes the stat object, then the value of it,
			var affectedStat = determineStat(currentDynamicStatName)
			changeStatValue(affectedStat, newTrait.AffectedDynamicStatsCurrent[currentDynamicStatName], false)

	if(newTrait.AffectedDynamicStatsMax.size() > 0):
		#for things that affect maxStats
		for maxDynamicStatName in newTrait.AffectedDynamicStatsMax.keys():
			var affectedStat = determineStat(maxDynamicStatName)
			changeMaxStatValue(affectedStat, newTrait.AffectedDynamicStatsMax[maxDynamicStatName])
		pass
	if(newTrait.AffectedStaticStats.size() > 0):
		#for things that are affecting the static stats
		for staticStatName in newTrait.AffectedStaticStats.keys():
			#var enumStat = stringToEnum[staticStat]
			var newStaticStatValue = get(staticStatName) + newTrait.AffectedStaticStats[staticStatName]
			set(staticStatName, newStaticStatValue)
			#set(staticStat, (get)) += newTrait.AffectedStaticStats[staticStat]

	if(newTrait.DrainingDynamicStats.size() > 0):
		#how many points drained per second
		for drainedDynamicStatName in newTrait.DrainingDynamicStats.keys():
			var affectedStat = determineStat(drainedDynamicStatName)
			addNewDrainSource(affectedStat, newTrait, newTrait.DrainingDynamicStats[drainedDynamicStatName])
	

	characterAttributes.append(newAttribute)
	emit_signal("newAttributeAdded", newAttribute)
	if(newAttribute.attributeTypes.has("temporaryCondition")):

		var timer = Timer.new()
		timer.wait_time = newTrait.duration
		timer.connect("timeout",self,"conditionTimedOut", [newAttribute]) 
		add_child(timer) #to process
		timer.start() #to start

	if(newAttribute.statSignalsToWatchFor.size() > 0):
		for signals in newAttribute.statSignalsToWatchFor.keys():
				pass
		removeAttribute(newAttribute)

signal newAttributeAdded(attribute)
signal attributeRemoved(attribute)

func conditionTimedOut(attribute):
	print(attribute.attributeName + " was temporary and has been removed")
	removeAttribute(attribute)
	pass
func removeAttributeByName(removeableAttributeName):
	#there's got to be some way to streamline this
	for attribute in characterAttributes:
		if attribute.attributeName == removeableAttributeName:
			removeAttribute(attribute)

	

func removeAttribute(attribute):
	for oldTrait in characterAttributes:
		if(attribute.canCombineWith.size() > 0):
			#if traits in this dictionary do exist
			for possibleCombineableTrait in attribute.canCombineWith.keys():
				#for each trait that can combine with this current trait
				if oldTrait.attributeName == possibleCombineableTrait:
					#if we find one of them already applied to the character
					#also remove the attribute caused by them being combined
					removeAttribute(attribute.canCombineWith[possibleCombineableTrait])
					#TODO: FIND A WAY TO REMOVE IT AS WELL

	# #TODO: Switch these variables so that they are being removed instead

	if(attribute.AffectedDynamicStatsCurrent.size() > 0):
				#for immediate "chunks" of damage
		pass
		# for currentDynamicStat in attribute.AffectedDynamicStatsCurrent.keys:
		# 	changeStatValue(currentDynamicStat, attribute.AffectedDynamicStatsCurrent[currentDynamicStat], false)
		# 	pass
	if(attribute.AffectedDynamicStatsMax.size() > 0):
			#for things that affect maxStats
		for maxDynamicStatName in attribute.AffectedDynamicStatsMax.keys():
			var affectedStat = determineStat(maxDynamicStatName)
			changeMaxStatValue(affectedStat, 1/attribute.AffectedDynamicStatsMax[maxDynamicStatName])
			#multiplying the value by one/THENUMBER will be the same as dividing the value by the THENUMBER
			#value goes into the numerator
			#IE: 100 * 0.5 = 50. 50/0.5 = 100. 50 * 1/0.5 = 100, as 50/1 * 1/0.5 = 50/0.5
			pass
	if(attribute.AffectedStaticStats.size() > 0):
			#for things that are affecting the static stats
		for staticStatName in attribute.AffectedStaticStats.keys():
			var newStaticStatValue = get(staticStatName) - attribute.AffectedStaticStats[staticStatName]
			set(staticStatName, newStaticStatValue)

	if(attribute.DrainingDynamicStats.size() > 0):
			#how many points drained per second
		for drainedDynamicStatName in attribute.DrainingDynamicStats.keys():
			var affectedStat = determineStat(drainedDynamicStatName)
			RemoveNewDrainSource(affectedStat, attribute, attribute.DrainingDynamicStats[drainedDynamicStatName])

	if(attribute.ResultingAttributes.size() > 0):
		#maybe make it a dictionary with a key attribute value chance?
		#if this has any attributes that result from it
		for resultingAttribute in attribute.ResultingAttributes.keys():
			var randomValue = randf()

			#this is checking the chance of the attribute
			if randomValue <= attribute.ResultingAttributes[resultingAttribute]:
				applyNewAttribute(AttributeJSONParser.fetchAndCreateAttribute(resultingAttribute))

	characterAttributes.erase(attribute)
	emit_signal("attributeRemoved", attribute)

func SetInitialValues(conditions, attributes):
	pass

func calculateDrainRate(affectedStat, pointsDrainedPerSecond):

	#this will determine how many seconds total the drain should take if we're trying to drain X points per second
	#current health = points to drain divided by points per second drained = how many seconds it should take
	var currentValue = affectedStat.currentValue

	var rate = currentValue/pointsDrainedPerSecond


	return rate

func determineStat(statName):
	#will return the object that's variable name is health, sanity, sustenance, or relationship
	return get(statName)

func addNewDrainSource(affectedStat, drainSource, newDrainPerSecond):

	#var affectedStat = determineStat(whichStat)


	#this is adding to the sources that may be draining the  stat
	affectedStat.drainSources.append(drainSource)

	#this is determining wether the stat is overall being drained, which if the sources are greater than one, yes
	affectedStat.drainState = true

	affectedStat.drainRate += newDrainPerSecond

	#RATES -- determining the drain rate (how many points are being drained per second) and adding to it

	if(affectedStat.drainRate >= 20):
		affectedStat.drainRate = 20

	drainValueOverTime(affectedStat, drainSource, calculateDrainRate(affectedStat, affectedStat.drainRate))

func RemoveNewDrainSource(affectedStat, drainSource, newDrainPerSecond):
	#var affectedStat = determineStat(whichStat)

	if(affectedStat.drainSources.size() > 0):

		#if there are still sources draining the health, remove the drain source not acting any longer,
		# and start over the healthTween with the decreased rate

		if(affectedStat.drainSources.has(drainSource)):
			affectedStat.drainSources.erase(drainSource)

			affectedStat.drainRates -= newDrainPerSecond
			if(affectedStat.drainRates <= 0):
				affectedStat.drainRates = 0

	if(affectedStat.drainSources.size() == 0):
		#if there aren't any sources draining any longer, set to false
		affectedStat.drainState = false
		stopAllDrains(affectedStat) #!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

#

func DetermineWhichValue(whichStat):
	var currentValue
	if(whichStat == DynamicStats.health):
		currentValue = currentHealth

	elif(whichStat == DynamicStats.sanity):
		currentValue = currentSanity

	elif(whichStat == DynamicStats.sustenance):
		currentValue = currentSustenance

	elif(whichStat == DynamicStats.relationship):
		currentValue = currentRelationship

	return currentValue

func restartInterruptedDrain(affectedStat):


	var currentValue = affectedStat.currentValue #DetermineWhichValue(whichStat)
	if(affectedStat.drainSources.size() > 0 && currentValue > 0):
		#only restart if there's some shit still draining
		drainValueOverTime(affectedStat, null, 2)

func stopAllDrains(affectedStat):
	#when there are no more drain sources, stop the tween that is interating the current hp AND the tween that is iterating the bar
	$Tween.stop(affectedStat, "currentValue")
	characterStats.stopAnimatingBar(characterStats.statTweens[affectedStat])

func drainValueOverTime(affectedStat, drainSource, rate):

	var currentValue
	var whichBar
	var whichTween

	currentValue = affectedStat.currentValue #statCurrentValues[whichStat]
	whichBar = characterStats.statBars[affectedStat]
	whichTween = characterStats.statTweens[affectedStat]
	#whichPointsDrainedPerSecond = statDrainRates[whichStat]

	#pause any tweens already happening and rstart to add a ny new values
	$Tween.stop(affectedStat, "currentValue")
	

	$Tween.interpolate_property(affectedStat, "currentValue", currentValue, 0, calculateDrainRate(affectedStat, affectedStat.drainRate), Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)

	characterStats.animateBar(whichTween, whichBar, currentValue, 0, calculateDrainRate(affectedStat, affectedStat.drainRate))
	$Tween.start()

var maxSustenance = 100
var currentSustenance = 100

onready var sustenanceBar = get_node("CharacterStats/Panel/SustenanceBar")




#warning-ignore:unused_class_variable
var maxSanity = 100
var currentSanity = 100


#warning-ignore:unused_class_variable

#warning-ignore:unused_class_variable
var maxRelationship = 100
var currentRelationship = 100


#this is for if anything doubles or reduces damage taken
var damageModifiers = []
var timer
func changeStatValue(affectedStat, amount, isMultiplicative):
	#var affectedStat = determineStat(dynamicStat)

	var endValue
	var currentBar = characterStats.statBars[affectedStat]
	var currentTween = characterStats.statTweens[affectedStat]
	var currentAnim = characterStats.statAnimationPlayers[affectedStat]
	var startValue = affectedStat.currentValue

	if(isMultiplicative):
		endValue = affectedStat.currentValue * amount
	else:
		endValue = affectedStat.currentValue + amount

	if($Tween.is_active()):
		$Tween.stop(affectedStat, "currentValue")

	if(isMultiplicative):
			affectedStat.currentValue *= amount
	else:
			affectedStat.currentValue +=amount

	if(affectedStat.currentValue <= 0):
		affectedStat.currentValue = 0
		emit_signal("statAtZero", affectedStat)

	if(affectedStat.currentValue > affectedStat.maxValue ):
		affectedStat.currentValue = affectedStat.maxValue
	

	#var statValueToSet = statPropertyNames[dynamicStat]
	#set(statValueToSet, statCurrentValues[dynamicStat])

	#print(statPropertyNames[dynamicStat] + " " + str(statCurrentValues[dynamicStat]))
	if(amount < 0):
		currentAnim.play(currentBar.get_name() + "Flash")
		#currentBar.tint_progress = Color.red
		pass

	characterStats.animateBar(currentTween, currentBar, startValue, endValue, 0.25)

# func calculateCurrentHealthPercentage(whichStat, oldMaxHealthValue):
# 	#calculate what percentage of maxHealth is currentHealth
# 	var percentageOfMax = (statCurrentValues[whichStat]/oldMaxHealthValue) * 100
# 	var onePercent = statCurrentValues[whichStat]/100
# 	var equivalentPercentageValue = onePercent * percentageOfMax
# 	return equivalentPercentageValue
# 	#return percentageOfMax


func changeMaxStatValue(affectedStat, amount):


	#set the old maximum v alue for printing purposes
	var oldStatValue = affectedStat.maxValue

	#multiply the current maxValue by the amont (should be a decimal if lowering, wholenumber+ if raising)
	affectedStat.maxValue *=  amount

	#TODO: MAYBE JUST MULTIPLY CURRENT HP BY AMOUNT TOO IF IT'S INCREASED

	#make sure that if the currentStat is higher now, make it equal the maximum stat
	if affectedStat.currentValue > affectedStat.maxValue:
		affectedStat.currentValue = affectedStat.maxValue

	#make sure the value of the bars are being changed too
	characterStats.changeBarMaxValue(characterStats.statBars[affectedStat], affectedStat.maxValue)



func _ready():

	health = Stat.new()
	sanity = Stat.new()
	sustenance = Stat.new()
	relationship = Stat.new()

	sustenanceBar.max_value = maxSustenance
	currentSustenance = maxSustenance
	System.connect("stoppedDraggingItem", self, "checkIfSomethingDropped")
	SignalManager.connect("AddTrait", self, "ApplyNewAttribute")
	SignalManager.connect("RemoveTrait", self, "removeAttribute")
	characterStats.setStatBars()




func checkIfSomethingDropped(dispenser):
	if(handInZone):
		if(dispenser.dispensedItem == dispenser.ItemOptions.health):
			changeStatValue(DynamicStats.health, dispenser.dispensedItemValue, false)
		elif(dispenser.dispensedItem == dispenser.ItemOptions.food):
			changeStatValue(DynamicStats.sustenance, dispenser.dispensedItemValue, false)
		System.emit_signal("dispensedItemConsumed", dispenser, self)

func _process(delta):

	if(handInZone && Input.is_action_pressed("left_click")):
		if(!dragging):
			System.emit_signal("draggingCharacter", self)
			dragging = true

	if(dragging && Input.is_action_pressed("left_click")):
		pass
	else:
		if(dragging):
			dragging = false
			System.emit_signal("stoppedDraggingCharacter", self)



func _on_Character_area_entered(area):
	if(area.name == "Hand"):
		handInZone = true
		characterStats.showDisplay()
	pass # Replace with function body.


func _on_Character_area_exited(area):
	if(area.name == "Hand"):
		handInZone = false
		#print("Hovering panel" + characterStats.hoveringOverPanel)
		if(!viewingCharacterDetail):
			#if the mouse isn't on the player anymore, and also isn't
			#hovering over the panel, hide the display
			characterStats.hideDisplay()
	pass # Replace with function body.

func _input(event):
	if(event.is_action_pressed("ui_interact")):
		if(handInZone && !viewingCharacterDetail):
			#if we're hovering over the character, but not viewing them in detail
			viewingCharacterDetail = true
			characterStats.scanLabel.text = ""
			characterStats.scanLabel.add_text("DETAILED SCAN")
			characterStats.scanLabel.pop()

		elif(viewingCharacterDetail && !handInZone):
			#if we're NOT hovering over the character and viewing them in detail
			characterStats.scanlabel.add_text("hover overview")
			characterStats.scanlabel.pop()
			viewingCharacterDetail = false
			characterStats.hideDisplay()

		elif(viewingCharacterDetail && handInZone):
			characterStats.scanLabel.add_text("hover overview")
			characterStats.scanLabel.pop()
			viewingCharacterDetail = false

func _on_Button_pressed():
	#var attribute = Attribute.new("OnFire")
	var attribute = System.attributeScript.new("OnFire")
	#attribute.sayHello()
	connect("statAtZero", attribute, "sayHello")
	#attribute._init("OnFire")
	attribute.characterAttachedTo = self
	attribute.description = "Help I'm on fire"
	attribute.ConflictingAttributes.append("Underwater")
	attribute.ResultingAttributes =  ["Shaken"] #Attributes that will result from this one 'On Fire --> Shaken'
	attribute.AffectedDynamicStatsMax = {System.DynamicStats.sustenance : 0.5}
	attribute.AffectedDynamicStatsCurrent = {System.DynamicStats.sanity : -50}
	attribute.DrainingDynamicStats = { System.DynamicStats.health : 20} #if any dynamic stats are actively drained
	attribute.duration = 2
	attribute.typeOfAttribute = System.attributeType.temporaryCondition

	attribute.externalCombinations = {[attribute.externalCombinations.new("Greasy", true)] : attribute.externalCombinations.new("Fine", false)}
#	attribute.attributeTypes.append(System.attributeType.temporaryCondition)
	# for item in attribute.attributeTypes:
	#
	# 	print(System.attributeType[item])
	applyNewAttribute(attribute)
	#characterAttributes.append(attribute)
	#addNewDrainSource(DynamicStats.sanity, null, 1)
	#addHealthDrainSource("test", 1.0)

	pass # Replace with function body.


func _on_FasterHealthDrain_pressed():
	for item in characterAttributes:
		if(item.attributeName == "OnFire"):
			removeAttribute(item)
	#removeAttribute("OnFire")
	#addNewDrainSource(DynamicStats.sanity, null, 2)
	#addHealthDrainSource("test2", 3.0)

	pass # Replace with function body.


func _on_Attack_pressed():
	var attribute = Attribute.new("Underwater")
	attribute.ConflictingAttributes.append("OnFire")
	attribute.description = "I'm underwater"
	attribute.ResultingAttributes = ["Wet"]
	attribute.DrainingDynamicStats = {System.DynamicStats.health : 10}
	attribute.typeOfAttribute = System.attributeType.auraCondition
	applyNewAttribute(attribute)
	#print("Attack pressed")
	#changeStatValue(DynamicStats.sanity, -30, false)
	pass # Replace with function body.

func _on_Tween_tween_step(object, key, elapsed, value):
	pass
	if object.currentValue <= 0:
		 emit_signal("statAtZero", object)

	if object.currentValue >= object.maxValue:
		emit_signal("statAtMax", object)

# 	if(key == ':currentHealth'):
# 		var stat = DynamicStats.health
# 		statCurrentValues[DynamicStats.health] = value

# 		if(statCurrentValues[DynamicStats.health] <= 0):
# 			emit_signal("statAtZero", DynamicStats.health)

# 		if(statCurrentValues[stat] >= statMaxValues[stat]):
# 			emit_signal("statAtMax", stat)

# 	elif(key == ':currentSustenance'):
# 		var stat = DynamicStats.sustenance
# 		statCurrentValues[DynamicStats.sustenance] = value

# 		if(statCurrentValues[DynamicStats.sustenance] <= 0):
# 			emit_signal("statAtZero", DynamicStats.sustenance)

# 		if(statCurrentValues[stat] >= statMaxValues[stat]):
# 			emit_signal("statAtMax", stat)

# 	elif(key == ':currentSanity'):
# 		var stat = DynamicStats.sanity
# 		statCurrentValues[DynamicStats.sanity] = value

# 		if(statCurrentValues[DynamicStats.sanity] <= 0):
# 			emit_signal("statAtZero", DynamicStats.sanity)

# 		if(statCurrentValues[stat] >= statMaxValues[stat]):
# 			emit_signal("statAtMax", stat)

# 	elif(key == ':currentRelationship'):
# 		var stat = DynamicStats.relationship
# 		statCurrentValues[DynamicStats.relationship] = value

# 		if(statCurrentValues[DynamicStats.relationship] <= 0):
# 			emit_signal("statAtZero", DynamicStats.relationshipBar)

# 		if(statCurrentValues[stat] >= statMaxValues[stat]):
# 			emit_signal("statAtMax", stat)

# func _on_Tween_tween_completed(object, key):
# 	if(object == self):
# 		if(key == 'currentHealth'):
# 			pass
# 		elif(key == 'currentSustenance'):
# 			pass
# 		elif(key == 'currentSanity'):
# 			pass
# 		elif(key == 'currentRelationship'):
# 			pass
