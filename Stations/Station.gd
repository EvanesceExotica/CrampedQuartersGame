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
var health = 3
# var b = "text"
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
func changeHealthAmount(amount):
	health+= amount
	#environmental effects can deal damage to stations too
	pass


func damage(amount):

	pass
func damgeOverTime():
	pass
func repair():
	pass

func _ready():
	pass # Replace with function body.
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
