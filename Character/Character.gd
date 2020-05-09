extends Node2D

class_name Character


onready var relationshipModule = get_node("RelationshipModule")
onready var conversationHandler = get_node("ConversationHandler")
onready var insanityHandler = get_node("InsanityHandler")

onready var dreamSpawner = get_node("DreamSpawner")
onready var sprite = get_node("Naut")
onready var dragSprite = sprite.texture
onready var deathHandler = get_node("DeathHandler")
var handInZone = false
var notDraggable = false
var notDroppable = false
onready var droppableZone = get_node("DroppableZone")
onready var draggableItem = get_node("DraggableItem")
var dropType

var viewingCharacterDetail = false
var dragging = true
signal draggingCharacter(character)
signal stoppedDraggingCharacter(character)
#warning-ignore:unused_class_variable
var characterName

var currentSlot
var previousSlot
#warning-ignore:unused_class_variable
var characterAttributes = [ ]
var auraSlotRange = {}

var temporaryAttributes = {}
var resultingAttributeTimers = {}
var spreadTimers = {}
var potentialResultingAttributes = {}
onready var rightFacingPosition = get_node("RightPosition")
onready var leftFacingPosition = get_node("LeftPosition")

onready var characterStats = get_node("CharacterStats")

#TODO ADD SOMETHING IN ATTRIBUTES THAT AFFECTS DRAIN RATES
signal MouseHover

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

#this are increased by certain stats
var foodRefusalChance = 0 #chance to refuse food
var medicineRefusalChance = 0 #chance to refuse healing
var negativeConversationStarterChance = 0 #chance to start a mean conversation 

#Here you can spend time training the characters to use stations,
#there are 3 levels, and on level three the character will auto-handle things for you. Level two they'll warn you.
#warning-ignore:unused_class_variable
var stationTraining = { }

var starvingAttribute


signal statAtZero(whichStat)
signal statAtMax(whichStat)
signal healedOverMax(whichStat) #this one would apply to being overfed or being overhealed, which removes injuries

func applyNewAttribute(newAttribute):	

	print("Applying new attribute " + newAttribute.attributeName)
	var newTrait = newAttribute
	if(characterAttributes.has(newTrait) && !newTrait.stackable):
		#if this trait already exists on the character && this trait's effects don't stack
		print("Character already has trait " + newTrait.attributeName)
		#add the trait, but don't do anything below the return statement
		characterAttributes.append(newTrait)
		emit_signal("newAttributeAdded", newAttribute)
		return

	if(newTrait.ConflictingAttributes != null):
		for oldTrait in characterAttributes:
			for possibleConflictingTrait in newTrait.ConflictingAttributes:
				if oldTrait.attributeName == possibleConflictingTrait:
					print("Conflicting trait existed")
					return #this Return statement should pop the player out of this method

	if(newTrait.AuraAttributes != null && newTrait.AuraAttributes.size() > 0):
		#if this trait is an aura, meaning it applies to other slots
		for auraAttribute in newAttribute.AuraAttributes:
			var aura = AttributeJSONParser.fetchAndCreateAttribute(auraAttribute["AttributeName"])
			SignalManager.emit_signal("emittingAura", currentSlot, aura, auraAttribute["Range"])
			auraSlotRange[aura] = auraAttribute["Range"] 

	if(newTrait.ResultingAttributes != null && newTrait.ResultingAttributes.size() > 0):
		for resultingAttribute in newTrait.ResultingAttributes:
			var result = AttributeJSONParser.fetchAndCreateAttribute(resultingAttribute["attributeName"])
			print("Trying for resulting attribute")
			#start a timer, set it's wait time to thirty in game minutes, and connect it to a method that either activates the resulting method if it lands on the chance, or tries again
			var timer = Timer.new()
			timer.wait_time = TimeConverter.GameMinutesToSeconds(30)
			#pass the resulting Attribute and the source attribute to the ActivateResultingAttribute class, and create a timer  
			timer.connect("timeout",self,"ActivateResultingAttribute", [resultingAttribute, newTrait]) 
			add_child(timer) #to process
			timer.start() #to start
			#create the timer and store it into a dictionary to keep track of it, and stop it if the resultingAttribute is never created
			resultingAttributeTimers[newTrait] = timer

	if newTrait.spreadChancePerHalfHour > 0:
		print("Beginning to spread contagious attribute " + newTrait.attributeName)
		#if this attribute can spread
		#start a timer that connects to a method that will try for the chance to spread, then start the timer over if it fails
		var timer = Timer.new()
		timer.wait_time = TimeConverter.GameMinutesToSeconds(30)
		timer.connect("timeout",self,"SpreadContagiousAttribute", [newTrait]) 
		add_child(timer) #to process
		timer.start() #t
		spreadTimers[newTrait] = timer

	# if newTrait.spreadVariables != null && newTrait.spreadVariables.size() > 0:
	# 	if newTrait.spreadVariables["spreadChancePerHalfHour"] > 0:
	# 		print("Beginning to spread contagious attribute " + newTrait.attributeName)
	# 		#if this attribute can spread
	# 		#start a timer that connects to a method that will try for the chance to spread, then start the timer over if it fails
	# 		var timer = Timer.new()
	# 		timer.wait_time = TimeConverter.GameMinutesToSeconds(30)
	# 		timer.connect("timeout",self,"SpreadContagiousAttribute", [newTrait]) 
	# 		add_child(timer) #to process
	# 		timer.start() #t

	for stat in newAttribute["AffectedStats"]:
		var affectedStat = determineStat(stat["statName"])
		match stat["whichValue"]:	
			"max":
				changeMaxStatValue(affectedStat, stat["amount"])

			"current":
				changeStatValue(affectedStat, newAttribute, stat["amount"], false)
			"drain":
				addNewDrainSource(affectedStat, newAttribute, stat["amount"])
			"static":
				var newValue = get(stat["statName"] + stat["amount"])
				set(stat["statName"], newValue)

	characterAttributes.append(newAttribute)
	emit_signal("newAttributeAdded", newAttribute)

	if newAttribute.temporary == true:
		var timer = Timer.new()
		timer.wait_time = newAttribute.duration
		timer.connect("timeout",self,"conditionTimedOut", [newAttribute]) 
		add_child(timer) #to process
		timer.start() #to start
		#add this to a dictionary to keep track of it and its timer
		temporaryAttributes[newAttribute] = timer
	

