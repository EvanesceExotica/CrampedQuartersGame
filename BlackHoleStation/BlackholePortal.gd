extends Node2D

onready var interactableObject = get_node("InteractableObject")


func processInteraction():
    SignalManager.emit_signal("WentBackThroughPortal")


func _on_Area2D_mouse_entered():
    print("Hand in zone")
    interactableObject.handInZone = true
    pass


func _on_Area2D_mouse_exited():
    print("Hand out zone")
    interactableObject.handInZone = false
    pass