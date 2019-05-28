extends Control

### GUI ELEMENT###
onready var tooltipNode = get_node("Tooltip")
onready var attributeText = get_node("Label")

func setAttribute(attribute):
  attributeText.text = attribute.attributeName
  tooltipNode.setTooltipText(attribute.description)

func _ready():
  pass
   # self.connect("mouse_enter", self, "_mouse_enter")
   # self.connect("mouse_exit", self, "_mouse_exit")

func _on_Label_mouse_entered():
  tooltipNode.visible = true
  print("Tooltip visible")
  #tooltipNode.isVisisble(true)

func _on_Label_mouse_exited():
  tooltipNode.visible = false
  print("Tooltip not visible")
  #tooltipNode.isVisisble(false)

# func _mouse_enter():
#    get_tree().get_root().tooltipNode.showToolTip(true)
#
#
# func _mouse_exit():
#    get_tree().get_root().tooltipNode.showToolTip(false)
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
