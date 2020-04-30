extends Node2D

onready var interactableObject = get_node("InteractableObject")
var allSanePassengers = []

var disembarkPosition = get_node("DisembarkPosition")


func _on_Area2D_mouse_entered():
    pass

func _on_Area2D_mouse_exited():
    pass

func DropOffPassengers():
    pass
    for character in get_tree().get_nodes_in_group("Characters"):
        if character.IsSane():
            #take the character off of the ship
            allSanePassengers.append(character) #list for characters who made it to the end
            character.global_position = disembarkPosition.global_position
            character.deathHandler.disembarkCharacter()

func processInteraction():
