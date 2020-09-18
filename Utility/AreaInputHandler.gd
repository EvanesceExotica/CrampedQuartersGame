extends Node2D

export(Array) var ourType = []#this should hvae particular "tags"

var parent
var area2d
var mouseHovering = false

func _ready():
	parent = get_parent()
	if parent is Area2D:
		area2d = parent
	else:
		for node in parent.get_children():
			if node is Area2D:
				area2d = node
	if area2d != null:
		area2d.connect("mouse_entered", self, "onMouseEntered")
		area2d.connect("mouse_exited", self, "onMouseExited")

# func _ready():
#    pass
#    parent = get_parent()
#    if parent is Area2D:
# 	   area2d = parent
#    else:
# 		for node in parent.get_children():
# 			if node is Area2D:
# 				area2d = node
# 	   #area2d = parent.get_node("Area2D")
#    print(parent.name + " has area2d?" + str(area2d))
#    if area2d != null:
# 	   area2d.connect("mouse_entered", self, "onMouseEntered")
# 	   area2d.connect("mouse_exited", self, "onMouseExited")

func onMouseEntered():
	print("Mouse entered " + area2d.name)
	mouseHovering = true
	pass

func onMouseExited():
	print("Mouse exited " + area2d.name)
	mouseHovering = false
	pass

func disableInput(exception):
	if !ourType.has(exception):
		#if we're not exempt from being disabled
		set_process(false)
		set_physics_process(false)
		set_process_input(false)


func enableInput(exception):
	if !ourType.has(exception):
		set_process(false)
		set_physics_process(false)
		set_process_input(false)
	pass
