extends Node2D

var currentRoom
var roomSwitched = false
func _input(event):

    var destinationRoom
    if event.is_action_pressed("ui_right"):
        print("Room to right of current is " + currentRoom.roomToRight)
        if currentRoom.roomToRight != null:
            destinationRoom = currentRoom.roomToRight;
            roomSwitched = true

    elif event.is_action_pressed("ui_left"):
        if currentRoom.roomToLeft != null:
            destinationRoom = currentRoom.roomToLeft;
            roomSwitched = true

    elif event.is_action_pressed("ui_up"):
        if currentRoom.roomAbove != null:
            destinationRoom = currentRoom.roomAbove;
            roomSwitched = true

    elif event.is_action_pressed("ui_down"):
        if currentRoom.roomBelow != null:
            destinationRoom = currentRoom.roomBelow;
            roomSwitched = true

    if(roomSwitched):
        SignalManager.emit_signal("OnRoomSwitched", currentRoom, get_node("destinationRoom"))
        currentRoom = get_node(destinationRoom)
        currentRoom.camera.current = true
        #currentRoom.SetCurrentRoom()
        roomSwitched = false
        print("Current room is " + currentRoom.name);

func _ready():
    currentRoom = get_parent().get_node("PassengerRoom")
    print("Current room is " + currentRoom.name)
    pass