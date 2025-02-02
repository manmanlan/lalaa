extends Node2D

var speed = 50
var follow_strength = 0.1
var move_limit = Vector2(40, 30)  # Adjust limits
var original_position

func _ready():
	original_position = position  # Store the starting position

func _process(delta):
	# Move background left
	position.x -= speed * delta
	if position.x < -500:
		position.x = 0

	# Get mouse position relative to the viewport center
	var viewport_center = get_viewport_rect().size / 2
	var mouse_offset = get_viewport().get_mouse_position() - viewport_center

	# INVERT the movement by negating the mouse offset
	var target_position = original_position - (mouse_offset * 0.1)
	
	# Limit the movement within the defined range
	target_position.x = clamp(target_position.x, original_position.x - move_limit.x, original_position.x + move_limit.x)
	target_position.y = clamp(target_position.y, original_position.y - move_limit.y, original_position.y + move_limit.y)

	# Smoothly interpolate to the target position
	position = position.lerp(target_position, follow_strength)
