extends Node2D

var shooting = false
@onready var sword: Node2D = $sword1
var Anipa = false


# Direction mapping for input actions
const DIRECTIONS = {
	"<-": Vector2(-1, 0),
	"->": Vector2(1, 0),
	"up": Vector2(0, 1),
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
	sword.z_index = 2 if action in ["<-", "down","->"] else 0
	
	rotation = deg_to_rad(rotation_deg)
	
	if Input.is_action_pressed("down"):
		position.x=-1
		position.y=--138
	
	if Input.is_action_pressed("up"):
		position.x=0
		position.y=-146
		
	if Input.is_action_pressed("<-"):
		position.x=-143
		position.y=-3
		
	if Input.is_action_pressed("->"):
		position.x=144
		position.y=-4
		
	if not shooting:
		shooting = true
		
		if not Anipa:
			$sword1/AnimationPlayer.play("swing")
			Anipa = true
		else:
			$sword1/AnimationPlayer.play("Swing reset")
			Anipa = false
		
# Ensure the Timer logic flows properly
		$sword1/Timer.start()
		await $sword1/Timer.timeout

		$sword1/Timer.start()
		await $sword1/Timer.timeout
		shooting = false


func _on_animation_completed():
	if Anipa:
		$sword1/AnimationPlayer.play("Swing reset")  # Reset animation after swinging
	else:
		$sword1/AnimationPlayer.play("swing")  # Go back to swinging if needed
