extends "res://Stations/Dispenser/Dispenser.gd"

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	._ready()
	dispensedItem = ItemOptions.health
	pass # Replace with function body.


func onRespawnTimerTimeout():
	.onRespawnTimerTimeout()
	if(amountToDispense < maxAmountHeld):
		respawnItem()
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
