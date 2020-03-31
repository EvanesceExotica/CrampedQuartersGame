extends TextureProgress

var fillSpeed = 10
#difficulty is smaller range, lower range, faster fill speed
var rangeMin = 10
var rangeMax = 15
var validRange = 0

var minValue = 0
var maxValue = 0

var minSpeed = 5
var maxSpeed = 10

onready var rangeValueLabel = get_node("RangeValueLabel")
onready var currentValueLabel = get_node("CurrentValueLabel")

onready var minRangeBar = get_node("MinRange")
onready var maxRangeBar = get_node("MaxRange")

var chosenKey

func _ready():
    randomize()
    validRange = rand_range(10, 15)
    minValue = rand_range(30, 80)
    maxValue = minValue + validRange
    minRangeBar.value = minValue
    maxRangeBar.value = maxValue

    fillSpeed = rand_range(minSpeed, maxSpeed)
    increaseBar()

func increaseBar():
    $Tween.interpolate_property(self, "value", 0, 100, fillSpeed, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
    $Tween.start()

func determineIfWithinRange():
    print(str(self.value))
    if self.value >= minValue && self.value <= maxValue:
        print("WITHIN RANGE")
    else:
        print("NOT WITHIN RANGE")

func _input(event):
    if event is InputEventKey and event.scancode == chosenKey and not event.echo:
        $Tween.stop_all()
        determineIfWithinRange()

func _process(delta):
    pass
  #  rangeValueLabel.text = ("Min: " + str(minValue) + "Max: " + str(maxValue))
  #  currentValueLabel.text = ("Current Value Is " + str(self.value))
    
