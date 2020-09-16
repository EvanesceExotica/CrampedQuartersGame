extends Node2D

var character = get_parent()
onready var area2d = get_node("Area2D")
onready var colShape2d = area2d.get_node("CollisionShape2D")
var conversationNodeTemplate = preload("res://Character/Desire.tscn")
var currentDialogue = []
onready var holderNode = get_node("HolderNode")
var dialogueNodes = holderNode.get_children()

signal dialogueNodesFilled(dialogue)
var nodesFilled = 0
var maxNodes = 3

func _ready():
	GenerateConversationNodes()

func GenerateConversationNodes():
	Spawner.spawn(area2d, colShape2d, conversationNodeTemplate, 3, self)

func AffectRelationship(amount):
	character.relationship.currentValue += amount
	
func fillDialogNode():
	nodesFilled+=1
	if nodesFilled == maxNodes:
		emit_signal("dialogueNodesfilled", currentDialogue)


