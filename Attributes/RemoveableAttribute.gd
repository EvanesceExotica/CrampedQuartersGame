extends Attribute

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
int numberOfTimesCalled = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func removeAttribute(signalToRemove):
	numberOfTimesCalled+=1
	if(signalsThatWillRemoveAttribute.size() > 0):
		if(numberOfTimesCalled >= signalsThatWillRemoveAttribute[signalToRemove]):
				characterAttachedTo.removeAttribute(self)

	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
