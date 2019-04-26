extends Area2D

# Declare member variables here. Examples:
# var a = 2

var health = 3
# var b = "text"
func interactWith():
	#different ways to interact with
	pass
# Called when the node enters the scene tree for the first time.

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

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
