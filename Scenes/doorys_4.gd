extends Area2D






func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.position.x -= 40
		Global.left=1
		print(Global.left)
