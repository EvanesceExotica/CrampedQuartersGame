extends "res://Stations/StationScreen.gd"

onready var bars = []
onready var keys = [KEY_Q, KEY_W, KEY_E, KEY_R]

func _ready():
	setChemicalKeys()

func setChemicalKeys():
	for child in get_children():
		if child is TextureProgress:
			bars.append(child)
	for i in range(bars.size()):
		bars[i].chosenKey = keys[i]
			#child.chosenKey = keys[bars.find(child)]
			#print(str(child.chosenKey))
