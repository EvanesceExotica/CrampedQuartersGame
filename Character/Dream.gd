extends Sprite

var randomThoughts = {} #random thoughts
var desires = {} #things they actually want
var nightmares = {} #bad dreams -- click to chase away? -- will cause sanity imrpovements
onready var interactableObject = get_node("InteractableObject")

var speed = 10.0
var direction = Vector2(0, -1)

enum Type{
    random,
    desire,
    nightmare
}
var ourType

func generateType():
    pass

func RiseAndFade():
    pass

func _physics_process(delta):
    move
    set_pos(get_pos() + dir * (speed * delta))

func _on_Area2D_mouse_entered():
    interactableObject.handInZone = true
    pass

func _on_Area2D_mouse_exited():
    pass