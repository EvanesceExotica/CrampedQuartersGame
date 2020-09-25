extends Node2D


var triangleShape = preload("res://Character/ConversationSprites/TriangleShape.png")
var hexShape = preload("res://Character/ConversationSprites/HexShape.png")
var circleShape =  preload("res://Character/ConversationSprites/CircleShape.png")
var diamondShape = preload("res://Character/ConversationSprites/DiamondShape.png")


onready var dragSprite = get_node("Sprite")
var desireName = ""
onready var desireText = get_node("DesireText")
var notDraggable = false
var beingDragged = false
var handInZone = false

var randomDesireList = ["environment", "food", "weather", "culture", "money", "politics", "health", "fashion", "travel", "crime", "entertainment", "animals", "science", "family", "romance", "plasure"]
var randomSubjectList = ["I", "you"]
var randomVerbList = ["love", "hate", "fear", "want"]

enum desireType{
	subject,
	topic,
	verb
}

export(desireType) var ourType = desireType.topic


func _ready():
	$AnimationPlayer.play_backwards("Pop")
	desireText.modulate = Color.black

func get_class():
	.get_class()
	return "Desire"

func setOurType(type):
	if type == 0:
		#our type is a subject
		ourType = 0
		dragSprite.texture = diamondShape
	#	self.modulate = Color.blue;
	elif type == 1:
		#our type is a topic
		ourType = 1
		dragSprite.texture = circleShape
	#	self.modulate = Color.green;
	elif type == 2:
		#our type is a verb
		ourType = 2
		dragSprite.texture = hexShape
	#	self.modulate = Color.red;

func setDesireName(name):
	desireName = name
	desireText.text = desireName

func generateRandomVerb():
	desireName = ChooseRandom.ChooseRandomFromList(randomVerbList)
	desireText.text = desireName
	ourType = desireType.verb
	
func generateRandomDesire():
	#will pick a random desire from the test list above and set the desire name to equal it; for testing purposes
	desireName = ChooseRandom.ChooseRandomFromList(randomDesireList)
	desireText.text = desireName

func setBeingDragged(_beingDragged):
	beingDragged = _beingDragged

func _process(delta):
	if beingDragged:
		updateDragPosition()

func updateDragPosition():
	self.global_position = get_global_mouse_position()

func _on_Area2D_mouse_entered():
	handInZone = true

func _on_Area2D_mouse_exited():
	handInZone = false

func Pop():
	$AnimationPlayer.play("Pop")
	yield($AnimationPlayer, "animation_finished")
	self.queue_free()


func ChangeColor(startColor, endColor):
	$Tween.interpolate_property(self, "modulate", startColor, endColor, 0.3, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()

func shrink():
	$Tween.stop_all()
	var startScale = self.scale
	var endScale = Vector2(0, 0)
	$Tween.interpolate_property(self, "scale", startScale, endScale, 0.3, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()

