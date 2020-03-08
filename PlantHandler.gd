extends Node2D

var currentValue = 100
var maxValue = 100

var regenRate = 30
var drainSources = []
var drainRate
var drainState = false
var maxDrainRate = 20

func adjustcurrentValue(amount):
	currentValue += amount
	if currentValue >= maxValue:
		currentValue = maxValue
	elif currentValue <= 0:
		currentValue = 0

func regen():
	#this method regenerates the plants over time. Just tweens the value back to full
	$Tween.stop(self, "currentValue")
	$Tween.interpolate_property(self, "currentValue", currentValue, maxValue, regenRate, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()

func drainValueOverTime(pointsDrainedPerSecond):

	#this method tweens the value to zero using the accumulated drain rates of all the things affecting this
	currentValue = currentValue

	$Tween.stop(self, "currentValue")

	$Tween.interpolate_property(self, "currentValue", currentValue, 0, calculateDrainRate(pointsDrainedPerSecond), Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)

	$Tween.start()
	
func calculateDrainRate(pointsDrainedPerSecond):

	#this will determine how many seconds total the drain should take if we're trying to drain X points per second
	#current health = points to drain divided by points per second drained = how many seconds it should take
	var currentValue = currentValue

	var rate = currentValue/pointsDrainedPerSecond


	return rate

func addNewDrainSource(drainSource, newDrainPerSecond):
	#this method adds a new drain source to the list, sets 'drainState' to true, and adds to the cumulative drainRate of all the sources combined, before calling the 'DrainValue' method
	#var affectedStat = determineStat(whichStat)


	#this is adding to the sources that may be draining the  stat
	drainSources.append(drainSource)

	#this is determining wether the stat is overall being drained, which if the sources are greater than one, yes
	drainState = true

	drainRate += newDrainPerSecond

	#RATES -- determining the drain rate (how many points are being drained per second) and adding to it

	if(drainRate >= maxDrainRate):
		drainRate = maxDrainRate

	drainValueOverTime(calculateDrainRate(drainRate))

func RemoveNewDrainSource(drainSource, newDrainPerSecond):
	#this method checks if there are still other drain sources, removes, recalculates the rate, and starts the tween over

	if(drainSources.size() > 0):

		#if there are still sources draining the health, remove the drain source not acting any longer,
		# and start over the healthTween with the decreased rate

		if(drainSources.has(drainSource)):
			drainSources.erase(drainSource)

			drainRate -= newDrainPerSecond
			if(drainRate <= 0):
				drainRate = 0

	if(drainSources.size() == 0):
		#if there aren't any sources draining any longer, set to false
		drainState = false
		stopAllDrains() #!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

func restartInterruptedDrain():

	var currentValue = currentValue #DetermineWhichValue(whichStat)
	if(drainSources.size() > 0 && currentValue > 0):
		#only restart if there's some shit still draining
		drainValueOverTime(2)

func stopAllDrains():
	#when there are no more drain sources, stop the tween that is interating the current value  AND the tween that is iterating the bar
	$Tween.stop(self, "currentValue")
	#start the regen tween to get the plant's health back up
	regen()
	#characterStats.stopAnimatingBar(characterStats.statTweens[affectedStat])

func intervalReached(interval):
	print("We reached the interval of " + interval)
	SendHarvest()

func SendHarvest():
	#this sends the FoodHarvested signal, which should happen every hour?? and go to the FoodDispenser 
	SignalManager.emit_signal("FoodHarvested", currentValue)
	pass
