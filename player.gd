extends CharacterBody2D

var SPEED = 100.0
var hp=10
var timer=false
func _physics_process(delta: float) -> void:
	Global.player_pos=global_position
	
	
	velocity = Input.get_vector("a", "d", "w", "s") * SPEED

	
	
	if Input.is_action_pressed("<-"):
		$AnimatedSprite2D.play("left")
	elif Input.is_action_pressed("->"):
		$AnimatedSprite2D.play("right")
	elif Input.is_action_pressed("up"):
		$AnimatedSprite2D.play("up")
	elif Input.is_action_pressed("down"):
		$AnimatedSprite2D.play("default")
	
	move_and_slide()  # Move the player


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemey"):
		hurt()
func hurt():
	if not timer:
		timer=true
		hp-=1
		print(hp)
		$hurt_frames.start()
		await $hurt_frames.timeout
		timer=false
