extends Sprite
class_name Dream

var randomThoughts = {} #random thoughts
var desires = {} #things they actually want
var nightmares = {} #bad dreams -- click to chase away? -- will cause sanity imrpovements
onready var interactableObject = get_node("InteractableObject")

var revealed = false
var speed = 100.0
var direction = Vector2(0, -1)

enum Type{
	random,
	desire,
	nightmare
}

func is_class(type):
	#overriding built in fuction
	return type == "Dream" or .is_class(type)

func get_class():
	#overriding built in fuction
	return "Dream"

var ourType



func generateType():
	#rather than doing this, just have all in a list and choose from
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
	if(!revealed):
		translate(direction * (speed * delta))
	#set_pos(get_pos() + dir * (speed * delta))

func _on_Area2D_mouse_entered():
	interactableObject.handInZone = true
	pass

func _on_Area2D_mouse_exited():
	interactableObject.handInZone = false
	pass
	pass

func _on_Area2D_input_event(viewport, event, shape_idx):
	if (event is InputEventMouseButton && event.pressed):
		Pop()

func Grow():
	var startScale = self.scale
	var endScale = Vector2(1, 1)
	$Tween.interpolate_property(self, "scale", startScale, endScale, 10, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()

func Pop():	
	$Tween.stop_all()
	var startScale = self.scale
	var endScale = Vector2(0, 0)
	$Tween.interpolate_property(self, "scale", startScale, endScale, 0.3, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
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
	$Tween.interpolate_property(self, "self_modulate", Color(1, 1, 1, 1), Color.red, 1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()

func _ready():
	#set to invisible
	generateType()
	self.modulate = Color(1, 1, 1, 0)
	FadeIn()
	#FadeToRed()
	if ourType == Type.desire || ourType == Type.nightmare:
		#if this is a desire or a nightmare, make it look like a desire
		FadeToBlue()

	if ourType == Type.nightmare:
		#if this is a nightmare, have a hidden timer
		$Timer.connect("timeout", self, "RevealNightmare")
		StartNightmareTimer()
	#Grow()

func RevealNightmare():
	revealed = true
	$Tween.stop_all()
	FadeToRed()
	Grow()

func StartNightmareTimer():
	var randomWaitTime = rand_range(3, 5)
	$Timer.set_wait_time(randomWaitTime)
	$Timer.start()

# func Pop():
# 	$AnimationPlayer.play("Pop")
# 	$Tween.stop_all()


func _on_Area2D_area_entered(area):
	var potentialDream = area.get_parent()
	if potentialDream.get_class() == "Dream":
		if ourType == Type.nightmare && revealed && potentialDream.ourType != Type.nightmare:
			#if we're a nightmare and the other dream isn't
			ConsumeDream(potentialDream)
		#the parent is the node that this Area2d is underneath


func ConsumeDream(dreamToConsume):
	dreamToConsume.Pop()


func _on_Tween_tween_completed(object, key):

	if object == self && key == ":scale":
		self.queue_free()
	pass # Replace with function body.
