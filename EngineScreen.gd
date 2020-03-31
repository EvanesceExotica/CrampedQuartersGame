extends "res://Stations/StationScreen.gd"

var buildUpPanels = []
var amountToMalfunction
var minAmount = 1
var maxAmount = 3
var currentIndex = 0
var selectedPanel

onready var positionCenter = get_node("PositionCenter")
onready var positionRight = get_node("PositionRight")
onready var positionLeft = get_node("PositionLeft")

func _ready():
    for item in get_children():
        if item is TextureProgress:
            buildUpPanels.append(item)
    selectedPanel = buildUpPanels[currentIndex]

func Spike():
    var malFunctioningPanels = [] + buildUpPanels
    var amountToMalfunction = randi()%maxAmount + minAmount
    #should return a random number between maxamount and minamount
    for i in range(amountToMalfunction):
        var randomIndex = randi()%buildUpPanels.size()
        var panel = malFunctioningPanels[randomIndex]
        panel.spikeBuildup()
        malFunctioningPanels.erase(panel)

func selectNewPanel():
    $Tween.interpolate_property(selectedPanel, "rect_position", selectedPanel.rect_position, positionCenter, 2, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
    
func _input(event):
    if event.is_action_just_pressed("ui_right"):
        currentIndex +=1
        if currentIndex == buildUpPanels.size():
            #if the index would be higher than the array, switch to the end of the array
            currentIndex = 0
        selectedPanel = buildUpPanels[currentIndex]
    
    elif event.is_action_just_pressed("ui_left"):
        currentIndex -=1
        if currentIndex == -1:
            #if the index would be lower than the array, switch to the end of the array
            currentIndex = buildUpPanels.size() - 1
        selectedPanel = buildUpPanels[currentIndex]



