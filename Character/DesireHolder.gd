extends Area2D

var handInZone = false
onready var anim = get_node("AnimationPlayer")

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
	if ourType == 0:
		#our type is a subject
		self.modulate = Color.blue;
	elif ourType == 1:
		#our type is a topic
		self.modulate = Color.green;
	elif ourType == 2:
		#our type is a verb
		self.modulate = Color.red;

signal desireRegistered(desire)

func processDroppedItem(desire):
	#make it so if the desire is moved, it unregisters it
	print("Dropped desire in me " + self.name)
	if desire.global_position.distance_to(self.global_position) <= 70:
		desire.global_position = self.global_position
		anim.play("Signal")
		emit_signal("desireRegistered", desire)
		currentDesire = desire
	# if desire.has_method("shrink"):
	# 	desire.shrink()
	pass


func _on_DesireHolder_mouse_entered():
	handInZone = true
	pass # Replace with function body.


func _on_DesireHolder_mouse_exited():
	handInZone = false
	pass # Replace with function body.
