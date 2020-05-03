extends TextureRect

onready var interactableObject = get_node("InteractableObject")
var allSanePassengers = []

onready var disembarkPosition = get_node("DisembarkPosition")

onready var outsideCamera = get_node("OutsideCamera")
onready var insideCamera = get_node("InsideCamera")
signal EnteredBlackHoleStation

func _ready():
	pass
	#outsideCamera.current = true

func setCurrentCamera():
	print("THIS IS TRIGGERING AGAIN")
	outsideCamera.current = true

func _on_Area2D_mouse_entered():
	interactableObject.handInZone = true
	print("Mouse entered area")
	pass

func _on_Area2D_mouse_exited():
	interactableObject.handInZone = false
	print("Mouse exited area")
	pass

func DropOffPassengers():
	pass
	for character in get_tree().get_nodes_in_group("Characters"):
		if character.IsSane():
			#take the character off of the ship
			allSanePassengers.append(character) #list for characters who made it to the end
			print("Character IS DISEMBARKING. WAS POSITION " + str(character.global_position))
			character.global_position = disembarkPosition.global_position
			character.position = disembarkPosition.global_position
			character.global_position = disembarkPosition.position
			print("NOW POSITION " + str(character.global_position))
			#character.global_position = disembarkPosition.position
			character.deathHandler.disembarkCharacter(character)


func processInteraction():
	emit_signal("EnteredBlackHoleStation")
	insideCamera.current = true
	
func _on_Button_pressed():
	DropOffPassengers()

