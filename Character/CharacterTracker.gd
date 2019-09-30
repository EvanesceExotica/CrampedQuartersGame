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

func RemoveCharacter(character):#, methodOfRemoval): //TODO add the removal method onto different method
    #methodOfRemoval = death
    #methodOfRemoval = disappearance, etc.
    DisconnectSignals(character)
    characters.remove(character)
    print("Character Removed and no longer tracked!")

func FindCharacterWithComparison(comparison):
    var comparisonDictionary = {}
    # if comparison.contains('currentHealth'):
    #     comparisonDictionary[character] = character.statCurrentValues[character.stringToEnum['health']]
    # if comparison.contains('currentSanity'):
    #     comparisonDictionary[character] = character.statCurrentValues[character.stringToEnum['sanity']]
    # if comparison.contains('currentSustenance'):
    #     comparisonDictionary[character] = character.statCurrentValues[character.stringToEnum['sustenance']]
    # if comparison.contains('currentRelationship'):
    #     comparisonDictionary[character] = character.statCurrentValues[character.stringToEnum['relationship']]
    #... FIX MORE HERE AFTER CONVERSION FROM ENUM TO DICTIONARY

    #for character in dictionary.keys():
    #    pass

func FindFittingCharacter(requirement):

    var potentialCharacters = [] + characters
    if requirement["requiredTraits"].size() > 0:
        checkIfCharacterHasAnyOfTraits(requirement["requiredTraits"], potentialCharacters)
    if requirement["requiredTraits"].size() > 0:
            #remove all that don't have the required traits
        checkIncludedTraits(requirement["requiredTraits"], potentialCharacters)
    if requirement["excludedTraits"].size() > 0:
            #remove all that have the included traits
        checkExcludedTraits(requirement["excludedTraits"], potentialCharacters)
    if requirement["requiredTraits"].size() == 0 && requirement["excludedTraits"].size() == 0:
            #remove none and go on to choose a random character
        print("This had no requirements, return a random character")

    #if there are multipole characters that fit the requirements
    if potentialCharacters.size() > 1:
        var randomNumber = randi()%potentialCharacters.size()
        return potentialCharacters[randomNumber]
    elif potentialCharacters.size() == 1:
        return potentialCharacters[0]
    elif potentialCharacters.size() == 0:
        return null
        
func checkIfCharacterHasAnyOfTraits(traits, potentialCharacters):
    var charactersThatMayHaveTraits = [] + potentialCharacters
    #make a character list
    for character in charactersThatMayHaveTraits:
        #for all characters that haven't been excluded yet
        var attributeList = []
        for attribute in character.characterAttributes:
            #get the characters attributes and dump them into a list with the names
            attributeList.append(attribute.attributeName)
        var hasAny = false
        for trait in traits:
            #for all the traits that we want any of
            if attributeList.has(trait):
                #if any of these traits exist in any capacity in the list
                hasAny = true
        if hasAny == false:
            #if the character has NONE of the traits above, erase it
            potentialCharacters.erase(character)
        
func checkIncludedTraits(traits, potentialCharacters):
    var charactersThatMayHaveTraits = [] + potentialCharacters

    for character in charactersThatMayHaveTraits:
        var attributeList = []
        for attribute in character.characterAttributes:
            attributeList.append(attribute.attributeName)
        for trait in traits:
            #for all the traits that are required
            if !attributeList.has(trait):
                #if this list doesn't have a trait, it doesn't have all of them, so erase
                potentialCharacters.erase(character)
        

    # for character in charactersThatMayHaveTraits:
    #     for trait in traits:
    #         if !character.characterAttributes.has(trait): 
    #         #if the character doesn't have this trait
    #             potentialCharacters.erase(character)

    
func checkExcludedTraits(traits, potentialCharacters):
    var charactersThatMayHaveTraits = [] + potentialCharacters
    for character in charactersThatMayHaveTraits:
        var attributeList = []
        for attribute in character.characterAttributes:
            attributeList.append(attribute.attributeName)
        for trait in traits:
            if attributeList.has(trait):
                potentialCharacters.erase(character)
    # for character in charactersThatMayHaveTraits:
    #     for trait in traits:
    #         if character.characterAttributes.has(trait):
    #             potentialCharacters.erase(character)

func compareTraits(trait):
    #pass
    var traitContained = false
    for character in characters:
        if character.characterAttributes.has(trait):
            traitContained = true
    return traitContained

func compareValues(comparison, characterDictionary):
    var splitArray = comparison.split(",")
    #keep to it being three values, second index should be the number
    var charactersFittingComparison = []
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
    
    elif "==" in comparison:
        for character in characterDictionary.keys():
            if characterDictionary[character] == splitArray[2] :
                charactersFittingComparison.append(character)


func _ready():
    pass