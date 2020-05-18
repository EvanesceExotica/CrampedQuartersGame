extends Node2D

var testCharacter
var targetCharacter
func MakeInsane():
	testCharacter.changeStatValue(testCharacter.sanity, null, -100, false)
	pass

func MakeHungry():
	testCharacter.changeStatValue(testCharacter.sustenance, null, -100, false)

func _input(event):
	if event.is_action_pressed("ui_focus_next"):
#	if event is InputEventKey and event.scancode == KEY_L and not event.echo:
		var characters = get_tree().get_nodes_in_group("Characters")
		testCharacter = characters[0]
		targetCharacter = characters[1]

		targetCharacter.relationshipModule.AdjustRelationship(testCharacter, -30)
		testCharacter.relationshipModule.AdjustRelationship(targetCharacter, -30)
		MakeInsane()

