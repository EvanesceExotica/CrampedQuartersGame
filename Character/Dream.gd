extends Sprite

var randomThoughts = {} #random thoughts
var desires = {} #things they actually want
var nightmares = {} #bad dreams -- click to chase away? -- will cause sanity imrpovements
onready var interactableObject = get_node("InteractableObject")

var speed = 100.0
var direction = Vector2(0, -1)

enum Type{
	random,
	desire,
	nightmare
}
var ourType

func generateType():
	ourType = Type.values()[ randi()%Type.size() ]
	if ourType == Type.random:
		pass
	elif ourType == Type.desire:
		pass
	elif ourType == Type.nightmare:
		#maybe nightamres are hidden as desires until you hover over them? Then they start to grow and scream?
		pass

func RiseAndFade():
	pass

func _physics_process(delta):
	translate(direction * (speed * delta))
	#set_pos(get_pos() + dir * (speed * delta))

func _on_Area2D_mouse_entered():
	interactableObject.handInZone = true
	pass

func _on_Area2D_mouse_exited():
	pass

func _on_Area2D_input_event(viewport, event, shape_idx):
	if (event is InputEventMouseButton && event.pressed):
		Pop()

func Grow():
	var startScale = self.scale
	var endScale = Vector2(40, 40)
	$Tween.interpolate_property(self, "scale", startScale, endScale, 10, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()
	
func FadeIn():
	$Tween.interpolate_property(self, "modulate", Color(1, 1, 1, 0), Color(1,1, 1, 1), 3, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()

func FadeOut():
	$Tween.interpolate_property(self, "modulate", Color(1, 1, 1, 1), Color(1,1, 1, 0), 3, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()

func FadeToBlue():
	$Tween.interpolate_property(self, "self_modulate", Color(1, 1, 1, 1), Color.cornflower, 5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()

func FadeToRed():
	$Tween.interpolate_property(self, "self_modulate", Color(1, 1, 1, 1), Color.red, 5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()

func _ready():
	#set to invisible
	self.modulate = Color(1, 1, 1, 0)
	FadeIn()
	FadeToRed()
	#FadeToBlue()
	#Grow()

func Pop():
	$AnimationPlayer.play("Pop")
	$Tween.stop_all()
