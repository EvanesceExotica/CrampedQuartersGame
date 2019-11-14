extends Sprite

onready var animationPlayer = get_node("AnimationPlayer")

func PlayWarningFlash():
    animationPlayer.play("FlashWarning")

func StopWarningFlash():
    animationPlayer.stop()
    pass