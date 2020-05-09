extends Node2D

var conversationData = {}

func load_json():
	var file = File.new()
	#assert(file.file_exists("res://RelevantJSON/CrampedQuartersAttributes2.JSON"))
	file.open("res://RelevantJSON/CrampedQuartersAttributes2.JSON", file.READ)
	var entireFile = parse_json(file.get_as_text())
	conversationData = entireFile["sheets"][0]["lines"]
	#attributeData = parse_json(file.get_as_text())
	return conversationData
	
func CompileCritera(speaker):
	pass

func valueComparison(value, comparison):
	if comparison == ">":
		pass
	elif comparison == "<":
		pass
	elif comparison == ">=":
		pass
	elif comparison == "<=":
		pass
	elif comparison == "==":
		pass

func compileWorldCriteria():

	pass
