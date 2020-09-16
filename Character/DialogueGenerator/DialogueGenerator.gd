extends Node2D

var interests = []
var likes = []
var dislikes = []
var fears = [] 
var desires = []


func collectCharacterInterests():

func _ready():
    randomize()
    connect("dialogueNodesFilled", self, "generateResponse")



func generateResponse(dialogueNodes): 
    #we want to choose an adjective or subject that is related and switch the others.
    var chooseRandomChoice = []
    chooseRandomChoice.append(dialogueNodes["adjective"])
    chooseRandomChoice.append(dialogueNodes["object"])
    chooseRandomChoice.append(dialogueNodes["verb"])
    var randomSubject = ChooseRandom.ChooseRandomFromList(chooseRandomChoice)
   #this random subject will be inserted back into the conversation with a random assortment of other icons 

