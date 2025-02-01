extends Area2D

@onready var player = preload("res://Scenes/player.tscn")
@onready var SWORD_1 = preload("res://Scenes/sword_1.tscn")


func _on_body_entered(body: Node2D) -> void:
	var sword1_temp = SWORD_1.instantiate()
	body.add_child(sword1_temp)
	sword1_temp.position = Vector2(0, 0)
	queue_free()
