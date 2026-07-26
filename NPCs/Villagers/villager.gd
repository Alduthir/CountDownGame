class_name Villager extends CharacterBody2D

@export var speed: float = 20.0
@export var knockback_force := 200.0

@onready var animator: AnimatedSprite2D = $AnimatedSprite2D
@onready var wander_timer: Timer = $WanderTimer
@onready var despawn_timer : Timer = %DespawnTimer

var direction := Vector2.ZERO
var is_knocked_back = false
var knockback_velocity = Vector2.ZERO
var is_dead := false

var sprite_options: Array[SpriteFrames] = [
	preload("res://NPCs/Villagers/SpriteFrames/villager_f_green.tres"),
	preload("res://NPCs/Villagers/SpriteFrames/villager_f_pink.tres"),
	preload("res://NPCs/Villagers/SpriteFrames/villager_f_red.tres"),
	preload("res://NPCs/Villagers/SpriteFrames/villager_m_blue.tres"),
	preload("res://NPCs/Villagers/SpriteFrames/villager_m_green.tres"),
	preload("res://NPCs/Villagers/SpriteFrames/villager_m_lavender.tres"),
	preload("res://NPCs/Villagers/SpriteFrames/villager_m_red.tres")
]

func _ready() -> void:
	randomize()

	animator.sprite_frames = sprite_options.pick_random()

	wander_timer.one_shot = true
	wander_timer.timeout.connect(_choose_new_direction)
	
	despawn_timer.one_shot = true
	despawn_timer.timeout.connect(_on_despawn_timer_timeout)

	_choose_new_direction()


func _physics_process(delta: float) -> void:
	if is_knocked_back:
		
		velocity = knockback_velocity
		knockback_velocity = knockback_velocity.lerp(Vector2.ZERO, 5*delta)
		if knockback_velocity.length() < 100: is_knocked_back = false
		move_and_slide()
		return
	velocity = direction * speed
	move_and_slide()

	# Als we ergens tegenaan lopen, kies direct een nieuwe richting
	if get_slide_collision_count() > 0:
		_choose_new_direction()

	if direction == Vector2.ZERO:
		animator.play("default")
		return

	# Speel de juiste animatie af
	if abs(direction.y) > abs(direction.x):
		animator.flip_h = false

		if direction.y < 0:
			animator.play("walk_up")
		else:
			animator.play("walk_down")
	else:
		if direction.x < 0:
			animator.flip_h = false
		else:
			animator.flip_h = true

		animator.play("walk_left")


func _choose_new_direction() -> void:
	var directions = [
		Vector2.ZERO,	# even stilstaan
		Vector2.LEFT,
		Vector2.RIGHT,
		Vector2.UP,
		Vector2.DOWN
	]

	direction = directions.pick_random()

	# Kies na 1-3 seconden opnieuw een richting
	wander_timer.start(randf_range(1.0, 3.0))
	
func die() -> void:
	if is_dead:
		return

	is_dead = true
	direction = Vector2.ZERO
	velocity = Vector2.ZERO
	is_knocked_back = false
	knockback_velocity = Vector2.ZERO

	animator.play("die")

	set_physics_process(false)

	collision_layer = 0
	collision_mask = 0

	print("Villager dood, despawn over ", despawn_timer.wait_time, " seconden")
	despawn_timer.start()
	GameState.ate += 1
	GameState.villagers -= 1
	GameState.suspicion += 5

func _on_despawn_timer_timeout() -> void:
	queue_free()
	
func apply_knockback(force: Vector2) -> void:
	animator.play("idle")
	is_knocked_back = true
	knockback_velocity = force	
