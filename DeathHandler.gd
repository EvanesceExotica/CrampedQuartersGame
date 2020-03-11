extends Node2D


#right after death, the corpse will apply the 'shaken' effect, which drains sanity. After that, it will apply the 'diseased' affect if not gotten rid of.
var applyAuraa 
enum deathType{
    burning,
    freezing,
    radiation,
    airLock,
}

func generateCorpse(typeOfDeath):
    pass

