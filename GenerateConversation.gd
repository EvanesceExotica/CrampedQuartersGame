extends Node2D

var character = get_parent()
onready var area2d = get_node("Area2D")
onready var colShape2d = area2d.get_node("CollisionShape2D")
var conversationNodeTemplate = preload("res://Character/Desire.tscn")
var currentDialogue = []
#onready var holderNode = get_node("HolderNode")
var holderNode
var dialogueNodes

signal dialogueNodesFilled(dialogue)
var nodesFilled = 0
var maxNodes = 3

func _ready():
	holderNode = get_node("HolderNode")
	dialogueNodes = holderNode.get_children()
	for dNode in dialogueNodes:
		dNode.connect("desireRegistered", self, "fillDialogNode")
	GenerateConversationNodes()

func GenerateConversationNodes():
	#for now this spawns the interests/desires
	var spawnedObjects = Spawner.spawnAndReturn(area2d, colShape2d, conversationNodeTemplate, 3, self)
	for spawned in spawnedObjects:
		#generate a random desire name for the spawned nodes
		spawned.generateRandomDesire()

func AffectRelationship(amount):
	character.relationship.currentValue += amount
	
func fillDialogNode(desire):
	#incrase the nodes that have been filled and append to list. Once all filed, send to dialogue generator
	nodesFilled+=1
	print(str(nodesFilled) + " dialogue nodes filled")
	currentDialogue.append(desire.desireName)
	if nodesFilled == maxNodes:
		print("Nodes filled!")
		#this is connected to the "DialogueGenerators" generate response method
		emit_signal("dialogueNodesFilled", currentDialogue)


