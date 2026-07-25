class_name Guard extends CharacterBody2D

@export var health := 100.0
@export var is_aggressive := true

@onready var sprite : AnimatedSprite2D = %AnimatedSprite2D
@onready var hitbox_left : Area2D = %HitBoxLeft
@onready var hitbox_right : Area2D = %HitBoxRight
@onready var hitbox_up : Area2D = %HitBoxUp
@onready var hitbox_down : Area2D = %HitBoxDown
@onready var despawn_timer : Timer = %DespawnTimer

var is_following := false
var attacking := false
var should_attack := false
var facing_direction := Vector2.DOWN
var count : Count = null

func _ready() -> void:
	hitbox_left.body_entered.connect(deal_damage)
	hitbox_right.body_entered.connect(deal_damage)
	hitbox_up.body_entered.connect(deal_damage)
	hitbox_down.body_entered.connect(deal_damage)
	
	sprite.animation_finished.connect(disable_hitboxes)

func _process(delta: float) -> void:
	if attacking:
		return
	
	if is_following:
		var direction_to_count := (count.global_position - global_position).normalized()
		
		if should_attack:
			attacking = true
			match direction_to_count:
				Vector2.LEFT:
					sprite.play("attack_left")
					hitbox_left.monitoring = true
		#move to player
		pass
	
	#walk around	

func deal_damage() -> void:
	pass

func take_damage(damage_amount : float) -> void:
	health = maxf(0, health - damage_amount)
	if health == 0:
		die()

func die() -> void:
	sprite.play("die")
	set_physics_process(false)
	set_deferred("monitoring", false)
	despawn_timer.start()

func disable_hitboxes()->void:
	hitbox_left.monitoring = false
	hitbox_right.monitoring = false
	hitbox_up.monitoring = false
	hitbox_down.monitoring = false
	
	
func _on_melee_range_area_entered(area: Area2D) -> void:
	should_attack = true

func _on_melee_range_area_exited(area: Area2D) -> void:
	should_attack = false

func _on_follow_range_body_entered(body: Node2D) -> void:
	if body is Count:
		count = body

func _on_follow_range_body_exited(body: Node2D) -> void:
	count = null


func _on_despawn_timer_timeout() -> void:
	queue_free()
