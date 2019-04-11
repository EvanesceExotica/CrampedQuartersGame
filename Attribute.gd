extends Object

class_name Attribute
#will go away after a certain duration (being upset over a death or bad experience)
#will go away after a certain critera is removed -- such as fire or a negative person nearby
#condition that can be removed if a critera is met (such as injured -- removed if get enough health packs)
#something the character inherintly has that can only be removed by events -- can also be applied by events
enum attributeType{
	temporaryCondition,
	auraCondition,
	removeableCondition,
	inherentAttribute,
}

var attributeName
var attributeTypes =  [] #what type(s) of attribute this is

var description = ""
var ConflictingAttributes =  [] #Other attributes that conflict with this one
var PreRequisiteAttributes = [] #Attributes that cause this one
var ResultingAttributes =  [] #Attributes that will result from this one 'On Fire --> Shaken'
var AffectedDynamicStatsCurrent = {} #if one of the dynamic stats will take an immediate 'chunk' hit
var AffectedDynamicStatsMax = {} #if this will lower one of the maximum stats
var AffectedStaticStats = { } #if this will effect a static stat like 'damage dealt' or 'space needed'
var DrainingDynamicStats = { } #if any dynamic stats are actively drained
var duration = 10 #for temp conditions

func _init(_name):
	attributeName = _name
