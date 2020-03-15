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

func setStatBars():
	statBars = {character.health: healthBar, character.sustenance: sustenanceBar, character.sanity: sanityBar, character.relationship: relationshipBar}
	statTweens = {character.health: healthTween, character.sustenance: sustenanceTween, character.sanity: sanityTween, character.relationship: relationshipTween}
	statAnimationPlayers = {character.health: healthAnimationPlayer, character.sustenance: sustenanceAnimationPlayer, character.sanity: sanityAnimationPlayer, character.relationship: relationshipAnimationPlayer}

func _ready():

	# self.connect("mouse_enter", self, "mouseOverPanel")
	# for child in statUIChildren:
	# 	print(str(child))
	# 	child.connect("mouse_enter", self, "mouseOverPanel")
	# 	child.connect("mouse_exit", self, "mouseNotOverPanel")

	hoveringOverPanel = false
	character.connect("newAttributeAdded", self, "addAttributeToPanel")
	character.connect("attributeRemoved", self, "removeAttributeFromPanel")
	if character != null:
		if character.characterName != null:
			nameLabel.text = "Name: " + character.characterName
	self.modulate = Color(1, 1, 1, 0)
	#hideDisplay()
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
	if attribute.specialAttribute == true:
		return
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

func removeAttributeFromPanel(attribute):

	#remove from our array of attributes
	attributeArray.erase(attribute)

	#find the instance of the descriptor
	# for item in attributeHolder.get_children():
	# 	print(item.name +  " vs " + attribute.attributeName)

	var attributeDescriptorInstance = attributeHolder.get_node(attribute.attributeName)

	#remove the descriptor object from the node tree in game
	attributeHolder.remove_child(attributeDescriptorInstance)

	#erase from the statUiChildren array, which is the list of cihldren in the panel
	statUIChildren.erase(attributeDescriptorInstance)

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

func SetToLeftFacingPosition():
	#character is sitting on right of room
	self.rect_position = character.leftFacingPosition.position

func SetToRightFacingPosition():
	#character is sitting on right of room
	self.rect_position = character.rightFacingPosition.position
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

func changeBarMaxValue(whichBar, newMaxValue):
	match whichBar:
		healthBar:
			healthBar.max_value = newMaxValue
		sustenanceBar:
			sustenanceBar.max_value = newMaxValue
		sanityBar:
			sanityBar.max_value = newMaxValue
		relationshipBar:
			relationshipBar.max_value = newMaxValue

func stopAnimatingBar(certainTween):
	#you can use STOP ALL here, as these tweens should only be animating a specific thing, the 'value' of the bar
	#the tween ($TWEEN) back in the Character script is handling all the different stats
	certainTween.stop_all()

func animateBar(affectedStat, startValue, targetValue, rate):#certainTween, certainBar, startValue, targetValue, rate):
	var certainBar = statBars[affectedStat]
	var certainTween = statTweens[affectedStat]
	if !certainTween.is_active():
		certainTween.stop_all()
	# if(certainBar == healthBar):
	# 	if(!isHealthTweenRunning):
	# 		isHealthTweenRunning = true
	# 	else:
	# 		healthTween.stop_all()
	# elif(certainBar == sustenanceBar):
	# 	if(!isSustenanceTweenRunning):
	# 		isSustenanceTweenRunning = true
	# 	else:
	# 		sustenanceTween.stop_all()
	# elif(certainBar == sanityBar):
	# 	if(!isSanityTweenRunning):
	# 		isSanityTweenRunning = true
	# 	else:
	# 		sanityTween.stop_all()
	# elif(certainBar == relationshipBar):
	# 	if(!isRelationshipTweenRunning):
	# 		isRelationshipTweenRunning = true
	# 	else:
	# 		relationshipTween.stop_all()
	print("Sustenance value is " + str(character.sustenance.currentValue))
	print("Sustenance BAR value is " + str(sustenanceBar.value))
	#get_tree().paused = true
	sustenanceBar.value = character.sustenance.currentValue
	certainTween.interpolate_property(certainBar, 'value', affectedStat.currentValue + 1, targetValue, rate, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	certainTween.start()

func EatCheese(test):
	print("Cheese was eaten")

func _process(delta):
	healthLabel.text = str(int(character.health.currentValue)) + " / " + str(int(character.health.maxValue))
	sanityLabel.text = str(int(character.sanity.currentValue)) + " / " + str(int(character.sanity.maxValue))
	#sustenanceLabel.text = str(int(sustenanceBar.value)) + " / " + str(int(character.sustenance.maxValue))
	sustenanceLabel.text = str(int(character.sustenance.currentValue)) + " / " + str(int(character.sustenance.maxValue))
	relationshipLabel.text = str(int(character.relationship.currentValue)) + " / " + str(int(character.relationship.maxValue))

	pass



func _on_HealthTween_tween_completed(object, key):
	print("health tween completed")
	var stat = character.health
	var startHealth = stat.currentValue

	isHealthTweenRunning = false
	if(character.health.drainState == true):
		character.restartInterruptedDrain(stat)



func _on_SustenanceTween_tween_completed(object, key):

	isSustenanceTweenRunning = false
	var stat = character.sustenance
	var startSustenance = stat.currentValue

	if(character.sustenance.drainState == true):
		character.restartInterruptedDrain(stat)
		#animateBar(sustenanceTween, sustenanceBar, startSustenance, 0, character.calculateDrainRate(stat, character.valueDrainRates[stat]))
func _on_SustenanceTween_tween_step(object, key, elaspsed, value):
#	print(int(value))
	#sustenanceLabel.text = str(int(value)) + " / " + str(int(character.sustenance.maxValue))
	pass
func _on_SanityTween_tween_completed(object, key):

	isSanityTweenRunning = false

	var stat = character.sanity
	var startSanity = stat.currentValue

	if(character.sanity.drainState == true):
		character.restartInterruptedDrain(stat)
		#animateBar(sanityTween, sanityBar, startSanity, 0, character.calculateDrainRate(character.valueDrainRates[stat]))


func _on_RelationshipTween_tween_completed(object, key):
	isRelationshipTweenRunning = false
	var stat = character.relationship
	var startRelationship = stat.currentValue
	if(character.relationship.drainState == true):
		character.restartInterruptedDrain(stat)
		#animateBar(relationshipTween, relationshipBar, startRelationship, 0, character.calculateDrainRate(character.valueDrainRates[stat]))
