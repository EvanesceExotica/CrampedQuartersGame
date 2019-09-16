extends Node2D


var eventData

func load_json():
	var file = File.new()
	assert file.file_exists( "res://Events/Events.json")
	file.open("res://Events/Events.json", file.READ)
	eventData = parse_json(file.get_as_text())
    return eventData
    
func sendEventSignals():
	var eventArray  = []
	eventArray = eventData[events]
    pass

func checkScope(scope):
	pass

func checkRequirements():
	pass

func createEvent():
	#here we add the event to the object and add the choices along with it, maybe have a countdown?
	pass

func checkActions(action):

	
	pass