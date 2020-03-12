extends Object

func ChooseRandomFromList(list):
    #will choose a random value from a list, no matter if it only has two values
    return list[randi()%list.size()]