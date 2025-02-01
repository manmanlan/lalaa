extends Area2D

@onready var player = preload("res://Scenes/player.tscn")
@onready var bow1 = preload("res://Scenes/bow1.tscn")


func _on_body_entered(body: Node2D) -> void:
	var bow1_temp = bow1.instantiate()
	body.add_child(bow1_temp)
	bow1_temp.position = Vector2(0, 0)
	queue_free()
