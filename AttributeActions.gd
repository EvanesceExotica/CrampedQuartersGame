extends Attribute

var numberOfTimesCalled =  { }
var signalsWaitingfor = { }

func CheckSignalCritera(signalCalled):
  var ourMethod = signalCalled
  for signalCriteria in signalsWaitingfor:
    if(signalCriteria.signalListeningFor == signalCalled):
      signalCriteria.numOfTimesCalled+= 1
      if signalCriteria.numOfTimesCalled >= signalCriteria.timesCalledToTriggerMethod
      call(ourMethod)
        #CALL METHOD
  pass

func RemoveSelfFromCharacter():
  characterAttachedTo.removeAttribute(self)
  pass



func Spread():
  pass
