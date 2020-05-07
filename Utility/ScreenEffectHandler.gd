extends CanvasLayer

var currentEffect
var previousEffect
var allEffects
onready var effectHolder = get_node("EffectHolder")
export (Dictionary) var screentimeEffects = {}

func _ready():
	allEffects = effectHolder.get_children()
	SignalManager.connect("DreamTimeStarted", self, "ActivateDreamtimeEffect")
	SignalManager.connect("Overheating", self, "ActivateOverheatingEffect")
	SignalManager.connect("Freezing", self, "ActivateFreezingEffect")
	SignalManager.connect("OnSpacetimeJumpDeparture", self, "ActivateSpacetimeTravelEffect")

	SignalManager.connect("OnRoomSwitched", self, "MoveEffectsWithCamera")

func MoveEffectsWithCamera(currentRoom, destinationRoom):
	#move all the effects to where the camera currently is
	effectHolder.global_position = destinationRoom.global_position

func ActivateEffect(effectName):
	var effect = get_node(screentimeEffects[effectName])
   # previousEffect = currentEffect
   # currentEffect = effect

	FadeInEffect(effect)

func StopEffect(effectName):
	var effect = get_node(screentimeEffects[effectName])
	FadeOutEffect(effect)

func FadeOutEffect(effect):

	#$Tween.interpolate_property(previousEffect, "modulate", Color(1, 1, 1, 1), Color(1,1, 1, 0), 3, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.interpolate_property(effect, "modulate", Color(1, 1, 1, 1), Color(1,1, 1, 0), 1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()

func FadeInEffect(effect):
	effect.visible = true
	#$Tween.interpolate_property(currentEffect, "modulate", Color(1, 1, 1, 0), Color(1,1, 1, 1), 3, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.interpolate_property(effect, "modulate", Color(1, 1, 1, 0), Color(1,1, 1, 1), 1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()


func ActivateDreamtimeEffect():
	ActivateEffect("dreamtime")

func ActivateOverheatingEffect():
	ActivateEffect("overheating")

func ActivateFreezingEffect():
	ActivateEffect("freezing")

func ActivateSpacetimeTravelEffect():
	ActivateEffect("spacetimeTravel")
	#maybe this is a less severe version of the future travel

func ActivateFutureTravelEffect():
	ActivateEffect("futureTravel")

