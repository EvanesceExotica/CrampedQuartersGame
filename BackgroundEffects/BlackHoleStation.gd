extends Node2D

var allSanePassengers = []



func _on_Area2D_mouse_entered():
    pass

func _on_Area2D_mouse_exited():
    pass

func DropOffPassengers():
    pass
    for member in get_tree().get_nodes_in_group("Characters"):
        if member.IsSane():
