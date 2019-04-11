extends Resource

class_name Trait

enum attributes{
	Xenophobic, 
	Antisocial,
	Asocial, 
	Paranoid,
	Strong,
	Sadistic,
	Agreeable
	
	}
var comminality = 0.3 

export var effectedType = {}

export var conflictingTraits  = []

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

enum StatType{
     health,
     sustenance,
     sanity,
     relationship
      }


#var attributeDictionary = {}
#
#func parseAttributes():
#	var file = File.new()
#	file.open("res://StatData/CharAttributes.json", file.READ)
#	var text = file.get_as_text()
#	attributeDictionary.parse_json(text)
#	file.close()
#
           
#export (Array) var effectedStats = {0, 1}
# Called when the node enters the scene tree for the first time.
# Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#     pass 
#
#Dictionary statsEffected{
#
#
#
#	}
#
#Dictionary antiAttributes{
#
#
#
#	}

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
