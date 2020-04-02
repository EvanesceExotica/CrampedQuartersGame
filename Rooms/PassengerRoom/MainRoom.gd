extends Node2D


var stations = { }

var rightRoom
var bottomRoom
var leftRoom
var topRoom

func switchRooms(whichRoom):
	pass
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
func _input(event):
	if(event.is_action_pressed("ui_right")):
		print("Switching to right room")
		if(rightRoom != null):
			switchRooms(rightRoom)
	elif(event.is_action_pressed("ui_left")):
		print("Switching to left room")
		if(leftRoom != null):
			switchRooms(leftRoom)
	elif(event.is_action_pressed("ui_down")):
		print("Switching to bottom room")
		if(bottomRoom != null):
			switchRooms(bottomRoom)
	elif(event.is_action_pressed("ui_up")):
		print("Switching to top room")
		if(topRoom != null):
			switchRooms(topRoom)																			
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	# if(Input.is_action("ui_right"):
	# 	if(rightRoom != null):
	# 		switchRooms(rightRoom)
	# elif(Input.is_action("ui_left")):
	# 	if(leftRoom != null):
	# 		switchRooms(leftRoom)
	# elif(Input.is_action("ui_down")):
	# 	if(bottomRoom != null):
	# 		switchRooms(bottomRoom)
	# elif(Input.is_action("ui_up")):
	# 	if(topRoom != null):
	# 		switchRooms(topRoom)
			