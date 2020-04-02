extends Node2D

onready var light = get_node("Light2D")
var defaultLightEnergy = 5

func _ready():
    add_to_group("Lights")

func TurnOff():
    light.energy = 0

func TurnOn():
    light.energy = defaultLightEnergy