
extends Object

class_name Stat

enum StatType{
	health,
	sustenance,
	sanity,
	relationship

}

var ourType = StatType.health; 
     
var currentValue = 100
#warning-ignore:unused_class_variable
var maxValue = 100
     
func changeValue(amount):
     currentValue -= amount
     if(currentValue <= 0):
          currentValue = 0
          emit_signal("valueAtZero")
     pass
     
signal valueAtZero
     
#warning-ignore:unused_signal
signal valueAtMax
    
func drainSustenanceOverTime():

	var timer = Timer.new()
	timer.connect("timeout", self, "onTimerTimeout")
	timer.set_wait_time(0.1)
	timer.set_one_shot(false)
	timer.start()
	

func onTimerTimeout():
	currentValue-= 1
	
func drainOverTime():
     pass
	
     # Called when the node enters the scene tree for the first time.
func _ready():

     pass # Replace with function body.
     
func _init(ourStatType):
     ourType = ourStatType
     pass

#warning-ignore:unused_class_variable
var draining = false

#warning-ignore:unused_class_variable
var drainIncrement
