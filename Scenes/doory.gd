extends Area2D

const ROOM_2 = preload("res://danny/Dungeon Room 1A.tscn")


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.position.y += 40
		Global.down=1
		print(Global.right)
		if $"..".v1:
			spawn(Vector2(-215, 392))
			$"..".v1 = false

func spawn(spawn_position: Vector2) -> void:
	var ROOM_2_temp = ROOM_2.instantiate()
	add_child(ROOM_2_temp)
	ROOM_2_temp.position = spawn_position
