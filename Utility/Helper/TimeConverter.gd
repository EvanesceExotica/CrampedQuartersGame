extends Node

#var timeRatio = 0.00694 #0.01
var timeRatio = 0.00100 #0.01
#var timeRatio = 0.000694 #0.01#FAKE ONE CHANGE BACK
var gameTime = 0
var realTime = 0

var handledHourPass = false
var handledDayPass = false

var dreamTime = false

var firstDay = true

func round_to_dec(num, places):
	return round (num * pow(10.0, places))/pow(10.0, places)

#func SetGameTimer(timer, waitTime, oneshot, )
func HandleDayPassing():
	print("A day has passed")
	SignalManager.emit_signal("DayPassed")

func HandleHourPassing():
	print("An hour has passed")
	SignalManager.emit_signal("HourPassed", Hours())

func SetDreamTime():
	dreamTime = true
	pass

func TurnOffDreamTime():
	dreamTime = false
	pass

func _ready():
	#SignalManager.connect("DreamTimeStarted", self, "SetDreamTime")
	SignalManager.connect("DreamTimeEnded", self, "TurnOffDreamTime")
	SignalManager.connect("DreamTimeSkipped", self, "TurnOffDreamTime")

	pass

#func SkipToNextDay():
func _process(delta):
	if(!dreamTime):
		#if it's not currently dream time, increase the game time
		gameTime += delta /  timeRatio
		realTime += delta


	#figure out cleaner way to handle this
	if Minutes() == 0 && !handledHourPass:
		if !firstDay:
			#if it is not the first day and first hour, which would explain why the hour and day is originally zero, handle like normal
			handledHourPass = true
			HandleHourPassing()

	if Minutes() == 1:
		#doing it on minute one rather than the next frame
		handledHourPass = false
		if firstDay:
			#if it's the first hour of the first day, skip handling anything, but tick firstDay to off to handle like normal from now on
			firstDay = false

	if Hours() == 0 && Minutes() == 0 && !handledDayPass:
		if !firstDay:
			#if it is not the first day and first hour, which would explain why the hour and day is originally zero, handle like normal
			handledDayPass = true
			HandleDayPassing()

	if Minutes() == 1:
		#reset the bool once the minutes are no longer zero
		handledDayPass = false
		if firstDay:
		#if it's the first hour of the first day, skip handling anything, but tick firstDay to off to handle like normal from now on
			firstDay = false
	
func ConvertSecondsToGameSeconds(amount): 
	return amount / timeRatio

func SecondsToGameMinutes(amount):
	var gameSeconds = amount/timeRatio
	var gameMinutes = gameSeconds/60
	return gameMinutes

func SecondsToGameHours(amount):
	var gameSeconds = amount/timeRatio
	var gameHours = gameSeconds/(60 * 60)
	return gameHours

func GameMinutesToSeconds(gameMinutes):
	#example: 30 minutes in game
	var gameSeconds = gameMinutes * 60 #this should convert game minutes to game seconds
	var realTimeSeconds = gameSeconds*timeRatio #this should undue the time ratio and convert to real seconds
	return realTimeSeconds

func GameHoursToSeconds(gameHours):
	var gameSeconds = gameHours * (60 * 60) #this should convert game hours to game seconds
	var realTimeSeconds = gameSeconds*timeRatio #this should undue the time ratio and convert to real seconds
	return realTimeSeconds

func Milliseconds():

	#gmaeTime converts totalSeconds to int, so this subtraction may be getting the difference of that to apply to the miliseconds which would be behind the decimal place
	return int(gameTime - totalSeconds()) * 1000

# func realTotalSeconds():
#     return int(realTime)
# func RealSeconds():
#     return int(realTotalSeconds() % 60)
# func RealMinutes():
#     #get the amount of minutes, see how many times they go into 60 which should euqal the number of hours that have passed, and gets what's left over to display as minutes
#     return int((realTotalSeconds() / 60) % 60)


func Seconds():

	#how many times does the total number of seconds neatly go into 60, and what's the reaimander
	#example, 25 goes into 40 once, with a remainder of 15
	# (25/7) = 3 times, with 4 as the remainder
	#so for 200 seconds, 60 goes into 200 -- 3 times neatly, with 20 left over 
	#for 5432 seconds, 60 goes into 5432  - 90 times with 32 left over
	return int(totalSeconds() % 60)

func Minutes():

	#get the amount of minutes, see how many times they go into 60 which should euqal the number of hours that have passed, and gets what's left over to display as minutes
	return int((totalSeconds() / 60) % 60)

func Hours():
	#3600 seconds in an hour, 60 seconds per minute * 60 minutes per hour. so the total seconds/(60*60) is the total seconds/(3600, the seconds in an hour)
	# -- the modulus 24 is for the display of hours, how many hours remaining if you're doing a day + x hours + x minutes + x seconds
	#get the amount of hours, see how many times they've been divided into 24 --which should equal the days that have passed, and get what's left over to display
	return int(totalSeconds() / (60 * 60) % 24)

func Days():
	#86,400 seconds in a day = 60 * 60 * 24, 60 seconds per minute, 60 minutes per hour, 24 hours per day
	return int(totalSeconds() / 60 * 60 * 24)

func totalSeconds():
	 return int(gameTime)
	
func RealSeconds():
	return int(realTime)
