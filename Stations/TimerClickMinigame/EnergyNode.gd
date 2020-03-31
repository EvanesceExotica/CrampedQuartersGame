extends Node2D

var moving = false

func _ready():
    pass

func moveNode(startNode, destinationNode):
    #on the move, so not risking blowing up
    resetTimer()
    $Tween.interpolate_property(self, "position", startNode.global_position, destinationNode.global_position, 2, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
    $Tween.start()

func _on_Tween_tween_completed():
    resetTimer()
    pass

func resetTimer():
    $Timer.set_wait_time(rand_range(6, 10))
    $Timer.start()

func _on_Timer_timeout():
    print("BOOOOOM")
    #circuit overloaded
    
    pass