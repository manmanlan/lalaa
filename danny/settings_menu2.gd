extends Control

@onready var pause_menu = $Pausemenu
# Variable to store the path of the previous scene
var previous_scene = ""

signal back_pressed  # Define a signal for when the back button is pressed

# Function to set the previous scene path before navigating to the settings menu
func set_previous_scene(scene_path):
	previous_scene = scene_path


func _on_back_pressed():
	emit_signal("back_pressed") 
	self.hide()  
	queue_free()
