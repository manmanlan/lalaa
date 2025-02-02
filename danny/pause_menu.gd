extends Control

@onready var pause_menu = $PauseMenu
@onready var color_rect = $PauseMenu/ColorRect  # Reference to ColorRect for shading

const SETTINGS_MENU = preload("res://danny/settings_menu2.tscn")
var spawn_position = Vector2(0, 0)
var settings_instance  # Store the settings menu instance
var max_health = 8

func _ready():
	get_tree().paused = false  # Ensure game starts unpaused
	

func _on_settings_closed():
	self.show()  # Reopen pause menu
	print("Settings menu closed, showing pause menu")  # Debug print
	pause_menu.visible = true  # Make sure the Pause Menu is visible

	# Remove settings menu from the scene tree, but ensure the instance exists first
	if settings_instance:
		settings_instance.queue_free()  # Only free it if it's valid
		settings_instance = null  # Set the reference to null after freeing it

func resume():
	get_tree().paused = false
	pause_menu.visible = false

func pause():
	get_tree().paused = true
	pause_menu.visible = true

func Testesc():
	# Only check if settings_instance is valid and inside the tree
	if settings_instance != null:
		return  # Don't process ESC if the settings menu is in the scene tree

	if Input.is_action_just_pressed("esc"):
		if get_tree().paused:
			resume()
		else:
			pause()

func _process(delta):
	Testesc()

func _on_resume_pressed():
	resume()

func _on_settings_p_pressed():
	pause_menu.visible = false
	if get_tree().current_scene:  # Ensure the current scene is valid
		if settings_instance == null:  # Only create a new instance if it's null
			settings_instance = SETTINGS_MENU.instantiate()
			add_child(settings_instance)
			settings_instance.connect("back_pressed", Callable(self, "_on_settings_closed"))
			print("Settings menu instance created and signal connected")  # Debug print
		
		settings_instance.show()  # Show settings menu if already created
	else:
		print("No current scene is loaded.")

func _on_return_to_main_menu_pressed():
	Global.player_hp = max_health
	resume()
	get_tree().change_scene_to_file("res://danny/background.tscn")
