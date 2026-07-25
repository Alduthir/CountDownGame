class_name Count extends CharacterBody2D

@export var speed := 75.0
@export var sprint_speed := 120

@onready var animator: AnimatedSprite2D = %AnimatedSprite2D
@onready var playerTimer: Timer = %player_timer

var facing := "down"
var is_attacking := false


func _ready() -> void:
	animator.animation_finished.connect(_on_animation_finished)
	GameState.health_changed.connect(_on_health_changed)
	play_idle()
	playerTimer.wait_time = 1.0
	playerTimer.timeout.connect(drainThirst)
	playerTimer.start()


func _physics_process(delta: float) -> void:
	# Tijdens een aanval niet bewegen
	if is_attacking:
		velocity = Vector2.ZERO
		move_and_slide()
		return

	# Linkermuisknop = aanval
	if Input.is_action_just_pressed("attack"): # Koppel "attack" aan Mouse Left
		play_attack()
		return
	if Input.is_action_just_pressed("test_damage"):
		take_damage(10)
	
	var direction := Input.get_vector(
		"move_left",
		"move_right",
		"move_up",
		"move_down"
	)

	var current_speed = speed
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
	
	var mouse_direction = (get_global_mouse_position() - global_position).normalized()
	if abs(mouse_direction.y) > abs(mouse_direction.x):
		# Verticale aanval
		animator.flip_h = false

		if mouse_direction.y < 0:
			facing = "up"
			animator.play("attack_up")
		else:
			facing = "down"
			animator.play("attack_down")
	else:
		# Horizontale aanval
		if mouse_direction.x < 0:
			facing = "left"
			animator.flip_h = false
		else:
			facing = "right"
			animator.flip_h = true

		animator.play("attack_left")
		
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
	if amount <= 0:
		return

	GameState.health -= amount


func heal(amount: int) -> void:
	if amount <= 0:
		return

	GameState.health += amount

func _on_health_changed(new_health: int) -> void:
	print("Player health: ", new_health)

	if new_health <= 0:
		die()

func die() -> void:
	velocity = Vector2.ZERO
	set_physics_process(false)
	animator.play("dead")
	print("Player is dood")
	
func drink() -> void:
	if GameState.is_day() == true:
		GameState.thirst += 15
	else:
		GameState.thirst += 30

func drainThirst() -> void:
	if GameState.thirst > 0:
		if GameState.is_day() == true:
			GameState.thirst -= 2
		else:
			GameState.thirst -= 1
	else:
		GameState.health -= 1

		
	
