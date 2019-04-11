extends Area2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var hoverTimeRequired = 0.5

var handInZone = false

var timer

var cameraTween
#export(float) var test
#export(NodePath) onready var destinationRoom = get_node(destinationRoom)

var destinationCameraPosition

enum Rooms{

	airlock,
	aquarium,
	supplyCloset,
	reactorRoom,
	mainRoom
}

export (Rooms) var destinationRoomType

var destinationRoom

func switchRooms():
	var camera2D = get_parent().get_node("Camera2D")
	var cameraTween = camera2D.get_node("Tween")
	camera2D.global_position = destinationCameraPosition.global_position
	# var startingPosition = camera2D.global_position
	# cameraTween.interpolate_property(camera2D, "global_position", startingPosition, destinationCameraPosition.global_position, 2.0, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	# cameraTween.start()
	# #System.tweenMainCameraToNewRoom(destinationCameraPosition)

	#destinationCamera.current = true

func startCountdown():
	timer = Timer.new()
	timer.set_wait_time(hoverTimeRequired)
	timer.connect("timeout", self, "onBulkheadHoverTimeout")
	add_child(timer)
	timer.start()

func stopCountdown():
	timer.stop()

func onBulkheadHoverTimeout():
	switchRooms()
	pass

func _ready():
	if(destinationRoomType == Rooms.airlock):
		destinationRoom = get_parent().get_node("AirlockRoom")

	elif(destinationRoomType == Rooms.aquarium):
		destinationRoom = get_parent().get_node("AquariumRoom")

	elif(destinationRoomType == Rooms.supplyCloset):
		destinationRoom = get_parent().get_node("SupplyClosetRoom")

	elif(destinationRoomType == Rooms.reactorRoom):
		destinationRoom = get_parent().get_node("ReactorRoom")

	elif(destinationRoomType == Rooms.mainRoom):
		destinationRoom = get_parent().get_node("MainRoom")

	destinationCameraPosition = destinationRoom.get_node("CameraPosition")
	#print(destinationCameraPosition.global_position)
	pass # Replace with function body.


func _input(event):
	if(event.is_action_pressed("ui_up") && handInZone):
		switchRooms()

func _on_Bulkhead_area_entered(area):
	if(area.name == "Hand"):
		print("TouchingBulkhead")
#		startCountdown()
		handInZone = true


func _on_Bulkhead_area_exited(area):
	if(area.name == "Hand"):
		handInZone = false
