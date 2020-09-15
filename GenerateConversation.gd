extends Node2D

var character = get_parent()
onready var area2d = get_node("Area2D")
onready var colShape2d = area2d.get_node("CollisionShape2D")
var conversationNodeTemplate = preload("res://Character/Desire.tscn")

func _ready():
	GenerateConversationNodes()

func GenerateConversationNodes():
	Spawner.spawn(area2d, colShape2d, conversationNodeTemplate, 3, self)

func AffectRelationship(amount):
	character.relationship.currentValue += amount
