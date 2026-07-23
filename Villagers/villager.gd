extends CharacterBody2D

@export var speed := 75.0

@onready var animator: AnimatedSprite2D = %AnimatedSprite2D

var facing := "down"

func _physics_process(delta: float) -> void:
	var direction := Input.get_vector(
		"move_left",
		"move_right",
		"move_up",
		"move_down"
	)

	velocity = direction * speed
	move_and_slide()

	if direction == Vector2.ZERO:
		play_idle()
	else:
		play_walk(direction)


func play_walk(direction: Vector2) -> void:
	# Verticale beweging krijgt voorrang
	if abs(direction.y) > abs(direction.x):
		animator.flip_h = false

		if direction.y < 0:
			facing = "up"
			animator.play("walk_up")
		else:
			facing = "down"
			animator.play("walk_down")
	else:
		facing = "left"

		if direction.x < 0:
			animator.flip_h = false
		else:
			animator.flip_h = true

		animator.play("walk_left")


func play_idle() -> void:
	match facing:
		"up":
			animator.flip_h = false
			animator.play("idle_up")
		"down":
			animator.flip_h = false
			animator.play("idle_down")
		"left":
			animator.flip_h = false
			animator.play("idle_left")
		"right":
			animator.flip_h = true
			animator.play("idle_left")
