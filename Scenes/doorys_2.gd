extends Area2D






func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.position.y += 40
		Global.up=1
		print(Global.right)
