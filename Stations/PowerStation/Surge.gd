extends Node2D


enum directions{
	vertical,
	horizontal
}
export (directions) var direction

onready var line = get_node("Line2D")
onready var rayCast = get_node("RayCast2D")
onready var animationPlayer = get_node("AnimationPlayer")
var hitSomething = false
onready var timer = get_node("Timer")
var surgeIntervalMin = 2
var surgeIntervalMax = 3


func _ready():
	if direction == directions.vertical:
		#rayCast.set_cast_to(Vector2(self.global_position.x, 800))
		rayCast.set_cast_to(Vector2(0, 800))
		line.add_point(Vector2(0, 0))
		line.add_point(Vector2(0, 800))
		#line.add_point(self.global_position)
		#line.add_point(Vector2(self.global_position.x, 800))
	elif direction == directions.horizontal:
		rayCast.set_cast_to(Vector2(800, 0))
		#rayCast.set_cast_to(Vector2(800, self.global_position.y))
		line.add_point(Vector2(0, 0))
		line.add_point(Vector2(800, 0))
		#line.add_point(self.global_position)
		#line.add_point(Vector2(800, self.global_position.y))
	line.visible = false
	restartSurgeTimer()
	#line.add_point(get_parent().global_position)
	pass

func _process(delta):
	if rayCast.is_colliding():
		hitSomething = true
	   # if rayCast.get_collider()
		print("hit something! " + str(rayCast.get_collider().name))
		
func startSurge():
	timer.set_wait_time(1)
	timer.connect("timeout", self, "surge")
	timer.start()

func restartSurgeTimer():
	#choose a random time for the surge to begin
	var random = rand_range(surgeIntervalMin, surgeIntervalMax)
	timer.set_wait_time(random)

	#disconnect the timeout of the timer from setDisabled if it's connected (so not the first time through, when it wouldn't be)
	if timer.is_connected("timeout", self, "setDisabled"):
		timer.disconnect("timeout", self, "setDisabled")

	#connect it to warn the surge as a 'tell' or 'telegraph' to the user
	timer.connect("timeout", self, "warnSurge")
	timer.start()

func warnSurge():
	#this method flickers the linerenderer as a telegraph to the user that a surge is about to begin
	#set it to flicker for .5 seconds, make the line visible and play the flicker animation
	timer.set_wait_time(0.5)
	line.visible = true
	animationPlayer.play("Flicker")
	#since we're already warning the surge, disconnect the timer's timeout from that and connect it to now actually start the surge when it times out
	if timer.is_connected("timeout", self, "warnSurge"):
		timer.disconnect("timeout", self, "warnSurge")
	timer.connect("timeout", self, "surge")
	timer.start()

func surge():
	#enable the raycast and play the surge animation which will have the line sort of grow and shrink over time
	setEnabled()
	#have this last for one second
	timer.set_wait_time(1)
	if timer.is_connected("timeout", self, "surge"):
		timer.disconnect("timeout", self, "surge")
	timer.connect("timeout", self, "setDisabled")
	timer.start()


func setEnabled():
	#this raycast will be a gameover if it collides with the end of the circuit
	rayCast.enabled = true
	animationPlayer.stop(true)
	animationPlayer.play("Surge")
	#line.visible = true

func setDisabled(): 
	rayCast.enabled = false
	animationPlayer.stop(true)
	line.visible = false
	restartSurgeTimer()
