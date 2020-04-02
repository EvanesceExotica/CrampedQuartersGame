extends Object

class_name DrainSource

enum Type{
	drain,
	damage,
	heal,
	gain
	
}

enum DynamicStats{
	health,
	sustenance,
	sanity,
	relationship
	
	}

var rate = 1
var effectedStat 
var type 

func _init(_rate, _effectedStat, _type):
	rate = _rate
	effectedStat = _effectedStat 
	type = _type

