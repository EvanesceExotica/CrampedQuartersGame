extends Resource


class_name Event
# Declare member variables here. Examples:
# var a = 2
export(string) id
export(Texture) var characterFace
# var b = "text"
export(Array) var eventDescriptionText
export(Dictionary) var eventChoices
# Called when the node enters the scene tree for the first time.
export(Resource) var linkedEvent
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
