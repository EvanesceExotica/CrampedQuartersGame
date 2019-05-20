extends Node2D

var attributeData = {}
func _ready():
  load_json()

func load_json():
  var file = File.new()
  assert file.file_exists("res://StatData/CharacterAttributes.json")
  file.open("res://StatData/CharacterAttributes.json", file.READ)
  #var attributeData = JSON.parse(file.get_as_text())
  var attributeData = parse_json(file.get_as_text())
  #assert attributeData.size() > 0
  print(attributeData)
  for item in attributeData:
    print(str(item))
  return attributeData
