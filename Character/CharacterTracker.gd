extends Node2D

var characters = []

func AddCharacter(character):
    ConnectSignals(character)
    characters.append(character)
    print("Character Added and tracked!")

func ConnectSignals(character):
    pass

func DisconnectSignals(character):
    pass

func RemoveCharacter(character)#, methodOfRemoval): //TODO add the removal method onto different method
    #methodOfRemoval = death
    #methodOfRemoval = disappearance, etc.
    DisconnectSignals(character)
    characters.remove(character)
    print("Character Removed and no longer tracked!")

func FindCharacterWithComparison(comparison):
    var comparisonDictionary = {}
    if comparison.contains('currentHealth'):
        comparisonDictionary[character] = character.statCurrentValues[character.stringToEnum['health']]
    if comparison.contains('currentSanity'):
        comparisonDictionary[character] = character.statCurrentValues[character.stringToEnum['sanity']]
    if comparison.contains('currentSustenance'):
        comparisonDictionary[character] = character.statCurrentValues[character.stringToEnum['sustenance']]
    if comparison.contains('currentRelationship'):
        comparisonDictionary[character] = character.statCurrentValues[character.stringToEnum['relationship']]
    #... FIX MORE HERE AFTER CONVERSION FROM ENUM TO DICTIONARY

    for character in dictionary.keys():
        pass

func checkIncludedTraits(traits):
    var traitIncluded = false
    for trait in traits:
        traitIncluded = compareTraits(trait)
    return traitIncluded
    

func compareTraits(trait):
    #pass
    var traitContained = false
    for character in characters:
        if character.characterAttributes.has(trait):
            traitContained = true
    return traitContained

func compareValues(comparison, characterDictionary):
    var splitArray = comparision.split(",")
    #keep to it being three values, second index should be the number
    var charactersFittingComparision = []
    if ">" in comparison:
        for character in characterDictionary.keys():
            if characterDictionary[character] > splitArray[2] :
                charactersFittingComparison.append(character)

    elif "<" in comparison: 
        for character in characterDictionary.keys():
            if characterDictionary[character] < splitArray[2] :
                charactersFittingComparison.append(character)

    elif ">=" in comparison:
        for character in characterDictionary.keys():
            if characterDictionary[character] >= splitArray[2] :
                charactersFittingComparison.append(character)

    elif "<=" in comparison: 
        for character in characterDictionary.keys():
            if characterDictionary[character] <= splitArray[2] :
                charactersFittingComparison.append(character)
    
    elif "==" in comparision:
        for character in characterDictionary.keys():
            if characterDictionary[character] == splitArray[2] :
                charactersFittingComparison.append(character)


func _ready():
    pass