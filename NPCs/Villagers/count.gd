extends CharacterBody2D

@export var speed: float = 75.0
@export var sprint_speed: float = 120.0

@onready var animator: AnimatedSprite2D = %AnimatedSprite2D

var facing: String = "down"
var is_attacking: bool = false
var is_dead: bool = false


func _ready() -> void:
	animator.animation_finished.connect(_on_animation_finished)
	GameState.health_changed.connect(_on_health_changed)
	play_idle()


func _physics_process(_delta: float) -> void:
	if is_dead:
		return

	# Tijdens een aanval niet bewegen
	if is_attacking:
		velocity = Vector2.ZERO
		move_and_slide()
		return

	# Linkermuisknop = aanval
	if Input.is_action_just_pressed("attack"):
		play_attack()
		return

	# Tijdelijke testknop voor schade
	if Input.is_action_just_pressed("test_damage"):
		take_damage(10)

	var direction := Input.get_vector(
		"move_left",
		"move_right",
		"move_up",
		"move_down"
	)

	var current_speed: float = speed

	if Input.is_action_pressed("sprint"):
		current_speed = sprint_speed

	velocity = direction * current_speed
	move_and_slide()

	if direction == Vector2.ZERO:
		play_idle()
	else:
		play_walk(direction)


func play_walk(direction: Vector2) -> void:
	if abs(direction.y) > abs(direction.x):
		animator.flip_h = false

		if direction.y < 0:
			facing = "up"
			animator.play("walk_up")
		else:
			facing = "down"
			animator.play("walk_down")
	else:
		if direction.x < 0:
			facing = "left"
			animator.flip_h = false
		else:
			facing = "right"
			animator.flip_h = true

		animator.play("walk_left")


func play_attack() -> void:
	is_attacking = true
	velocity = Vector2.ZERO

	var mouse_direction := get_global_mouse_position() - global_position

	# Als de muis exact op de speler staat, gebruik dan de huidige kijkrichting
	if mouse_direction.length_squared() == 0:
		play_attack_for_facing()
		return

	if abs(mouse_direction.y) > abs(mouse_direction.x):
		animator.flip_h = false

		if mouse_direction.y < 0:
			facing = "up"
			animator.play("attack_up")
		else:
			facing = "down"
			animator.play("attack_down")
	else:
		if mouse_direction.x < 0:
			facing = "left"
			animator.flip_h = false
		else:
			facing = "right"
			animator.flip_h = true

		animator.play("attack_left")


func play_attack_for_facing() -> void:
	match facing:
		"up":
			animator.flip_h = false
			animator.play("attack_up")

		"down":
			animator.flip_h = false
			animator.play("attack_down")

		"left":
			animator.flip_h = false
			animator.play("attack_left")

		"right":
			animator.flip_h = true
			animator.play("attack_left")


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


func _on_animation_finished() -> void:
	if animator.animation.begins_with("attack_"):
		is_attacking = false
		play_idle()


func take_damage(amount: int) -> void:
	if amount <= 0 or is_dead:
		return

	GameState.health -= amount


func heal(amount: int) -> void:
	if amount <= 0 or is_dead:
		return

	GameState.health += amount


func _on_health_changed(new_health: int) -> void:
	print("Player health: ", new_health)

	if new_health <= 0:
		die()


func die() -> void:
	if is_dead:
		return

	is_dead = true
	is_attacking = false
	velocity = Vector2.ZERO

	set_physics_process(false)
	animator.play("dead")
	print("Player is dood")
