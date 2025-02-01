extends Area2D

signal player_teleport

@export var target_scene_path: String = "res://path/to/your/target_scene.tscn"  # Path to the scene
@export var spawn_position: Vector2 = Vector2(100, 100)  # Position where the player should appear in the new scene

func _ready():
	# Connect the signal to the method in the player script
	# Find the player node in the scene and connect the signal to the method
	var player = get_node("/root/YourScene/Player")  # Replace with the actual path to the player node
	if player:
		connect("body_entered", player, "_on_teleport_area_entered")  # Connect signal to player method

# Signal handler for when the player enters the teleport area
func _on_teleport_area_entered(body):
	if body.is_in_group("player"):  # Make sure it's the player
		emit_signal("player_teleport")
