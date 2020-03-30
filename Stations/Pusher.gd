extends RigidBody2D

var push = true
func _process(delta):
    if push:
	    self.add_force(Vector2(), Vector2(0, 50))

func _input(event):
    if event.is_action_pressed("ui_interact"):
        push = !push
