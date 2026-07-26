extends Node2D

@onready var night_overlay: ColorRect = $CanvasLayer/NightOverlay
@onready var night_shader: ShaderMaterial = night_overlay.material as ShaderMaterial


func _ready() -> void:
	update_night_overlay()


func _process(_delta: float) -> void:
	update_night_overlay()


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
