extends Node2D
var hello
var speed: float = 100
@onready var anim = $Area2D/AnimatedSprite2D
var target_angle = (Global.player_pos - global_position).angle()
func _physics_process(delta: float) -> void:
	if anim.animation == "new_animation":
		
		rotation += delta * 0.8
	elif anim.animation !="new_animation":
		var direction = (Global.player_pos - global_position).normalized()
		position += direction * speed * delta

func _on_animated_sprite_2d_animation_finished() -> void:
	print("hel")
	
	if anim.animation != "new_animation":
		anim.play("new_animation")

	$Timer.start()
	await $Timer.timeout
	queue_free()
