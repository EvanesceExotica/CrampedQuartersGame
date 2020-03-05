extends Control

onready var text = get_node("Panel/Text")

func _ready():
   text.text =  get_parent().name + "\n Press E to interact."

func hideDisplay():
	$Tween.stop_all()
	$Tween.interpolate_property(self, "modulate", Color(1, 1, 1, 1), Color(1, 1, 1, 0), 0.2, Tween.TRANS_LINEAR, Tween.EASE_IN)
	$Tween.start()
	pass

func showDisplay():
	$Tween.stop_all()
	$Tween.interpolate_property(self, "modulate", Color(1, 1, 1, 0), Color(1, 1, 1, 1), 0.15, Tween.TRANS_LINEAR, Tween.EASE_IN)
	$Tween.start()

