extends Node2D

onready var speechBubble = get_node("SpeechBubble")
onready var convoText = speechBubble.get_node("ConvoText")
onready var anim = get_node("AnimationPlayer")
var inConversation = false
var character
var manager

var conversationReactions = {
	"bigNegative" : -10,
	"smallNegative" : - 5,
	"smallPositive" : 5,
	"bigPositive" : 10
}
#var tempInteractionNumbers = 

func _ready():
	character = get_parent()
	#manager = character.currentSlot.get_parent()
	speechBubble.modulate = Color(1, 1, 1, 0)
	#SignalManager.connect("HourPassed", self, "ScanForPeopleToTalkTo")


func MakeComment():
	var query : Dictionary = {}
	query["concept"] = "Reaction"
	query["who"] = character
	query["charcterRoom"] = character.currentSlot.slotManager.room
	#this is for if a comment is made in reaction to an event like a fire/event attack
	pass

# func DetermineConversationChance(hours):
# 	ScanForPeopleToTalkTo()
# 	#TODO: Put random determination back in
	# var random = randf()
	# if random > 0.5:
	#     ScanForPeopleToTalkTo()

# func ScanForPeopleToTalkTo():
# 	var nearbyCharacters = character.currentSlot.slotManager.returnNearbyCharacters()
# 	#perhaps do something here to take into account their relationship & traits
# 	#maybe not necessary to have them choose someone to start with, but weight who replies. 
# 	var chosen = ChooseRandom.ChooseRandomFromList(nearbyCharacters)

# 	if !System.conversationRunning && !inConversation:
# 		System.conversationRunning = true
# 		inConversation = true
# 		StartConversation(chosen)

# 	pass
# func StartConversation(chosen):
# 	DisplaySpeech()
# 	yield(DisplaySpeech(), "completed")
# 	chosen.conversationHandler.DisplaySpeech()
# 	yield(chosen.conversationHandler.DisplaySpeech(), "completed")
# 	dialogueIndex = 0
# 	# chosen.conversationHandler.FadeInSpeechBubble()
# 	# chosen.conversationHandler.SetText("Nothing much. You?")
# 	# chosen.conversationHandler.TypeText()
# 	# chosen.conversationHandler.FadeOutSpeechBubble()

#	ChooseRandomConversationReaction(chosen)
var testDialogue = ["What's up man?", "Nothing, what's up with you?"]
var dialogueIndex = 0

func DisplaySpeech(index):
	#FadeInSpeechBubble()
	yield(FadeInSpeechBubble(), "completed")
	SetText(testDialogue[index])
	#TypeText()
	yield(TypeText(), "completed")
	yield(FadeOutSpeechBubble(), "completed")
	SetText("")


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
	
func ChooseRandomConversationReaction(otherCharacter):
	var randomConvoReaction = ChooseRandom.ChooseRandomFromList(conversationReactions.keys())
	var reactionValue = conversationReactions[randomConvoReaction]
	character.relationshipModule.AdjustRelationship(otherCharacter, reactionValue)
	print("RELATIONSHIPPPP is now " + str(character.relationshipModule.relationships[otherCharacter]))

# func ChooseRandomConversationReaction(otherCharacter):
# 	var randomConvoReaction = ChooseRandom.ChooseRandomFromList(conversationReactions.keys())
# 	print(character.characterName + " reactected as " + randomConvoReaction)
# 	var reactionValue = conversationReactions[randomConvoReaction]
# 	character.relationshipModule.AdjustRelationship(otherCharacter, reactionValue)
# 	otherCharacter.relationshipModule.AdjustRelationship(self, reactionValue)
# 	System.conversationRunning = false
# 	inConversation = false
# 	dialogueIndex = 0
	


	pass

func DetermineConversationSuccess():
	pass

func TypeText():
	anim.play("TypeText")
	yield(anim, "animation_finished")
	print("ANIMATION FINISHED")

func FadeInSpeechBubble():
	FadeHandler.FadeToColor($Tween, speechBubble, "modulate", Color(1, 1, 1, 0), Color.white, 0.3)
	yield($Tween, "tween_completed")

func FadeOutSpeechBubble():
	FadeHandler.FadeToColor($Tween, speechBubble, "modulate", Color.white, Color(1, 1, 1, 0), 0.3)
	yield($Tween, "tween_completed")

func _input(ev):
	pass
	# if ev is InputEventKey and ev.scancode == KEY_K and not ev.echo:
	# 	var characters = get_tree().get_nodes_in_group("Characters")
	# 	if !System.conversationRunning && !inConversation:
	# 		var talkingCharacter = characters[0]
	# 		print("We have this many characters " + str(characters.size()))
	# 		talkingCharacter.conversationHandler.DetermineConversationChance(null)
