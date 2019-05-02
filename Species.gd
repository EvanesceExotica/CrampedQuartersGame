extends Attribute

var slotTypeComfortRanking = []

var _init():
  for i in range 8:
   slotTypeComfortRanking.append([])

#I.E. normal human : slotTypeComfortRanking[0] = System.normalAirSeating
#: slotTypeComfortRanking[1] = System.uncomfortableSeating
#: slotTypeComfortRanking[2] = System.dangerousSeating
#: slotTypeComfortRanking[3] = System.airLock
