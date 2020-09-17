extends Node2D

var interests = []
var likes = []
var dislikes = []
var fears = [] 
var desires = []
var topic = preload("res://Character/Desire.tscn")
onready var responseHolder = get_parent().get_node("ResponseHolder")
var responseAreaNumber = 1
#maybe weight different interests as conversation topics to originally arise?
#have a mix of things they like, dislike, feara show up as options, along with some random ones


var randomDesireList = ["environment", "food", "weather", "culture", "money", "politics", "health", "fashion", "travel", "crime", "entertainment", "animals", "science", "family", "romance", "plasure"]
var parent

signal responseGenerated

func _ready():
	parent = get_parent()
	randomize()
	parent.connect("dialogueNodesFilled", self, "generateResponse")

func checkIfInterest():
	#if something is something they like, dislike, or fear, they will focus on that. If not they'll ranomlly choose from what you said to continue upon.
	#if you speak positively of something they hate, relationship will drop and they'll end conversation unless kind. 
	pass

func generateResponse(dialogueNodes): 
	print("Is this working?")
	#we want to choose an adjective or subject that is related and switch the others.
	# var chooseRandomChoice = []
	# chooseRandomChoice.append(dialogueNodes["adjective"])
	# chooseRandomChoice.append(dialogueNodes["object"])
	# chooseRandomChoice.append(dialogueNodes["verb"])

	#choose from something player said
	var randomSubject = ChooseRandom.ChooseRandomFromList(dialogueNodes)

	var newTopicList = [] + randomDesireList
	#choose new desires that the player didn't choose
	newTopicList.remove(randomSubject)
	var newResponse = []

	#append what the player was talking about that we chose to focus on
	print("Chose to talk about " + randomSubject)
	newResponse.append(randomSubject)
	for i in range(2):
		#generate a new topic
		var randomNewTopic = ChooseRandom.ChooseRandomFromList(newTopicList)
		#remove so it can't be chosen again
		newTopicList.remove(randomNewTopic)
		#add to the newResponse array
		newResponse.append(randomNewTopic)

	 #probably unnecesary to do this twice
	for newTopic in newResponse:
		print("Here are our response options " + newTopic)

		#choose a new topi cfrom the newly random generated list (including a topic the player mentioned)
		var newTopicObject = topic.instance()
		get_parent().add_child(newTopicObject)

		#place this after the add child, as the ready function is being called when you add child
		newTopicObject.setDesireName(newTopic)

		#put the response in the correct position
		newTopicObject.global_position = responseHolder.get_node(str(responseAreaNumber)).global_position

		#increment the response area number so that it goes into the next available position
		responseAreaNumber+=1
	#reset response area number so that the next batch starts at the first position again
	responseAreaNumber = 1

	#emit response generated signal
	emit_signal("responseGenerated")



   #this random subject will be inserted back into the conversation with a random assortment of other icons 

