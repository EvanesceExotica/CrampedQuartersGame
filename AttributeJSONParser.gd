extends Node2D

var attributeData = {}
var createdAttributes = [ ]

func _ready():
	var dynamicStringToEnum = {"health" : System.DynamicStats.health, "sustenance" : System.DynamicStats.sustenance, "sanity" : System.DynamicStats.sanity, "relationship" : System.DynamicStats.relationship, "damageDealt" : System.StaticStats.damageDealt, "spaceRequirement" : System.StaticStats.spaceRequirement}
	var staticStringToEnum = {"damageDealt" : System.StaticStats.damageDealt, "spaceRequirement" : System.DynamicStats.spaceRequirement}
	load_json()
	var newAttribute = fetchAndCreateAttribute("OnFire")
	# print("New attribute created " + str(newAttribute.attributeName) + " Description " + str(newAttribute.description))
	# for item in newAttribute.ConflictingAttributes:
	# 	print("New attribute conflicts " + item)

func load_json():
	var file = File.new()
	assert file.file_exists("res://StatData/CharacterAttributes.json")
	file.open("res://StatData/CharacterAttributes.json", file.READ)
	#var attributeData = JSON.parse(file.get_as_text())
	attributeData = parse_json(file.get_as_text())
	#assert attributeData.size() > 0
	#print(attributeData)
	# for item in attributeData:
	# 	print(str(item))
	return attributeData

func fetchAndCreateAttribute(attributeName):
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
	attribute.description = thisAttributeDictionary["description"]
	attribute.contagious = thisAttributeDictionary["contagious"]
	attribute.contagionChance = thisAttributeDictionary["contagionChance"]
	attribute.stackable = thisAttributeDictionary["stackable"]
	attribute.ConflictingAttributes = thisAttributeDictionary["ConflictingAttributes"]
	attribute.PreRequisiteAttributes = thisAttributeDictionary["PreRequisiteAttributes"]
	attribute.ResultingAttributes = thisAttributeDictionary["ResultingAttributes"]
	attribute.AffectedDynamicStatsCurrent = thisAttributeDictionary["AffectedDynamicStatsCurrent"]
	attribute.AffectedDynamicStatsMax = thisAttributeDictionary["AffectedDynamicStatsMax" ]
	attribute.AffectedStaticStats = thisAttributeDictionary["AffectedStaticStats" ]
	attribute.DrainingDynamicStats = thisAttributeDictionary["DrainingDynamicStats"]
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
