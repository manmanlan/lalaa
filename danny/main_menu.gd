extends Control

func _on_play_pressed():
	get_tree().change_scene_to_file("res://main.tscn")


func _on_settings_pressed():
	if get_tree().current_scene:  # Ensure the current scene is valid
		var current_scene_path = get_tree().current_scene.get_scene_file_path()  # Get the scene's file path
		Global.previous_scene = current_scene_path  # Save the path in the global singleton
		get_tree().change_scene_to_file("res://danny/Settings_menu.tscn")
	else:
		print("No current scene is loaded.")



func _on_quit_pressed():
	get_tree().quit()
