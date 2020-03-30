extends Node2D

onready var nameDisplay = get_node("ShowName")
onready var warningFlash = get_node("WarningFlash")
onready var room
onready var interactionSpace = get_node("InteractionSpace")

var disabled
var appliedAttributeOnFailure = ""
var createdAttribute
# Declare member variables here. Examples:
# var a = 2
export (PackedScene) var minigameScreen

var gardenDamagePerSecondOnFail = 0
var screenInstance
#export var TypeOfStation
#maybe when health is low, have cracks and glitches on screen
var mouseHovering = false
var currentHealth = 3
var maxHealth = 3

#for how long until the station needs maintenance
var cooldownMaxInGameHours = 2
var cooldownMinInGameHours = 1
var cooldownMaxValue = 500 
var cooldownMinValue = 200

#for how long the warning will go off until maintenance
export var warningDuration = 10

const hale = "hale"
const minorDamage = "minorDamage" #glitches appear on screen making it hard to see?
const majorDamage = "majorDamage" #non-functional but can be repaired
const destroyed = "destroyed"

signal newAttributeAdded
signal attributeRemoved

onready var maintenanceTimer = get_node("MaintenanceTimer")
onready var warningTimer =  get_node("WarningTimer")

var damageLevel
var tags = []

func addAttribute(attribute):
	emit_signal("newAttributeAdded")

func removeAttribute(attribute):
	emit_signal("attributeRemoved")

func interactWith():
	#different ways to interact with
	pass
# Called when the node enters the scene tree for the first time.
func loadMinigameScene(isRepairing):

	#stop warning timer
	warningTimer.stop()
	print("Loading minigame scene")
	if screenInstance == null:
		screenInstance = minigameScreen.instance()
		get_parent().add_child(screenInstance)
	else:
		get_parent().add_child(screenInstance)

		#the game was a success, reset the maintenance timer
	if !isRepairing:
		#if you're doing maintenance, and not repairing, have a success reset the maintenace timer, and a gameOver disable the station
		screenInstance.connect("success", self, "resetMaintenanceTimer")
		screenInstance.connect("gameOver", self, "disableStation")
	else:
		#if you're repairing, have a success re-enable the station, turning off the ill effects, and reset the maintenace timer
		screenInstance.connect("success", self, "enableStation")
		screenInstance.connect("success", self, "resetMaintenanceTimer")
	screenInstance.initializeGame()

func _loadMinigameScene(isReparing):
	if screenInstance == null:
		pass
	pass

func addDamageTag(tag):
	#damage makes games harder
	tags.append(tag)


func changeHealthAmount(amount):
	currentHealth+= int(amount)
	if currentHealth > maxHealth:
		currentHealth = maxHealth

	if currentHealth == 3:
		damageLevel = hale

	elif currentHealth == 2:
		damageLevel = minorDamage

	elif currentHealth == 1:
		damageLevel = majorDamage

	elif currentHealth == 0:
		damageLevel = destroyed
	# if currentHealth < maxHealth && currentHealth > getHalfHealthValue():
	# 	damageLevel = minorDamage
	# elif currentHealth <= getHalfHealthValue():
	# 	damageLevel = majorDamage
	# elif 

	# #environmental effects can deal damage to stations too
	# pass

func resetMaintenanceTimer():

	hideAndStopWarningFlash()
	var randomValue = rand_range(cooldownMinValue, cooldownMaxValue)
	maintenanceTimer.wait_time = randomValue
	maintenanceTimer.one_shot = true
	if !maintenanceTimer.is_connected("timeout", self, "callForMaintenance"):
		maintenanceTimer.connect("timeout", self, "callForMaintenance")
	maintenanceTimer.start()

func hideAndStopWarningFlash():
	warningFlash.StopWarningFlash()
	warningFlash.hide()

func showAndPlayWarningFlash():
	warningFlash.show()
	warningFlash.PlayWarningFlash()

func callForMaintenance():
	#here, the station will beep and show a warning, showing it's about to be disabled.
	showAndPlayWarningFlash()
	warningTimer.wait_time = warningDuration
	warningTimer.one_shot = true
	warningTimer.connect("timeout", self, "disableStation")
	warningTimer.start()
	#here, flash a red caution sign on the screen and a beeping noise
	pass

func disableStation():
	disabled = true
	hideAndStopWarningFlash()
	print("Station disabled! -- effects taking place!")
	#this happens when the station takes too much damage or a maintenance check is failed or runs out of time
	if appliedAttributeOnFailure != null:
		#if we have an attribute to apply  -- some stations won't
		print("Our failure is going to apply " + appliedAttributeOnFailure)
		if createdAttribute == null:
			#if our attribute has NOT already been created by the AttributeJsonParser, create it, and set it to createdAttribute to be used again later which will pass this null check
			createdAttribute = AttributeJSONParser.fetchAndCreateAttribute(appliedAttributeOnFailure)
		get_tree().call_group("slots", "applyNewAttributeToSlot", createdAttribute)

func enableStation():
	disabled = false
	if createdAttribute != null:
		#if this station has an attribute to apply
		get_tree().call_group("slots", "removeAttributeFromSlot", createdAttribute)
	pass
func getHalfHealthValue():
	return int((floor(maxHealth/2)))

func damage(amount):

	pass
func damgeOverTime():
	pass
func repair():
	print("Repairing!")
	loadMinigameScene(true)
	pass

func _ready():
	randomize()
	add_to_group("Stations")
	resetMaintenanceTimer()

func _input(event):
	if(event.is_action_pressed("ui_interact")):
		if(mouseHovering && !disabled):
			loadMinigameScene(false)
		elif(mouseHovering && disabled):
			repair()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _on_InteractionSpace_mouse_entered():
	mouseHovering = true
	nameDisplay.showDisplay()

func _on_InteractionSpace_mouse_exited():
	mouseHovering = false
	nameDisplay.hideDisplay()


func _on_Button_pressed():
	disableStation()
	pass # Replace with function body.
