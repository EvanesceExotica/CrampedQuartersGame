extends Area2D

var triangleHolder = preload("res://Character/ConversationSprites/TriangleHolder.png")
var hexHolder = preload("res://Character/ConversationSprites/HexHolder.png")
var circleHolder =  preload("res://Character/ConversationSprites/CircleHolder.png")
var diamondHolder = preload("res://Character/ConversationSprites/DiamondHolder.png")
var handInZone = false
onready var anim = get_node("AnimationPlayer")
var desireContained = false

enum desireType{
	subject,
	topic,
	verb
}

export(desireType) var ourType = desireType.topic

var currentDesire

func get_class():
	return "DesireHolder"

func _ready():
	setTypes()

	

func setTypes():
	if ourType == 0:
		#our type is a subject
		#self.modulate = Color.blue;
		$Sprite.texture = diamondHolder
	elif ourType == 1:
		#our type is a topic
		#self.modulate = Color.green;
		$Sprite.texture = circleHolder
	elif ourType == 2:
		#our type is a verb
		#self.modulate = Color.red;
		$Sprite.texture = hexHolder

signal desireRegistered(desire)
signal desireRemoved(desire)

func processDroppedItem(desire):
	#make it so if the desire is moved, it unregisters it
	print("Dropped desire in me " + self.name)
	if desire.ourType == ourType && currentDesire == null:
		#if the desire is of our type and we don't already have a current desire
		if desire.global_position.distance_to(self.global_position) <= 70:
			desire.global_position = self.global_position
			anim.play("Signal")
			emit_signal("desireRegistered", desire)
			currentDesire = desire
	else:
		print("Wrong type OR already full")

	# if desire.has_method("shrink"):
	# 	desire.shrink()
	pass


func removeDesire():
	emit_signal("desireRemoved", currentDesire)
	currentDesire = null


func _on_DesireHolder_mouse_entered():
	handInZone = true
	pass # Replace with function body.


func _on_DesireHolder_mouse_exited():
	handInZone = false
	#checking if it's been moved
	
func _process(delta):
	if currentDesire != null && System.dragging:
		if currentDesire.global_position.distance_to(self.global_position) > 70:
		#if the desire has been moved beyond the drop point
			removeDesire()
	pass
