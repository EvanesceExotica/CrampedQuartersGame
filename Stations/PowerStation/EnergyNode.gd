extends Node2D

var moving = false
onready var parent = get_parent()
var currentIndex
var onLeftSide = true
signal canMoveAgain
var currentNode
var destinationNode
var previousNode
func _ready():
	pass

func moveNode(startNode, _destinationNode):
	#on the move, so not risking blowing up
	currentNode = startNode
	destinationNode = _destinationNode
	resetTimer()
	$Tween.interpolate_property(self, "position", currentNode.global_position, destinationNode.global_position, 2, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()

func _on_Tween_tween_completed(object, key):
	previousNode = currentNode
	currentNode = destinationNode
	currentIndex = parent.allNodes.find(currentNode)
	emit_signal("canMoveAgain")
	#resetTimer()
	pass

func resetTimer():
	$Timer.set_wait_time(rand_range(6, 10))
	$Timer.start()

func _on_Timer_timeout():
	print("BOOOOOM")
	#circuit overloaded
	
	pass
