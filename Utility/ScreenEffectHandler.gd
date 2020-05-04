extends Node2D

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

func ActivateEffect(effect):
    #you don't necessarily want to fade any out unless they're ending, in case multiple effects are stacking
    previousEffect = currentEffect
    #add a fade later?
    currentEffect = effect
    #fade out last effect
    FadeOutEffect()

    #fade in current effect
    FadeInEffect()

func FadeOutEffect():
    $Tween.interpolate_property(previousEffect, "modulate", Color(1, 1, 1, 1), Color(1,1, 1, 0), 3, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)

func FadeInEffect():
    $Tween.interpolate_property(currentEffect, "modulate", Color(1, 1, 1, 0), Color(1,1, 1, 1), 3, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)

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

