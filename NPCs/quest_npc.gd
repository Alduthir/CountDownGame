class_name QuestNPC extends StaticBody2D

@export var dialog : DialogData
@export var sprite_frames : SpriteFrames = preload("res://NPCs/Villagers/SpriteFrames/villager_m_blue.tres")

@onready var sprite : AnimatedSprite2D = %Sprite
@onready var speech_bubble : AnimatedSprite2D = %SpeechBubble
@onready var spawn_bubble_zone : Area2D = %SpawnBubbleZone
@onready var interaction_zone : Area2D = %InteractionZone
@onready var speech_sound: AudioStreamPlayer2D = %speechSound

var dialog_completed := false
var player_in_range := false

func _ready() -> void:
	sprite.sprite_frames = sprite_frames
	sprite.play("default")
	speech_bubble.animation_finished.connect(func()->void: speech_bubble.play("has_dialogue"))

func _unhandled_input(event: InputEvent) -> void:
	if not player_in_range || dialog_completed:
		return
	
	if event.is_action_pressed("interact"):
		speech_sound.play()
		get_viewport().set_input_as_handled()
		var dialog_system = get_tree().current_scene.find_child("DialogSystem", true, false)
		if dialog_system == null: 
			print_debug("DialogSystem not found in scene tree")
			return
		dialog_system.start_dialog(dialog.portrait, dialog.conversation)
		dialog_system.dialog_finished.connect(_dialog_done)

func _dialog_done() -> void:
	dialog_completed = true
	interaction_zone.monitoring = false
	spawn_bubble_zone.monitoring = false

func _on_spawn_bubble_zone_body_entered(_body: Node2D) -> void:
	if dialog_completed == false:
		speech_bubble.visible = true
		speech_bubble.play("appear")

func _on_spawn_bubble_zone_body_exited(_body: Node2D) -> void:
	speech_bubble.visible = false

func _on_interaction_zone_body_entered(body: Node2D) -> void:
	player_in_range = true
	speech_bubble.play("alert")

func _on_interaction_zone_body_exited(body: Node2D) -> void:
	player_in_range = false
	speech_bubble.play("has_dialogue")
