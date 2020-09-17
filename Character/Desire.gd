extends Node2D

onready var dragSprite = get_node("Sprite")
var desireName = ""
onready var desireText = get_node("DesireText")
var notDraggable = false
var beingDragged = false
var handInZone = false

var randomDesireList = ["environment", "food", "weather", "culture", "money", "politics", "health", "fashion", "travel", "crime", "entertainment", "animals", "science", "family", "romance", "plasure"]

func _ready():
	pass

func get_class():
	.get_class()
	return "Desire"

func setDesireName(name):
	desireName = name
	desireText.text = desireName

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

func shrink():
	$Tween.stop_all()
	var startScale = self.scale
	var endScale = Vector2(0, 0)
	$Tween.interpolate_property(self, "scale", startScale, endScale, 0.3, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()

