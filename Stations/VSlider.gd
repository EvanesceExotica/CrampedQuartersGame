extends VSlider

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var minSliderRiseDuration = 1
var maxSliderRiseDuration = 4
var slideDuration

var bottomedOut = false
signal reachedMax
var slidingBackUp = false
onready var tween = get_node("Tween")
onready var okayButton = get_node("OkayButton")
# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	slideDuration = rand_range(minSliderRiseDuration, maxSliderRiseDuration)
	tryToSlideBackUp()
	pass # Replace with function body.

func tryToSlideBackUp():
	slidingBackUp = true
	tween.interpolate_property(self, "value", self.value, 100, slideDuration, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#if(self.value < self.max_value && !slidingBackUp):
	#	tryToSlideBackUp()
	if self.value == self.max_value:
		okayButton.modulate = Color.red
		print("We reached max!")
		emit_signal("reachedMax")
	if self.value == self.min_value && !bottomedOut:
		okayButton.modulate = Color.green
		bottomedOut = true

func _on_HardSlider_gui_input(event):
	if event.is_action_pressed("left_click"):
		tween.stop_all()
	if event.is_action_released("left_click") && !bottomedOut:
		tryToSlideBackUp()
