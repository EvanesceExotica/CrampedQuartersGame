extends Node2D


enum directions{
	vertical,
	horizontal
}
export (directions) var direction

onready var line = get_node("Line2D")
onready var rayCast = get_node("RayCast2D")
var hitSomething = false
onready var timer = get_node("Timer")
var surgeIntervalMin = 2
var surgeIntervalMax = 3

func _ready():
	if direction == directions.horizontal:
		rayCast.set_cast_to(Vector2(self.global_position.x, 1000))
		line.add_point(self.global_position)
		line.add_point(Vector2(self.global_position.x, 800))
	elif direction == directions.vertical:
		rayCast.set_cast_to(Vector2(1000, self.global_position.y))
		line.add_point(self.global_position)
		line.add_point(Vector2(800, self.global_position.y))
	line.visible = false
	restartSurgeTimer()
	#line.add_point(get_parent().global_position)
	pass

func _process(delta):
	if rayCast.is_colliding():
		hitSomething = true
	   # if rayCast.get_collider()
		print("hit something! " + str(rayCast.get_collider()))
		
func startSurge():
	timer.set_wait_time(1)
	timer.connect("timeout", self, "surge")
	timer.start()

func restartSurgeTimer():
	var random = rand_range(surgeIntervalMin, surgeIntervalMax)
	timer.set_wait_time(random)
	timer.connect("timeout", self, "surge")
	timer.start()

func surge():
	setEnabled()
	line.visible = true
	timer.set_wait_time(1)
	timer.connect("timeout", self, "setDisabled")
	timer.start()


func setEnabled():
	rayCast.enabled = true

func setDisabled(): 
	rayCast.enabled = false
	line.visible = false
	restartSurgeTimer()
