extends Control

# Variable to store the path of the previous scene
var previous_scene = ""

# Function to set the previous scene path before navigating to the settings menu
func set_previous_scene(scene_path):
	previous_scene = scene_path

# Function for the back button to return to the previous scene
func _on_back_pressed():
	if Global.previous_scene != "":
		get_tree().change_scene_to_file(Global.previous_scene)
	else:
		print("Previous scene path not set.")
