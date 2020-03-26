extends Spatial

onready var particleHolder = get_node("ParticleHolder")
onready var startingGroup = particleHolder.get_node("StartingGroup")
onready var waitingGroup = particleHolder.get_node("WaitingGroup")
var direction
#when the stars get double the distance of the particle box emitter extents away 
#they should be completely off screen
#place them back on the other side of the screen

func setUpDirection(_direction):
	direction = _direction
	if direction == -1:
		#if we're moving to the right
		waitingGroup.translation.x = -20
	elif direction == 1:
		waitingGroup.translation.x = 20
		#if we're moving to the left

func translateParticleSystems():
	startingGroup.translate(Vector3(-0.01, 0, 0))
	waitingGroup.translate(Vector3(-0.01, 0, 0))
	#this will depend on the direction
	print(str(startingGroup.translation.x))
	print(str(waitingGroup.translation.x))
	if startingGroup.translation.x <= -20:
		startingGroup.translation = Vector3(20, 0, 0)
		#startingGroup.translation.x == 20
	if waitingGroup.translation.x <= -20:
		waitingGroup.translation = Vector3(20, 0, 0)
		#waitingGroup.translation.x = 20


func _process(delta):
	translateParticleSystems()

