class_name Count extends CharacterBody2D

@export var speed := 75.0
@export var sprint_speed := 120
@export var knockback_force := 200.0

@onready var animator: AnimatedSprite2D = %AnimatedSprite2D
@onready var playerTimer: Timer = %player_timer
@onready var hitbox_left : Area2D = %HitBoxLeft
@onready var hitbox_right : Area2D = %HitBoxRight
@onready var hitbox_up : Area2D = %HitBoxUp
@onready var hitbox_down : Area2D = %HitBoxDown

var facing := "down"
var is_attacking := false
var is_knocked_back = false
var knockback_velocity := Vector2.ZERO
var shader : ShaderMaterial
var is_invulnerable := false

func _ready() -> void:
	hitbox_left.body_entered.connect(deal_damage)
	hitbox_right.body_entered.connect(deal_damage)
	hitbox_up.body_entered.connect(deal_damage)
	hitbox_down.body_entered.connect(deal_damage)
	animator.animation_finished.connect(_on_animation_finished)
	play_idle()
	GameState.timer.timeout.connect(drainThirst)
	shader = animator.material

func _physics_process(delta: float) -> void:
	if is_knocked_back:
		
		velocity = knockback_velocity
		knockback_velocity = knockback_velocity.lerp(Vector2.ZERO, 5*delta)
		if knockback_velocity.length() < 100: is_knocked_back = false
		move_and_slide()
		return
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
		animator.play("walk_left")
		if direction.x < 0:
			facing = "left"
			animator.flip_h = false
		else:
			facing = "right"
			animator.flip_h = true

		


func play_attack() -> void:
	is_attacking = true
	
	var mouse_direction = (get_global_mouse_position() - global_position).normalized()
	if abs(mouse_direction.x) > abs(mouse_direction.y):
		# horizontal attack
		animator.play("attack_left")
		if mouse_direction.x > 0:
			animator.flip_h = true
			facing = "right"
			hitbox_right.monitoring = true
		else:
			animator.flip_h = false
			facing = "left"
			hitbox_left.monitoring = true
	else:
		# vertical attack
		animator.flip_h = false
		if mouse_direction.y > 0:
			facing = "down"
			animator.play("attack_down")
			hitbox_down.monitoring = true
		else:
			facing = "up"
			animator.play("attack_up")
			hitbox_up.monitoring = true



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

func deal_damage(body: Node2D) -> void:
	var direction_to_target = (body.global_position - global_position).normalized()
	if body is Guard:
		body.take_damage(10)
		body.apply_knockback(direction_to_target * knockback_force)
	elif body is Villager:
		print_debug("hit villager")
		body.apply_knockback(direction_to_target * -knockback_force)
		drink()	
		body.die()
		
func _on_animation_finished() -> void:
	if animator.animation.begins_with("attack_"):
		is_attacking = false
		hitbox_left.monitoring = false
		hitbox_right.monitoring = false
		hitbox_up.monitoring = false
		hitbox_down.monitoring = false
		play_idle()
		
func take_damage(amount: int) -> void:
	if is_invulnerable:
		return
		
	is_invulnerable = true
	shader.set_shader_parameter("flash_amount", 1.0)
	await get_tree().create_timer(0.15).timeout
	shader.set_shader_parameter("flash_amount", 0.0)
	is_invulnerable = false
	GameState.health = maxi(0, GameState.health - amount)
	if GameState.health <= 0:
		die()

func heal(amount: int) -> void:
	if amount <= 0:
		return

	GameState.health += amount

func die() -> void:
	animator.play("dead")
	print("Player is dood")
	velocity = Vector2.ZERO
	set_physics_process(false)
	set_deferred("monitoring", false)
	
func drink() -> void:
	if GameState.is_day() == true:
		GameState.thirst += 15
	else:
		GameState.thirst += 30

func drainThirst() -> void:
	if GameState.thirst > 0:
		if GameState.is_day() == true:
			GameState.thirst -= GameState.thirst_day
		else:
			GameState.thirst -= GameState.thirst_night
	else:
		GameState.thirst_health_lost_counter += 1
		GameState.health -= GameState.thirst_health_lost * (GameState.thirst_health_lost_counter / GameState.thirst_health_lost_multiplier)

func apply_knockback(force: Vector2) -> void:
	is_knocked_back = true
	knockback_velocity = force	
