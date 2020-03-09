
extends Object

class_name Stat

enum StatType{
	health,
	sustenance,
	sanity,
	relationship

}

var ourType = StatType.health; 
     
#what sources are draining this stat
var drainSources = []

#is the stat currently draining? If sources >=1, then it is
var drainState = false

#sources can add up to make the stat drain faster, the number of points drained per second will add together with each additional source
var drainRate = 0

#the currentValue of the stat
var currentValue = 100

#the max Value of the stat
var maxValue = 100
     
func changeValue(amount):
     currentValue -= amount
     if(currentValue <= 0):
          currentValue = 0
          emit_signal("valueAtZero")
     pass
     

     
func _init():
    # self.ourType = ourStatType
     pass
