extends Control

var attributeArray = []
var attributeDescriptorTemplate =  preload("res://AttributeDescriptor.tscn")

onready var attributeHolder = get_node("AttributeHolder")

onready var character = get_parent()
onready var healthBar = get_node("Panel/HealthBar")
onready var healthAnimationPlayer = healthBar.get_node("AnimationPlayer")
onready var healthLabel = healthBar.get_node("HealthLabel")
onready var healthTween = healthBar.get_node("HealthTween")
var healthIsDraining = false

onready var sustenanceBar = get_node("Panel/SustenanceBar")
onready var sustenanceLabel = sustenanceBar.get_node("SustenanceLabel")
onready var sustenanceAnimationPlayer = sustenanceBar.get_node("AnimationPlayer");
onready var sustenanceTween = sustenanceBar.get_node("SustenanceTween")
var sustenanceIsDraining = false

onready var relationshipBar = get_node("Panel/RelationshipBar")
onready var relationshipLabel = relationshipBar.get_node("RelationshipLabel")
onready var relationshipAnimationPlayer = relationshipBar.get_node("AnimationPlayer");
onready var relationshipTween = relationshipBar.get_node("RelationshipTween")
var relationshipIsDraining = false

onready var sanityBar = get_node("Panel/SanityBar")
onready var sanityLabel = sanityBar.get_node("SanityLabel")
onready var sanityTween = sanityBar.get_node("SanityTween")
onready var sanityAnimationPlayer = sanityBar.get_node("AnimationPlayer");
var sanityIsDraining = false

var statBars
var statTweens
var statAnimationPlayers

func _ready():
	character.connect("newAttributeAdded", self, "addAttributeToPanel")
	character.connect("statAtZero", self, "EatCheese")
	statBars = {System.DynamicStats.health: healthBar, System.DynamicStats.sustenance: sustenanceBar, System.DynamicStats.sanity: sanityBar, System.DynamicStats.relationship: relationshipBar}
	statTweens = {System.DynamicStats.health: healthTween, System.DynamicStats.sustenance: sustenanceTween, System.DynamicStats.sanity: sanityTween, System.DynamicStats.relationship: relationshipTween}
	statAnimationPlayers = {System.DynamicStats.health: healthAnimationPlayer, System.DynamicStats.sustenance: sustenanceAnimationPlayer, System.DynamicStats.sanity: sanityAnimationPlayer, System.DynamicStats.relationship: relationshipAnimationPlayer}

func addAttributeToPanel(attribute):
	attributeArray.append(attribute)
	var attributeDescriptorInstance = attributeDescriptorTemplate.instance()
	attributeDescriptorInstance.set_name(attribute.attributeName)
	attributeHolder.add_child(attributeDescriptorInstance)
	attributeDescriptorInstance.setAttribute(attribute)
	#TODO: DO THE EQUIVALENT FOR REMOVAL BELOW
	pass

func removeAttributeFromPanel(attribute):
	attributeArray.erase(attribute)

func hideDisplay():
	$Tween.stop_all()
	$Tween.interpolate_property(self, "modulate", Color(1, 1, 1, 1), Color(1, 1, 1, 0), 0.2, Tween.TRANS_LINEAR, Tween.EASE_IN)
	$Tween.start()
	pass

func showDisplay():
	$Tween.stop_all()
	$Tween.interpolate_property(self, "modulate", Color(1, 1, 1, 0), Color(1, 1, 1, 1), 0.15, Tween.TRANS_LINEAR, Tween.EASE_IN)
	$Tween.start()


func displayAttributes():
	pass

func displayConditions():
	pass

var isHealthTweenRunning = false
var isSustenanceTweenRunning = false
var isSanityTweenRunning = false
var isRelationshipTweenRunning = false


func stopAnimatingBar(certainTween):
	#you can use STOP ALL here, as these tweens should only be animating a specific thing, the 'value' of the bar
	#the tween ($TWEEN) back in the Character script is handling all the different stats
	certainTween.stop_all()

func animateBar(certainTween, certainBar, startValue, targetValue, rate):
	if(certainBar == healthBar):
		if(!isHealthTweenRunning):
			isHealthTweenRunning = true
		else:
			healthTween.stop_all()
	elif(certainBar == sustenanceBar):
		if(!isSustenanceTweenRunning):
			isSustenanceTweenRunning = true
		else:
			sustenanceTween.stop_all()
	elif(certainBar == sanityBar):
		if(!isSanityTweenRunning):
			isSanityTweenRunning = true
		else:
			sanityTween.stop_all()
	elif(certainBar == relationshipBar):
		if(!isRelationshipTweenRunning):
			isRelationshipTweenRunning = true
		else:
			relationshipTween.stop_all()
	certainTween.interpolate_property(certainBar, 'value', startValue, targetValue, rate, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	certainTween.start()

func EatCheese(test):
	print("Cheese was eaten")

func _process(delta):
	healthLabel.text = str(int(character.currentHealth)) + " / " + str(int(character.maxHealth))
	sanityLabel.text = str(int(character.currentSanity)) + " / " + str(int(character.maxSanity))
	sustenanceLabel.text = str(int(character.currentSustenance)) + " / " + str(int(character.maxSustenance))
	relationshipLabel.text = str(int(character.currentRelationship)) + " / " + str(int(character.maxRelationship))
	pass



func _on_HealthTween_tween_completed(object, key):
	print("health tween completed")
	var stat = character.DynamicStats.health
	var startHealth = character.currentHealth
	isHealthTweenRunning = false
	if(character.statDrainState[stat] == true):
		#print("Current health" + str(character.currentHealth))

		#The health itself isn't restarting to drain here
		character.restartInterruptedDrain(stat)
		#animateBar(healthTween, healthBar, startHealth, 0, character.calculateDrainRate(character.valueDrainRates[stat]))

func _on_SustenanceTween_tween_completed(object, key):

	isSustenanceTweenRunning = false
	var stat = character.DynamicStats.sustenance
	var startSustenance = character.currentSustenance

	if(character.statDrainState[stat] == true):
		character.restartInterruptedDrain(stat)
		#animateBar(sustenanceTween, sustenanceBar, startSustenance, 0, character.calculateDrainRate(stat, character.valueDrainRates[stat]))

func _on_SanityTween_tween_completed(object, key):

	isSanityTweenRunning = false

	var stat = character.DynamicStats.sanity
	var startSanity = character.currentSanity

	if(character.statDrainState[stat] == true):
		character.restartInterruptedDrain(stat)
		#animateBar(sanityTween, sanityBar, startSanity, 0, character.calculateDrainRate(character.valueDrainRates[stat]))


func _on_RelationshipTween_tween_completed(object, key):
	isRelationshipTweenRunning = false
	var stat = character.DynamicStats.relationship
	var startRelationship = character.currentRelationship
	if(character.statDrainState[stat] == true):
		character.restartInterruptedDrain(stat)
		#animateBar(relationshipTween, relationshipBar, startRelationship, 0, character.calculateDrainRate(character.valueDrainRates[stat]))


func _on_Panel_mouse_entered():
	pass # Replace with function body.


func _on_Panel_mouse_exited():
	pass # Replace with function body.
