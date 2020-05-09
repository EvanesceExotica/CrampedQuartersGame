extends Node2D

func DetermineIfEventHappens(chanceValue):
    var random = randf()
    if random <= chanceValue:
        pass
