extends Node2D

var currentRoom
var roomSwitched = false
func _input(event):

    var destinationRoom
    #unassigned, these nodepaths will default to the current node
    #if(currentRoom.roomAbove == NodePath()):
    #    print(currentRoom.name + ": going Up is an Empty nodepath!!!")
    if event.is_action_pressed("ui_right"):
        if currentRoom.roomToRight != NodePath():
        #if get_node(currentRoom.roomToRight) != self:
            destinationRoom = currentRoom.roomToRight;
            roomSwitched = true

    elif event.is_action_pressed("ui_left"):
        if currentRoom.roomToLeft != NodePath():
        #if get_node(currentRoom.roomToLeft) != self:
            destinationRoom = currentRoom.roomToLeft;
            roomSwitched = true

    elif event.is_action_pressed("ui_up"):
        if currentRoom.roomAbove != NodePath():
        #if get_node(currentRoom.roomAbove) != self:
            destinationRoom = currentRoom.roomAbove;
            roomSwitched = true

    elif event.is_action_pressed("ui_down"):
        if currentRoom.roomBelow != NodePath():
        #if get_node(currentRoom.roomBelow) != self:
            destinationRoom = currentRoom.roomBelow;
            roomSwitched = true
    else:
        roomSwitched = false
    if(roomSwitched && destinationRoom != NodePath()):
        SignalManager.emit_signal("OnRoomSwitched", currentRoom, get_node(destinationRoom))
        currentRoom = get_node(destinationRoom)
        currentRoom.camera.current = true
        #currentRoom.SetCurrentRoom()
        roomSwitched = false
       # print(str(roomSwitched))
        print("Current room is " + currentRoom.name);

func _ready():
    currentRoom = get_parent().get_node("PassengerRoom")
    print("Current room is " + currentRoom.name)
    pass