extends Node2D

onready var cleaner = get_node("PipeHolder/Cleaner")
onready var sewage = get_node("PipeHolder2/Sewage")
onready var lever = get_node("Lever2")

func _ready():
    lever.connect("justFlushed", self, "flushPipes")
    pass
   # flushPipes()

func flushPipes():
    cleaner.value = 0
    sewage.value = 100
    $Tween.interpolate_property(cleaner, "value", 0, 100, 5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
    $Tween.interpolate_property(sewage, "value", 100, 0, 5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
    $Tween.start()

func _on_Tween_tween_completed():
    pass