extends Node2D

@onready var bullet = preload("res://Scenes/bullet.tscn")
@onready var bow = $bow
var shooting = false

# Direction mapping for input actions
const DIRECTIONS = {
	"<-": Vector2(-1, 0),
	"->": Vector2(1, 0),
	"up": Vector2(0, -1),
	"down": Vector2(0, 1)
}
const ROTATIONS = {
	"<-": 270,
	"->": 90,
	"up": 0,
	"down": 180
}

func _physics_process(delta: float) -> void:
	var active_action = get_highest_priority_action()
	if active_action != "":
		handle_shooting(active_action, DIRECTIONS[active_action], ROTATIONS[active_action])

func get_highest_priority_action() -> String:
	# Define priority order: left > right > up > down
	var priority = ["<-", "->", "up", "down"]
	for action in priority:
		if Input.is_action_pressed(action):
			return action
	return ""

func handle_shooting(action: String, direction: Vector2, rotation_deg: float) -> void:
	bow.z_index = 2 if action in [ "down","->","<-"] else 0
	position = get_bow_position_adjustment(action)
	rotation = deg_to_rad(rotation_deg)
	
	if not shooting:
		shooting = true
		shoot_bullet(direction, rotation_deg)
		$Timer.start()
		await $Timer.timeout
		shooting = false

func get_bow_position_adjustment(action: String) -> Vector2:
	if action == "<-":
		return Vector2(-6, -8)
	elif action == "->":
		return Vector2(6, -8)
	elif action == "up":
		return Vector2(0, -5)
	elif action == "down":
		return Vector2(0, 0)
	return Vector2.ZERO

func shoot_bullet(direction: Vector2, rotation_deg: float) -> void:
	var bullet_temp = bullet.instantiate()
	get_parent().get_parent().add_child(bullet_temp)
	bullet_temp.position = global_position
	if bullet_temp.has_method("set_direction"):
		bullet_temp.set_direction(direction)
	elif bullet_temp.has_variable("direction"):
		bullet_temp.direction = direction
	
	bullet_temp.rotation = deg_to_rad(rotation_deg)