func removeAttribute(attribute):

	if characterAttributes.count(attribute) > 1 && !attribute.stackable:
		#check if the attribute is in the array multiple times, and it wasn't an attribute with stackable effects
		print("Attribute is in the array " + str(characterAttributes.count(attribute)) + " time(s)")
		#erase the first occurance
		characterAttributes.erase(attribute)
		#emit the signal for the characterStats panel update
		print("Now attribute is in the array " + str(characterAttributes.count(attribute)) + " time(s)")
		#erase the first occurance
		emit_signal("attributeRemoved", attribute)
		return

	for stat in attribute["AffectedStats"]:
		var affectedStat = determineStat(stat["statName"])
		match stat["whichValue"]:	
			"max":
				changeMaxStatValue(affectedStat, 1/stat["amount"])
			"current":
				pass
				#changeStatValue(affectedStat, stat["amount"], false)
			"drain":
				RemoveNewDrainSource(affectedStat, attribute, stat["amount"])
			"static":
				var newValue = get(stat["statName"] - stat["amount"])
				set(stat["statName"], newValue)


	if(attribute.ResultingAttributes != null && attribute.ResultingAttributes.size() > 0):
		for resultingAttribute in attribute.ResultingAttributes:
			#this should stop the timers that are trying to spread the resulting attribute
			StopResultingAttributeGeneration(resultingAttribute, attribute)
	if attribute.temporary:
		#if the attribute was temporary and is getting removed, stop the timer that's looking to remove it at the end of its duration
		temporaryAttributes[attribute].stop()

	emit_signal("attributeRemoved", attribute)

func StopResultingAttributeGeneration(resultingAttribute, sourceAttribute):
	#stop the timer that's held in this dictionary, so it will stop checking for
	resultingAttributeTimers[sourceAttribute].stop()	



func ActivateResultingAttribute(resultingAttribute, sourceAttribute):
	var randomValue = randf()
	if randomValue <= resultingAttribute["chancePerHalfHour"]:
		#if the chance is rolled, apply the attribute
		print("Resulting attribute has applied!" + resultingAttribute["attributeName"])
		applyNewAttribute(AttributeJSONParser.fetchAndCreateAttribute(resultingAttribute["attributeName"]))
	else:
		#if not, restart the timer for each time it checks
		print("Check again  for " + resultingAttribute["attributeName"])
		var timer = Timer.new()
		timer.wait_time = TimeConverter.GameMinutesToSeconds(30)
		timer.connect("timeout",self,"ActivateResultingAttribute", [resultingAttribute, sourceAttribute]) 
		#timer.connect("timeout",self,"ActivateResultingAttribute", [resultingAttribute]) 
		add_child(timer) #to process
		timer.start() #to sta
		resultingAttributeTimers[sourceAttribute] = timer

