extends Node2D

var character = get_parent()

onready var responseGenerator = get_node("ResponseGenerator")
onready var area2d = get_node("Area2D")
onready var colShape2d = area2d.get_node("CollisionShape2D")
onready var conversationBar = get_node("ConversationBar")


var conversationNodeTemplate = preload("res://Character/Desire.tscn")
var currentDialogue = []
var currentSpawnedObjects = []

#onready var holderNode = get_node("HolderNode")
var holderNode
var dialogueNodes


signal dialogueNodesFilled(dialogue)
var nodesFilled = 0
var maxNodes = 3

func _ready():

	#if you stop interfacing with the character, delete yourself
	SignalManager.connect("StoppedInterfacingWithCharacter", self, "DeleteSelf")

	#get the node that holds the holders of the dialuge nodes
	holderNode = get_node("HolderNode")

	#get the holder nodes that the dialogue is going to be dropped into
	dialogueNodes = holderNode.get_children()
	for dNode in dialogueNodes:
		#connect the dialogue nodes so that they signal when conversation topics are dropped into them
		dNode.connect("desireRegistered", self, "fillDialogNode")
		
	#spawn the initial conversation nodes
	GenerateConversationNodes()
	
	#this signal connection will restart the conversation
	responseGenerator.connect("responseGenerated", self, "FormNewConversationThread")

	#disable innput on all objects except the needed ones
	print("Disabling input")
	get_tree().call_group("InputAreas", "disableInput", ["Desire", "DesireHolder"])
	

func GrowConversationBar():
	conversationBar.growBar(25, 0.5)

func FormNewConversationThread():
	GrowConversationBar()
	ShrinkOldNodes()
	GenerateConversationNodes()

func ShrinkOldNodes():
	#find all of the previous dialogues and srhink them when the new convo starts.
	for topic in currentDialogue:
		topic.Pop()
	for option in currentSpawnedObjects:
		option.Pop()
	#clear the dialogue so that a new batch of nodes can appear
	currentDialogue.clear()
	currentSpawnedObjects.clear()


func GenerateConversationNodes():
	print("Genereating nodes")
	#for now this spawns the interests/desires
	currentSpawnedObjects = Spawner.spawnAndReturn(area2d, colShape2d, conversationNodeTemplate, 9, self)

	var counter = 0;
	for spawned in currentSpawnedObjects:
		#generate a random desire name for the spawned nodes
		if counter < 3:
			spawned.generateRandomDesire()
		elif counter == 3:
			spawned.setDesireName("I")
		elif counter == 4:
			spawned.setDesireName("You")
		elif counter > 4:
			spawned.generateRandomVerb()
		counter+=1

func AffectRelationship(amount):
	character.relationship.currentValue += amount
	
func fillDialogNode(desire):
	#incrase the nodes that have been filled and append to list. Once all filed, send to dialogue generator
	nodesFilled+=1
	print(str(nodesFilled) + " dialogue nodes filled")
	currentDialogue.append(desire)
	if nodesFilled == maxNodes:
		print("Nodes filled!")
		#this is connected to the "DialogueGenerators" generate response method
		emit_signal("dialogueNodesFilled", currentDialogue)

		#reset nodes filled to zero for next one
		nodesFilled = 0

func endConversation():
	#this can be caused by the character taking damage, or you cancelling out
	#enable all of the input that was shut down
	get_tree().call_group("InputAreas", "enableInput")

func deleteSelf():
	self.queue_free()
