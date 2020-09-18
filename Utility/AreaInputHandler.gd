extends Node2D

export(Array) var ourType = []#this should hvae particular "tags"

var parent
var area2d
var mouseHovering = false

func _ready():
	add_to_group("InputAreas")
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
	mouseHovering = true
	if parent.has_method("displayHoverInfo"):
		parent.displayHoverInfo()
	pass

func onMouseExited():
	mouseHovering = false
	if parent.has_method("hideHoverInfo"):
		parent.hideHoverInfo()
	pass

func disableInput(exceptions):
	if !exceptions.has(parent.get_class()):
		print(parent.name + " input being disabled")
		#if our parent's type is not exempt from being disabled, and is not in the exceptions array
		area2d.get_node("CollisionShape2D").set_deferred("disabled", true)
		# area2d.set_process(false)
		# set_process(false)
		# set_physics_process(false)
		# set_process_input(false)


func enableInput():
	set_process(false)
	set_physics_process(false)
	set_process_input(false)

func _input(event):
	pass
