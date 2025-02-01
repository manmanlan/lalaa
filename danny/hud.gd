extends CanvasLayer

@onready var healthbar_2 = $Healthbar2


var max_health = 8  # Maximum health (can be adjusted if needed)

func _process(delta):
	healthbar_2.frame = clamp(Global.player_hp, 0, max_health)
