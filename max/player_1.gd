extends CharacterBody2D

# Constants for movement
const SPEED: float = 100.0
const ACCEL: float = 10.0
const ANIMATION_SPEED: int = 6  # Frames per second for walking animations

# Frame size (will be set dynamically)
var FRAME_WIDTH: int = 64
var FRAME_HEIGHT: int = 64

# Node references
@onready var sprite: Sprite2D = $Sprite2D  # Reference to the main Sprite2D node
@onready var hat: Sprite2D = $Hat  # Reference to the hat Sprite2D node
@onready var box: Sprite2D = $Box  # Reference to the box Sprite2D node
@onready var fbox: Sprite2D = $FBox  # Reference to the box Sprite2D node
@onready var blue: Sprite2D = $Blue  # Reference to the box Sprite2D node
@onready var orange: Sprite2D = $Orange  # Reference to the box Sprite2D node
@onready var point: Sprite2D = $Point  # Reference to the box Sprite2D node
@onready var dab: Sprite2D = $Dab  # Reference to the box Sprite2D node
@onready var bob: Sprite2D = $Bob  # Reference to the box Sprite2D node

# Variables for input, animations, and direction
var input: Vector2
var animation_timer: float = 0.0
var facing_direction: int = 0  # 0: Down, 1: Up, 2: Right, 3: Left
var is_moving: bool = false  # Movement flag

func _ready() -> void:
	# Ensure the sprite and texture are properly set up
	if not sprite or not sprite.texture:
		print("Error: Main sprite or texture not set!")
		return

	if not hat or not hat.texture:
		print("Error: Hat sprite or texture not set!")
		return

	if not box or not box.texture:
		print("Error: Box sprite or texture not set!")
		return

	# Dynamically calculate frame size
	FRAME_WIDTH = sprite.texture.get_width() / 8
	FRAME_HEIGHT = sprite.texture.get_height() / 8

	# Enable sprite regions and set initial frames for all layers
	sprite.region_enabled = true
	hat.region_enabled = true
	box.region_enabled = true

	sprite.region_rect = Rect2(Vector2.ZERO, Vector2(FRAME_WIDTH, FRAME_HEIGHT))
	hat.region_rect = Rect2(Vector2.ZERO, Vector2(FRAME_WIDTH, FRAME_HEIGHT))
	box.region_rect = Rect2(Vector2.ZERO, Vector2(FRAME_WIDTH, FRAME_HEIGHT))

	print("Texture size: ", sprite.texture.get_size(), ", Frame size: (", FRAME_WIDTH, ", ", FRAME_HEIGHT, ")")

func get_input() -> Vector2:
	# Capture movement input
	input.x = Input.get_action_strength("d") - Input.get_action_strength("a")
	input.y = Input.get_action_strength("s") - Input.get_action_strength("w")
	return input.normalized()

func _process(delta: float) -> void:
	# Update the sprite based on mouse direction and movement
	update_sprite(delta)

func _physics_process(delta: float) -> void:
	# Handle movement
	var player_input = get_input()
	velocity = lerp(velocity, player_input * SPEED, delta * ACCEL)
	move_and_slide()

	# Update movement status (used to control walking animation)
	is_moving = velocity.length() > 0.1  # Ensure the character is truly moving

func update_sprite(delta: float) -> void:
	# Get the direction to the mouse
	var mouse_position = get_global_mouse_position()
	var direction = (mouse_position - global_position).normalized()

	# Determine the facing direction based on the mouse position
	if abs(direction.x) > abs(direction.y):
		facing_direction = 2 if direction.x > 0 else 3  # Right or Left
	else:
		facing_direction = 0 if direction.y > 0 else 1  # Down or Up

	# Determine the animation frame
	var frame_x: int = 0
	if is_moving:
		animation_timer += delta * ANIMATION_SPEED
		frame_x = int(animation_timer) % 6  # Cycle through walking frames
	else:
		animation_timer = 0
		frame_x = 0  # Immediately switch to standing frame when not moving

	# Calculate the Y offset based on direction
	var frame_y = facing_direction
	if is_moving:
		if facing_direction == 0:  # Walking Down
			frame_y = 4
		elif facing_direction == 1:  # Walking Up
			frame_y = 5
		elif facing_direction == 2:  # Walking Right
			frame_y = 6
		elif facing_direction == 3:  # Walking Left
			frame_y = 7

	# Safely update the region_rect for all sprites
	update_layer_region(sprite, frame_x, frame_y)
	update_layer_region(hat, frame_x, frame_y)
	update_layer_region(box, frame_x, frame_y)
	update_layer_region(fbox, frame_x, frame_y)
	update_layer_region(blue, frame_x, frame_y)
	update_layer_region(orange, frame_x, frame_y)
	update_layer_region(point, frame_x, frame_y)
	update_layer_region(dab, frame_x, frame_y)
	update_layer_region(bob, frame_x, frame_y)


func update_layer_region(layer: Sprite2D, frame_x: int, frame_y: int) -> void:
	if layer.texture:
		var texture_size = layer.texture.get_size()
		if frame_x * FRAME_WIDTH < texture_size.x and frame_y * FRAME_HEIGHT < texture_size.y:
			layer.region_rect = Rect2(Vector2(frame_x * FRAME_WIDTH, frame_y * FRAME_HEIGHT), Vector2(FRAME_WIDTH, FRAME_HEIGHT))
		else:
			print("Warning: region_rect out of bounds for layer: ", layer.name)
			

@onready var interact_ray: RayCast2D = $InteractRay

signal toggle_inventory()
@export var inventory_data: InventoryData

func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("inventory"):
		toggle_inventory.emit()
		
	if Input.is_action_just_pressed("interact"):
		interact()
		
func interact() -> void:
	if interact_ray.is_colliding():
		interact_ray.get_collider().player_interact()