func SpreadContagiousAttribute(attribute):
	var randomValue = randf()
	if randomValue <= attribute.spreadChancePerHalfHour: #spreadChancePerHalfHour:
		#if the chance is rolled, apply the attribute
		print("Attribute has spread to another character!" + attribute.attributeName)
		currentSlot.SpreadFromCharacter(attribute)
	else:
		#if not, restart the timer for each time it checks
		print("Check again  for spread of " + attribute.attributeName)
		var timer = Timer.new()
		timer.wait_time = TimeConverter.GameMinutesToSeconds(30)
		timer.connect("timeout",self,"SpreadContagiousAttribute", [attribute]) 
		add_child(timer) #to process
		timer.start() #to sta

func StopSpreadAttempts(attribute):
	#stop the timer that's held in this dictionary, so it will stop checking for
	spreadTimers[attribute].stop()	

func hasAttribute(attributeName):
	#to determine if a character has an attribute or not by name
	for attribute in characterAttributes:
		if attribute.attributeName == attributeName:
			return true
	return false

func _applyNewAttribute(newAttribute):
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
					var combinedAttribute = AttributeJSONParser.fetchAndCreateAttribute(newTrait.canCombineWith[possibleCombineableTrait])
					applyNewAttribute(combinedAttribute)

	if(newTrait.AuraAttributes != null && newTrait.AuraAttributes.size() > 0):
		#if this trait is an aura, meaning it applies to other slots
		for auraAttributeName in newAttribute.AuraAttributes:
			var aura = AttributeJSONParser.fetchAndCreateAttribute(auraAttributeName)
			SignalManager.emit_signal("emittingAura", currentSlot, aura, newAttribute.AuraAttributes[auraAttributeName])
			auraSlotRange[aura] = newAttribute.AuraAttributes[auraAttributeName]
	if(newTrait.AffectedDynamicStatsCurrent.size() > 0):
		#for immediate "chunks" of damage
		for currentDynamicStatName in newTrait.AffectedDynamicStatsCurrent.keys():
			#
			#var affectedStat = determineStat(currentDynamicStat)
			#this passes the stat object, then the value of it,
			var affectedStat = determineStat(currentDynamicStatName)
			changeStatValue(affectedStat, null, newTrait.AffectedDynamicStatsCurrent[currentDynamicStatName], false)

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
			break


func calculateDrainRate(affectedStat, pointsDrainedPerSecond):

	#this will determine how many seconds total the drain should take if we're trying to drain X points per second
	#current health = points to drain divided by points per second drained = how many seconds it should take
	var currentValue = affectedStat.currentValue

	# TODO:Try to figure out how to better handle this division by zero problem
	if pointsDrainedPerSecond == 0:
		pointsDrainedPerSecond = 1
	var rate = currentValue/pointsDrainedPerSecond


	return rate

func determineStat(statName):
	#will return the object that's variable name is health, sanity, sustenance, or relationship
	return get(statName)

func addNewDrainSource(affectedStat, drainSource, newDrainPerSecond):
	if affectedStat == health && newDrainPerSecond > 0:
		#if this is draining the health, and it's a positive, not a negative drain (i.e., not healing)
		deathHandler.addPotentialDeathSource(drainSource, newDrainPerSecond)
	#var affectedStat = determineStat(whichStat)


	#this is adding to the sources that may be draining the  stat
	affectedStat.drainSources.append(drainSource)

	#this is determining wether the stat is overall being drained, which if the sources are greater than one, yes
	affectedStat.drainState = true

	affectedStat.drainRate += newDrainPerSecond

	#RATES -- determining the drain rate (how many points are being drained per second) and adding to it

		#the actualy drain speed is already being calculated in the "Drain value over time" method I think?
	drainValueOverTime(affectedStat, drainSource, affectedStat.drainRate)

func RemoveNewDrainSource(affectedStat, drainSource, sourceDrainPerSecond):
	#this source is usually going to be from an attribute. "drainSource" is the attribute and "sourceDrainPerSecond" is the attribute's drain amount. Could be better named. 
	#var affectedStat = determineStat(whichStat)
	if deathHandler.potentialDeathSources.keys().has(drainSource):
		#if the death handler was tracking this source, remove it
		deathHandler.removePotentialDeathSource(drainSource)

	if(affectedStat.drainSources.size() > 0):

		#if there are still sources draining the health, remove the drain source not acting any longer,
		# and start over the healthTween with the decreased rate

		if(affectedStat.drainSources.has(drainSource)):
			affectedStat.drainSources.erase(drainSource)
			print(affectedStat.drainSources.size())

			affectedStat.drainRate -= sourceDrainPerSecond
			if(affectedStat.drainRate <= 0):
				affectedStat.drainRate = 0

	if(affectedStat.drainSources.size() == 0):
		#if there aren't any sources draining any longer, set to false
		affectedStat.drainState = false
		stopAllDrains(affectedStat) #!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
	else:
		drainValueOverTime(affectedStat, null, affectedStat.drainRate)
		#restartInterruptedDrain(affectedStat)

