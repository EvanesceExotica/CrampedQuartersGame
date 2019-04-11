extends Node2D


var handInZone = false

var dragging = true

signal draggingCharacter(character)
signal stoppedDraggingCharacter(character)
#warning-ignore:unused_class_variable
var characterName
#warning-ignore:unused_class_variable
var characterAttributes = { }

onready var characterStats = get_node("CharacterStats")

#this dictionary is to handle which dynamic stat is being effected by a drain source
var statDrainSources = { DynamicStats.health: [], DynamicStats.sustenance: [], DynamicStats.sanity: [], DynamicStats.relationship: [] }
var statDrainState = {DynamicStats.health: false, DynamicStats.sustenance: false, DynamicStats.sanity: false, DynamicStats.relationship: false}
var statDrainRates = {DynamicStats.health: 3, DynamicStats.sustenance: 3, DynamicStats.sanity: 3, DynamicStats.relationship: 3}
var statCurrentValues = {DynamicStats.health: 100, DynamicStats.sustenance: 100, DynamicStats.sanity: 100, DynamicStats.relationship: 50}
var statMaxValues = {DynamicStats.health: 100, DynamicStats.sustenance: 100, DynamicStats.sanity: 100, DynamicStats.relationship: 50}
var statPropertyNames = {DynamicStats.health: 'currentHealth', DynamicStats.sustenance: 'currentSustenance', DynamicStats.sanity: 'currentSanity', DynamicStats.relationship: 'currentRelationship'}
var staticStatValues = {StaticStats.damageDealt: 25, StaticStats.spaceRequirement : 1}

signal MouseHover

var health = Stat.new(Stat.StatType.health)
var sustenance = Stat.new(Stat.StatType.sustenance)
var sanity = Stat.new(Stat.StatType.sanity)
var relationship = Stat.new(Stat.StatType.relationship)

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


var conditions = []

func addNewCondition(condition):

	#check what stats the condition effects, and apply
	#
	pass

func applyConditionEffects(condition):
	pass

#[Dynamic Stats]
#warning-ignore:unused_class_variable
var maxHealth = 100
var currentHealth = 100
#warning-ignore:unused_class_variable
var healthDraining = false

var healthLossRate = 3
var healthGainRate = 3



onready var healthBar = get_node("CharacterStats/Panel/HealthBar")
onready var healthTween = healthBar.get_node("HealthTween")

func applyNewAttribute(newAttribute):
	var newTrait = newAttribute
	for oldTrait in characterAttributes:
		if(newTrait.ConflictingAttributes.has(oldTrait)):
			#don't apply
			pass
	if(newTrait.AffectedDynamicStatsCurrent.size() > 0):
		#for immediate "chunks" of damage
		for currentDynamicStat in newTrait.AffectedDynamicStatsCurrent.keys():
			changeStatValue(currentDynamicStat, newTrait.AffectedDynamicStatsCurrent[currentDynamicStat], false)
			#statCurrentValues[currentDynamicStat] - newTrait.AffectedDynamicStatsCurrent[currentDynamicStat]
			pass
		pass
	if(newTrait.AffectedDynamicStatsMax.size() > 0):
		#for things that affect maxStats
		for maxDynamicStat in newTrait.AffectedDynamicStatsMax.keys():
			#changeStatValue(currentDynamicStat, newTrait.AffectedDynamicStatsMax[maxDynamicStat], true)
			#statMaxValues[maxDynamicStat] * newTrait.AffectedDynamicStatsMax[maxDynamicStat]
			changeMaxStatValue(maxDynamicStat, newTrait.AffectedDynamicStatsMax[maxDynamicStat])
		pass
	if(newTrait.AffectedStaticStats.size() > 0):
		#for things that are affecting the static stats
		for staticStat in newTrait.AffectedStaticStats.keys():
			staticStatValues[staticStat] + newTrait.AffectedStaticStats[staticStat]
		pass
	if(newTrait.DrainingDynamicStats.size() > 0):
		#how many points drained per second
		for drainedDynamicStat in newTrait.DrainingDynamicStats.keys():
			print("This is what our trait drains " + str(newTrait.DrainingDynamicStats[drainedDynamicStat]))
			addNewDrainSource(drainedDynamicStat, null, newTrait.DrainingDynamicStats[drainedDynamicStat])
			#drainValueOverTime(drainedDynamicStat, newTrait, newTrait.DrainingDynamicStats[drainedDynamicStat])
			#statCurrentValues[drainedDynamicStat]
	characterAttributes.append(newAttribute)
	if(newAttribute.attributeTypes.has(Attribute.attributeTypes.temporaryCondition)):
		#here we set a countdown
		yield(get_tree().create_timer(newAttribute.duration), "timeout")
		removeAttribute(newAttribute)
		# var timer = timer.new()
		# #timer.connect("timeout", self, "removeAttribute", attribute)
		# timer.set_wait_time(newAttribute.duration)
		# timer.start()
		# yield(timer, "removeAttribute", newAttribute)
		#
		pass

