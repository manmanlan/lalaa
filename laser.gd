extends Node2D

var hello
var random: int

# Store all AnimatedSprite2D nodes in an array
@onready var anim_sprites = [
	$Area2D/AnimatedSprite2D,
	$Area2D/AnimatedSprite2D2,
	$Area2D/AnimatedSprite2D3,
	$Area2D/AnimatedSprite2D4
]

func _ready():
	random = randi_range(0, 1)  # Initialize random value

func _physics_process(delta: float) -> void:
	# Check if any of the animations is playing "new_animation"
	var is_playing_new_animation = false
	for anim in anim_sprites:
		if anim.animation == "new_animation":
			is_playing_new_animation = true
			break  # Exit the loop early if any sprite is playing "new_animation"

	# Apply rotation only if any sprite is playing "new_animation"
	if is_playing_new_animation:
		if random == 1:
			rotation += delta * 0.4  # Adjust the multiplier to control speed
		else:
			rotation -= delta * 0.4  # Adjust the multiplier to control speed

func _on_animated_sprite_2d_animation_finished() -> void:
	print("hel")
	
	# Play "new_animation" on all AnimatedSprite2D nodes if they aren't already playing it
	for anim in anim_sprites:
		if anim.animation != "new_animation":
			anim.play("new_animation")

	# Start the timer and free the node after it times out
	$Timer.start()
	await $Timer.timeout
	queue_free()
