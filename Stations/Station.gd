extends Node2D

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

const hale = "hale"
const minorDamage = "minorDamage" #glitches appear on screen making it hard to see?
const majorDamage = "majorDamage" #non-functional but can be repaired
const destroyed = "destroyed"

signal newAttributeAdded
signal attributeRemoved

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
	print("Loading minigame scene")
	if screenInstance == null:
		screenInstance = minigameScreen.instance()
		get_parent().add_child(screenInstance)
	else:
		get_parent().add_child(screenInstance)
	screenInstance.initializeGame()

func addDamageTag(tag):
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

func getHalfHealthValue():
	return int((floor(maxHealth/2)))

func damage(amount):

	pass
func damgeOverTime():
	pass
func repair():
	pass

func _ready():
	add_to_group("Stations")

func _input(event):
	if(event.is_action_pressed("ui_interact")):
		if(mouseHovering):
			loadMinigameScene()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _on_InteractionSpace_mouse_entered():
	mouseHovering = true
	pass

func _on_InteractionSpace_mouse_exited():
	mouseHovering = false
	pass # Replace with function body.
