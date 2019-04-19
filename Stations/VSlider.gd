extends VSlider

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var slidingBackUp = false
onready var tween = get_node("Tween")
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func tryToSlideBackUp():
	slidingBackUp = true
	#tween.interpolate_property("")
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(self.value < self.max_value && !slidingBackUp):
		tryToSlideBackUp()

	pass
