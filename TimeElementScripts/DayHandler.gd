extends Node2D

export(int) var daysPassed = 0
export(int) var maxDays = 5

func _ready():
    SignalManager.connect("DayPassed", self, "AddToDayCounter")

func AddToDayCounter():
    daysPassed+=1
    pass