extends "res://Stations/StationScreen.gd"

onready var sliderHolder = get_node("SliderHolder")
func _ready():
    for slider in sliderHolder.get_children():
        slider.connect("reachedMax", self, "gameOver")
