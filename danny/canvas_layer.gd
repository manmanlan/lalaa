extends CanvasLayer

var menu_open = false

# Reference to the game Viewport node
@onready var game_viewport = $Viewport

func _input(event):
	if event.is_action_pressed("ui_cancel"):  # "ui_cancel" is usually mapped to Esc
		toggle_menu()

func toggle_menu():
	menu_open = !menu_open
	visible = menu_open
	
	if menu_open:
		# Render the current game state into the ViewportTexture
		$Background.texture = game_viewport.get_texture()
		$Background.visible = true
	else:
		$Background.visible = false
