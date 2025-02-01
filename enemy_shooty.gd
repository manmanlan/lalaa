extends CharacterBody2D

const ENEMEY_BULLET = preload("res://enemey_bullet.tscn")
var speed = 50
var target_direction
var shoot =false
var walk=false
var walking=false




func _physics_process(delta: float):
	
	# Access the global player position
	var player_position = Global.player_pos
	
	# Calculate the direction towards the player
	target_direction = (player_position - global_position).normalized()
	if not walking:
	# Move the enemy towards the player
		if global_position.distance_to(player_position) > 3:
			velocity = target_direction * speed
			move_and_slide()
	if not walk:
		walk= true
		$Timer.start()
		await $Timer.timeout
		walking=true
		if not shoot:
			shoot=true
			$Timer.start()
			await $Timer.timeout
			shoot_bullet()
			
			
			shoot=false
			walk=false
			walking=false

func shoot_bullet() -> void:
	var bullet_temp = ENEMEY_BULLET.instantiate()
	get_parent().add_child(bullet_temp)
	bullet_temp.speed=200
	bullet_temp.position = position
	if bullet_temp.has_method("set_direction"):
		bullet_temp.set_direction(target_direction)
	elif bullet_temp.has_variable("direction"):
		bullet_temp.direction = target_direction
