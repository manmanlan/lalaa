extends Node2D

const ROOM_0 = preload("res://room_0.tscn")
const DOOR_RIGHT = preload("res://Scenes/open_door.tscn")
const MAP = preload("res://Scenes/room_1.tscn")
const ROOM_OFFSET = Vector2(784, 464)  # Room size offset
const MAX_ROOMS = 20

var occupied_positions = {}  # Set to track occupied positions

func _ready() -> void:
	spawn_start(Vector2(0, 0))  
	
	while occupied_positions.size() < MAX_ROOMS:
		var random_position = get_random_position()
		if random_position != Vector2(-1, -1) and not occupied_positions.has(random_position):
			spawn(random_position)

func spawn(spawn_position: Vector2) -> void:
	var MAP_temp = MAP.instantiate()
	add_child(MAP_temp)
	MAP_temp.position = spawn_position
	occupied_positions[spawn_position] = true  # Mark position as occupied


func spawn_start(spawn_position: Vector2) -> void:
	var ROOM_0_temp = ROOM_0.instantiate()
	add_child(ROOM_0_temp)
	ROOM_0_temp.position = spawn_position
	occupied_positions[spawn_position] = true  # Mark position as occupied



func get_random_position() -> Vector2:
	var directions = [Vector2(1, 0), Vector2(-1, 0), Vector2(0, 1), Vector2(0, -1)]
	var base_position = occupied_positions.keys()[randi() % occupied_positions.size()]
	var direction = directions[randi() % directions.size()]
	var new_position = base_position + direction * ROOM_OFFSET
	
	if not occupied_positions.has(new_position):
		return new_position
	return Vector2(-1, -1)  # Return an invalid position if none is found
