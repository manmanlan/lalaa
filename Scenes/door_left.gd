extends Area2D


const ROOM_2 = preload("res://room_2.tscn")
var v1=true




func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.position.x-=40
		if v1:
			spawn(Vector2(-442,8))
			v1 =false
		
		
func spawn(spawn_position: Vector2) -> void:
	var ROOM_2_temp = ROOM_2.instantiate()
	add_child(ROOM_2_temp)
	ROOM_2_temp.position = spawn_position
