extends Object

class_name Attribute
#will go away after a certain duration (being upset over a death or bad experience)
#will go away after a certain critera is removed -- such as fire or a negative person nearby
#condition that can be removed if a critera is met (such as injured -- removed if get enough health packs)
#something the character inherintly has that can only be removed by events -- can also be applied by events
var characterAttachedTo

var Self = load("res://Attributes/Attribute.gd")
class externalCombination:

	#make this an enum
	#self
	#other
	#all
	var onSelf = true
	var thisAttributeName

	func _init( _name, _onSelf):
		thisAttributeName = _name
		onSelf = _onSelf

class SignalCriteria:
	var signalListeningFor
	var numOfTimesCalled
	var resultingMethod
	var timesCalledToTriggerMethod


enum attributeType{
	temporaryCondition,
	auraCondition,
	removeableCondition,
	inherentAttribute
}

var entitiesCanApplyTo = [] #determines whether this attribute only applies to characters, slots, or stations
#for example, "Fire" can spread to all of them

var contagious #determines whether this attribute can spread i.e., fire, disease
var contagionChance #determines the chance of spreading over a certain amount of time
#determines if the trait's effects stack or not
var stackable = false #this determines if an attribute can be stacked with the same  condition twice -- probably not?
var attributeName
var typeOfAttribute
var attributeTypes =  [] #what type(s) of attribute this is

#var characterAttachedTo
var description = ""
var temporary = false
var specialAttribute = false
var ConflictingAttributes =  [] #Other attributes that conflict with this one
var PreRequisiteAttributes = [] #Attributes that cause this one
var ResultingAttributes =  [] #Attributes that will result from this one 'On Fire --> Shaken'
var AuraAttributes = {}
var AffectedStats = {}
var AffectedDynamicStatsCurrent = {} #if one of the dynamic stats will take an immediate 'chunk' hit
var AffectedDynamicStatsMax = {} #if this will lower one of the maximum stats
var AffectedStaticStats = { } #if this will effect a static stat like 'damage dealt' or 'space needed'
var DrainingDynamicStats = { } #if any dynamic stats are actively drained
var duration = 10 #for temp conditions
var statSignalsToWatchFor = {} #this dictionary is
var signalsThatWillRemoveAttribute = {}
var canCombineWith = {} #can comebine with key to cause value; i.e:, if Aquatic -- {"InAir": "Ashixipating"}
var modifiedAttributes = {} #other attributes this one will modify?
var characterEventTypeChance = { } #insanity events; drift events
var externalCombinations = [] #alien:self
var deathType
var spreadChancePerHalfHour
var spreadVariables
var spreadRange = 0
var effect = ""

func Copy():
	var attribute = Self.new(attributeName)
	#var attribute = get_script().new()
	print("Is this a new attribute? : " + str(attribute))
	attribute.entitiesCanApplyTo = [] + entitiesCanApplyTo
	attribute.contagious = contagious
	attribute.contagionChance = contagionChance #determines the chance of spreading over a certain amount of time
	attribute.stackable = stackable #this determines if an attribute can be stacked with the same  condition twice -- probably not?
	attribute.attributeName = attributeName
	attribute.typeOfAttribute = typeOfAttribute
	attribute.attributeTypes =  [] + attributeTypes #what type(s) of attribute this is
	attribute.description = description
	attribute.temporary = temporary
	attribute.specialAttribute = specialAttribute
	attribute.ConflictingAttributes =  [] + ConflictingAttributes 
	attribute.PreRequisiteAttributes = [] + PreRequisiteAttributes #Attributes that cause this one
	attribute.ResultingAttributes =  [] + ResultingAttributes
	attribute.AuraAttributes = AuraAttributes.duplicate(true)
	attribute.AffectedStats = AffectedStats.duplicate(true)
	attribute.AffectedDynamicStatsCurrent = AffectedDynamicStatsCurrent.duplicate(true) #if one of the dynamic stats will take an immediate 'chunk' hit
	attribute.AffectedDynamicStatsMax = AffectedDynamicStatsMax.duplicate(true)#if this will lower one of the maximum stats
	attribute.AffectedStaticStats = AffectedStaticStats.duplicate(true) 
	attribute.DrainingDynamicStats = DrainingDynamicStats.duplicate(true)
	attribute.duration = duration #for temp conditions
	attribute.statSignalsToWatchFor = statSignalsToWatchFor.duplicate(true) #this dictionary is
	attribute.signalsThatWillRemoveAttribute = signalsThatWillRemoveAttribute.duplicate(true)
	attribute.canCombineWith = canCombineWith.duplicate(true) #can comebine with key to cause value; i.e:, if Aquatic -- {"InAir": "Ashixipating"}
	attribute.modifiedAttributes = modifiedAttributes.duplicate(true) #other attributes this one will modify?
	attribute.characterEventTypeChance = characterEventTypeChance.duplicate(true) #insanity events; drift events
	attribute.externalCombinations = [] + externalCombinations
	attribute.deathType = deathType
	attribute.spreadChancePerHalfHour = spreadChancePerHalfHour
	attribute.spreadVariables = spreadVariables
	attribute.spreadRange = spreadRange
	attribute.effect = effect

	return attribute
func CheckRemoveableCritera(signalCalled):
	var numberOfTimesCalled = 0
	numberOfTimesCalled+= 1
	#put this ^^ in a  list
	if(numberOfTimesCalled >= signalsThatWillRemoveAttribute[signalCalled]):
		pass
	#perhaps set up a signal here
	#this method is for checking if the removeableCritera have been met
	#IE -- healing over maxHealth or several days of rest at max health for 'injured'
	pass
func sayHello(test):
	print("Sup there yo")
func _init(_name):
	attributeName = _name
