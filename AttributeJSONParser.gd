extends Object

var attributeData = {}

func load_json(json, type):
  var file = File.new()
  file.open("res://StatData/CharAttributes.json", file.READ)
  attributeData = parse_json(file.get_as_text())
