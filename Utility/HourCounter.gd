extends Node2D

var hourCount = 0
export var interval = 1
var parent
func _ready():
	SignalManager.connect("HourPassed", self, "UptickCountedHours")
	parent = get_parent() #change this later

func UptickCountedHours(hour):
	if(hourCount < interval):
		hourCount+= 1
	elif(hourCount >= interval):
		ResetCountedHours()

func ResetCountedHours():
	hourCount = 0
	parent.intervalReached(interval)