func applyNewAttributes(newAttributes):
	for newTrait in newAttributes:
		for oldTrait in characterAttributes:
			if(newTrait.ConflictingAttributes.has(oldTrait)):
				#don't apply
				pass
		if(newTrait.AffectedDynamicStatsCurrent.size > 0):
			#for immediate "chunks" of damage
			for currentDynamicStat in newTrait.AffectedDynamicStatsCurrent.keys:
				changeStatValue(currentDynamicStat, newTrait.AffectedDynamicStatsCurrent[currentDynamicStat], false)
				#statCurrentValues[currentDynamicStat] - newTrait.AffectedDynamicStatsCurrent[currentDynamicStat]
				pass
			pass
		if(newTrait.AffectedDynamicStatsMax.size > 0):
			#for things that affect maxStats
			for maxDynamicStat in newTrait.AffectedDynamicStatsMax.keys:
				#changeStatValue(currentDynamicStat, newTrait.AffectedDynamicStatsMax[maxDynamicStat], true)
				statMaxValues[maxDynamicStat] * newTrait.AffectedDynamicStatsMax[maxDynamicStat]
			pass
		if(newTrait.AffectedStaticStats.size > 0):
			#for things that are affecting the static stats
			for staticStat in newTrait.AffectedStaticStats.keys:
				staticStatValues[staticStat] + newTrait.AffectedStaticStats[staticStat]
			pass
		if(newTrait.DrainingDynamicStats.size > 0):
			#how many points drained per second
			for drainedDynamicStat in newTrait.DrainingDynamicStats.keys:
				drainValueOverTime(drainedDynamicStat, newTrait, newTrait.DrainingDynamicStats[drainedDynamicStat])
				#statCurrentValues[drainedDynamicStat]
			pass
	pass

func removeAttribute(attribute):
	#TODO: Switch these variables so that they are being removed instead 
	if(newTrait.AffectedDynamicStatsCurrent.size > 0):
				#for immediate "chunks" of damage
		for currentDynamicStat in newTrait.AffectedDynamicStatsCurrent.keys:
			changeStatValue(currentDynamicStat, newTrait.AffectedDynamicStatsCurrent[currentDynamicStat], false)
				pass
			pass
	if(newTrait.AffectedDynamicStatsMax.size > 0):
			#for things that affect maxStats
		for maxDynamicStat in newTrait.AffectedDynamicStatsMax.keys:
			statMaxValues[maxDynamicStat] * newTrait.AffectedDynamicStatsMax[maxDynamicStat]
			pass
	if(newTrait.AffectedStaticStats.size > 0):
			#for things that are affecting the static stats
		for staticStat in newTrait.AffectedStaticStats.keys:
			staticStatValues[staticStat] + newTrait.AffectedStaticStats[staticStat]
			pass
	if(newTrait.DrainingDynamicStats.size > 0):
			#how many points drained per second
		for drainedDynamicStat in newTrait.DrainingDynamicStats.keys:
			RemoveNewDrainSource(drainedDynamicStat, newTrait, newTrait.DrainingDynamicStats[drainedDynamicStat])

	characterAttributes.remove(newAttribute)
func _SetInitialValues(conditions, attributes):
	pass
