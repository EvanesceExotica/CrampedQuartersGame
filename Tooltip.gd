extends Panel

# Declare member variables here. Examples:

onready var text = get_node("TooltipText")
# var a = 2
# var b = "text"
var specialWords = {}

func colorWords(string):
	for substring in specialWords.keys():
		if string.find(substring):
			#if you find the substring in this, replace all occurances with value in special colorWords
			#which should be markup version of substring
			string.replace(substring, specialWords[substring])
	pass

func setTooltipText(string):
	text.Text = string

func showToolTip(isVisisble, tooltipValues):
   if(isVisisble):
       scene.set_pos(Vector2(0, 0)) #position
       # Do stuff like...
       # ...changing the labels on the tooltip scene
       scene.set_hidden(false)
   else:
       scene.set_hidden(true)

# Called when the node enters the scene tree for the first time.
func _ready():
	specialWorlds = {
		"health" : "[color=#E6285D]health[/color]",
		"sustenance" : "[color=#936BB9]sustenance[/color]",
		"sanity" : "[color=#56A2DD]sanity[/color]",
		"relationship" : "[color=#1DE0D2]relationship[/color]",
		"maximum" : "[b]maximum[/b]",
		"current" : "[i]current[/i]"

	}
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
