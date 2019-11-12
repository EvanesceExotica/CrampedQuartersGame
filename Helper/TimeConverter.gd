extends Node

var timeRatio = 0.00694 #0.01
var gameTime = 0
#var fullDayTimeInMinutes = 8 #8 minutes
#var hours  #20 seconds
var handledHourPass = false
var handledDayPass = false

func round_to_dec(num, places):
    return round (num * pow(10.0, places))/pow(10.0, places)

func HandleDayPassing():
    print("A day has passed")

func HandleHourPassing():
    print("An hour has passed")

func _process(delta):
    gameTime += delta /  timeRatio


    #figure out cleaner way to handle this
    if Minutes() == 0 && Seconds() == 0 && !handledHourPass:
        handledHourPass = true
        HandleHourPassing()
    if Seconds() == 1:
        handledHourPass = false

    if Hours() == 0 && Minutes() == 0 && !handledDayPass:
        handledDayPass = true
        HandleDayPassing()
    if Minutes() == 1:
        #reset the bool once the minutes are no longer zero
        handledDayPass = false
    

func Milliseconds():

    #gmaeTime converts totalSeconds to int, so this subtraction may be getting the difference of that to apply to the miliseconds which would be behind the decimal place
    return int(gameTime - totalSeconds()) * 1000

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
    