func SetInitialValues(conditions, attributes):
	#this will run when the character is first instantiated
	#it will run through the conditions and attributes and set the values appropriately

	healthBar.max_value = maxHealth
	healthBar.value = currentHealth

	sanityBar.max_value = maxSanity
	sanityBar.value = currentSanity

	sustenanceBar.max_value = maxSustenance
	sustenanceBar.value = currentSustenance

	relationshipBar.max_value = maxRelationship
	relationshipBar.value = currentRelationship

	pass

func changeHealth(value):
	currentHealth+=value
	if(currentHealth <= 0):
		currentHealth = 0
		emit_signal("healthAtZero")

var healthDrainSources = []
var totalHealthDrainRate = 30
var pointsDrainedPerSecond = 3
var healthPointsDrainedPerSecond = 3

var sustenanceDraining = false

var sanityDraining = false

var relationshipDraining = false



func calculateDrainRate(whichStat, pointsDrainedPerSecond):

	#this will determine how many seconds total the drain should take if we're trying to drain X points per second
	#current health = points to drain divided by points per second drained = how many seconds it should take
	var currentValue
	if(whichStat == DynamicStats.health):
		currentValue = currentHealth
	elif(whichStat == DynamicStats.sustenance):
		currentValue = currentSustenance
	elif(whichStat == DynamicStats.sanity):
		currentValue = currentSanity
	elif(whichStat == DynamicStats.relationship):
		currentValue = currentRelationship

	print("Current value " + str(currentValue) + "Points per second " + str(pointsDrainedPerSecond) + " = " + str(currentValue/pointsDrainedPerSecond))

	var rate = currentValue/pointsDrainedPerSecond


	return rate

func addNewDrainSource(whichStat, drainSource : DrainSource, newDrainPerSecond):
	#uncomment these after seeing if base version works
	#statDrainSources[drainSource.effectedStat].append(drainSource)

	#statDrainState[drainSource.effectedStat] = true

	#this is adding to the sources that may be draining the  stat
	statDrainSources[whichStat].append(drainSource)

	#this is determining wether the stat is overall being drained, which if the sources are greater than one, yes
	statDrainState[whichStat] = true

	#RATES -- determining the drain rate (how many points are being drained per second) and adding to it
	statDrainRates[whichStat]+= newDrainPerSecond

	if(statDrainRates[whichStat] >= 20):
		statDrainRates[whichStat] = 20

	drainValueOverTime(whichStat, drainSource, calculateDrainRate(whichStat, statDrainRates[whichStat]))

func RemoveNewDrainSource(whichStat, drainSource, newDrainPerSecond):
	if(statDrainSources[whichStat].size() > 0):
		#if there are still sources draining the health, remove the drain source not acting any longer,
		# and start over the healthTween with the decreased rate

		if(statDrainSources[whichStat].has(drainSource)):
			statDrainSources[whichStat].remove(drainSource)

			statDrainRates[whichStat] -= newDrainPerSecond
			#pointsDrainedPerSecond -= newDrainPerSecond
			drainHealthOverTime(drainSource, calculateDrainRate(whichStat, statDrainRates[whichStat]))

	if(statDrainSources[whichStat].size() == 0):
		#if there aren't any sources draining any longer, set to false
		statDrainState[whichStat] = false

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

func restartInterruptedDrain(whichStat):

	var currentValue = DetermineWhichValue(whichStat)
	if(statDrainSources[whichStat].size() > 0 && currentValue > 0):
		#only restart if there's some shit still draining
		drainValueOverTime(whichStat, null, 2)



