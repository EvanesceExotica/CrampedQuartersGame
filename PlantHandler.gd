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
