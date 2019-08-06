extends Resource


class_name Event

export(String) id

export(Texture) var image

#the text of the event (could be an array for random text, but not necessary rn I think)
export(String) var eventDescriptionText

#these can be flags to see what triggers the event
export(Array) eventPrereqs

export(float) chanceOfOccurring

export(Dictionary) var eventChoices

export(Resource) var linkedEvent

func _ready():
	pass 

