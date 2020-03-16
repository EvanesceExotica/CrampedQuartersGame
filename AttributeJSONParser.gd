extends Node2D

var attributeData = {}
var createdAttributes = [ ]
var stringToEnum = { }
func _ready():
	stringToEnum = {"health" : System.DynamicStats.health, "sustenance" : System.DynamicStats.sustenance,
	"sanity" : System.DynamicStats.sanity, "relationship" : System.DynamicStats.relationship, "damageDealt" : System.StaticStats.damageDealt,
	"spaceRequirement" : System.StaticStats.spaceRequirement, "temporaryCondition" : System.attributeType.temporaryCondition,
	"auraCondition" : System.attributeType.auraCondition, "removeableCondition" : System.attributeType.removeableCondition,
	"inherentAttribute" : System.attributeType.inherentAttribute, "character" : System.entitiesAppliedTo.character,
	"station" : System.entitiesAppliedTo.station, "slot" : System.entitiesAppliedTo.slot }
	load_json()
	var newAttribute = fetchAndCreateAttribute("OnFire")
	# print("New attribute created " + str(newAttribute.attributeName) + " Description " + str(newAttribute.description))
	# for item in newAttribute.ConflictingAttributes:
	# 	print("New attribute conflicts " + item)

# enum attributeType{
# 	temporaryCondition,
# 	auraCondition,
# 	removeableCondition,
# 	inherentAttribute,
# 	species
# }
#
# enum DynamicStats{
# 	health,
# 	sustenance,
# 	sanity,
# 	relationship
#
# 	}
#
#
# enum StaticStats{
# 	damageDealt,
# 	spaceRequirement
# 	}
#
# enum entitiesAppliedTo{
# 	character,
# 	station,
# 	slot
# }
func load_json():
	var file = File.new()
	#assert(file.file_exists("res://RelevantJSON/CrampedQuartersAttributes2.JSON"))
	file.open("res://RelevantJSON/CrampedQuartersAttributes2.JSON", file.READ)
	var entireFile = parse_json(file.get_as_text())
	attributeData = entireFile["sheets"][0]["lines"]
	#attributeData = parse_json(file.get_as_text())
	return attributeData

func _load_json():
	var file = File.new()
	#assert file.file_exists("res://StatData/CharacterAttributes.json")
	file.open("res://StatData/CharacterAttributes.json", file.READ)
	#var attributeData = JSON.parse(file.get_as_text())
	attributeData = parse_json(file.get_as_text())
	#assert attributeData.size() > 0
	#print(attributeData)
	# for item in attributeData:
	# 	print(str(item))
	return attributeData

func convertArrayStringsToEnum(stringArray):
	var convertedArray = []
	for item in stringArray:
		#this should add them as an enum instead of a string
		convertedArray.append(stringToEnum[item])
		#attribute.attributeTypes.append(inherentTypesToEnum[item])	pass
	return convertedArray

func convertDictionaryStringsToEnum(dict):
	var convertedDictionary = {}
	for item in dict.keys():
	#for all of the keys in the dictionary
		convertedDictionary[stringToEnum[item]] = dict[item]
	#convert them to the right enum, add to the dictionary, and then set to the value
	return convertedDictionary;

func fetchAndCreateAttribute(attributeName):
	var thisAttributeDictionary  = {}
	#dictionary for a single attribute
	for stat in createdAttributes:
	#if this attribute has already been created once,
	# use the version already created
		if stat.attributeName == attributeName:
			return stat

	for item in attributeData:
		#for every attribute copied to attributeData from the 'lines' array
		if item["attributeName"] == attributeName:
			thisAttributeDictionary = item.duplicate()

	#thisAttributeDictionary = attributeData[attributeName]
	var attribute = System.attributeScript.new(attributeName)
	#Add functions to fill variables
	#for item in thisAttributeDictionary:
	print(attribute.attributeName)
	attribute.attributeName = thisAttributeDictionary["attributeName"]
	#attribute.entitiesCanApplyTo = thisAttributeDictionary["entitiesCanApplyTo"]
	#attribute.attributeTypes =  thisAttributeDictionary["attributeTypes"]
	#attribute.attributeTypes = (thisAttributeDictionary["attributeTypes"])

	attribute.description = thisAttributeDictionary["description"]
	#attribute.contagious = thisAttributeDictionary["contagious"]
	#attribute.contagionChance = thisAttributeDictionary["contagionChance"]
	#attribute.stackable = thisAttributeDictionary["stackable"]
	if thisAttributeDictionary.has("ConflictingAttributes") && thisAttributeDictionary["ConflictingAttributes"].size() > 0:
		attribute.ConflictingAttributes = thisAttributeDictionary["ConflictingAttributes"]
	#attribute.PreRequisiteAttributes = thisAttributeDictionary["PreRequisiteAttributes"]
	if thisAttributeDictionary.has("ResultingAttributes") && thisAttributeDictionary["ResultingAttributes"].size() > 0:
		attribute.ResultingAttributes = thisAttributeDictionary["ResultingAttributes"]

	attribute.AffectedStats = thisAttributeDictionary["AffectedStats"]

	#attribute.AffectedDynamicStatsCurrent = thisAttributeDictionary["AffectedDynamicStatsCurrent"]
	#attribute.AffectedDynamicStatsCurrent = (thisAttributeDictionary["AffectedDynamicStatsCurrent"])

	#attribute.AffectedDynamicStatsMax = thisAttributeDictionary["AffectedDynamicStatsMax"]
	#attribute.AffectedDynamicStatsMax = (thisAttributeDictionary["AffectedDynamicStatsMax"])

	#attribute.AffectedStaticStats = thisAttributeDictionary["AffectedStaticStats" ]
	if thisAttributeDictionary.has("AuraAttributes") && thisAttributeDictionary["AuraAttributes"].size() > 0:
		attribute.AuraAttributes = thisAttributeDictionary["AuraAttributes"]

	attribute.temporary = thisAttributeDictionary["temporary"]
	attribute.specialAttribute = thisAttributeDictionary["SpecialAttribute"]
	#attribute.DrainingDynamicStats = thisAttributeDictionary["DrainingDynamicStats"]
	#attribute.DrainingDynamicStats = (thisAttributeDictionary["DrainingDynamicStats"])

	attribute.duration = thisAttributeDictionary["duration"]
	attribute.deathType = thisAttributeDictionary["deathType"]
	attribute.spreadChancePerHalfHour = thisAttributeDictionary["spreadChancePerHalfHour"]
	attribute.stackable = thisAttributeDictionary["stackable"]
	#attribute.statSignalsToWatchFor = thisAttributeDictionary["statSignalsToWatchFor"]
	#attribute.signalsThatWillRemoveAttribute = thisAttributeDictionary["signalsThatWillRemoveAttribute"]
	#attribute.canCombineWith = thisAttributeDictionary["canCombineWith"]
	#attribute.modifiedAttributes = thisAttributeDictionary["modifiedAttributes"]
	#attribute.characterEventTypeChance = thisAttributeDictionary["characterEventTypeChance"]
	#attribute.externalCombinations = thisAttributeDictionary["externalCombinations"]

	createdAttributes.append(attribute)

	return attribute


	
