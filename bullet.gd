extends Area2D

var speed = 700
var direction = Vector2.RIGHT  # Default direction is right

func _process(delta: float) -> void:
	position += direction * speed * delta  # Move the bullet

func set_direction(new_direction: Vector2) -> void:
	direction = new_direction.normalized()  # Normalize to avoid speed differences




func _on_visible_on_screen_enabler_2d_screen_exited() -> void:
	queue_free()
