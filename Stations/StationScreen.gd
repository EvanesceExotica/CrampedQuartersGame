extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

signal success
signal gameOver

signal meterEffected(amount)

func initializeGame():
	print("Initializing")

func openScreen():
	pass
	#activate screen/have camera look at screen

func closeScreen():
	self.hide()
	#get_parent().remove_child(self)
	pass
	#close screen/have camera return to main room camera
# Called when the node enters the scene tree for the first time.
func gameSuccess():
	print("SUCCESS")
	emit_signal("success")
	closeScreen()

func gameOver():
	print("Game over")
	emit_signal("gameOver")
	closeScreen()


func _input(event):
	if(event.is_action_pressed("ui_cancel")):
		closeScreen()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
