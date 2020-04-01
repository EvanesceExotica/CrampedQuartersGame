extends Area2D


onready var parent = get_parent().get_parent()
var nodeConnectedTo = null
var nodesConnectedTo = []
var colors = [Color.coral, Color.cornflower, Color.palegreen, Color.gold]
var ourColor
var mouseIn = false

func _ready():
	randomize()
	chooseDefaultColor()
	resetTimer()

func _input(event):
	if event.is_action_pressed("left_click"):
		if mouseIn:	
			if parent.connecting && parent.lastConnected != self && nodeConnectedTo == null:
				if parent.lastConnected.ourColor == ourColor:
					parent.createConnection(self)
			elif !parent.connecting:
				parent.lastConnected = self
				parent.connecting = true
				parent.lineConnection.default_color = ourColor


func _on_ConnectNode_mouse_entered():
	mouseIn = true
	# if parent.connecting && parent.lastConnected != self && nodeConnectedTo == null:
	# 	if parent.lastConnected.ourColor == ourColor:
	# 		parent.createConnection(self)

func _on_ConnectNode_mouse_exited():
	mouseIn = false
	# if nodesConnectedTo.size() <= 2:
	# 	parent.lastConnected = self
	# 	parent.connecting = true
	# 	parent.lineConnection.default_color = ourColor

	# if nodeConnectedTo == null:
	# 	parent.lastConnected = self
	# 	parent.connecting = true
	# 	parent.lineConnection.default_color = ourColor

func switchColor():
	var remainingColors = [] + colors
	remainingColors.erase(ourColor)
	var randomIndex = randi()%remainingColors.size()
	ourColor = remainingColors[randomIndex]
	self.modulate = ourColor

func chooseDefaultColor():
	var randomIndex = randi()%colors.size()
	ourColor = colors[randomIndex]
	self.modulate = ourColor

func resetTimer():
	$Timer.set_wait_time(rand_range(3, 4))
	$Timer.start()

func _on_Timer_timeout():
	if parent.lastConnected != self  &&  nodeConnectedTo == null:
		switchColor()
		resetTimer()
	pass # Replace with function body.
