extends RigidBody2D

var dragging = false
var mouse_in = false
var addingForce = false
var defaultReisitance
var justReleased
var forceAmount = Vector2(0, 10)
var maxForceAmount = Vector2(0, 10)
onready var topNode = get_parent().get_node("TopNode")
var mouseMovingDown = true

func _process(delta):
	var distance = self.global_position.distance_to(topNode.global_position)
	if (!dragging && mouse_in && Input.is_action_pressed("left_click") && mouseMovingDown):
		addingForce = true
		dragging = true
		self.add_force(Vector2(), Vector2(0, 75))
		#self.mass *= 2
		#print(self.mass)

	if (dragging && Input.is_action_pressed("left_click")) && mouseMovingDown:
		var position = get_viewport().get_mouse_position()
		#set_position(position)
		self.add_force(Vector2(), Vector2(0, -0.03*distance))
		#print("Still adding upward force")
	else:
		if dragging:
			self.applied_force = Vector2(0, 0)
			self.apply_impulse(Vector2(0, 0), Vector2(0, -500))
			dragging = false
		#self.mass = 1

func _input(event):
	if event is InputEventMouseMotion:
		if event.relative.y > 0:
			mouseMovingDown = true
		else:
			mouseMovingDown = false
	# else:
	# 	mouseMoving = false
	# 	print("Mouse STOPPED moving")


func _on_Lever2_mouse_entered():
	mouse_in = true


func _on_Lever2_mouse_exited():
	mouse_in = false
	print("Mouse out")
