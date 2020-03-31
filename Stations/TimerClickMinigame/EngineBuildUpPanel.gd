extends TextureProgress

var fillSpeed = 5
var minSpeed = 5
var maxSpeed = 10

func _ready():
    randomize()
    fillSpeed = rand_range(minSpeed, maxSpeed)
    increaseBar()

func spikeBuildup():
    pass
func increaseBar():
    $Tween.interpolate_property(self, "value", 0, 100, fillSpeed, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
    $Tween.start()