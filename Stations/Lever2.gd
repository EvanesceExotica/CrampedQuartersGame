extends RigidBody2D

var dragging = false
var mouse_in = false
var addingForce = false
var defaultReisitance

func _process(delta):
	if (!dragging && mouse_in && Input.is_action_pressed("left_click")):
		addingForce = true
		dragging = true
		self.add_force(Vector2(), Vector2(0, 100))
		self.mass *= 2
		print(self.mass)

	if (dragging && Input.is_action_pressed("left_click")):
		var position = get_viewport().get_mouse_position()
		#set_position(position)
	else:
		dragging = false
		self.mass = 1
		self.apply_impulse(Vector2(0, 0), Vector2(0, -100))


func _on_Lever2_mouse_entered():
	mouse_in = true


func _on_Lever2_mouse_exited():
	mouse_in = false
