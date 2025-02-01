extends Area2D



var speed = 500
var direction = Vector2.RIGHT  # Default direction is right

func _process(delta: float) -> void:
	position += direction * speed * delta  # Move the bullet

func set_direction(new_direction: Vector2) -> void:
	direction = new_direction.normalized()  # Normalize to avoid speed differences
	
	$Timer.start()
	await $Timer.timeout
	queue_free()






func _on_body_entered(body: Node2D) -> void:
	if body.has_method("hurt"):
		body.hurt()
	queue_free()