func restartInterruptedDrain(affectedStat):

	var currentValue = affectedStat.currentValue #DetermineWhichValue(whichStat)
	if(affectedStat.drainSources.size() > 0 && currentValue > 0):
		#only restart if there's some shit still draining
		drainValueOverTime(affectedStat, null, affectedStat.drainRate)

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

	$Tween.start()
	characterStats.animateBar(affectedStat, currentValue, 0, calculateDrainRate(affectedStat, affectedStat.drainRate))
	#characterStats.animateBar(whichTween, whichBar, currentValue, 0, calculateDrainRate(affectedStat, affectedStat.drainRate))

func IsSane():
	if sanity.currentValue > 0:
		return true
	else:
		return false


func travelToFuture(defaultAttributeName):
	#characters travelling back to the EndOfTime
	
	var defaultAttribute = AttributeJSONParser.fetchAndCreateAttribute(defaultAttributeName)#.Copy(self.characterName)
	var moddedAttribute = defaultAttribute.Copy()
	var scaleValue = scaleValueToNewRange()
	#take the copy of the default attribute, modify it's value to be less
	if moddedAttribute.AffectedStats[0]["amount"] > sanity.maxValue:
		moddedAttribute.AffectedStats[0]["amount"] = sanity.maxValue

	moddedAttribute.AffectedStats[0]["amount"] = moddedAttribute.AffectedStats[0]["amount"] - scaleValue
	applyNewAttribute(moddedAttribute)
	pass

func arrivedAtFuture(defaultAttributeName):
	#remove the 'beholding the truth'. Anyone with no relationship stat should be insane at this point.
	removeAttributeByName(defaultAttributeName)

func scaleValueToNewRange():
	# OldRange = (OldMax - OldMin)  
	# NewRange = (NewMax - NewMin)  
	# NewValue = (((OldValue - OldMin) * NewRange) / OldRange) + NewMin
	var relationshipRange = relationship.maxValue - 0
	var sanityRange = sanity.maxValue - 0
	var scaledBuffer = ((relationship.currentValue - 0) * sanityRange/relationshipRange) + 0
	return scaledBuffer
#func normalize(value):
#	var normalizedValue = (sanity.maxValue - 0)((value - min)/(max(x)-min(x)))+0

#this is for if anything doubles or reduces damage taken
var damageModifiers = []
var timer
func changeStatValue(affectedStat, newAttribute, amount, isMultiplicative):
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
		if affectedStat == health:
			#if the affected stat is health and is zero, the character has died
			Die(newAttribute, false)
		elif affectedStat == sustenance:
			Starve()

	if(affectedStat.currentValue > affectedStat.maxValue ):
		affectedStat.currentValue = affectedStat.maxValue
	

	if(amount < 0):
		currentAnim.play(currentBar.get_name() + "Flash")
	if amount > 0 && affectedStat.currentValue > 0:
		#if the affected stat was zero and has now been healed/regained
		if affectedStat == sustenance:
			#this should usually be applied by food, with the 'CheckIfSomethingDropped' method.
			#make it so the character isn't starving anymore
			ClearStarvation()

	characterStats.animateBar(affectedStat, startValue, endValue, 0.25)


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

func Die(source, causedByDrain):
	print(characterName + " died")
	#later you can pass in the source of the death
	deathHandler.handleDeath(self, source, causedByDrain)
	pass

func Starve():
	applyNewAttribute(starvingAttribute)

func ClearStarvation():
	removeAttribute(starvingAttribute)

func _ready():
	randomize()
	health = Stat.new()
	sanity = Stat.new()
	sustenance = Stat.new()
	relationship = Stat.new()
	relationship.currentValue  = 49

	#System.connect("stoppedDraggingItem", self, "checkIfSomethingDropped")
	SignalManager.connect("AddTrait", self, "ApplyNewAttribute")
	SignalManager.connect("RemoveTrait", self, "removeAttribute")
	characterStats.setStatBars()

	#this adds the attribute to have the characters be constantly hungry
	applyNewAttribute(AttributeJSONParser.fetchAndCreateAttribute("NeedsSustenance"))
	starvingAttribute = AttributeJSONParser.fetchAndCreateAttribute("Starving")


