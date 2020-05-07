extends Node

func FadeToColor(tween, object, propertyName, startColor, endColor, duration):
    tween.interpolate_property(object, propertyName, startColor, endColor, duration, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
    tween.start()



