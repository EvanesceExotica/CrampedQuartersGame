extends TextureProgress

func growBar(amount, speed):
	var initialValue = self.value 
	var newValue = self.value + amount
	$Tween.interpolate_property(self, "value", initialValue, newValue, speed, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()