func turnOffAuras():
	for aura in auraSlotRange.keys():
		print("Stopping aura " + aura.attributeName)
		SignalManager.emit_signal("stoppedEmittingAura", previousSlot, aura, auraSlotRange[aura])
func turnOnAuras():
	for aura in auraSlotRange.keys():
		SignalManager.emit_signal("emittingAura", currentSlot, aura, auraSlotRange[aura])

func HandleInterrupt(dispenser):
	#make a flag to only do this if there's a flab determining that there's a crazy person present

	#determine if will refuse food
	if hasAttribute("Paranoid"):
		#TODO: Change these values
		if ChooseRandom.DetermineIfEventHappens(0.5):
			RefuseResource()

	#determine if will refuse food
	var selfishCharacter = IsSelfishCharacterNearby()
	if selfishCharacter != null:
		if ChooseRandom.DetermineIfEventHappens(0.5):
			selfishCharacter.StealResource()
			

func RefuseResource():
	print("I don't want your tainted goods!")
	#TODO: have character make comment about not needing it
	pass



func StealResource(dispenser):
	#this is when a character adjacent yoinks an item from 
	print("YOINK!")
	processDroppedItem(dispenser)

func IsSelfishCharacterNearby():
	var adjacentSlots = currentSlot.get_parent().returnAdjacentSlots(currentSlot)
	var selfishCharacter = null
	for slot in adjacentSlots:
		if slot.characterInSlot.hasAttribute("Selfish"):
			selfishCharacter = slot.characterInSlot
	return selfishCharacter



func processDroppedItem(dispenser):
	if(dispenser.dispensedItem == dispenser.ItemOptions.health):
		changeStatValue(health, dispenser, dispenser.dispensedItemValue, false)
	elif(dispenser.dispensedItem == dispenser.ItemOptions.food):
		changeStatValue(sustenance, dispenser, dispenser.foodValues.pop_back(), false)
		if dispenser.givenAttributes.size() > 0:
			#if this food is contaminated and has any attributes to apply
			#TODO:have the contaminated food look stinky/gross on click-and-drag
			var attributesToApply = dispenser.givenAttributes.pop_back()
			for attribute in attributesToApply:
				applyNewAttribute(attribute)

	System.emit_signal("dispensedItemConsumed", dispenser, self)

func _process(delta):

	pass
	# if(handInZone && Input.is_action_pressed("left_click")):
	# 	if(!dragging):
	# 		System.emit_signal("draggingCharacter", self)
	# 		dragging = true

	# if(dragging && Input.is_action_pressed("left_click")):
	# 	pass
	# else:
	# 	if(dragging):
	# 		dragging = false
	# 		System.emit_signal("stoppedDraggingCharacter", self)



func _on_Character_area_entered(area):
	if(area.name == "Hand"):
		handInZone = true
		if(!viewingCharacterDetail):
			#if the character detail panel isn't already locked in
			characterStats.showDisplay()


func _on_Character_area_exited(area):
	if(area.name == "Hand"):
		handInZone = false
		#print("Hovering panel" + characterStats.hoveringOverPanel)
		if(!viewingCharacterDetail):
			#if the mouse isn't on the player anymore, and also isn't
			#hovering over the panel, hide the display
			characterStats.hideDisplay()

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
	#applyNewAttribute(AttributeJSONParser.fetchAndCreateAttribute("Smelly"))
	Die(null, false)

func _on_FasterHealthDrain_pressed():
	applyNewAttribute(AttributeJSONParser.fetchAndCreateAttribute("Diseased"))


func _on_Attack_pressed():
	removeAttributeByName("Diseased")
	#changeStatValue(sustenance, null, -100, false)

func _on_Tween_tween_completed(object, key):
	print(str(object) + " Tween completed")

func _on_Tween_tween_step(object, key, elapsed, value):
	if object.currentValue <= 0:
		emit_signal("statAtZero", object)
		if object == health:
			Die(null, true)
		if object == sustenance:
			Starve()

	if object.currentValue >= object.maxValue:
		emit_signal("statAtMax", object)

func _on_Character_mouse_entered():
	handInZone = true
	droppableZone.handInZone = true
	draggableItem.handInZone = true
	System.emit_signal("HoveringOverInteractibleZone")
	if(!viewingCharacterDetail):
			#if the character detail panel isn't already locked in
			characterStats.showDisplay()



func _on_Character_mouse_exited():
	handInZone = false
	droppableZone.handInZone = false
	draggableItem.handInZone = false
	System.emit_signal("StoppedHoveringOverInteractibleZone")
	if(!viewingCharacterDetail):
		#if the character viewing isn't locked in and the mouse is no longer hoevring over the character
		characterStats.hideDisplay()
