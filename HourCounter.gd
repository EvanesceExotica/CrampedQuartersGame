extends Node2D

var hourCount
var maxAmountOfHours

func _ready():
    SignalManager.connect("HourPassed", self, "UptickCountedHours")

func UptickCountedHours():
    if(hourCount < maxAmountOfHours):
        hourCount++
    elif(hourCount >= maxAmountOfHours):
        ResetCountedHours()

func ResetCountedHours():
    hourCount = 0