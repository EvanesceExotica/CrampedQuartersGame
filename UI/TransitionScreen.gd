extends CanvasLayer

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

signal transitioned

onready var anim = get_node("AnimationPlayer")
onready var rect = get_node("Control/ColorRect") 


func change_scene(path, delay = 0.5):
	yield(get_tree().create_timer(delay), "timeout")
	anim.play("Fade")
	yield(anim, "animation_finished")
	anim.play_backwards("Fade")
	yield(anim, "animation_finished")
	emit_signal("transitioned")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
