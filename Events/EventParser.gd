extends Node2D


var eventData

func load_json():
	var file = File.new()
	assert file.file_exists("res://StatData/CharacterAttributes.json")
	file.open("res://StatData/CharacterAttributes.json", file.READ)
	attributeData = parse_json(file.get_as_text())
    return attributeData
    
func sendEventSignals():
	var eventDictionary  = {}
	eventDictionary = attributeData[attributeName]
    pass