func drainValueOverTime(whichStat, drainSource, rate):

	var whichProperty
	var currentValue
	var whichBar
	var whichTween
	var whichPointsDrainedPerSecond

	whichProperty = statPropertyNames[whichStat]
	currentValue = statCurrentValues[whichStat]
	whichBar = characterStats.statBars[whichStat]
	whichTween = characterStats.statTweens[whichStat]
	whichPointsDrainedPerSecond = statDrainRates[whichStat]

	$Tween.stop(self, whichProperty)
	#
	# if(whichValue == DynamicStats.health):
	# 	whichProperty = "currentHealth"
	# 	currentValue = currentHealth
	# 	whichBar = characterStats.healthBar
	# 	whichTween = characterStats.healthTween
	# 	whichPointsDrainedPerSecond = statDrainRates[whichValue]
	# 	$Tween.stop(self, "currentHealth")
	#
	# elif(whichValue == DynamicStats.sustenance):
	# 	whichProperty = "currentSustenance"
	# 	currentValue = currentSustenance
	# 	whichBar = characterStats.sustenanceBar
	# 	whichTween = characterStats.sustenanceTween
	# 	whichPointsDrainedPerSecond = statDrainRates[whichValue]
	# 	$Tween.stop(self, "currentSustenance")
	#
	# elif(whichValue == DynamicStats.sanity):
	# 	whichProperty = "currentSanity"
	# 	currentValue = currentSanity
	# 	whichBar = characterStats.sanityBar
	# 	whichTween = characterStats.sanityTween
	# 	whichPointsDrainedPerSecond = statDrainRates[whichValue]
	# 	$Tween.stop(self, "currentSanity")
	#
	# elif(whichValue == DynamicStats.relationship):
	# 	whichProperty = "currentRelationship"
	# 	currentValue = currentRelationship
	# 	whichBar = characterStats.relationshipBar
	# 	whichTween = characterStats.relationshipTween
	# 	whichPointsDrainedPerSecond = statDrainRates[whichValue]
	# 	$Tween.stop(self, "currentRelationship")

	$Tween.interpolate_property(self, whichProperty, currentValue, 0, calculateDrainRate(whichStat, whichPointsDrainedPerSecond), Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()

	characterStats.animateBar(whichTween, whichBar, currentValue, 0, calculateDrainRate(whichStat, whichPointsDrainedPerSecond))

func drainHealthOverTime(drainSource, rate):
	var startHealth = currentHealth
	#print("Current health " + str(currentHealth))
	$Tween.stop_all()
	$Tween.interpolate_property(self, 'currentHealth', startHealth, 0, rate, Tween.TRANS_LINEAR, Tween.EASE_IN)
	$Tween.start()
	#things like fires, injury, or disease
	#if(healthDrainSources.size() > 0):
	#	totalHealthDrainRate-= rate
	#characterStats.animateBar(characterStats.healthTween, characterStats.healthBar, startHealth, 0, calculateDrainRate(pointsDrainedPerSecond))

	#each time a new thing affects the healthbar, reset the tween and have it animate again w/ new rates afterward
	pass

var isHealthTweenIsRunning = false
#restart the tween if draining
func animate_healthBar(targetValue, rate):
	healthTween.stop()
	if(!isHealthTweenIsRunning):
		isHealthTweenIsRunning = true
		healthTween.interpolate_property(self, 'value', currentHealth, targetValue, rate, Tween.TRANS_SINE, Tween.EASE_IN)
		healthTween.start()
	#yield(healthTween, "tween_completed")


signal healthAtZero

#warning-ignore:unused_signal
signal updateHealthBar

var maxSustenance = 100
var currentSustenance = 100

var sustenanceLossRate = 3
var sustenanceGainRate = 3

onready var sustenanceBar = get_node("CharacterStats/Panel/SustenanceBar")



var drainingSustenance = true #TODO: Change back to false

func changeSustenance(value):
	currentSustenance+=value
	if(currentSustenance <= 0):
		currentSustenance = 0

func drainSustenanceOverTime():

	var timer = Timer.new()
	timer.connect("timeout", self, "onTimerTimeout")
	timer.set_wait_time(0.1)
	timer.set_one_shot(false)
	timer.start()





#warning-ignore:unused_signal
signal sustanceAtZero

#warning-ignore:unused_signal
signal updateSustenanceBar

#warning-ignore:unused_class_variable
var maxSanity = 100
var currentSanity = 100

var sanityLossRate = 3
var sanityGainRate = 3

#warning-ignore:unused_class_variable
onready var sanityBar = get_node("CharacterStats/Panel/SanityBar")

func changeSanity(value):
	currentSanity+=value
	if(currentSanity <= 0):
		currentSanity = 0

#warning-ignore:unused_signal
signal updateSanityBar

#warning-ignore:unused_class_variable
var maxRelationship = 100
var currentRelationship = 100

var relationshipLossRate = 3
var relationshipGainRate = 3

#this is for if anything doubles or reduces damage taken
var damageModifiers = []
var timer
func changeStatValue(dynamicStat, amount, isMultiplicative):
	var currentBar
	var currentTween
	var currentValue
	var startValue
	var endValue
	var currentAnim
	currentBar = characterStats.statBars[dynamicStat]
	currentTween = characterStats.statTweens[dynamicStat]
	currentAnim = characterStats.statAnimationPlayers[dynamicStat]
	startValue = statCurrentValues[dynamicStat]

	if(isMultiplicative):
		endValue = statCurrentValues[dynamicStat] * amount
	else:
		endValue = statCurrentValues[dynamicStat] + amount

	if($Tween.is_active()):
		$Tween.stop(self, statPropertyNames[dynamicStat])

	if(isMultiplicative):
			statCurrentValues[dynamicStat] *= amount
	else:
			statCurrentValues[dynamicStat] +=amount


	if(statCurrentValues[dynamicStat] < 0):
		statCurrentValues[dynamicStat] = 0
	if(statCurrentValues[dynamicStat] > statMaxValues[dynamicStat]):
		statCurrentValues[dynamicStat] = statMaxValues[dynamicStat]
	#
	# if(dynamicStat == DynamicStats.health):
	# 	currentAnim = characterStats.healthAnimationPlayer
	# 	currentBar = characterStats.healthBar
	# 	currentTween = characterStats.healthTween
	# 	startValue = currentHealth
	#
	# 	if(isMultiplicative):
	# 		endValue = currentHealth * amount
	# 	else:
	# 		endValue = currentHealth + amount
	#
	# 	if($Tween.is_active()):
	# 		#if we're already tweening health, stop it to restart
	# 		$Tween.stop(self, 'currentHealth')
	#
	#
	# 	#characterStats.animateBar(characterStats.healthTween, characterStats.healthBar, startHealth, endHealth, 0.5)
	#
	# 	if(isMultiplicative):
	# 		endValue = currentHealth * amount
	# 	else:
	# 		currentHealth+=amount
	#
	# 	if(currentHealth <= 0):
	# 		currentHealth = 0
	# 	if(currentHealth >= maxHealth):
	# 		currentHealth = maxHealth
	# if(dynamicStat == DynamicStats.sanity):
	# 	currentBar = characterStats.sanityBar
	# 	currentTween = characterStats.sanityTween
	# 	currentAnim = characterStats.sanityAnimationPlayer
	#
	# 	startValue = currentSanity
	# 	if(isMultiplicative):
	# 		endValue = currentSanity * amount
	# 	else:
	# 		endValue = currentSanity + amount
	#
	# 	if($Tween.is_active()):
	# 		$Tween.stop(self, 'currentSanity')
	#
	# 	if(isMultiplicative):
	# 		current *=  amount
	# 	else:
	# 		currentSanity+=amount
	#
	# 	if(currentSanity <= 0):
	# 		currentSanity = 0
	# 	if(currentSanity >= maxSanity):
	# 		currentSanity = maxSanity
	#
	# if(dynamicStat == DynamicStats.sustenance):
	# 	currentBar = characterStats.sustenanceBar
	# 	currentTween = characterStats.sustenanceTween
	# 	currentAnim = characterStats.sustenanceAnimationPlayer
	# 	startValue = currentSustenance
	# 	endValue = currentSustenance + amount
	#
	#
	# 	if($Tween.is_active()):
	# 		$Tween.stop(self, 'currentSustenance')
	#
	# 	currentSustenance+=amount
	# 	if(currentSustenance <= 0):
	# 		currentSustenance = 0
	# 	if(currentSustenance >= maxSustenance):
	# 		currentSustenance = maxSustenance
	#
	# if(dynamicStat == DynamicStats.relationship):
	# 	currentBar = characterStats.relationshipBar
	# 	currentTween = characterStats.relationshipTween
	# 	currentAnim = characterStats.relationshipAnimationPlayer
	#
	# 	startValue = currentRelationship
	# 	endValue = currentRelationship + amount
	#
	#
	# 	if($Tween.is_active()):
	# 		$Tween.stop(self, 'currentRelationship')
	#
	# 	currentRelationship+= amount
	#
	# 	if(currentRelationship <= 0):
	# 		currentRelationship = 0
	#
	# 	if(currentRelationship >= maxRelationship):
	# 		currentRelationship = maxRelationship
	#

	var statValueToSet = statPropertyNames[dynamicStat]
	set(statValueToSet, statCurrentValues[dynamicStat])

	#print(statPropertyNames[dynamicStat] + " " + str(statCurrentValues[dynamicStat]))
	if(amount < 0):
		currentAnim.play(currentBar.get_name() + "Flash")
		#currentBar.tint_progress = Color.red
		pass

	characterStats.animateBar(currentTween, currentBar, startValue, endValue, 0.25)


func changeMaxStatValue(whichStat, amount):
	statMaxValues[whichStat] *=  amount
	statCurrentValues[whichStat] > statMaxValues[whichStat]
	statCurrentValues[whichStat] = statMaxValues[whichStat]

	var statValueToSet = statPropertyNames[whichStat]
	set(statValueToSet, statCurrentValues[whichStat])
#warning-ignore:unused_class_variable
onready var relationshipBar = get_node("CharacterStats/Panel/RelationshipBar")

func changeRelationship(value):
	currentRelationship+= value
	if(currentRelationship <= 0):
		currentRelationship = 0

#warning-ignore:unused_signal
signal updateRelationshipBar

#[Static Stats]




func _ready():
	sustenanceBar.max_value = maxSustenance
	currentSustenance = maxSustenance
	System.connect("stoppedDraggingItem", self, "checkIfSomethingDropped")
#	sustenanceBar.max_value = maxSustenance


	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#warning-ignore:unused_argument

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
		characterStats.hideDisplay()
	pass # Replace with function body.


func _on_Button_pressed():
	var attribute = Attribute.new("OnFire")
	#attribute._init("OnFire")
	attribute.description = "Help I'm on fire"
	attribute.ConflictingAttributes.append("Underwater")
	attribute.ResultingAttributes =  ["Shaken"] #Attributes that will result from this one 'On Fire --> Shaken'
	attribute.AffectedDynamicStatsMax = {System.DynamicStats.sustenance : 0.5}
	attribute.AffectedDynamicStatsCurrent = {System.DynamicStats.sanity : -50}
	attribute.DrainingDynamicStats = { System.DynamicStats.health : 20} #if any dynamic stats are actively drained
	applyNewAttribute(attribute)
	#addNewDrainSource(DynamicStats.sanity, null, 1)
	#addHealthDrainSource("test", 1.0)

	pass # Replace with function body.


func _on_FasterHealthDrain_pressed():
	addNewDrainSource(DynamicStats.sanity, null, 2)
	#addHealthDrainSource("test2", 3.0)

	pass # Replace with function body.


func _on_Attack_pressed():
	print("Attack pressed")
	changeStatValue(DynamicStats.sanity, -30, false)
	pass # Replace with function body.

func _on_Tween_tween_step(object, key, elapsed, value):
	#this feels dirty. Maybe find a better way in the future
	if(key == ':currentHealth'):
		statCurrentValues[DynamicStats.health] = value
		print(statCurrentValues[DynamicStats.health])
	elif(key == ':currentSustenance'):
		statCurrentValues[DynamicStats.sustenance] = value
		print(statCurrentValues[DynamicStats.sustenance])
		pass
	elif(key == ':currentSanity'):
		statCurrentValues[DynamicStats.sanity] = value
		print(statCurrentValues[DynamicStats.sanity])
		pass
	elif(key == ':currentRelationship'):
		statCurrentValues[DynamicStats.relationship] = value
		print(statCurrentValues[DynamicStats.relationship])

func _on_Tween_tween_completed(object, key):
	if(object == self):
		if(key == 'currentHealth'):
			pass
		elif(key == 'currentSustenance'):
			pass
		elif(key == 'currentSanity'):
			pass
		elif(key == 'currentRelationship'):
			pass
