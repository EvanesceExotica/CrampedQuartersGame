extends Node2D


var inConversation
func _ready():
	SignalManager.connect("HourPassed", self, "DetermineConversationChance")

func DetermineConversationChance(hours):
	ScanForPeopleToTalkTo()
	#TODO: Put random determination back in
	# var random = randf()
	# if random > 0.5:
	#     ScanForPeopleToTalkTo()

func ScanForPeopleToTalkTo():
	var nearbyCharacters = get_parent().returnNearbyCharacters()
	#perhaps do something here to take into account their relationship & traits
	#maybe not necessary to have them choose someone to start with, but weight who replies. 
	var starter = ChooseRandom.ChooseRandomFromList(nearbyCharacters)
	if nearbyCharacters.size() <=1:
		#there's only one person so they can't have a conversation
		return
	#choose the first character, remove them from the list so they're not chosen again
	nearbyCharacters.erase(starter)
	var replier = ChooseRandom.ChooseRandomFromList(nearbyCharacters)

	if !System.conversationRunning && !inConversation:
		System.conversationRunning = true
		inConversation = true
		StartConversation(starter, replier)

var testDialogue = ["What's up man?", "Nothing, what's up with you?"]
var dialogueIndex = 0

func StartConversation(starter, replier):
	starter.conversationHandler.DisplaySpeech(dialogueIndex)
	yield(starter.conversationHandler.DisplaySpeech(dialogueIndex), "completed")
	dialogueIndex+=1
	replier.conversationHandler.DisplaySpeech(dialogueIndex)
	yield(replier.conversationHandler.DisplaySpeech(dialogueIndex), "completed")
	dialogueIndex = 0
	starter.conversationHandler.ChooseRandomConversationReaction(replier)
	replier.conversationHandler.ChooseRandomConversationReaction(starter)
	System.conversationRunning = false
	inConversation = false

	
