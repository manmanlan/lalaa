extends Control

func _on_master_vol_mouse_exited():
	release_focus()

func _on_sfx_vol_mouse_exited():
	release_focus()

func _on_music_vol_mouse_exited():
	release_focus()

func _ready():
	# Initialize the slider values (optional if you set it in the editor)
	$"../CanvasLayer/Panel/VBoxContainer/Master Vol".value = db_to_linear(AudioServer.get_bus_volume_db(0))
	$"../CanvasLayer/Panel/VBoxContainer/SFX Vol".value = db_to_linear(AudioServer.get_bus_volume_db(1))
	$"../CanvasLayer/Panel/VBoxContainer/Music Vol".value = db_to_linear(AudioServer.get_bus_volume_db(2))
