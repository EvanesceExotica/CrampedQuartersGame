extends Area2D


onready var parent = get_parent().get_parent()
var nodeConnectedTo = null
var nodesConnectedTo = []
var colors = [Color.red, Color.blue, Color.green, Color.yellow]
var ourColor

func _ready():
	randomize()
	resetTimer()

func _on_ConnectNode_mouse_entered():
	# if parent.connecting && parent.lastConnected != self && nodesConnectedTo.size() <= 2:
	# 	if parent.lastConnected.ourColor == ourColor:
	# 		parent.createConnection(self)
	if parent.connecting && parent.lastConnected != self && nodeConnectedTo == null:
		if parent.lastConnected.ourColor == ourColor:
			parent.createConnection(self)
	#if parent.lastConnected != null && parent.lastConnected != self && nodeConnectedTo == null:
		pass
		#nodeConnectedTo = parent.lastConnected
		#parent.lastConnected.nodeConnectedTo = self

func _on_ConnectNode_mouse_exited():
	# if nodesConnectedTo.size() <= 2:
	# 	parent.lastConnected = self
	# 	parent.connecting = true
	# 	parent.lineConnection.default_color = ourColor

	if nodeConnectedTo == null:
		parent.lastConnected = self
		parent.connecting = true
		parent.lineConnection.default_color = ourColor

func switchColor():
	var remainingColors = [] + colors
	remainingColors.erase(ourColor)
	var randomIndex = randi()%remainingColors.size()
	ourColor = remainingColors[randomIndex]
	self.modulate = ourColor

func resetTimer():
	$Timer.set_wait_time(rand_range(3, 4))
	$Timer.start()

func _on_Timer_timeout():
	if parent.lastConnected != self  &&  nodeConnectedTo == null:
		switchColor()
		resetTimer()
	pass # Replace with function body.
