extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var tags = []
var hullPoints = 30 
var stations  = []
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func ChangeHullPoints(amount):
	hullPoints += amount

func checkIfHasTag(tag):
	if tags.has(tag):
		return true
	else:
		return false

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
