extends Node2D


var defaultGravity = -1
var gravityScaleMax = -2.15
var mouse_in = false
var dragging = false
var addingForce = false
onready var handle = get_node("Handle")
onready var topNode = get_node("TopNode")

func _process(delta):
    if (!dragging && mouse_in && Input.is_action_pressed("left_click")):
        addingForce = true
        dragging = true
        print("Adding force")
        handle.add_force(Vector2(), Vector2(0, 200))

    if (dragging && Input.is_action_pressed("left_click")):
        var position = get_viewport().get_mouse_position()
        #set_position(position)
    else:
        dragging = false

func _physics_process(delta):
    #print(str(handle.position.distance_to(topNode.position)))
    #move_and_collide(Vector2(0, 3))
    if(!dragging && addingForce):
        handle.add_force(Vector2(), Vector2(0, -200))
        handle.gravity_scale = defaultGravity
        addingForce = false
    elif dragging:# && handle.position.distance_to(topNode.position) > 100:
        if(handle.gravity_scale > gravityScaleMax):
            handle.gravity_scale-=0.01 

func _on_Handle_mouse_entered():
    print("Mouse entered handle")
    mouse_in = true

func _on_Handle_mouse_exited():
    print("Mouse exited handle")
    mouse_in = false
