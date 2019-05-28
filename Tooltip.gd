extends Panel

# Declare member variables here. Examples:

onready var tooltipText = get_node("TooltipText")
# var a = 2
# var b = "text"
var specialWords = {}

func colorWords(string):
	var newString = string
	for substring in specialWords.keys():
		if newString.findn(substring):
			#if you find the substring in this, replace all occurances with value in special colorWords
			#which should be markup version of substring
			newString.replace(substring, specialWords[substring])
	return newString	
	pass

func setTooltipText(string):
	tooltipText.text = colorWords(string)

# func showToolTip(isVisisble, tooltipValues):
#    if(isVisisble):
#        scene.set_pos(Vector2(0, 0)) #position
#        # Do stuff like...
#        # ...changing the labels on the tooltip scene
#        scene.set_hidden(false)
#    else:
#        scene.set_hidden(true)

# Called when the node enters the scene tree for the first time.
func _ready():
	specialWords = {
		"health" : "[color=#E6285D]Health[/color]",
		"sustenance" : "[color=#936BB9]Sustenance[/color]",
		"sanity" : "[color=#56A2DD]Sanity[/color]",
		"relationship" : "[color=#1DE0D2]Relationship[/color]",
		"maximum" : "[b]Maximum[/b]",
		"current" : "[i]Current[/i]"

	}
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