func _fetchAndCreateAttribute(attributeName):
	var thisAttributeDictionary  = {}
	#dictionary for a single attribute
	for stat in createdAttributes:
	#if this attribute has already been created once,
	# use the version already created
		if stat.attributeName == attributeName:
			return stat

	thisAttributeDictionary = attributeData[attributeName]
	var attribute = System.attributeScript.new(attributeName)
	#Add functions to fill variables
	#for item in thisAttributeDictionary:
	attribute.attributeName = thisAttributeDictionary["attributeName"]
	attribute.entitiesCanApplyTo = thisAttributeDictionary["entitiesCanApplyTo"]
	attribute.attributeTypes =  thisAttributeDictionary["attributeTypes"]
	#attribute.attributeTypes = (thisAttributeDictionary["attributeTypes"])

	attribute.description = thisAttributeDictionary["description"]
	attribute.contagious = thisAttributeDictionary["contagious"]
	attribute.contagionChance = thisAttributeDictionary["contagionChance"]
	attribute.stackable = thisAttributeDictionary["stackable"]
	attribute.ConflictingAttributes = thisAttributeDictionary["ConflictingAttributes"]
	attribute.description = thisAttributeDictionary["description"]
	attribute.PreRequisiteAttributes = thisAttributeDictionary["PreRequisiteAttributes"]
	attribute.ResultingAttributes = thisAttributeDictionary["ResultingAttributes"]

	#attribute.AffectedStats = thisAttributeDictionary["AffectedStats"]

	attribute.AffectedDynamicStatsCurrent = thisAttributeDictionary["AffectedDynamicStatsCurrent"]
	#attribute.AffectedDynamicStatsCurrent = (thisAttributeDictionary["AffectedDynamicStatsCurrent"])

	attribute.AffectedDynamicStatsMax = thisAttributeDictionary["AffectedDynamicStatsMax"]
	#attribute.AffectedDynamicStatsMax = (thisAttributeDictionary["AffectedDynamicStatsMax"])

	attribute.AffectedStaticStats = thisAttributeDictionary["AffectedStaticStats" ]
	attribute.AuraAttributes = thisAttributeDictionary["AuraAttributes"]

	attribute.DrainingDynamicStats = thisAttributeDictionary["DrainingDynamicStats"]
	#attribute.DrainingDynamicStats = (thisAttributeDictionary["DrainingDynamicStats"])

	attribute.duration = thisAttributeDictionary["duration"]
	attribute.statSignalsToWatchFor = thisAttributeDictionary["statSignalsToWatchFor"]
	attribute.signalsThatWillRemoveAttribute = thisAttributeDictionary["signalsThatWillRemoveAttribute"]
	attribute.canCombineWith = thisAttributeDictionary["canCombineWith"]
	attribute.modifiedAttributes = thisAttributeDictionary["modifiedAttributes"]
	attribute.characterEventTypeChance = thisAttributeDictionary["characterEventTypeChance"]
	attribute.externalCombinations = thisAttributeDictionary["externalCombinations"]

	createdAttributes.append(attribute)


	return attribute
#  for key in attributeData.keys():
	#for each attribute, go by name
#    if key == attributeName:
	#if the attributeName equals a key in this dictionary
#      thisAttributeDictionary = attributeData[attributeName]
