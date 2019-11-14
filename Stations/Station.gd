extends Node2D


onready var warningFlash = get_node("WarningFlash")
onready var room
onready var interactionSpace = get_node("InteractionSpace")
# Declare member variables here. Examples:
# var a = 2
export (PackedScene) var minigameScreen

var screenInstance
#export var TypeOfStation
#maybe when health is low, have cracks and glitches on screen
var mouseHovering = false
var currentHealth = 3
var maxHealth = 3

#for how long until the station needs maintenance
var cooldownMaxValue = 15 
var cooldownMinValue = 10

#for how long the warning will go off until maintenance
var warningDuration = 10

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
func loadMinigameScene():

	#stop warning timer
	warningTimer.stop()
	print("Loading minigame scene")
	if screenInstance == null:
		screenInstance = minigameScreen.instance()
		get_parent().add_child(screenInstance)
	else:
		get_parent().add_child(screenInstance)

		#the game was a success, reset the maintenance timer
	screenInstance.connect("success", self, "resetMaintenanceTimer")
	screenInstance.connect("gameOver", self, "disableStation")
	screenInstance.initializeGame()

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
	hideAndStopWarningFlash()
	print("Station disabled! -- affects taking place!")
	#this happens when the station takes too much damage or a maintenance check is failed or runs out of time
	pass
func getHalfHealthValue():
	return int((floor(maxHealth/2)))

func damage(amount):

	pass
func damgeOverTime():
	pass
func repair():
	pass

func _ready():
	randomize()
	add_to_group("Stations")
	resetMaintenanceTimer()

func _input(event):
	if(event.is_action_pressed("ui_interact")):
		if(mouseHovering):
			loadMinigameScene()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _on_InteractionSpace_mouse_entered():
	mouseHovering = true

func _on_InteractionSpace_mouse_exited():
	mouseHovering = false


func _on_Button_pressed():
	disableStation()
	pass # Replace with function body.
