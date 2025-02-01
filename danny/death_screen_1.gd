extends Control

@onready var death_screen = $DeathScreen
@onready var return_to_main_menu = $"DeathScreen/VBoxContainer/Return To Main Menu"


var max_health = 8

func Death():
	if Global.player_hp == 0:
		death_screen.visible = true
		return_to_main_menu.disabled = false
		$Timer.start()
		await$Timer.timeout
		get_tree().paused = true

func _on_return_to_main_menu_pressed():
	Global.player_hp = max_health
	death_screen.visible = false
	get_tree().paused = false
	get_tree().change_scene_to_file("res://danny/main_menu.tscn")

func _process(delta):
	Death()
