extends "res://InteractableObject.gd"

func _input(event):
    ._input(event)

    if event.is_action_pressed("ui_talk") && mouseHovering:
        pass