extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var cameraPosition = get_node("CameraPosition")
var stations = [] 
var slots = [] 
onready var camera = get_node("Camera2D")
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
