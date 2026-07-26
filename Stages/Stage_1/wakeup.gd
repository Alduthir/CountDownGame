extends Control

@export var dialog_data: DialogData

@onready var DialogSystem : DialogSystem = %DialogSystem
@onready var night_overlay: ColorRect = get_node_or_null("CanvasLayer/NightOverlay")
var night_shader: ShaderMaterial

func _ready() -> void:
	if night_overlay == null:
		push_error("NightOverlay niet gevonden vanaf Wakeup!")
	else:
		night_shader = night_overlay.material as ShaderMaterial
	setup_endgame()
	DialogSystem.start_dialog(dialog_data.portrait, dialog_data.conversation)
	update_night_overlay()


func _process(delta: float) -> void:
	update_night_overlay()
	pass

func _on_game_end(new_value: bool):
	await get_tree().create_timer(1.9).timeout
	get_tree().change_scene_to_file("res://UI/Overlay/End/end.tscn")

func setup_endgame():
	GameState.gameover_changed.connect(_on_game_end)

func update_night_overlay() -> void:
	if night_shader == null:
		return

	if GameState.is_day():
		night_shader.set_shader_parameter("darkness", 0.0)
	else:
		
		#darkness = 0.78
		#fog_strength = 0.55
		#fog_size = 0.72
		#fog_softness = 0.30
		#fog_speed = 0.12
		#fog_scale = 6.0
		night_shader.set_shader_parameter("darkness", 0.78)
		night_shader.set_shader_parameter("fog_strength", 0.25)
		night_shader.set_shader_parameter("fog_size", 0.22)
		night_shader.set_shader_parameter("fog_softness", 0.60)
		night_shader.set_shader_parameter("fog_speed", 0.50)
		night_shader.set_shader_parameter("fog_scale", 2.0)
		
