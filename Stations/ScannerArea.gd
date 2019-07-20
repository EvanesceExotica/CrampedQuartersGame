extends Area2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
signal interactPressed(array)

var overlappingArray = []
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _input(event):
	if(event.is_action_pressed("ui_interact")):
		if(overlappingArray.size() > 0):
			for item in overlappingArray:
				emit_signal("interactPressed", overlappingArray)
				print(item.name)
		#if(mouseHovering):
			#loadMinigameScene()
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func _on_ScannerArea_area_entered(area):
	overlappingArray.append(area)
	#print(area.name + " Shit entered")
	pass

func _on_ScannerArea_area_exited(area):
	overlappingArray.erase(area)
	#print(area.name + " Shit exited")
	pass