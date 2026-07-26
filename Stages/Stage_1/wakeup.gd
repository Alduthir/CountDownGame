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
	
func check_stories():
	if check_all_quests_completed():
		GameState.won = true
		GameState.gameover_changed.emit(true)

func check_all_quests_completed() -> bool:
	var npcs = get_tree().get_nodes_in_group("quest_npcs")
	for npc in npcs:
		if not npc.dialog_completed:
			return false
	return true
