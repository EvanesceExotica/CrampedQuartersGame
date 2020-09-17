extends Node2D

var pointsRemaining
var totalPoints = 60


var interestList = ["environment", "food", "weather", "culture", "money", "politics", "health", "fashion", "travel", "crime", "entertainment", "animals", "science", "family", "romance", "plasure"]
var interestDictionary = {}
func _ready():
	pointsRemaining = totalPoints
	randomize()
	allocatePoints()

func allocatePoints():
	#randomlly allocate points across the spectrum of interests
	#or would we rather it be a "likes" and "dislikes" sort of thing?
	for i in range(interestList.size()):

        #TODO: Fix this tomorrow
		#this will choose a random value and remove it from the list, so the next turn around it won't choose the same one
		var randomInterest = ChooseRandom.ChooseRandomAndRemove(interestList)
		#This needs to be randomized, as it's always going to take from the end of the list
		var randomValue
		if pointsRemaining >= 10:
			#if you have more than ten points left, take the points from the full ten
			randomValue = randi()%10+1
			pointsRemaining-=randomValue
		elif(pointsRemaining > 0):
			#else, allocate the points from however many you have remaining
			randomValue = randi()%pointsRemaining+1
			pointsRemaining-=randomValue    
		else:
			randomValue = 0

		interestDictionary[randomInterest] = randomValue

		# if (pointsRemaining-randomValue) >= 0:
		#     pointsRemaining-=randomValue
		# elif (pointsRemaining-randomValue) < 0:

		# if pointsRemaining > 0:
		# 	pointsRemaining -=randomValue
		# 	interestDictionary[randomInterest] = randomValue
		# else:
		# 	interestDictionary[randomInterest] = 0
		
		print("Interest in " + randomInterest + " = " +  str(interestDictionary[randomInterest]))
	pass
