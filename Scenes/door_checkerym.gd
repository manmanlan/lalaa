extends Area2D

@onready var tile_map: TileMap = $".."
var acjesent=true
var wall_tile := Vector2i(7, 7)



func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("door"):
		acjesent=false
		
		queue_free()


func _ready() -> void:
	$"Timer".start()
	await $"Timer".timeout
	if acjesent:
		print("uu")
		var tile_position = Vector2i(0,0) # Convert global_position to Vector2i
		tile_position = Vector2i(12,-26)
		for i in range(3):
			tile_map.set_cell(0, tile_position, 1, wall_tile) # Ensure the layer, position, tile ID, and autotile coordinates are correct
			tile_position += Vector2i(1, 0)
			queue_free()
