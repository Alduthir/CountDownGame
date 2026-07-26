extends Control

@export var dialog_data: DialogData

@onready var DialogSystem : DialogSystem = %DialogSystem

func _ready() -> void:
	setup_endgame()
	DialogSystem.start_dialog(dialog_data.portrait, dialog_data.conversation)

func _process(delta: float) -> void:
	pass

func _on_game_end(new_value: bool):
	await get_tree().create_timer(1.9).timeout
	get_tree().change_scene_to_file("res://UI/Overlay/End/end.tscn")

func setup_endgame():
	GameState.gameover_changed.connect(_on_game_end)
