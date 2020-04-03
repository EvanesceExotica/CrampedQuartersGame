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
var downwardMovement 
var flushed = false

signal justFlushed
signal flushReleased

func _ready():
	#Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	pass
func _process(delta):
	var distance = self.global_position.distance_to(topNode.global_position)
	var distanceToBottom = self.global_position.distance_to(get_parent().get_node("BottomNode").global_position)

	var clickingLeft = Input.is_action_pressed("left_click")
	if distanceToBottom < 100 && !flushed:
		#FLUSH PIPES HERE
		emit_signal("justFlushed")
		#get_parent().flushPipes()
		flushed = true
		pass
	if (!dragging && mouse_in && Input.is_action_pressed("left_click") && mouseMovingDown):
		addingForce = true
		dragging = true
		self.linear_velocity = Vector2(0, 100)

	if (dragging && Input.is_action_pressed("left_click")) && mouseMovingDown && downwardMovement >= 0.5:
		var down = 100/(distance/50)
		#print(down)
		self.linear_velocity = Vector2(0, down)
	else:
		if dragging:
			#self.linear_velocty = Vector2(0, 0)
			self.apply_impulse(Vector2(0, 0), Vector2(0, -3 * distance))
			if distanceToBottom > 40 || !clickingLeft:
#				self.applied_force = Vector2(0, 0)
				#self.apply_impulse(Vector2(0, 0), Vector2(0, -400))
				dragging = false
				emit_signal("flushReleased")

func process(delta):

	var distance = self.global_position.distance_to(topNode.global_position)
	var distanceToBottom = self.global_position.distance_to(get_parent().get_node("BottomNode").global_position)

	var clickingLeft = Input.is_action_pressed("left_click")
	if (!dragging && mouse_in && Input.is_action_pressed("left_click") && mouseMovingDown):
		addingForce = true
		dragging = true
		#self.add_force(Vector2(), Vector2(0, 20))
	if (dragging && Input.is_action_pressed("left_click")) && mouseMovingDown && downwardMovement >= 0.5:
	#	if mouseMovingDown:
		self.applied_force = Vector2(0, 0)
		var downwardForce = 50 #* (distanceToBottom/1000)
		#print(downwardForce)
		self.add_force(Vector2(), Vector2(0, downwardForce))
		#print(self.applied_force)
		if distanceToBottom > 40:

		# 	#self.linear_velocity.y = self.linear_velocity.y/distance#lerp(self.linear_velocity.y, 0, 0.3*distance)
		# 	#print(self.linear_velocity.y)
			var resistance = -0.5 * distance
			if resistance <= -50:
				resistance = -50
			self.add_force(Vector2(), Vector2(0, resistance))
			print(applied_force)
			if self.applied_force.y < 0:
				print("Applied force " + str(self.applied_force))
				print("Resistance " + str(resistance))
				get_tree().paused = true

	#	else:
	#		pass
			# if distance < 150:
			# 	self.applied_force = Vector2(0, 0)
			# 	self.apply_impulse(Vector2(0, 0), Vector2(0, -400))
			# 	dragging = false
	else:
		if dragging:
			if distanceToBottom > 40 || !clickingLeft:
				self.applied_force = Vector2(0, 0)
				#self.apply_impulse(Vector2(0, 0), Vector2(0, -400))
				self.apply_impulse(Vector2(0, 0), Vector2(0, -7 * distance))
				dragging = false

func _input(event):
	if event is InputEventMouseMotion:
		downwardMovement = event.relative.y
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
