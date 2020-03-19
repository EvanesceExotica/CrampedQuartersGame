extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var backgroundLocation = null
var primaryLocation = null

onready var area2D = get_node("Area2D")
onready var label = get_node("Label")
onready var sprite = get_node("StarSprite")
onready var anim = get_node("AnimationPlayer")
onready var tween = get_node("Tween")
onready var dottedCircle = get_node("DottedCircle")
onready var pointer = get_node("Pointer")

var isDistressLocation = false

var arrivalEventID = 1 
var selected = false


var isCurrentLocation = false
#maybe keep location info on this node too? But h ave it be a separate node or resource attached

func setAsDistressSignal():
	print("Playing signal animation ")
	anim.play("DistressPulse")
	isDistressLocation = true

func setPickable():
	area2D.input_pickable = true
	sprite.modulate = Color.green
	
	pass

func setUnpickable():
	area2D.input_pickable = false
	sprite.modulate = Color.white
# Called when the node enters the scene tree for the first time.
func _ready():
	SignalManager.connect("SelectedLocationNode", self, "CheckSelectedNode")
	SignalManager.connect("OnArrival", self, "CheckIfCurrentLocation")
	pass # Replace with function body.

func CheckIfCurrentLocation(node):
	if node == self:
		#if this node is us, but we aren't the current location, add the dressings of a current location
		setCurrentLocationDressing()
	elif node != self && isCurrentLocation:
		#if this node is us 
		removeCurrentLocationDressing()

		


func setCurrentLocationDressing():
	sprite.modulate = Color.cornflower
	tween.interpolate_property(pointer, "modulate",  Color(0, 0, 0, 0), Color.white, 0.25, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()
	anim.play("Bob")
	isCurrentLocation = true

func removeCurrentLocationDressing():
	tween.interpolate_property(pointer, "modulate",  Color.white, Color(0, 0, 0, 0), 0.25, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()
	isCurrentLocation = false

func addSelectionDressing():
	tween.interpolate_property(dottedCircle, "modulate", Color(0, 0, 0, 0), Color.green, 0.25, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()
	anim.play("SpinSelectionCircle")
	selected = true

func removeSelectionDressing():
	tween.interpolate_property(dottedCircle, "modulate", Color.green, Color(0, 0, 0, 0), 0.25, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()
	#anim.stop("SpinSelectionCircle")
	selected = false


func CheckSelectedNode(selectedNode):
	if selectedNode != self && selected:
		#deselct if another node is selected
		removeSelectionDressing()
	# elif selectedNode == self && selected:
	# 	print("DESELECTED ON NODE ITSELF")
	# 	#deselect if already selected
	# 	removeSelectionDressing()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func _on_Area2D_input_event(viewport, event, shape_idx):
	if (event is InputEventMouseButton && event.pressed):
		if(!selected):
			addSelectionDressing()
			SignalManager.emit_signal("SelectedLocationNode", self)
		elif(selected):
			removeSelectionDressing()
			SignalManager.emit_signal("DeselectedLocationNode", self)
			
		
