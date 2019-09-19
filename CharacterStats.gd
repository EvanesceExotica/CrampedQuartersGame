extends Control


onready var nameLabel = get_node("Panel/NameLabel")
onready var scanLabel = get_node("ScanLabel")
var attributeArray = []
var attributeDescriptorTemplate =  preload("res://AttributeDescriptor.tscn")
var hoveringOverPanel = false
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

var statUIChildren = []
var statBars
var statTweens
var statAnimationPlayers

var displayVisible = false

# func _gui_input(event: InputEvent):
# 	# if(event == MOUSE_MOTION):
# 	# 	print("Hovering mouse hover")
# 	# if(event.type == InputEvent.MOUSE_MOTION):
# 	# 	print("Hovering mouse over")
# 	# if(event == InputEvent.MOUSE_MOTION):
# 	# 	print("hovering mouse over")
# 	if event is InputEventMouseMotion:
# 		hoveringOverPanel = true
# 		if(!displayVisible):
# 			displayVisible = true
# 	pass
func getAllNodes(node):
	for child in node.get_children():
		if child.get_node_count() > 0:
			statUIChildren.append(child)
			getAllNodes(child)


func _ready():

	# self.connect("mouse_enter", self, "mouseOverPanel")
	# for child in statUIChildren:
	# 	print(str(child))
	# 	child.connect("mouse_enter", self, "mouseOverPanel")
	# 	child.connect("mouse_exit", self, "mouseNotOverPanel")
	hoveringOverPanel = false
	character.connect("newAttributeAdded", self, "addAttributeToPanel")
	character.connect("statAtZero", self, "EatCheese")
	statBars = {System.DynamicStats.health: healthBar, System.DynamicStats.sustenance: sustenanceBar, System.DynamicStats.sanity: sanityBar, System.DynamicStats.relationship: relationshipBar}
	statTweens = {System.DynamicStats.health: healthTween, System.DynamicStats.sustenance: sustenanceTween, System.DynamicStats.sanity: sanityTween, System.DynamicStats.relationship: relationshipTween}
	statAnimationPlayers = {System.DynamicStats.health: healthAnimationPlayer, System.DynamicStats.sustenance: sustenanceAnimationPlayer, System.DynamicStats.sanity: sanityAnimationPlayer, System.DynamicStats.relationship: relationshipAnimationPlayer}
	nameLabel.text = "Name: " + character.characterName
# func mouseOverPanel():
# 	print("Mouse over panel!")
# 	hoveringOverPanel = true
# func mouseNotOverPanel():
# 	print("Mouse NOT ovr panel")
# 	hoveringOverPanel = false
# 	if(!character.handInZone):
# 		hideDisplay()

func addAttributeToPanel(attribute):
	#add to attribute array to keep track
	attributeArray.append(attribute)

	#instance the template, set name, add to holder which should align it
	var attributeDescriptorInstance = attributeDescriptorTemplate.instance()
	attributeDescriptorInstance.set_name(attribute.attributeName)
	attributeHolder.add_child(attributeDescriptorInstance)

	#add to the list of children of the panel
	statUIChildren.append(attributeDescriptorInstance)
#
	#attach the UI signals for hovering mouse over elements
	#attributeDescriptorInstance.connect("mouse_enter", self, "mouseOverPanel")
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

# func _on_Panel_mouse_entered():
# 	hoveringOverPanel = true
# 	pass
#
# func _on_Panel_mouse_exited():
# 	hoveringOverPanel = false
# 	if(!character.handInZone):
# 		#if the mouse isn't in the panel any longer, but also not on the player
# 		#hide the display
# 		hideDisplay()
# 	pass

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
