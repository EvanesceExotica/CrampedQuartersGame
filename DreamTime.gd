extends Node2D

var minDream

var maxDream

func _ready():
    SignalManager.connect("DayPassed", self, "StartDreamTime")
#this method will generate dreams for a character that you click on depending on their traits?/things that've happened
#You can also tune into conversations. (Reason aside from busyness that you can't talk to them always?)
#generated phrases 

#low sanity = nonsensical dreams?
#add a castleDB with all the different things, separated into categories maybe
#use flags to show which trait category they'd fall under

func EndDreamTime():
    SignalManager.emit_signal("DreamTimeEnded")

func StartDreamTime():
    SignalManager.emit_signal("DreamTimeStarted")
    get_tree().paused = true
    var characters = get_tree().get_nodes_in_group("Characters")
    for character in characters:
        character.dreamSpawner.spawnDreams()
	get_tree().call_group("Characters","travelToFuture", beholdingTheTruth)#AttributeJSONParser.fetchAndCreateAttribute(beholdingTheTruth))