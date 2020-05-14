extends Node2D

var minDream

var maxDream
 
onready var sleepPanel = get_node("CanvasLayer/SleepPanel")
onready var restButton = sleepPanel.get_node("RestButton")
onready var watchDreamButton = sleepPanel.get_node("WatchDreamButton")
onready var parent = get_parent()
func SkipDreamTime():
	SignalManager.emit_signal("DreamTimeSkipped")

func _ready():
	SignalManager.connect("DayPassed", self, "PromptDreamtime")
	
func _on_WatchDreamButton_pressed():
	HidePanel()
	DisableButtons()
	parent.transitionScreen.fadeToClear()
	yield(parent.transitionScreen.fadeToClear(), "completed")
	StartDreamTime()
	pass

func _on_RestButton_pressed():
	HidePanel()
	DisableButtons()
	parent.transitionScreen.fadeToClear()
	yield(parent.transitionScreen.fadeToClear(), "completed")
	SkipDreamTime()
	pass

func DisableButtons():
	restButton.disabled = true
	watchDreamButton.disabled = true
	get_parent()

func EnableButtons():
	restButton.disabled = false
	watchDreamButton.disabled = false

func PromptDreamtime():

	#var transitionScreen = get_parent().get_node("TransitionScreen")
	var transitionScreen = parent.transitionScreen 
	transitionScreen.fadeToBlack()
	yield(transitionScreen.fadeToBlack(), "completed")
	#this method we're calling has the clock pause when dream time is being prompted/ or continuing
	#print("Finished")
	TimeConverter.SetDreamTime()
	get_tree().paused = true
	FadeHandler.FadeToColor($Tween, sleepPanel, "modulate", Color(1, 1, 1, 0), Color.white, 0.3)

	#find all characters, put in list
	var characters = get_tree().get_nodes_in_group("Characters")
	#print("There are this many characters " + str(characters.size()))
	if characters.size() == 0:
		#if there are no characters
		restButton.disabled = false
	else:
		#if there are some
		EnableButtons()

func HidePanel():
	get_tree().paused = false
	FadeHandler.FadeToColor($Tween, sleepPanel, "modulate", Color.white, Color(1, 1, 1, 0), 0.3)
	#sleepPanel.visible = false

#this method will generate dreams for a character that you click on depending on their traits?/things that've happened
#You can also tune into conversations. (Reason aside from busyness that you can't talk to them always?)
#generated phrases 

#low sanity = nonsensical dreams?
#add a castleDB with all the different things, separated into categories maybe
#use flags to show which trait category they'd fall under

func EndDreamTime():
	SignalManager.emit_signal("DreamTimeEnded")

func StartDreamTime():
	#maybe add some sort of energy debuff for choosing to use dreams. a "health" for the ship/you
	SignalManager.emit_signal("DreamTimeStarted")
   # get_tree().paused = true
	var characters = get_tree().get_nodes_in_group("Characters")
	for character in characters:
		character.dreamSpawner.spawnDreams()
	#get_tree().call_group("Characters","travelToFuture", beholdingTheTruth)#AttributeJSONParser.fetchAndCreateAttribute(beholdingTheTruth))
	
func _input(event):
	if event.is_action_pressed("ui_fire"):
	   #PromptDreamtime()
	   SignalManager.emit_signal("DayPassed")
	
