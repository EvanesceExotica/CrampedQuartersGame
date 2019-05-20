extends Node2D

var attributeData = {}
var createdAttributes = { }
func _ready():
  load_json()

func load_json():
  var file = File.new()
  assert file.file_exists("res://StatData/CharacterAttributes.json")
  file.open("res://StatData/CharacterAttributes.json", file.READ)
  #var attributeData = JSON.parse(file.get_as_text())
  attributeData = parse_json(file.get_as_text())
  #assert attributeData.size() > 0
  print(attributeData)
  for item in attributeData:
    print(str(item))
  return attributeData

func fetchAndCreateAttribute(attributeName):
  var thisAttributeDictionary  = {}
  #dictionary for a single attribute
  for stat in createdAttributes:
    #if this attribute has already been created once,
    # use the version already created
    if stat.attributeName == attributeName
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
	attribute.ConflictingAttibutes = thisAttributeDictionary["ConflictingAttributes"]
	attribute.PreRequisiteAttributes = thisAttributeDictionary["PreRequisiteAttributes"]
	attribute.ResultingAttributes = thisAttributeDictionary["ResultingAttributes"]
	attribute.AffectedDynamicStatsCurrent = "AffectedDynamicStatsCurrent" : {},
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
