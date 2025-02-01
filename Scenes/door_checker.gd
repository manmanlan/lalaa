extends Area2D
const DOOR_LEFT = preload("res://Scenes/door_left.tscn")
@onready var tile_map: TileMap = $".."
var acjesent=true
var wall_tile := Vector2i(4, 6)



func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("door"):
		acjesent=false


func _ready() -> void:
	$"Timer".start()
	await $"Timer".timeout
	if acjesent:
		print("wu")
		var tile_position = Vector2i(0,0) # Convert global_position to Vector2i
		tile_position = Vector2i(36,-12)
		for i in range(3):
			tile_map.set_cell(0, tile_position, 1, wall_tile) # Ensure the layer, position, tile ID, and autotile coordinates are correct
			tile_position += Vector2i(0, 1)
			queue_free()
	else:
		print("he")
		door(Vector2(0,0))
		


		queue_free()
		
		
func door(spawn_position: Vector2) -> void:
	var door_temp = DOOR_LEFT.instantiate()
	get_parent().add_child(door_temp)
	door_temp.position=spawn_position
