class_name Guard extends CharacterBody2D

@export var health : int = 30
@export var knockback_force := 200.0
@export var max_speed := 80.0
@export var acceleration := 600.0
@export var minimal_detection_radius := 30.0

@onready var sprite : AnimatedSprite2D = %AnimatedSprite2D
@onready var hitbox_left : Area2D = %HitBoxLeft
@onready var hitbox_right : Area2D = %HitBoxRight
@onready var hitbox_up : Area2D = %HitBoxUp
@onready var hitbox_down : Area2D = %HitBoxDown
@onready var despawn_timer : Timer = %DespawnTimer
@onready var attack_timer : Timer = %AttackTimer
@onready var follow_range_shape : CollisionShape2D = %FollowRangeShape
@onready var attack_sound: AudioStreamPlayer2D = %attackSound
@onready var death_sound: AudioStreamPlayer2D = %deathSound




var is_following := false
var is_attacking := false
var can_attack := true
var facing_direction := Vector2.DOWN
var count : Count = null
var is_knocked_back = false
var knockback_velocity = Vector2.ZERO
var shader : ShaderMaterial

var current_max_speed : float = max_speed * 0.5 

func _ready() -> void:
	hitbox_left.body_entered.connect(deal_damage)
	hitbox_right.body_entered.connect(deal_damage)
	hitbox_up.body_entered.connect(deal_damage)
	hitbox_down.body_entered.connect(deal_damage)
	sprite.animation_finished.connect(animation_finished)
	shader = sprite.material
	GameState.suspicion_changed.connect(resize_detection_radius)
	
func _process(delta: float) -> void:
	if is_knocked_back:
		velocity = knockback_velocity
		knockback_velocity = knockback_velocity.lerp(Vector2.ZERO, 5*delta)
		if knockback_velocity.length() < 100: is_knocked_back = false
		move_and_slide()
		
	if is_attacking:
		return
	
	if is_following && count != null:
		var direction_to_count := global_position.direction_to(count.global_position)
		var distance_to_count := global_position.distance_to(count.global_position)
		if can_attack &&  distance_to_count < 30.0:
			attack_sound.play()
			is_attacking = true
			can_attack = false
			if abs(direction_to_count.x) > abs(direction_to_count.y):
				#attack horizontal
				sprite.play("attack_left")
				if direction_to_count.x > 0:
					sprite.flip_h = true
					hitbox_right.monitoring = true
				else:
					sprite.flip_h = false
					hitbox_left.monitoring = true
			else:
				#attack vertical
				sprite.flip_h = false
				if direction_to_count.y > 0:
					sprite.play("attack_down")
					hitbox_down.monitoring = true
				else:
					sprite.play("attack_up")
					hitbox_up.monitoring = true
			return

		#move to player
		var speed := current_max_speed if distance_to_count > 100 else max_speed * distance_to_count / 100
		var desired_velocity = direction_to_count * speed
		
		current_max_speed = move_toward(current_max_speed, max_speed, delta * acceleration)
		velocity = velocity.move_toward(desired_velocity, delta * acceleration)
		play_walking_animation()
		move_and_slide()
		return
	
	#Look around
	sprite.play("idle")	

func resize_detection_radius(new_value: int) -> void:
	var shape = follow_range_shape.get_shape() as CircleShape2D
	shape.radius = max(minimal_detection_radius, new_value * 10)

func play_walking_animation() -> void:
	if abs(velocity.x) > abs(velocity.y):
		sprite.play("walk_left")
		if velocity.x > 0:
			sprite.flip_h = true
		else:
			sprite.flip_h = false
	else:
		sprite.flip_h = false
		if velocity.y > 0:
			sprite.play("walk_down")
		else:
			sprite.play("walk_up")
			
func deal_damage(body: Node2D) -> void:
	if body is Count:
		var direction_to_count = (body.global_position - global_position).normalized()
		body.take_damage(10)
		body.apply_knockback(direction_to_count * knockback_force)

func take_damage(damage_amount : int) -> void:	
	shader.set_shader_parameter("flash_amount", 1.0)
	await get_tree().create_timer(0.08).timeout
	shader.set_shader_parameter("flash_amount", 0.0)
	health = maxi(0, health - damage_amount)
	if health == 0:
		die()

func die() -> void:
	sprite.play("die")
	death_sound.play()
	set_process(false)
	set_deferred("monitoring", false)
	despawn_timer.start()

func animation_finished()->void:
	if sprite.animation.begins_with("attack_"):
		is_attacking = false
		hitbox_left.monitoring = false
		hitbox_right.monitoring = false
		hitbox_up.monitoring = false
		hitbox_down.monitoring = false
		sprite.play("idle")
		attack_timer.start()


func _on_follow_range_body_entered(body: Node2D) -> void:
	is_following = true
	if body is Count:
		count = body

func _on_follow_range_body_exited(_body: Node2D) -> void:
	is_following = false
	count = null

func _on_despawn_timer_timeout() -> void:
	queue_free()

func apply_knockback(force: Vector2) -> void:
	can_attack = false
	sprite.play("idle")
	is_knocked_back = true
	knockback_velocity = force	


func _on_attack_timer_timeout() -> void:
	can_attack = true
