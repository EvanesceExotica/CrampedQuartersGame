extends Control

### GUI ELEMENT###
onready var tooltipNode = get_node()
func _ready():
   self.connect("mouse_enter", self, "_mouse_enter")
   self.connect("mouse_exit", self, "_mouse_exit")


func _mouse_enter():
   get_tree().get_root().tooltipNode.showToolTip(true)


func _mouse_exit():
   get_tree().get_root().tooltipNode.showToolTip(false)
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
