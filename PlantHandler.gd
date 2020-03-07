extends Node2D

var currentHealth = 100
var maxHealth = 100

var regenRate
var drainSources = []

func adjustCurrentHealth(amount):
    currentHealth += amount
    if currentHealth >= maxHealth:
        currentHealth = maxHealth
    elif currentHealth <= 0:
        currentHealth = 0

func regen():
    $Tween.stop(self, "currentHealth")

	$Tween.interpolate_property(self, "currentHealth", currentValue, 0, regenRate, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)

    $Tween.start()

func drainValueOverTime(pointsDrainedPerSecond):

	currentValue = currentHealth

	$Tween.stop(self, "currentHealth")

	$Tween.interpolate_property(self, "currentHealth", currentValue, 0, calculateDrainRate(pointsDrainedPerSecond), Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)

    $Tween.start()
    
func calculateDrainRate(affectedStat, pointsDrainedPerSecond):

	#this will determine how many seconds total the drain should take if we're trying to drain X points per second
	#current health = points to drain divided by points per second drained = how many seconds it should take
	var currentValue = affectedStat.currentValue

	var rate = currentValue/pointsDrainedPerSecond


	return rate

func determineStat(statName):
	#will return the object that's variable name is health, sanity, sustenance, or relationship
	return get(statName)

func addNewDrainSource(affectedStat, drainSource, newDrainPerSecond):

	#var affectedStat = determineStat(whichStat)


	#this is adding to the sources that may be draining the  stat
	affectedStat.drainSources.append(drainSource)

	#this is determining wether the stat is overall being drained, which if the sources are greater than one, yes
	affectedStat.drainState = true

	affectedStat.drainRate += newDrainPerSecond

	#RATES -- determining the drain rate (how many points are being drained per second) and adding to it

	if(affectedStat.drainRate >= 20):
		affectedStat.drainRate = 20

	drainValueOverTime(affectedStat, drainSource, calculateDrainRate(affectedStat, affectedStat.drainRate))

func RemoveNewDrainSource(affectedStat, drainSource, newDrainPerSecond):
	#var affectedStat = determineStat(whichStat)

	if(affectedStat.drainSources.size() > 0):

		#if there are still sources draining the health, remove the drain source not acting any longer,
		# and start over the healthTween with the decreased rate

		if(affectedStat.drainSources.has(drainSource)):
			affectedStat.drainSources.erase(drainSource)

			affectedStat.drainRates -= newDrainPerSecond
			if(affectedStat.drainRates <= 0):
				affectedStat.drainRates = 0

	if(affectedStat.drainSources.size() == 0):
		#if there aren't any sources draining any longer, set to false
		affectedStat.drainState = false
		stopAllDrains(affectedStat) #!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

func restartInterruptedDrain(affectedStat):

	var currentValue = affectedStat.currentValue #DetermineWhichValue(whichStat)
	if(affectedStat.drainSources.size() > 0 && currentValue > 0):
		#only restart if there's some shit still draining
		drainValueOverTime(affectedStat, null, 2)

func stopAllDrains(affectedStat):
	#when there are no more drain sources, stop the tween that is interating the current hp AND the tween that is iterating the bar
	$Tween.stop(affectedStat, "currentValue")
	characterStats.stopAnimatingBar(characterStats.statTweens[affectedStat])

func drainValueOverTime(affectedStat, drainSource, rate):

	var currentValue
	var whichBar
	var whichTween

	currentValue = affectedStat.currentValue #statCurrentValues[whichStat]
	whichBar = characterStats.statBars[affectedStat]
	whichTween = characterStats.statTweens[affectedStat]
	#whichPointsDrainedPerSecond = statDrainRates[whichStat]

	#pause any tweens already happening and rstart to add a ny new values
	$Tween.stop(affectedStat, "currentValue")
	

	$Tween.interpolate_property(affectedStat, "currentValue", currentValue, 0, calculateDrainRate(affectedStat, affectedStat.drainRate), Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)

	characterStats.animateBar(whichTween, whichBar, currentValue, 0, calculateDrainRate(affectedStat, affectedStat.drainRate))
	$Tween.start()

func calculateDrainRate(pointsDrainedPerSecond):

	#this will determine how many seconds total the drain should take if we're trying to drain X points per second
	#current health = points to drain divided by points per second drained = how many seconds it should take
	var currentValue = currentHealth

	var rate = currentValue/pointsDrainedPerSecond


    return rate

func SendHarvest():
    #this sends the FoodHarvested signal, which should happen every hour?? and go to the FoodDispenser 
    SignalManager.emit_signal("FoodHarvested", currentHealth)
    pass
