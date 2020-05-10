extends Node2D

onready var character = get_parent()
var manager = character.slot.get_parent()
onready var speechBubble = get_node("SpeechBubble")
onready var convoText = get_node("ConvoText")
onready var anim = get_node("AnimationPlayer")

#var tempInteractionNumbers = 

func _ready():
    speechBubble.modulate = Color(1, 1, 1, 0)
    SignalManager.connect("HourPassed", self, "DetermineConversationChance")
    #SignalManager.connect("HourPassed", self, "ScanForPeopleToTalkTo")


func MakeComment():
    var query : Dictionary = {}
    query["concept"] = "Reaction"
    query["who"] = character
    query["charcterRoom"] = character.currentSlot.slotManager.room
    #this is for if a comment is made in reaction to an event like a fire/event attack
    pass

func DetermineConversationChance():
    var random = randf()
    if random > 0.5:
        ScanForPeopleToTalkTo()

func ScanForPeopleToTalkTo():
    var nearbyCharacters = manager.returnNearbyCharacters()
    #perhaps do something here to take into account their relationship & traits
    #maybe not necessary to have them choose someone to start with, but weight who replies. 
    var chosen = ChooseRandom.ChooseRandomFromList(nearbyCharacters)

    StartConversation(chosen)

    pass
func StartConversation(chosen):
    FadeInSpeechBubble()
    SetText("Hey, what's up, man? How are you doing today?")
    TypeText()
    FadeOutSpeechBubble()

func HandleConversation():
    var query : Dictionary = {}
    query["concept"] = "ConversationStart"
    query["who"] = character
    query["characterRoom"] = character.currentSlot.slotManager.room 
    query["adjacentCharacters"] = character.GetAdjacentCharacters()
    query["attributes"] = character.characterAttributes
    query["friends"] = character.relationshipModule.friends
    query["enemies"] = character.relationshipModule.enemies

func SetText(text):
    convoText.text = text
    
func TypeText():
    anim.play("TypeText")
    yield(anim, "animation_finished")

func FadeInSpeechBubble():
    FadeHandler.FadeToColor($Tween, speechBubble, "modulate", Color(1, 1, 1, 0), Color.white, 0.3)
    yield($Tween, "tween_completed")

func FadeOutSpeechBubble():
    FadeHandler.FadeToColor($Tween, speechBubble, "modulate", Color.white, Color(1, 1, 1, 1), 0.3)
    yield($Tween, "tween_completed")